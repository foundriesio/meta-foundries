---
title: Build QLI Wrynose for UNO Q
description: Prepare a Linux host, build Qualcomm Linux Wrynose, and preserve the UNO Q image and OS repository.
type: page
doc-category: instructional
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-10
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2
  - https://github.com/qualcomm-linux/meta-qcom-distro/tree/c3e4c471ddf7874b95a9d417a61019af25aa2c5b
  - https://github.com/siemens/kas/tree/5.4
relations:
  prev: README.md
  next: flash.md
  parent: README.md
---

# Build QLI Wrynose for UNO Q

[Guide overview](README.md) · **Part 1 of 4**

Prepare your computer and build Qualcomm® Linux® (QLI) with meta-foundries for Arduino® UNO Q.
Save the flash bundle and OS repository for the flashing and update exercises.

> **Validation status:** Source-reviewed draft. The complete build and hardware walkthrough remain pending.
> See [sources and validation](validation.md).

- [Prepare the build host](#prepare-the-build-host)
- [Build QLI from Wrynose](#build-qli-from-wrynose)

## Prepare the Build Host

You need an x86-64 Linux computer running Docker.

Use an x86-64 Linux build environment with a case-sensitive Linux filesystem.
As a planning allowance, provide 16 GB RAM and 200 GB free disk space; actual requirements vary with caches and parallelism.
Reuse existing download and shared-state caches when available.

### Prepare Your Linux Host

Install [Docker Engine](https://docs.docker.com/engine/install/ubuntu/), including the Compose and Buildx plugins.
Install Git, Git Large File Storage (LFS), Python 3, and curl using your distribution's packages.
For Ubuntu:

```bash
sudo apt update
sudo apt install git git-lfs python3 curl
git lfs install
```

Check Docker from your local host shell:

```bash
docker run --rm hello-world
docker compose version
docker buildx version
```

### Establish a Working Directory

Copy this entire guide directory to your computer, including `kas/` and `workarounds/`.
Open a Bash shell in that directory:

```bash
export GUIDE_DIR="$PWD"
mkdir -p "$GUIDE_DIR/workspace"
```

In a new shell, return to this directory and set `GUIDE_DIR` again.

## Build QLI From Wrynose

Run this section in your **Linux build environment**.
The configuration selects `qcom-distro-sota` and machine `uno-q`, supplied by `meta-qcom-arduino`.
It builds `core-image-full-cmdline` with the platform updater, Docker application support, networking, and Android Debug Bridge (ADB).
ADB is enabled in the shared image so either console path works; Bughopper users can complete the guide entirely through serial.

### What Is Pinned, and What Uses Wrynose?

| Component | Selection |
| --- | --- |
| Qualcomm Linux distro | `meta-qcom-distro`, **wrynose**, pinned revision |
| Qualcomm BSP | `meta-qcom`, **wrynose**, pinned revision |
| OpenEmbedded Core, `meta-openembedded`, `meta-virtualization`, `meta-selinux`, `meta-security` | **wrynose** |
| meta-updater | **wrynose**, pinned revision |
| BitBake | **2.18**, the Wrynose series |
| Linux firmware mixin | `wrynose/linux-firmware`, with the patch referenced by QLI's BSP configuration |
| meta-foundries | Pinned revision; no Wrynose branch exists at the source-review date |
| Arduino board layer | Pinned revision from `main`; that revision explicitly declares Wrynose compatibility |

The last two pins supply the integration and machine support.
The QLI distro and BSP use Wrynose.
The [companion configuration](kas/uno-q-wrynose.yml) includes the pinned meta-foundries `ci/include/base.yml`
and declares the complete Wrynose source and layer list locally.
This preserves the guide's Arduino and QLI baseline while the upstream `ci/uno-q.yml` evolves its include layout and development-branch locks.
Use the companion configuration throughout this walkthrough.

The October 10, 2026 revision updates meta-foundries to `ff40dc1`, which selects aktualizr-lite `5d93718` with the OS-name fix.
The client derives the booted OSTree stateroot, including `nodistro`, when `pacman.os` is unset.
The guide leaves `pacman.os` unset and requires the OS-update exercise to verify finalization after reboot.
The Arduino, Qualcomm distro, Qualcomm BSP, and meta-updater pins are deliberately retained from the previous source baseline.
They are held revisions, not a claim that each is the latest branch tip.
See [sources and validation](validation.md#october-10-source-reconciliation) for the verification limits.

### Install kas-container and Build OS Version 1

Install the [kas-container wrapper](https://kas.readthedocs.io/en/latest/userguide.html#kas-container)
and put it on `PATH`.
The example below fixes the wrapper and build-container version at 5.4:

```bash
mkdir -p "$HOME/.local/bin"
curl -fL https://raw.githubusercontent.com/siemens/kas/5.4/kas-container \
  -o "$HOME/.local/bin/kas-container"
chmod +x "$HOME/.local/bin/kas-container"
export PATH="$HOME/.local/bin:$PATH"
export KAS_IMAGE_VERSION=5.4
export KAS_WORK_DIR="$HOME/unoq-build"
export DL_DIR="$HOME/yocto-cache/downloads"
export SSTATE_DIR="$HOME/yocto-cache/sstate"
mkdir -p "$KAS_WORK_DIR" "$DL_DIR" "$SSTATE_DIR"
```

Change the cache paths to your existing caches when appropriate.
Keep the build tree on a case-sensitive Linux filesystem.

### Select the Board's Memory Configuration

Start with the base configuration:

```bash
export GUIDE_KAS='kas/uno-q-wrynose.yml'
```

Affected **4 GB UNO Q boards** need the temporary M-05 memory reservation while running the affected firmware.
Record the board's RAM size and firmware revision before selecting this workaround:

- **RAM size:** UNO Q boards ship with different RAM sizes.
  Read your board's variant from its product label or purchase record.
  On a running board, `free -h` is supporting evidence only: reserved memory lowers the total it reports.
- **Firmware revision:** open the board's serial console as described in [the flashing page](flash.md#with-a-bughopper)
  and power-cycle the board.
  The boot firmware prints a line beginning `UEFI Ver` early in the boot output; record that line.
  For example, an affected 4 GB lab board printed `UEFI Ver : 6.0.260722.BOOT.MXF.1.0.c1-00536-KODIAKLA-2`.
  This is an example, not a complete list of affected revisions.

The workaround's scope is the observed firmware memory-map issue.
If you cannot tell whether your board is affected, stop and confirm with the firmware maintainer before building.

The [optional layer](workarounds/meta-unoq-m05/conf/layer.conf) reserves
`0x7b8ff000` through `0x7c9fefff` (17 MiB), with `no-map`, to keep that window out of Linux allocation and the linear map.
It carries the [lab diagnostic patch](https://github.com/foundriesio/foundries-open-update-tests/blob/10b030947f7fc30d513428129f36aecc4cd957bc/build/recipes/linux-arduino/0001-arm64-dts-qcom-qrb2210-arduino-imola-reserve-m05-boundary.patch).
This reduces usable RAM and is a temporary firmware workaround.
The firmware team's test firmware reportedly fixes the issue; a released fix and reservation-free validation remain pending.
Retain the reservation on affected boards until the released firmware passes validation without it.

For an affected 4 GB board, copy the supplied layer into the kas work directory and select its overlay:

```bash
mkdir -p "$KAS_WORK_DIR/meta-unoq-m05"
cp -a "$GUIDE_DIR/workarounds/meta-unoq-m05/." "$KAS_WORK_DIR/meta-unoq-m05/"
export GUIDE_KAS="$GUIDE_KAS:kas/m05-4gb.yml"
```

The overlay's relative repository path resolves under `KAS_WORK_DIR`, including inside kas-container.
It targets `linux-arduino_7.0` on `uno-q` and intentionally fails if that recipe is absent.
Its applicability to the retained Arduino pin, patch application, and resulting image still require build validation.
Do not suppress a dangling-append error or generalize the patch to another kernel or board without reviewing it.
Use the same selection and layer contents for both OS builds; test firmware changes separately.

### Lock the Sources and Build

When adopting this revised baseline in an existing guide directory, archive the previous
`kas/uno-q-wrynose.lock.yml` outside `kas/` before running the lock command, and use a fresh build directory.
An old lockfile can override the new meta-foundries pin.
Keep that archive with the previous build's records; create a new lock only for the new baseline.

Record your selection, generate the lockfile for the remaining layer revisions, then build:

```bash
cd "$GUIDE_DIR"
printf '%s\n' "$GUIDE_KAS" > "$GUIDE_DIR/workspace/kas-config"
kas-container lock kas/uno-q-wrynose.yml
kas-container dump --resolve-refs "$GUIDE_KAS:kas/os-v1.yml" \
  > "$GUIDE_DIR/workspace/os-v1-resolved.yml"
cat "$GUIDE_DIR/workspace/os-v1-resolved.yml"
```

Check that the resolved configuration retains the five explicit commit pins from `kas/uno-q-wrynose.yml`
and records commits for the remaining repositories from their selected Wrynose branches or BitBake 2.18.
The lockfile covers floating repositories; the five explicit pins remain in the companion configuration.
Then build:

```bash
kas-container build "$GUIDE_KAS:kas/os-v1.yml"
```

Retain the generated `kas/uno-q-wrynose.lock.yml` with your build records.
Use the same lockfile for OS version 2.
Do not update layer revisions between the two builds in this walkthrough.
Retain the resolved configuration, `workspace/kas-config`, and the optional layer bytes with the lockfile,
because kas does not lock a local repository without a URL.

The deployment directory is:

```bash
export DEPLOY="$KAS_WORK_DIR/build/tmp/deploy/images/uno-q"
ls "$DEPLOY"
```

Before continuing, confirm that it contains an `ostree_repo` directory and
`core-image-full-cmdline-uno-q.rootfs.qcomflash`.
Inspect the flash directory for `prog_firehose_ddr.elf`, `rawprogram0.xml`, and `patch0.xml`.

Preserve the OS repository before the next build changes it:

```bash
mkdir -p "$GUIDE_DIR/workspace/releases/1"
cp -a "$DEPLOY/ostree_repo" "$GUIDE_DIR/workspace/releases/1/ostree_repo"
tar -chzf "$GUIDE_DIR/workspace/unoq-os1-flash.tar.gz" \
  -C "$DEPLOY" core-image-full-cmdline-uno-q.rootfs.qcomflash
```

The archive follows symlinks so the transferred flash bundle contains its referenced files.
If your builder is remote, transfer the archive and `releases/1/ostree_repo` to the local guide's `workspace/`.
For example, on the local computer, replacing the host and paths:

```bash
scp builder:/absolute/path/to/guide/workspace/unoq-os1-flash.tar.gz "$GUIDE_DIR/workspace/"
mkdir -p "$GUIDE_DIR/workspace/releases/1"
scp -r builder:/absolute/path/to/guide/workspace/releases/1/ostree_repo \
  "$GUIDE_DIR/workspace/releases/1/"
```

**Next:** [Flash UNO Q and connect to the board](flash.md).
Keep the guide directory, OS repository, lockfile, and Linux build environment for the later update exercises.
