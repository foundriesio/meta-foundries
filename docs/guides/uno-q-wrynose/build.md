---
title: Build QLI Wrynose for UNO Q
description: Prepare a Linux host, build Qualcomm Linux Wrynose, and preserve the UNO Q image and OS repository.
date: 2026-09-23
status: Source-reviewed draft; hardware walkthrough pending
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

Copy this entire guide directory to your computer, including `kas/` and `server/`.
Open a Bash shell in that directory:

```bash
export GUIDE_DIR="$PWD"
mkdir -p "$GUIDE_DIR/workspace" "$GUIDE_DIR/.registry-auth"
chmod 700 "$GUIDE_DIR/.registry-auth"
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
The [companion configuration](kas/uno-q-wrynose.yml) overrides the upstream CI configuration's moving branch selections.
Do not substitute a plain `ci/uno-q.yml` build command: that configuration selects development branches.

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

Generate a lockfile for the remaining layer revisions, then build:

```bash
cd "$GUIDE_DIR"
kas-container lock kas/uno-q-wrynose.yml
kas-container build kas/uno-q-wrynose.yml:kas/os-v1.yml
```

Retain the generated `kas/uno-q-wrynose.lock.yml` with your build records.
Use the same lockfile for OS version 2.
Do not update layer revisions between the two builds in this walkthrough.

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
