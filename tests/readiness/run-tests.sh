#!/bin/sh
# Copyright (c) 2026 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Fixture tests for fio-readiness.
#
# Usage: ./run-tests.sh [SHELL]   (default: sh)
# Builds a fake image tree per scenario, stubs systemctl/id/uname, and runs
# the suite with a restricted PATH so tool absence can be simulated.

set -u
HERE=$(cd "$(dirname "$0")" && pwd)
SUITE="${FIO_READINESS_SUITE:-$HERE/fio-readiness}"
SH_UNDER_TEST=${1:-sh}
mkdir -p "${TMPDIR:-/tmp}"
T=$(mktemp -d "${TMPDIR:-/tmp}/t.XXXXXX")
trap '[ -n "${KEEP:-}" ] || rm -rf "$T"' EXIT

PASSES=0 FAILS=0
ok() { PASSES=$((PASSES + 1)); }
bad() { FAILS=$((FAILS + 1)); printf '  FAIL: %s\n' "$*"; }

# Real tools exposed to the suite (each scenario may drop some).
TOOLS="sh awk sed grep head tail tr wc cut dirname mkdir rm cp cat date df ls readlink mktemp sleep timeout"

mk_toolbin() { # DIR, then tools to omit
	_tb=$1; shift
	mkdir -p "$_tb"
	for _t in $TOOLS; do
		_skip=""
		for _o in "$@"; do [ "$_o" = "$_t" ] && _skip=1; done
		[ -n "$_skip" ] && continue
		_real=$(command -v "$_t") && ln -sf "$_real" "$_tb/$_t"
	done
	cat >"$_tb/id" <<'EOF'
#!/bin/sh
[ "$1" = "-u" ] && { echo "${FIX_UID:-0}"; exit 0; }
echo "uid=${FIX_UID:-0}"
EOF
	cat >"$_tb/uname" <<'EOF'
#!/bin/sh
case "$1" in
-m) echo "${FIX_ARCH:-aarch64}" ;;
-r) echo "6.6.0-fixture" ;;
-n) echo fixture-host ;;
*) echo Linux ;;
esac
EOF
	# systemctl: answers `show` from $FIX_UNITS ("unit|Key=Value" lines).
	cat >"$_tb/systemctl" <<'EOF'
#!/bin/sh
echo "systemctl $*" >>"$FIX_LOG"
cmd=$1; shift
case "$cmd" in
show)
	props="" unit=""
	while [ $# -gt 0 ]; do
		case "$1" in -p) props="$props $2"; shift 2 ;; *) unit=$1; shift ;; esac
	done
	[ -n "$unit" ] || unit=_manager
	for k in $props; do
		v=$(grep "^$unit|$k=" "$FIX_UNITS" 2>/dev/null | head -n 1 | cut -d= -f2-)
		[ -n "$v" ] || { [ "$k" = LoadState ] && v=not-found; }
		echo "$k=$v"
	done ;;
list-unit-files) grep '^_files|' "$FIX_UNITS" 2>/dev/null | cut -d'|' -f2 ;;
*) echo "unexpected systemctl $cmd" >&2; exit 1 ;;
esac
EOF
	chmod +x "$_tb/id" "$_tb/uname" "$_tb/systemctl"
}

stub() { # ROOT PATH BODY
	mkdir -p "$(dirname "$1$2")"
	printf '#!/bin/sh\necho "${0##*/} $*  DOCKER_HOST=${DOCKER_HOST:-}" >>"$FIX_LOG"\n%s\n' "$3" >"$1$2"
	chmod +x "$1$2"
}

# Healthy Wrynose Full Update image, unregistered.
mk_root() {
	r=$1
	mkdir -p "$r/proc/self" "$r/proc/sys/kernel" "$r/run" "$r/sys/firmware/efi/esrt/entries/entry0" \
		"$r/etc" "$r/var/sota" "$r/boot/efi/EFI/BOOT" "$r/usr/lib/tmpfiles.d" "$r/usr/lib/sota/conf.d" \
		"$r/usr/lib/docker" "$r/sys/class/watchdog/watchdog0"
	echo fixture-host >"$r/proc/sys/kernel/hostname"
	: >"$r/run/ostree-booted"
	: >"$r/boot/efi/EFI/BOOT/BOOTAA64.EFI"
	echo "fixture-wdt" >"$r/sys/class/watchdog/watchdog0/identity"
	cat >"$r/etc/os-release" <<'EOF'
ID=nodistro
NAME="OpenEmbedded"
VERSION_ID=6.0
VERSION_CODENAME=wrynose
PRETTY_NAME="OpenEmbedded 6.0 (wrynose)"
EOF
	cat >"$r/proc/self/mountinfo" <<'EOF'
20 1 179:2 /ostree/deploy/os/deploy/abc.0 / rw,relatime shared:1 - ext4 /dev/mmcblk0p2 rw
21 20 179:2 / /sysroot rw,relatime shared:2 - ext4 /dev/mmcblk0p2 rw
22 20 179:2 /ostree/deploy/os/var /var rw,relatime shared:3 - ext4 /dev/mmcblk0p2 rw
23 20 179:1 / /boot/efi rw,relatime shared:4 - vfat /dev/mmcblk0p1 rw
24 20 0:25 / /sys/firmware/efi/efivars rw,nosuid shared:5 - efivarfs efivarfs rw
25 20 0:26 / /run rw shared:6 - tmpfs tmpfs rw
EOF
	echo 'd /var/sota 0700 root root -' >"$r/usr/lib/tmpfiles.d/aktualizr-lite.conf"
	printf '[provision]\nprimary_ecu_hardware_id = "uno-q"\n' >"$r/usr/lib/sota/conf.d/40-hardware-id.toml"
	printf '{"features":{"containerd-snapshotter":false},"storage-driver":"overlay2"}\n' >"$r/usr/lib/docker/daemon.json"

	stub "$r" /usr/bin/aktualizr-lite '[ -n "${FIX_SLOW:-}" ] && sleep "$FIX_SLOW"; echo "Current aktualizr version is: 5d93718"'
	stub "$r" /usr/bin/lshw 'exit 0'
	stub "$r" /usr/bin/ostree 'case "$1" in --version) echo "libostree:"; echo " Version: 2025.7";; admin) echo "* os abc123.0"; echo "    origin refspec: x";; esac'
	stub "$r" /usr/bin/fio-device-register 'i=0; while [ $i -lt 40 ]; do echo "  --basic-option-$i arg    a long explanatory help line for a basic option"; i=$((i+1)); done
cat <<H
  --device-api arg
  --oauth-api arg
  --api-token arg   example token=abc123secret
Git Commit d8f39a6
H
exit 255'
	stub "$r" /usr/bin/fioconfig 'echo af05a01'
	printf '# build\t-compiler=gc\n# build\t-tags=vpn\n# build\t-trimpath=true\n# build\tGOARCH=arm64\n' >>"$r/usr/bin/fioconfig"
	mkdir -p "$r/usr/share/fioconfig/handlers" "$r/usr/share/fioconfig/actions"
	for h in aktualizr-toml-update factory-config-vpn renew-client-cert; do stub "$r" "/usr/share/fioconfig/handlers/$h" 'exit 0'; done
	for a in diag reboot; do stub "$r" "/usr/share/fioconfig/actions/$a" 'exit 0'; done
	stub "$r" /usr/bin/nmcli 'echo "nmcli tool, version 1.52"'
	stub "$r" /usr/bin/docker 'case "$1" in
--version) echo "Docker version 28.3.0";;
version) [ "$DOCKER_HOST" = "unix:///var/run/docker.sock" ] && echo 28.3.0 || exit 1;;
info) echo "overlay2|/var/lib/docker|[]";;
esac'
	stub "$r" /usr/bin/dockerd 'echo "Docker version 28.3.0"'
	stub "$r" /usr/libexec/docker/cli-plugins/docker-compose 'echo "Docker Compose version v2.39.0"'
	stub "$r" /usr/bin/composectl 'case "$1" in version) echo 0af6d77;; --help) printf "  -i, --compose string   compose projects root path (default \"/var/sota/compose-apps\")\n  -s, --store string     store root path (default \"/var/sota/reset-apps\")\n";; esac'
	ln -s composectl "$r/usr/bin/aklite-apps"
	stub "$r" /usr/bin/fwupdmgr 'exit 0'
}

mk_units() {
	cat >"$1" <<'EOF'
aktualizr-lite.service|LoadState=loaded
aktualizr-lite.service|UnitFileState=enabled
aktualizr-lite.service|ActiveState=inactive
aktualizr-lite.service|ExecStart={ path=/usr/bin/aktualizr-lite ; argv[]=/usr/bin/aktualizr-lite daemon ; }
aktualizr-lite.service|Requires=boot-complete.target
boot-complete.target|LoadState=loaded
fioconfig.service|LoadState=loaded
fioconfig.path|LoadState=loaded
fioconfig-extract.service|LoadState=loaded
docker.service|LoadState=loaded
docker.service|UnitFileState=enabled
docker.service|ActiveState=active
docker.socket|UnitFileState=enabled
docker.socket|ActiveState=active
EOF
}

# scenario NAME [suite args...]; uses $ROOT $UNITS $TB set by setup
setup() {
	S="$T/$1"; mkdir -p "$S"
	ROOT="$S/root"; UNITS="$S/units"; TB="$S/toolbin"; LOG="$S/calls.log"; REP="$S/report.txt"
	mk_root "$ROOT"; mk_units "$UNITS"; : >"$LOG"
	shift
	mk_toolbin "$TB" "$@"
}

suite() {
	env -i PATH="$TB" FIO_READINESS_TEST_ROOT="$ROOT" FIX_UNITS="$UNITS" FIX_LOG="$LOG" \
		FIX_UID="${FIX_UID:-0}" FIX_SLOW="${FIX_SLOW:-}" \
		"$SH_UNDER_TEST_PATH" "$SUITE" --report "$REP" "$@" >"$S/console.txt" 2>&1
	RC=$?
}

# Matrix columns are fixed width: ID(16) CAPABILITY(16) SCOPE(9) RESULT(8).
res() { awk -v id="$1" '$1 == id && length($0) >= 45 { r = substr($0, 45, 8); sub(/ +$/, "", r); print r; exit }' "$REP" 2>/dev/null; }

expect() { # ID RESULT
	_got=$(res "$1")
	if [ "$_got" = "$2" ]; then ok; else bad "$SCEN: $1 expected $2, got ${_got:-<missing>}"; fi
}
expect_absent() {
	if grep -q "^$1 " "$REP"; then bad "$SCEN: $1 present but should be omitted"; else ok; fi
}
expect_grep() { # PATTERN FILE
	if grep -q -- "$1" "$2"; then ok; else bad "$SCEN: '$1' not found in $(basename "$2")"; fi
}
expect_nogrep() {
	if grep -q -- "$1" "$2"; then bad "$SCEN: '$1' unexpectedly found in $(basename "$2")"; else ok; fi
}

SH_UNDER_TEST_PATH=$(command -v "$SH_UNDER_TEST" 2>/dev/null || echo "$SH_UNDER_TEST")
set -- $SH_UNDER_TEST_PATH
[ -x "$1" ] || { echo "shell not found: $SH_UNDER_TEST"; exit 2; }

# --- healthy, unregistered Full Update image
SCEN=healthy; setup "$SCEN"; suite
[ "$RC" -eq 0 ] && ok || bad "$SCEN: exit $RC"
for id in ENV-01 ENV-02 ENV-03 ENV-05 OS-01 OS-02 OS-03 OS-04 OS-05 OS-06 OS-07 OS-08 OS-09 OS-10 OS-11 OS-12 \
	BOOT-01 BOOT-02 BOOT-03 BOOT-05 APP-01 APP-02 APP-03 APP-04 APP-05 FW-01 FW-02 FW-03 FW-04; do
	expect "$id" PASS
done
for id in BOOT-04 BOOT-06 APP-06 APP-08; do expect "$id" UNKNOWN; done
expect_grep "Profile: Full Update (default)" "$REP"
expect_grep "post-MVP: not required before MVP" "$REP"
expect_grep "not required before MVP (would be" "$REP"
expect_grep "inactive is expected on an unregistered image" "$REP"
expect_nogrep "abc123secret" "$REP"
expect_nogrep "abc123secret" "$S/console.txt"
[ ! -e "$REP.partial" ] && ok || bad "$SCEN: partial file left behind"

# --- dockerd enabled but stopped: fails, never socket-activated
SCEN=docker-stopped; setup "$SCEN"
sed -i.bak 's/^docker.service|ActiveState=active/docker.service|ActiveState=inactive/' "$UNITS"; suite
expect APP-01 PASS; expect APP-02 FAIL; expect APP-03 BLOCKED; expect APP-04 PASS
expect_nogrep "DOCKER_HOST=unix:///var/run/docker.sock" "$LOG"
expect_grep "storage-driver=overlay2" "$REP"

# --- composectl missing: own check fails, only dependents blocked
SCEN=no-composectl; setup "$SCEN"; rm "$ROOT/usr/bin/composectl" "$ROOT/usr/bin/aklite-apps"; suite
expect APP-04 FAIL; expect APP-05 BLOCKED; expect APP-02 PASS; expect OS-01 PASS

# --- stock fioconfig: no vpn handler, built without vpn tag, no nmcli
SCEN=stock-fioconfig; setup "$SCEN"
rm "$ROOT/usr/share/fioconfig/handlers/factory-config-vpn" "$ROOT/usr/bin/nmcli"
stub "$ROOT" /usr/bin/fioconfig 'echo af05a01'
printf '# build\t-compiler=gc\n# build\t-tags=disable_pkcs11\n# build\t-trimpath=true\n' >>"$ROOT/usr/bin/fioconfig"; suite
expect OS-09 FAIL; expect OS-11 FAIL; expect OS-12 FAIL; expect OS-08 PASS

# --- Yocto -trimpath build without any tags (the iq9 case): FAIL, not UNKNOWN
SCEN=trimpath-novpn; setup "$SCEN"
stub "$ROOT" /usr/bin/fioconfig 'echo af05a01'
printf '# build\t-compiler=gc\n# build\t-trimpath=true\n# build\tGOARCH=arm64\n' >>"$ROOT/usr/bin/fioconfig"; suite
expect OS-12 FAIL; expect OS-09 PASS

# --- no embedded build settings at all: UNKNOWN
SCEN=no-buildinfo; setup "$SCEN"
stub "$ROOT" /usr/bin/fioconfig 'echo af05a01'; suite
expect OS-12 UNKNOWN

# --- OS Update profile: container rows omitted, presence noted
SCEN=os-profile; setup "$SCEN"; suite --profile os
for id in APP-01 APP-02 APP-03 APP-04 APP-05 APP-06 APP-08; do expect_absent "$id"; done
expect_grep "Container components present: docker dockerd composectl; not needed for OS Update; not evaluated." "$REP"
expect FW-01 PASS

# --- missing firmware tooling and efivarfs still PASS before MVP, with the raw outcome recorded
SCEN=no-firmware; setup "$SCEN"; rm "$ROOT/usr/bin/fwupdmgr"
sed -i.bak '/efivarfs/d' "$ROOT/proc/self/mountinfo"; suite
expect FW-01 PASS; expect BOOT-02 PASS
expect_grep "inspection outcome would be FAIL" "$REP"

# --- state on tmpfs fails OS-06
SCEN=var-tmpfs; setup "$SCEN"
sed -i.bak 's#^22 .*#22 20 0:30 / /var rw shared:3 - tmpfs tmpfs rw#' "$ROOT/proc/self/mountinfo"; suite
expect OS-06 FAIL; expect OS-01 PASS

# --- not root: root-dependent checks blocked, others run
SCEN=non-root; setup "$SCEN"; FIX_UID=1000 suite
expect ENV-01 FAIL; expect OS-06 BLOCKED; expect OS-07 BLOCKED; expect OS-01 PASS

# --- no timeout facility: harness failure blocks only query checks
SCEN=no-timeout; setup "$SCEN" timeout; suite
expect ENV-04.timeout FAIL; expect OS-02 BLOCKED; expect APP-01 BLOCKED; expect OS-01 PASS; expect BOOT-01 PASS

# --- hung query is bounded
SCEN=hang; setup "$SCEN"; FIX_SLOW=30 suite --timeout 2
expect OS-02 FAIL; expect OS-03 PASS

# --- missing provenance is UNKNOWN, never guessed
SCEN=no-provenance; setup "$SCEN"; printf 'ID=qli\nNAME="Qualcomm Linux"\n' >"$ROOT/etc/os-release"; suite
expect ENV-03 UNKNOWN

# --- unwritable report path: console still carries the report
SCEN=bad-report; setup "$SCEN"; REP_SAVE=$REP; REP="$S/missing-dir/report.txt"; suite
expect_grep "Report could not be written" "$S/console.txt"
expect_grep "ENV-05" "$S/console.txt"; REP=$REP_SAVE

# --- interruption leaves an incomplete report
SCEN=interrupt; setup "$SCEN"
env -i PATH="$TB" FIO_READINESS_TEST_ROOT="$ROOT" FIX_UNITS="$UNITS" FIX_LOG="$LOG" FIX_UID=0 FIX_SLOW=3 \
	"$SH_UNDER_TEST_PATH" "$SUITE" --report "$REP" >"$S/console.txt" 2>&1 &
pid=$!; sleep 1; kill -TERM "$pid"; wait "$pid"; RC=$?
[ "$RC" -eq 130 ] && ok || bad "$SCEN: exit $RC, expected 130"
expect_grep "INCOMPLETE" "$REP"
expect_nogrep "^APP-01" "$REP"

printf '%s: %s passed, %s failed\n' "$SH_UNDER_TEST" "$PASSES" "$FAILS"
[ "$FAILS" -eq 0 ]
