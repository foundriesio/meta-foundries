#!/bin/sh -e
# Copyright (c) 2026 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
# Builds a qemu CI image as OS version 1 and derives from its ostree commit
# version 2, and a broken OS on machines whose kas/<machine>.yml enables
# boot counting. Stages what the tests boot and upload.
#
# Usage: [OTA_TEST_MACHINE=<machine>] [OTA_TEST_KAS_EXTRA=<a.yml:b.yml>] \
#        tests/qemu-ota/build.sh [OUT_DIR]
#
# OTA_TEST_KAS_EXTRA adds kas overlays after the test's own, e.g.
# ci/include/ci.yml on a CI runner.

TOPDIR=$(realpath "$(dirname "$(readlink -f "$0")")/../..")
MACHINE=${OTA_TEST_MACHINE:-qemuarm64-secureboot}
OUT=$(realpath -m "${1:-${OTA_TEST_OUT:-$TOPDIR/tests/qemu-ota/.cache/$MACHINE}}")
IMAGE=core-image-full-cmdline
KAS_CONTAINER=${KAS_CONTAINER:-$(which kas-container)}
: "${KAS_WORK_DIR:?set KAS_WORK_DIR outside the repository}"
command -v ostree >/dev/null || { echo "ostree is required" >&2; exit 1; }

DEPLOY="$KAS_WORK_DIR/build/tmp/deploy/images/$MACHINE"

cd "$TOPDIR"
KAS_YAMLS="ci/$MACHINE.yml"
VERSIONS=2
if [ -f "tests/qemu-ota/kas/$MACHINE.yml" ]; then
    KAS_YAMLS="$KAS_YAMLS:tests/qemu-ota/kas/$MACHINE.yml"
    VERSIONS="$VERSIONS broken"
fi
"$KAS_CONTAINER" build "$KAS_YAMLS${OTA_TEST_KAS_EXTRA:+:$OTA_TEST_KAS_EXTRA}"

rm -rf "${OUT:?}"
mkdir -p "$OUT/1"
cp -a "$DEPLOY/ostree_repo" "$OUT/1/ostree_repo"
cp -L "$DEPLOY/$IMAGE-$MACHINE.rootfs.wic.qcow2" "$OUT/1/disk.qcow2"
case "$MACHINE" in
qemux86-64)
    cp -L "$DEPLOY/ovmf.code.qcow2" "$DEPLOY/ovmf.vars.qcow2" "$OUT/1/" ;;
*)
    cp -L "$DEPLOY/flash.bin" "$OUT/1/flash.bin" ;;
esac

# update-server takes a Target's commit from the first ref of its upload.
repo="$OUT/1/ostree_repo"
ref=$(ostree --repo="$repo" refs)
if [ "$(echo "$ref" | wc -l)" -ne 1 ]; then
    echo "expected one ref in $DEPLOY/ostree_repo, found: $ref" >&2
    exit 1
fi
base=$(ostree --repo="$repo" rev-parse "$ref")
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for v in $VERSIONS; do
    overlay="$work/$v"
    mkdir -p "$overlay/usr/lib"
    ostree --repo="$repo" cat "$base" /usr/lib/os-release |
        grep -v '^BUILD_ID=' > "$overlay/usr/lib/os-release"
    echo "BUILD_ID=\"qemu-ota-os-$v\"" >> "$overlay/usr/lib/os-release"
    if [ "$v" = broken ]; then
        mkdir -p "$overlay/usr/sbin"
        ln -s ../bin/false "$overlay/usr/sbin/init"
    fi
    # Owned by root, as is the tree it lands on.
    tar -C "$overlay" --owner=0 --group=0 --numeric-owner \
        --mode=u=rwX,go=rX -cf "$overlay.tar" usr
    # A version of its own makes OSTree write a counted boot entry for the
    # update, which it shares with the replaced deployment when kernel,
    # kernel arguments and version all match.
    commit=$(ostree --repo="$repo" commit --orphan --tree=ref="$base" \
        --tree=tar="$overlay.tar" --add-metadata-string=version="qemu-ota-os-$v" \
        --subject="qemu-ota OS $v")

    mkdir -p "$OUT/$v"
    cp -al "$repo" "$OUT/$v/ostree_repo"
    rm "$OUT/$v/ostree_repo/refs/heads/$ref"
    ostree --repo="$OUT/$v/ostree_repo" refs --create="$ref" "$commit"
done

echo "Staged releases in $OUT"
