---
title: Build QLI for UNO Q
description: Prepare a Linux host, build Qualcomm Linux with meta-foundries, and preserve the UNO Q image and OS repository.
type: page
doc-category: instructional
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-13
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2
  - https://github.com/qualcomm-linux/meta-qcom-arduino/tree/a65e94a51f8233607b683787735225a10d80fe65
  - https://github.com/qualcomm-linux/meta-qcom-distro/tree/acc7f52e830e4308ea97020184cfb8171b0b1d87
  - https://github.com/qualcomm-linux/meta-qcom/tree/21c9c0d8138e3472b0ac04e780f18be14aa959ab
  - https://github.com/siemens/kas/tree/5.4
relations:
  prev: README.md
  next: flash.md
  parent: README.md
---

# Build QLI for UNO Q

[Guide overview](README.md) · **Part 1 of 4**

Prepare your computer and build Qualcomm® Linux® (QLI) with meta-foundries for Arduino® UNO Q.
Save the flash bundle and OS repository for the flashing and update exercises.

> **Validation status:** This configuration built successfully on October 12, 2026.
> See [sources and validation](validation.md) for what has and has not been run on hardware.

- [Prepare the build host](#prepare-the-build-host)
- [Build QLI](#build-qli)

## Prepare the Build Host

You need an x86-64 Linux computer running Docker.
The machine that builds the image is the **build environment**.
The machine that flashes the board and runs the update server is the **local computer**.
They can be the same machine.

Use a case-sensitive Linux filesystem for the build.
As a planning allowance, provide 16 GB RAM and 200 GB free disk space; actual requirements vary with caches and parallelism.
Reuse existing download and shared-state caches when available.

### Prepare Your Linux Host

Do this on the build environment and, if it is a separate machine, on the local computer.
Install Git, Python 3, and curl. For Ubuntu:

```bash
sudo apt update
sudo apt install git python3 curl
```

Install Docker Engine with its Buildx and Compose plugins, using **one** of these routes:

- **Docker's packages:** follow [Docker's Ubuntu instructions](https://docs.docker.com/engine/install/ubuntu/).
  They add Docker's apt repository and install `docker-ce`, `docker-buildx-plugin`, and `docker-compose-plugin`.
- **Ubuntu's packages** (Ubuntu 24.04): `sudo apt install docker.io docker-buildx docker-compose-v2`.

Use only one route; their packages conflict.
kas-container and the packaging steps run Docker as your account.
If `docker` needs `sudo`, follow Docker's [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/).

Check Docker in a new shell:

```bash
docker run --rm hello-world
docker compose version
docker buildx version
```

### Get the Guide Files

The build reads this guide's `kas/` and `workarounds/` directories, so each machine you use needs a copy of the guide.
Clone meta-foundries and copy the guide directory out of it:

```bash
git clone https://github.com/foundriesio/meta-foundries.git "$HOME/meta-foundries"
cp -a "$HOME/meta-foundries/docs/guides/uno-q-wrynose" "$HOME/unoq-guide"
cd "$HOME/unoq-guide"
export GUIDE_DIR="$PWD"
mkdir -p "$GUIDE_DIR/workspace"
```

If you are reading the guide from a branch or pull request, check out that revision in `$HOME/meta-foundries` before copying.
Do this on the build environment and on the local computer.
In a new shell, run `cd "$HOME/unoq-guide"` and set `GUIDE_DIR` again.

## Build QLI

Run this section in your **build environment**.
The configuration selects `qcom-distro-sota` and machine `uno-q`, supplied by `meta-qcom-arduino`.
It builds `core-image-full-cmdline` with the platform updater, Docker application support, networking, and Android Debug Bridge (ADB).
ADB is enabled in the shared image so either console path works; Bughopper users can complete the guide entirely through serial.

### What Is Pinned

The [companion configuration](kas/uno-q-wrynose.yml) pins every layer to a commit.
They are the revisions that the October 8, 2026 hardware validation of meta-foundries `ff40dc1` built and ran on UNO Q.

| Layer | Branch | Commit |
| --- | --- | --- |
| meta-foundries | `main` | `ff40dc1` |
| `meta-qcom-arduino`, the UNO Q machine | `main` | `a65e94a` |
| `meta-qcom-distro`, the QLI distro | `main` | `acc7f52` |
| `meta-qcom`, the Qualcomm BSP | `master` | `21c9c0d` |
| OpenEmbedded Core | `master` | `db81c1a`, with three `meta-qcom` patches |
| BitBake | `master` | `18cca50` |
| `meta-openembedded` | `master` | `8b1d948` |
| `meta-selinux` | `master` | `7351443`, with three `meta-qcom` patches |
| `meta-security` | `master` | `0339b65` |
| `meta-virtualization` | `master` | `f45cc37` |
| `meta-updater` | `master` | `3f79539` |
| `meta-ai` | `main` | `3511d6c` |
| `meta-audioreach` | `master` | `c25274a` |

The configuration includes meta-foundries `ci/include/base.yml` at the pinned commit and lists the remaining layers itself.
Use the companion configuration throughout this walkthrough.

> **Why development branches?** The guide's directory, file names, update tag, and build IDs keep the name Wrynose, the release it was first written for.
> At these revisions, the UNO Q machine needs a boot-firmware recipe that exists only on `meta-qcom` master.
> meta-foundries also writes license expressions in a syntax that only OpenEmbedded master accepts.
> A Wrynose build fails on both, so the guide uses the development-branch commits validated on hardware.

meta-foundries `ff40dc1` selects aktualizr-lite `5d93718`, which includes the OS-name fix.
The client derives the booted OSTree stateroot, including `nodistro`, when `pacman.os` is unset.
The guide leaves `pacman.os` unset and requires the OS-update exercise to verify finalization after reboot.

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
kas-container --version
```

The last command must print `kas-container 5.4`.
The `PATH` setting places this wrapper ahead of any other installed kas-container, for this shell only.
These settings last for this shell; in a new shell for a build, set `GUIDE_DIR` and repeat the `export` lines above.
If you already have Yocto Project download and shared-state caches, point `DL_DIR` and `SSTATE_DIR` at them; otherwise keep these paths.
Keep the build tree on a case-sensitive Linux filesystem.

### Select the Board's Memory Configuration

Start with the base configuration:

```bash
export GUIDE_KAS='kas/uno-q-wrynose.yml'
```

**4 GB UNO Q boards** need the temporary M-05 memory reservation.
Until Qualcomm releases fixed boot firmware, every 4 GB board is affected; 2 GB boards are not.
Record the board's RAM size and, with a Bughopper, its firmware revision in `$GUIDE_DIR/workspace/board-record.txt`.
Keep this record in the build environment's guide directory, next to the build records.
The firmware revision comes from the console on the local computer; copy that line into the record:

- **RAM size:** UNO Q boards ship with different RAM sizes.
  Read your board's variant from its product label or purchase record.
  On a running board, `free -h` is supporting evidence only: reserved memory lowers the total it reports.
- **Firmware revision:** this needs the Bughopper's serial console, which you can open before the first flash.
  Fit the Bughopper as shown in [Connect a Bughopper](flash.md#with-a-bughopper).
  On the local computer, install `picocom` (`sudo apt install picocom`) and open the console:

  ```bash
  ls /dev/serial/by-id/
  export BUGHOPPER_PORT='/dev/serial/by-id/PASTE_THE_BUGHOPPER_PORT'
  picocom -b 115200 "$BUGHOPPER_PORT"
  ```

  If `picocom` reports a permission error, see the serial-permission note in [Connect a Bughopper](flash.md#with-a-bughopper).
  Power-cycle the board: unplug the UNO Q's USB-C cable, wait five seconds, and plug it back in.
  Early in the boot output, the boot firmware prints a line beginning `UEFI Ver`; record that line.
  For example, an affected 4 GB lab board printed `UEFI Ver : 6.0.260722.BOOT.MXF.1.0.c1-00536-KODIAKLA-2`.
  Exit `picocom` with Ctrl+A, then Ctrl+X.
  Without a Bughopper, skip this record; the RAM size decides.

If you cannot determine the RAM size, find it before building.

The [optional layer](workarounds/meta-unoq-m05/conf/layer.conf) reserves
`0x7b8ff000` through `0x7c9fefff` (17 MiB), with `no-map`, to keep that window out of Linux allocation and the linear map.
It carries the [lab diagnostic patch](https://github.com/foundriesio/foundries-open-update-tests/blob/10b030947f7fc30d513428129f36aecc4cd957bc/build/recipes/linux-arduino/0001-arm64-dts-qcom-qrb2210-arduino-imola-reserve-m05-boundary.patch).
This reduces usable RAM and is a temporary firmware workaround.
The firmware team's test firmware reportedly fixes the issue; a released fix and reservation-free validation remain pending.
Retain the reservation on affected boards until the released firmware passes validation without it.

For a 4 GB board, copy the supplied layer into the kas work directory and select its overlay:

```bash
mkdir -p "$KAS_WORK_DIR/meta-unoq-m05"
cp -a "$GUIDE_DIR/workarounds/meta-unoq-m05/." "$KAS_WORK_DIR/meta-unoq-m05/"
export GUIDE_KAS="$GUIDE_KAS:kas/m05-4gb.yml"
```

The overlay's relative repository path resolves under `KAS_WORK_DIR`, including inside kas-container.
It targets `linux-arduino_7.0` on `uno-q` and intentionally fails if that recipe is absent.
The patch applies to the kernel that the pinned Arduino layer selects.
Do not suppress a dangling-append error or generalize the patch to another kernel or board without reviewing it.
Use the same selection and layer contents for both OS builds; test firmware changes separately.

### Check the Sources and Build

The configuration pins every repository, so the build needs no kas lockfile.
If `kas/uno-q-wrynose.lock.yml` exists from an earlier revision of this guide, move it out of `kas/` first.
kas applies a lockfile next to a configuration automatically, and an old one would replace these pins.

Record your selection, write out the resolved configuration, and list its commits:

```bash
cd "$GUIDE_DIR"
printf '%s\n' "$GUIDE_KAS" > "$GUIDE_DIR/workspace/kas-config"
kas-container dump --resolve-refs "$GUIDE_KAS:kas/os-v1.yml" \
  > "$GUIDE_DIR/workspace/os-v1-resolved.yml"
awk '/^repos:/{r=1; next} /^[^ ]/{r=0} r && /^  [a-z]/{name=$1} r && /commit:/{print name, $2}' \
  "$GUIDE_DIR/workspace/os-v1-resolved.yml"
```

Check that each commit begins with the commit in the [table above](#what-is-pinned). Then build:

```bash
kas-container build "$GUIDE_KAS:kas/os-v1.yml"
```

The first build runs about 6,900 BitBake tasks.
On a 16-core host with 32 GB RAM and the sources already downloaded, it took about 35 minutes.
Allow two hours or more on a smaller host, or when the sources still need downloading.
If the build stops with an error, see [troubleshooting](troubleshooting.md#troubleshoot-a-failed-checkpoint).
Keep the pinned revisions; changing one to work around an error produces an untested combination.

Keep `workspace/kas-config`, `workspace/os-v1-resolved.yml`, and the optional layer bytes with your build records.
Use the same selection for OS version 2.
Do not update layer revisions between the two builds in this walkthrough.

The deployment directory is:

```bash
export DEPLOY="$KAS_WORK_DIR/build/tmp/deploy/images/uno-q"
ls "$DEPLOY"
```

Before continuing, confirm that it contains an `ostree_repo` directory and
`core-image-full-cmdline-uno-q.rootfs.qcomflash`.
That name is a symbolic link to the build's timestamped flash directory, so list it with `ls -L`:

```bash
ls -L "$DEPLOY/core-image-full-cmdline-uno-q.rootfs.qcomflash" \
  | grep -x -E 'prog_firehose_ddr.elf|rawprogram0.xml|patch0.xml'
```

The command must print all three file names.
The build also writes `core-image-full-cmdline-uno-q.rootfs.qcomflash.tar.gz`, which unpacks into a differently named directory.
This guide creates its own archive in the next step, so you can ignore that file.

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
Keep the guide directory, OS repository, build records, and Linux build environment for the later update exercises.
