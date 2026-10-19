---
title: Sources and Validation
description: Source revisions, authoring checks, and pending execution evidence for the UNO Q walkthrough.
type: page
doc-category: record
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-19
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2
  - https://github.com/qualcomm-linux/meta-qcom-distro/tree/acc7f52e830e4308ea97020184cfb8171b0b1d87
  - https://github.com/qualcomm-linux/meta-qcom/tree/21c9c0d8138e3472b0ac04e780f18be14aa959ab
  - https://github.com/qualcomm-linux/meta-qcom-arduino/tree/a65e94a51f8233607b683787735225a10d80fe65
  - https://github.com/uptane/meta-updater/tree/3f79539a8e1250c46d824b3af2415b9add945161
  - https://github.com/openembedded/openembedded-core/tree/db81c1a42a0f552d9a8ec124f004ae2063d58c33
  - https://github.com/foundriesio/update-server/tree/e30762e42e3cd45f730be51d2f0e5aaca2b02363
  - https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098
  - https://github.com/foundriesio/composeapp/tree/0af6d7702713f36848ae569dc7a6c7f05f1d2abe
  - https://github.com/foundriesio/aktualizr-lite/tree/5d9371869bb83dff10f951d26247cdd4a531bbb7
  - https://github.com/foundriesio/lmp-device-register/tree/d8f39a6d95e20f5b64881ae014381682aa1c7aad
  - https://github.com/foundriesio/foundries-open-update-tests/tree/10b030947f7fc30d513428129f36aecc4cd957bc/build/recipes
  - https://github.com/foundriesio/containers/tree/5be067eb56d1cb59dcbf82568f36986705af9a8a/shellhttpd
  - https://github.com/arduino/docs-content/tree/dab66ecbd6ad52cd742da6c19c5b6330a7f2caae
  - https://github.com/siemens/kas/tree/5.4
  - https://github.com/linux-msm/qdl/tree/v2.8
  - https://github.com/foundriesio/meta-foundries/pull/54
  - https://github.com/foundriesio/meta-foundries/commit/3ed349554814f5596891ac155d58a55f9a636df7
  - https://github.com/qualcomm/pytactl/tree/6ee43578f983487821ade4feebebad94198da622
  - https://github.com/qualcomm/pytactl/blob/4c47a6172e3ee6fabc16fb8b7042004ec9cd140f/60-pytactl.rules
  - https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/quick-start.md
  - https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/build-an-update.md
  - https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/updates.md
  - https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/fiocli.md
  - https://github.com/foundriesio/fio-style/blob/main/frontmatter-spec.md
relations:
  parent: README.md
---

# Sources and Validation

Build and hardware sources were reviewed on September 23, 2026.
Native server and packaging releases, frontmatter, and revised commands were reviewed on October 1, 2026.
The meta-foundries pin, registration contract, kas include layout, and optional M-05 workaround were reconciled on October 10, 2026.
A walkthrough of that revision ran on hardware on October 11, and the layer set changed on October 12, 2026.
A walkthrough of revision `f97458c` completed every exercise on hardware on October 13, 2026.
The update server then moved from release v1.0-rc1 to a source build of `main`.
Run 3 verified that source build at `e30762e` with guide revision `c71f6af` on 2026-10-13; its record was added on 2026-10-19.
This record describes the guide's evidence and outstanding execution checks.

## Source Baseline

| Source | Revision or version | Used for |
| --- | --- | --- |
| [meta-foundries](https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2) | `ff40dc16da368d471e890dd19fe945a220ef3ce2` | Shared integration configuration, package groups, client recipes |
| [meta-qcom-distro](https://github.com/qualcomm-linux/meta-qcom-distro/tree/acc7f52e830e4308ea97020184cfb8171b0b1d87) | `main`, `acc7f52e830e4308ea97020184cfb8171b0b1d87` | Qualcomm® Linux® (QLI) configuration, `qcom-distro-sota` |
| [meta-qcom](https://github.com/qualcomm-linux/meta-qcom/tree/21c9c0d8138e3472b0ac04e780f18be14aa959ab) | `master`, `21c9c0d8138e3472b0ac04e780f18be14aa959ab` | Qualcomm BSP, UNO Q boot-firmware recipe, Android Debug Bridge (ADB) image class, OpenEmbedded Core and `meta-selinux` patches, and the lock set for the core layers |
| [`meta-qcom-arduino`](https://github.com/qualcomm-linux/meta-qcom-arduino/tree/a65e94a51f8233607b683787735225a10d80fe65) | `main`, `a65e94a51f8233607b683787735225a10d80fe65` | UNO Q machine and the `linux-arduino` 7.0 kernel |
| [OpenEmbedded Core](https://github.com/openembedded/openembedded-core/tree/db81c1a42a0f552d9a8ec124f004ae2063d58c33) | `master`, `db81c1a42a0f552d9a8ec124f004ae2063d58c33` | Core layer; the remaining layer pins are listed on [the build page](build.md#what-is-pinned) |
| [meta-updater](https://github.com/uptane/meta-updater/tree/3f79539a8e1250c46d824b3af2415b9add945161) | `master`, `3f79539a8e1250c46d824b3af2415b9add945161` | OTA integration layer |
| [Foundries Update Server](https://github.com/foundriesio/update-server/tree/e30762e42e3cd45f730be51d2f0e5aaca2b02363) | `main`, `e30762e42e3cd45f730be51d2f0e5aaca2b02363` (`v1.0-rc1-12-ge30762e`), built from source and verified in run 3 on 2026-10-13; the earlier walkthroughs used release v1.0-rc1 (`6da3313295010f1bb521a393f15dacf987050254`) | Bootstrap, enrollment, CLI, configuration selection, upload and rollout implementation |
| [Host composectl](https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098) | v96.3.0, `07a5b14b2e55f6882f7323ad6a32e62438aa5098` | Released host packaging tool, publication, ARM64 content download, Docker credential support |
| [Device composeapp](https://github.com/foundriesio/composeapp/tree/0af6d7702713f36848ae569dc7a6c7f05f1d2abe) | `0af6d7702713f36848ae569dc7a6c7f05f1d2abe` | Device tool revision selected by the pinned meta-foundries recipe |
| [aktualizr-lite](https://github.com/foundriesio/aktualizr-lite/tree/5d9371869bb83dff10f951d26247cdd4a531bbb7) | `5d9371869bb83dff10f951d26247cdd4a531bbb7` | OS-name derivation, app comparison and unchanged OS handling, matched to the v97 recipe |
| [lmp-device-register](https://github.com/foundriesio/lmp-device-register/tree/d8f39a6d95e20f5b64881ae014381682aa1c7aad) | `d8f39a6d95e20f5b64881ae014381682aa1c7aad` | `fio-device-register` flags, factory environment override, tag and Compose configuration |
| [M-05 diagnostic patch](https://github.com/foundriesio/foundries-open-update-tests/blob/10b030947f7fc30d513428129f36aecc4cd957bc/build/recipes/linux-arduino/0001-arm64-dts-qcom-qrb2210-arduino-imola-reserve-m05-boundary.patch) | Tests repository `10b030947f7fc30d513428129f36aecc4cd957bc` | Optional reservation for affected 4 GB UNO Q firmware |
| [Foundries containers](https://github.com/foundriesio/containers/tree/5be067eb56d1cb59dcbf82568f36986705af9a8a/shellhttpd) | `5be067eb56d1cb59dcbf82568f36986705af9a8a` | Existing shellhttpd Dockerfile, script, and Compose example |
| [Arduino documentation](https://github.com/arduino/docs-content/tree/dab66ecbd6ad52cd742da6c19c5b6330a7f2caae) | `dab66ecbd6ad52cd742da6c19c5b6330a7f2caae` | Bughopper connection, 115200 baud, Emergency Download (EDL) procedure, linked hardware illustrations |
| [kas](https://github.com/siemens/kas/tree/5.4) | 5.4 | Wrapper, schema, container version variable |
| [`qdl`](https://github.com/linux-msm/qdl/tree/v2.8) | 2.8 | Linux host binary and flashing syntax |

## Run 3 Hardware Walkthrough on 2026-10-13

This record summarizes the verification of [guide revision `c71f6af2564cc7611b56f2ae8298cad8bddbb0a2`](https://github.com/foundriesio/meta-foundries/tree/c71f6af2564cc7611b56f2ae8298cad8bddbb0a2/docs/guides/uno-q-wrynose).
The run took place from 22:40 to 23:45 UTC on 2026-10-13.
An agent with read-only file and web access, no machine access, and no lab knowledge read the guide and issued the commands.
An operator ran each command verbatim on the named machine and returned its raw output.
The protocol allowed two operator rescues beyond relaying commands and output; none were needed.

### Verified Baseline

| Item | Revision or configuration |
| --- | --- |
| Board and access | Arduino UNO Q, 4 GB (4096 MB), with Bughopper for serial access and EDL |
| Boot firmware | UEFI `6.0.260722.BOOT.MXF.1.0.c1-00536-KODIAKLA-2` |
| BSP and kernel | meta-qcom `21c9c0d`, meta-qcom-arduino `a65e94a`, meta-qcom-distro `acc7f52`; kernel `7.0.14-gf2e5cd16ede5`; temporary M-05 workaround enabled |
| Build configuration | Guide kas configuration at `c71f6af`; meta-foundries `ff40dc1`, OpenEmbedded Core `db81c1a`, BitBake `18cca50`, meta-openembedded `8b1d948`; all 13 resolved pins matched |
| Image identity | Qualcomm Linux Reference Distro (OTA-enabled) `2.99+snapshot-93e9c9de95`; build IDs `unoq-wrynose-os-1` and `unoq-wrynose-os-2`; tag `wrynose` |
| Client and packaging | aktualizr-lite `97+git` at `5d93718`, with `pacman.os` unset; host composectl v96.3.0 |
| Server and CLI | Both built using the guide's source-build instructions at update-server `e30762e` (`v1.0-rc1-12-ge30762e`) |
| Build machine | Ubuntu 24.04.5 x86-64, kas-container 5.4 |
| Local computer | Separate Ubuntu 24.04.4 x86-64 machine for the server, flashing, and console; qdl v2.8; the guide's transfer steps were exercised |

### Checkpoint Results

| Checkpoint | Result |
| --- | --- |
| 1. Prepare the build host | PASS: host checks, kas-container, and guide checkout |
| 2. Build | PASS: firmware record, M-05 selection, all 13 pins, OS version 1 build (6,927 tasks), archive, and transfer |
| 3. Flash and connect | PASS: Bughopper EDL, qdl flash of 31 partitions with no errors, reset, serial shell, Wi-Fi, clock, identity, and M-05 checks |
| 4. Start the update server | PASS: source build, initialization, and serving with `attemptsPerSecond: 20` |
| 5. Register and select | PASS: registration and UI listing, active services, configuration, CLI login, and selection applied at the next poll; consecutive configuration commands returned no HTTP 429 |
| 6. Initial update | PASS: shellhttpd version 1 published, pulled over HTTPS, uploaded, rolled out, and responding on the existing OS |
| 7. OS version 2 and shellhttpd version 2 | PASS: 6,927 build tasks, rollout, reboot, successful finalization, OS version 2 identity, retained M-05 reservation, and application response |
| 8. Add a second application | PASS: both applications responded; OS checksum and boot ID were unchanged |
| 9. Application-only update | PASS: shellhttpd returned `X-App-Version: 3`, statushttpd remained available, and OS checksum and boot ID were unchanged |

The combined OS and application update in checkpoint 7 was the run's only OS update.
An OS-only update with unchanged applications was not exercised.
Checkpoints 8 and 9 verified application-only changes without an OS reboot.

### Coverage Limits and Follow-Up

- The HTTPS container registry was provisioned before the run and required no login.
  Registry setup and authenticated registry access were not tested.
- Build-machine packages were already installed, so the package-installation command was not rerun.
- Builds used shared download and shared-state caches, plus a local overlay limiting build parallelism.
  OS version 1 reused 6,499 of 6,927 tasks from shared state; a build without caches was not tested.
- The run used the Bughopper path and a 4 GB board with M-05.
  The ADB path and the 2 GB configuration were not exercised in this run.
- Shells stayed open, so restoring variables in a new shell was not tested.
  The conditional ARM64 emulation step was not needed by the example Dockerfile.
- The reader initially missed the local-computer prerequisites and encountered a missing Buildx error.
  The guide's Ubuntu instructions resolved it without an operator rescue.
  Add a `docker buildx version` check where Buildx is first needed.
- Clarify the location of `board-record.txt` when the build and console use separate computers, the first-boot Docker startup delay, and expected build and qdl success messages.
- Explain the observed client version-parsing warning, initial fioconfig target-parsing message, pre-finalization OSTree version mismatch, and `ffs_fs_kill_sb` shutdown warning.
- Clarify how kas applies the meta-qcom patches and add a build-page pointer to `kas/diag-download-mode.yml`.

The board's Wi-Fi address changed after the OS update reboot; the guide's address re-check handled it.
These results apply to the recorded guide and component revisions.

## October 12 Layer-Set Change and Build

### Why the Layer Set Changed

The October 11 walkthrough of revision `3039ef5` found that its Wrynose configuration could not build as written.
It failed in four ways, each confirmed and then patched locally to continue the walkthrough:

1. The kas checkout could not apply `meta-qcom`'s `linux-firmware` patch, because `meta-lts-mixins` followed its branch head.
   `meta-qcom` pins that repository in its own lockfile.
2. BitBake 2.18 at its branch head could not parse OpenEmbedded Core's `recipe_sanity` class, which `meta-qcom-distro` enables.
3. meta-foundries `ff40dc1` writes license expressions with `AND`, the Software Package Data Exchange (SPDX) syntax.
   OpenEmbedded Core master accepts them; Wrynose rejects them at parsing and at license collection.
4. The pinned Arduino layer's `uno-q` machine requires `firmware-qcom-boot-qrb2210`, a recipe that exists only on `meta-qcom` master.

The October 12 revision uses the layer set that the October 8, 2026 hardware validation of meta-foundries `ff40dc1` built and ran.
That validation composed meta-foundries `ci/uno-q.yml`, which includes the Arduino layer's `ci/uno-q.yml` and `meta-qcom`'s base configuration and lockfiles.
The companion configuration flattens that composition: the same repositories, commits, layers, and `meta-qcom` patches.
The pins match the validation build's recorded layer revisions, including the patched OpenEmbedded Core snapshot `93e9c9de95`.

The guide's local configuration still differs from that validation build:

- It includes meta-foundries `ci/include/base.yml` only.
  From `meta-qcom` `ci/base.yml` it carries the CodeLinaro fetch fallbacks (`MIRRORS`) and the 30-second systemd watchdog (`WATCHDOG_RUNTIME_SEC`).
  The forced `qcom_scm.download_mode=1` is the optional diagnostic overlay `kas/diag-download-mode.yml`.
  The build statistics, disk monitoring, and local `BUILD_ID` default stay out; the distro (`qcom-base.inc`) enables `efi`, `pam`, and `pni-names` itself.
- It sets the guide's update tag and server addresses, and ADB and root-filesystem growth as meta-foundries `ci/uno-q.yml` does.
  It also installs the `libcomposite` and `usb_f_fs` kernel modules: the UNO Q machine configuration installs a short module list without them, and the ADB service needs both.
- It omits the validation suite's test-only packages and settings, so the image has no `curl`.
  The guide's HTTP checks run from the computer.

The M-05 layer's `LAYERSERIES_COMPAT` now names `blacksail`, the OpenEmbedded Core master series, as well as `wrynose`.
Its patch is byte-identical to the one the October 8 validation build carried.

### Build Result

The build ran on October 12, 2026, on an x86-64 Ubuntu 24.04 host, following [the build page](build.md#check-the-sources-and-build) with the M-05 overlay:

- `kas-container lock kas/uno-q-wrynose.yml` wrote no lockfile, because every repository is pinned.
- `kas-container dump --resolve-refs` resolved all 13 repositories to the commits in [the build page's table](build.md#what-is-pinned).
- `kas-container build kas/uno-q-wrynose.yml:kas/m05-4gb.yml:kas/os-v1.yml` with kas 5.4 completed all 6,927 tasks without an error.
  The OS version 2 build, with `kas/os-v2.yml`, also completed all 6,927 tasks; its commit differs from version 1's.
- The deployment directory held `ostree_repo` and the flash directory with `prog_firehose_ddr.elf`, `rawprogram0.xml`, and `patch0.xml`.
- The OS version 1 commit's `/usr/lib/os-release` reports `BUILD_ID="unoq-wrynose-os-1"` and `LMP_FACTORY_TAG="wrynose"`, and version 2's reports `BUILD_ID="unoq-wrynose-os-2"`.
  The image has no `/usr/bin/curl`.
- The compiled device tree contains the `m05-boundary-guard@7b8ff000` reservation node.

The build reused the download and shared-state caches of the October 8 builds, and reused 98% of its shared-state tasks.
The kernel and device tree came from that cache, so their task inputs match the hardware-validated build exactly.
The host added a local overlay that limits BitBake threads and memory pressure; it is not part of the guide.

### October 13 Flash and ADB Check

A flash of the October 12 OS version 1 image booted, but `android-tools-adbd` failed: `modprobe libcomposite` found no module, because the image installed no USB gadget modules.
The guide's configuration now installs `kernel-module-libcomposite` and `kernel-module-usb-f-fs`.
On October 13, OS versions 1 and 2 were rebuilt with that change; each build again completed all 6,927 tasks.
OS version 1 was flashed with `qdl` 2.8 through a Bughopper on a 4 GB UNO Q and booted normally:

- `BUILD_ID="unoq-wrynose-os-1"`, kernel `7.0.14`, and no failed systemd units.
- The `m05-boundary-guard@7b8ff000` reservation is present with `no-map`, at `0x7b8ff000` with size `0x1100000`.
- `android-tools-adbd` is active, and the USB gadget is bound and configured.
- From an Ubuntu 24.04 container on the computer attached by USB, `adb devices` listed the board, and `adb root` and `adb shell` gave a root shell.

The kernel logs a `WARNING` from `ffs_fs_kill_sb` each time the ADB service removes its USB function: once during boot, and again when `adb root` restarts the service.
ADB keeps working after it.
The October 13 walkthrough below repeated Wi-Fi, registration, and the update exercises with this configuration.

### October 13 Hardware Walkthrough of Revision `f97458c`

A reader followed revision `f97458c` from start to finish on the same 4 GB UNO Q with a Bughopper.
The build environment was Ubuntu 24.04 with Docker's packages; the local computer was Ubuntu 24.04 with Ubuntu's Docker packages.
The local computer ran update-server release v1.0-rc1 and, with no registry account, a local `registry:2` container.

- **Build:** OS versions 1 and 2 built from the guide's configuration with the M-05 overlay, with no corrections.
- **Flash and connect:** EDL entry, the 31-partition flash, reset, Wi-Fi, and clock checks completed as written.
  The M-05 reservation was present on OS versions 1 and 2.
- **Server and registration:** completed. Back-to-back CLI commands hit release v1.0-rc1's request-rate limit (HTTP 429) three times.
- **First rollout:** `UNO Q: shellhttpd version 1`.
- **OS version 2:** `BUILD_ID="unoq-wrynose-os-2"`, a new boot ID and deployment, and the OS version 1 deployment kept for rollback.
  aktualizr-lite finalized the update after the reboot with `pacman.os` unset, and `shellhttpd` version 2 answered.
- **Second application:** `statushttpd` version 1 answered on port 8081 beside `shellhttpd` version 2; the boot ID and OS checksum were unchanged.
- **Application-only update:** port 8080 returned `X-App-Version: 3` and `UNO Q: shellhttpd version 3`; `statushttpd`, the boot ID, and the OS checksum were unchanged.

The walkthrough needed two corrections, both on the application page:

- `composectl publish` packs the current directory into the app bundle; from `workspace/` it failed with `app bundle size exceeds the maximum allowed`.
- `composectl pull` needs a registry that serves HTTPS with a trusted certificate; the plain-HTTP local registry failed.

It also found that the board's Wi-Fi address changed across the OS version 2 reboot.
The Wi-Fi interface takes a new random hardware address at each boot, so the local network assigned a new address.

This revision adds those findings and builds update-server from `main` at `e30762e`, which raises the request-rate limit to 20 per second.
The later [run 3 walkthrough](#run-3-hardware-walkthrough-on-2026-10-13) verified that source build against the board.

### October 11 Hardware Walkthrough of Revision `3039ef5`

A reader followed revision `3039ef5` on a 4 GB UNO Q with a Bughopper, using an Ubuntu 24.04 build host and local computer.
The walkthrough stopped at the first container-registry step of [the application page](application-updates.md), by design.
Its image came from the Wrynose configuration with the four local fixes above, so it is not the image this revision builds.

Every step after the build completed as written or with the clarifications this revision adds:

- `qdl` 2.8 and `pytactl` 2.0.0 installation, the Bughopper permissions rules, `pytactl list`, `bootToEDL`, `qdl list`, the 31-partition flash, and `reset` to normal boot.
- The serial console, `/etc/os-release` (`BUILD_ID="unoq-wrynose-os-1"`), Wi-Fi, and clock synchronization.
- The M-05 check: `reg` of `0x7b8ff000` and size `0x1100000`, with `no-map` present.
- The update server's download, initialization, and `serve`; UI sign-in; device registration as `unoq-01` with tag `wrynose`;
  `type = "ostree+compose_apps"`, no `pacman.os`; heartbeat; `fiocli login`; and the `shellhttpd` selection.

This revision adds fixes for the walkthrough's findings:

- Build page: Docker package routes, where the guide files come from, the serial console for the firmware record, and build failures.
- Flashing page: `qdl` installation, EDL timing, the `qdl list` stop rule, and the `nmcli` pager.
- Server page: name checks without `getent`, firewall checks, a browser on another computer, and the application-selection check.
- Application page: HTTP checks from the computer, since the image has no `curl`.

## October 10 Source Reconciliation

This section records the review of revision `3039ef5`.
Its layer findings are superseded by the [October 12 change](#october-12-layer-set-change-and-build); the client, registration, and M-05 findings still apply.

The updated meta-foundries pin is the main-branch head observed on October 10, 2026.
Its v97 recipe selects aktualizr-lite `5d93718`, including
[OS-name derivation](https://github.com/foundriesio/aktualizr-lite/blob/5d9371869bb83dff10f951d26247cdd4a531bbb7/src/ostree/sysroot.cc#L38-L60)
and [propagation to the package manager](https://github.com/foundriesio/aktualizr-lite/blob/5d9371869bb83dff10f951d26247cdd4a531bbb7/src/liteclient.cc#L111-L113).
Its aktualizr submodule also uses the configured OS name in the
[deployment query](https://github.com/foundriesio/aktualizr/blob/3c0260eda5a3abd2e0268d1c43b48ad383d82d79/src/libaktualizr/package_manager/ostreemanager.cc#L460-L464).
The tutorial leaves `pacman.os` unset, so its own reboot and update-finalization evidence must establish the result.
Other lab tests do not validate this tutorial's exact configuration.

The upstream UNO Q CI entrypoint now includes configuration files from the Arduino layer and its development-branch lock set.
The tutorial instead includes only `ci/include/base.yml`, which has no recursive includes or sibling lockfile at this pin.
Its complete source map retains the prior Wrynose branches, layer list, ADB settings, and root-filesystem growth package.
This keeps imported development lockfiles out of the tutorial's resolution.

Not including the Arduino and QCOM CI files also drops the local configuration that meta-qcom `ci/base.yml` (`18fe568`) supplies.
The guide restores its CodeLinaro fetch fallbacks (`MIRRORS`) and the 30-second systemd watchdog (`WATCHDOG_RUNTIME_SEC`) unchanged.
`IMAGE_ROOTFS_EXTRA_SPACE = "307200"` is already set by meta-foundries `ci/include/base.yml`.
The forced `qcom_scm.download_mode=1` is left out of the normal configuration and offered as the optional diagnostic overlay `kas/diag-download-mode.yml`.
Without it, a kernel crash resets the board instead of leaving it in Qualcomm RAM-dump mode.
The distro (`qcom-base.inc`) enables `efi` itself.
`meta-qcom-distro` does not require `meta-ai` or `meta-audioreach`; it lists `meta-audioreach` only as a recommendation.
The remaining base settings (build statistics and history, disk monitoring, and the local `BUILD_ID` default) are build-host conveniences and are not carried.

The Arduino, QLI distro, QCOM BSP, and meta-updater revisions are deliberately held at the recorded pins.
The Qualcomm source trees and exact current branch heads could not be re-inspected in this review because source access was denied.
Their original source-review record is retained; this update makes no new claim about their current heads or kernel compatibility.
The reviewed meta-updater Wrynose head is three commits ahead of the retained pin; no reviewed change requires moving that pin for this walkthrough.
Unpinned Wrynose repositories still require the documented kas lock step, followed by inspection of the resolved revisions.
No lockfile or image was generated as part of this source review.

The registration recipe builds `d8f39a6` with `REQUIRE_FACTORY` disabled.
The [option handling](https://github.com/foundriesio/lmp-device-register/blob/d8f39a6d95e20f5b64881ae014381682aa1c7aad/src/options.cpp#L96-L152)
defaults the factory string to `fio-device-register`; `DEVICE_FACTORY=unoq-lab` overrides it.
The guide removes the ineffective `LMP_FACTORY` assignment and retains the `wrynose` image and enrollment tags.
The pinned local server [normalizes the factory-prefixed authorization scope](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/server/ui/api/handlers_oauth2.go#L68-L82)
and [preserves the certificate subject](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/server/ui/api/handlers_devices_create.go#L92-L108).
The factory label is client/certificate metadata; it does not select a separate namespace on this server.

The optional M-05 layer copies the diagnostic patch unchanged:
SHA-256 `69d982aa158e7741b39087519d134b1748010a6c39931f68dadb703e7290c560`.
Its append targets `linux-arduino_7.0`, matching the source test fixture.
On October 10, `git apply --check` of the patch against `arch/arm64/boot/dts/qcom/qrb2210-arduino-imola-base.dts` passed.
It was run at the kernel source the retained Arduino pin selects (linux-arduino 7.0, `122c2c2` from `35f3dfd`).
That is a textual check only.
At the October 10 source review, building, the compiled device-tree contents, the live reservation, and update behavior were unverified for this guide.
Later build and hardware results are recorded above, including the [run 3 walkthrough](#run-3-hardware-walkthrough-on-2026-10-13).
The scope is affected 4 GB boards with the firmware memory-map issue, not every UNO Q.
The reported test-firmware fix is awaiting release; removing the reservation requires validation of released firmware without it.

## Bughopper Procedure Sources

The Bughopper EDL procedure is adapted from Caio Pereira's
[PR #54](https://github.com/foundriesio/meta-foundries/pull/54),
[commit `3ed3495`](https://github.com/foundriesio/meta-foundries/commit/3ed349554814f5596891ac155d58a55f9a636df7).
The guide uses `pytactl` 2.0.0, whose
[release source](https://github.com/qualcomm/pytactl/tree/6ee43578f983487821ade4feebebad94198da622)
was checked for device discovery, Bughopper V1/V2 support, EDL entry, and reset behavior.
The Bughopper permissions rules follow the
[upstream rules at `4c47a61`](https://github.com/qualcomm/pytactl/blob/4c47a6172e3ee6fabc16fb8b7042004ec9cd140f/60-pytactl.rules).
`bootToEDL` asserts EDL while cycling power; `reset` clears EDL and cycles power for normal boot.
These source checks are supplemented by the Bughopper hardware runs recorded above and in the execution-status table.

## Relationship to the Upstream Server Documentation

The guide follows these documents, checked at the pinned server revision:

- [`quick-start.md`](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/quick-start.md): development bootstrap and device registration.
- [`build-an-update.md`](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/build-an-update.md): image publication, Compose app publication, and offline content download.
- [`updates.md`](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/updates.md): upload, target versioning, and rollout.
- [`fiocli.md`](https://github.com/foundriesio/update-server/blob/e30762e42e3cd45f730be51d2f0e5aaca2b02363/docs/fiocli.md): CLI authentication and contexts.

The upstream QLI/meta-foundries build subsection is unfinished at this revision.
This guide adds the UNO Q build configuration and follows the native development-server bootstrap.
The server and CLI are built from the same update-server commit.
The host packaging tool uses the released composectl binary with publication enabled.

The current CLI takes an update name, such as `unoq-001`, for rollout commands.
The guide follows the CLI implementation for rollout arguments.
The guide downloads and uploads app blobs; supplying only `--apps name=digest` would not supply the required content.

## Design Choices

- Every layer is pinned to the commits of the October 8, 2026 UNO Q hardware validation, on the `main` and `master` development branches.
  The guide moves to a release branch only when that release can build the UNO Q machine and meta-foundries.
- The companion configuration pins every repository, so the build needs no kas lockfile.
  The selected M-05 overlay and its local source bytes, when used, are recorded separately and reused for OS version 2.
- The walkthrough uses an x86-64 Linux host for building, flashing, and running the local server.
- The server, CLI, and packaging tool run under the host account.
  Server state persists in `workspace/datadir/`; CLI login persists in `$HOME/.config/fiocli.yaml`.
- Native packaging uses the host Docker configuration and its credential helpers.
- The server's local-network hostname is set explicitly when creating its public key infrastructure (PKI).
  Both the computer and board resolve that name through their hosts files.
- Application packaging uses an Open Container Initiative (OCI) registry. Private packages work because authenticated packaging downloads the complete app content.
- The example keeps the existing Foundries shellhttpd implementation and changes its Compose `MSG` between releases.
- The second release changes both the OS `BUILD_ID` and the app message, making both changes observable.
- The third release adds an independent `statushttpd` Compose app, reusing the Foundries example on port 8081.
- The fourth release rebuilds the `shellhttpd` image with a visible HTTP header and retains the original `statushttpd` digest.
- Both application-only uploads omit the OS repository and pass the device's current OS checksum explicitly through `--ostree-hash`.
  The server otherwise substitutes the SHA-256 checksum of empty content; omission does not preserve the installed OS automatically.
- Application-only verification checks the original boot ID, OS checksum, and OS build ID, together with both application responses.

## Execution Status

The following table combines the historical checks and run 3 results.
Run 3 used guide revision `c71f6af` and update server `e30762e`; remaining gaps are explicit.

| Check | Required evidence | Status |
| --- | --- | --- |
| Build | Resolved configuration, build result, manifests, flash bundle, OS repository | OS version 1 and 2 built October 12, 2026, rebuilt October 13 with the ADB kernel modules, and built again by the October 13 walkthrough |
| Boot of this revision's image | Flash, normal boot, `BUILD_ID`, console | OS version 1 flashed and booted October 13; OS version 2 booted through the update |
| M-05 on affected 4 GB board | Board/RAM and firmware identity, matching kernel recipe, successful patch/build, compiled and booted device-tree reservation at `0x7b8ff000` of size `0x1100000`, update/reboot logs | Patch, build, and compiled node checked October 12; booted reservation checked October 13 on OS versions 1 and 2, before and after the update reboot |
| M-05 removal | Released fixed firmware identity and passing reservation-free memory/update validation | Pending released firmware and validation |
| Bughopper path | Record Bughopper revision and tool version; verify installation, permissions, serial discovery, EDL enumeration, successful `qdl` write, reset to normal boot, and working serial console | Completed October 11 and 13 with `pytactl` 2.0.0 and `qdl` 2.8; Bughopper revision not recorded |
| Jumper flashing path | EDL pin sequence, USB enumeration, successful `qdl` write, jumper removal, and normal boot | Not run |
| ADB path | Device enumeration, root shell, Wi-Fi setup | Enumeration and root shell checked October 13 with a Bughopper-flashed board; Wi-Fi setup over ADB not run |
| Linux host | Docker Engine, Compose, Buildx, and native USB access | Build host with Docker's packages completed October 11 and 13; local computer with Ubuntu's packages, including `docker-buildx`, completed October 13 |
| Native server and tools | Linux binaries run, `composectl publish` is available, host registry authentication works, initialization succeeds, and restart preserves the data directory | With release v1.0-rc1 on October 13: initialization, `serve`, CLI login, `composectl` publish and pull. Registry authentication and restart not run (local registry). Run 3 also completed initialization, serving, CLI login, publication, and pull with the source build at `e30762e`; registry authentication and server restart remain untested |
| Enrollment | Successful board command, device identifier, `unoq-lab` certificate OU, `wrynose` tag, Compose package-manager type, heartbeat over gateway | Completed October 11 and 13, except the certificate OU, which was not inspected |
| App selection | fioconfig delivery and requested app list | Delivered to the board October 13: `shellhttpd`, then `shellhttpd,statushttpd` |
| First rollout | shellhttpd version 1 response and server result | Completed October 13 with release v1.0-rc1 and repeated in run 3 with source build `e30762e` |
| Second rollout | New OS build ID, changed boot ID/deployment, version 2 response, server success with `pacman.os` unset and the same memory-workaround selection | Completed October 13 with release v1.0-rc1 and repeated in run 3 with source build `e30762e` |
| Add a second application | Both HTTP apps respond; original app digest, OS checksum/build ID, and boot ID retained | Completed October 13 with release v1.0-rc1. Run 3 with `e30762e` confirmed both app responses and unchanged OS checksum and boot ID |
| Update only the existing app | New image's HTTP header and message; second app digest, OS checksum/build ID, and boot ID retained | Completed October 13 with release v1.0-rc1. Run 3 with `e30762e` confirmed the version 3 header, retained statushttpd, and unchanged OS checksum and boot ID |

The host resource allowance is a planning estimate, not a measured minimum.

## Earlier Authoring Checks

The following checks were recorded for the earlier guide revision.
They are historical authoring evidence and do not constitute a pass for the October 10 configuration changes.

- All three kas YAML files pass the kas 5.4 JSON schema.
- An offline expansion of the pinned upstream CI includes confirms the Wrynose branch overrides,
  pinned integration exceptions, `uno-q` machine, `qcom-distro-sota` distro, and image target.
- All Bash blocks pass `bash -n`; this verifies shell syntax, not command execution.
- All Bash blocks and local Markdown links pass their checks.
  Heading anchors resolve within the guide directory.
- All five diagrams pass the Mermaid 11 parser; sequence-note line breaks use `<br/>` rather than unescaped semicolons.
- The two official hardware images were retrieved and visually checked.
- The release assets, native bootstrap flags, CLI update arguments, and host credential handling were checked against release sources.
- The composectl release workflow builds with the `publish` tag used by the application exercises.
- All seven guide pages include the required frontmatter fields, source references, and page relationships.
  Metadata follows the [frontmatter specification](https://github.com/foundriesio/fio-style/blob/main/frontmatter-spec.md).
  The license remains `MIT`, as declared by the repository.

These checks do not establish layer compatibility beyond the declarations, native server startup, or successful device updating.

## October 10 Authoring Checks

These checks ran on the October 10 review patch, before `kas/diag-download-mode.yml` was added, so that patch had four companion YAML files.
The patch was then committed as `3039ef5`, whose CI checks passed.
CI's image builds use the repository's own configurations, not this guide's.

- All four companion YAML files pass the kas 5.4 JSON schema.
- Offline source-map expansion preserves all 12 repository URLs and layer selections, the four held pins, Wrynose branches, and BitBake 2.18.
  It selects meta-foundries `ff40dc1` and includes only its shared base configuration, without a nested CI lockfile.
- All four offline compositions (OS versions 1 and 2, with and without M-05) pass the same schema.
  This checks configuration structure; kas checkout, BitBake parsing, and kernel patch application remain pending.
- All 60 Bash blocks pass `bash -n`; none was executed as a walkthrough step.
- All seven pages pass required-frontmatter checks, and all 59 local Markdown links and heading anchors resolve.
- The copied M-05 patch matches the recorded upstream SHA-256 byte for byte; its start, size, and end addresses agree.
- Git whitespace checks pass for the edited guide and layer files.
  The unchanged upstream patch produces one space-before-tab warning on a diff-context line; its original bytes are preserved.
- The complete review diff passes a clean-base application check.

These are source and static checks. They do not validate the changed build or firmware combination.
Vale and the container-based Yocto checks were not rerun: that review environment had no Vale, Docker, Podman, or kas-container installed.

## Documentation Review Still Required

The tutorial uses title-case headings, defines unfamiliar acronyms, and uses registered trademark symbols at first body mention.
The flagged long sentences and ambiguous instructions have been clarified.
Remaining Vale findings include date punctuation, generic target capitalization, and false positives for defined acronyms and literal identifiers.
Vale also flags the required license identifier and agent name in frontmatter as undefined acronyms.
The acronym rule does not recognize some definitions containing lowercase words or trademark symbols.
The branding rule also suggests replacing the word "exceptions" with `?:+.py` because its exception configuration is nested under its replacement mapping.
The tutorial retains ISO-8601 dates, lowercase generic targets, and the word "exceptions".
These findings require rule or terminology review; the guide does not apply the malformed replacement.
The advisory Vale CI job can pass while findings remain.

The guide adds documentation and a separate optional layer; it does not change the meta-foundries layer itself.
CI runs the repository's container-based `yocto-patchreview` and `yocto-check-layer` checks on each revision.

## Illustrations

The diagrams are original Mermaid source embedded in Markdown.
Hardware images link to Arduino's published documentation at the recorded revision, with attribution and alt text.
They require network access when the Markdown viewer loads them.
No generated hardware image or invented UI screenshot is used.
