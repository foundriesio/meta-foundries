---
title: Sources and Validation
description: Source revisions, authoring checks, and pending execution evidence for the UNO Q walkthrough.
type: page
doc-category: record
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-10
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2
  - https://github.com/qualcomm-linux/meta-qcom-distro/tree/c3e4c471ddf7874b95a9d417a61019af25aa2c5b
  - https://github.com/qualcomm-linux/meta-qcom/tree/18fe56873dc425b0bb6c3a7e7b01af0c14005288
  - https://github.com/qualcomm-linux/meta-qcom-arduino/tree/35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd
  - https://github.com/uptane/meta-updater/tree/92f4788c30fdcab2d376eb9ae6b191bda7d06d0a
  - https://github.com/foundriesio/update-server/tree/6da3313295010f1bb521a393f15dacf987050254
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
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/quick-start.md
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/build-an-update.md
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/updates.md
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/fiocli.md
  - https://github.com/foundriesio/fio-style/blob/main/frontmatter-spec.md
relations:
  parent: README.md
---

# Sources and Validation

Build and hardware sources were reviewed on September 23, 2026.
Native server and packaging releases, frontmatter, and revised commands were reviewed on October 1, 2026.
The meta-foundries pin, registration contract, kas include layout, and optional M-05 workaround were reconciled on October 10, 2026.
This record describes the guide's evidence and outstanding execution checks.

## Source Baseline

| Source | Revision or version | Used for |
| --- | --- | --- |
| [meta-foundries](https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2) | `ff40dc16da368d471e890dd19fe945a220ef3ce2` | Shared integration configuration, package groups, client recipes |
| [meta-qcom-distro](https://github.com/qualcomm-linux/meta-qcom-distro/tree/c3e4c471ddf7874b95a9d417a61019af25aa2c5b) | Wrynose, `c3e4c471ddf7874b95a9d417a61019af25aa2c5b` | Qualcomm® Linux® (QLI) 2.1 configuration, `qcom-distro-sota`, Wrynose dependency branches |
| [meta-qcom](https://github.com/qualcomm-linux/meta-qcom/tree/18fe56873dc425b0bb6c3a7e7b01af0c14005288) | Wrynose, `18fe56873dc425b0bb6c3a7e7b01af0c14005288` | BitBake 2.18, firmware mixin, ADB image class |
| [`meta-qcom-arduino`](https://github.com/qualcomm-linux/meta-qcom-arduino/tree/35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd) | `35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd` | UNO Q machine and Wrynose compatibility declaration |
| [meta-updater](https://github.com/uptane/meta-updater/tree/92f4788c30fdcab2d376eb9ae6b191bda7d06d0a) | Wrynose, `92f4788c30fdcab2d376eb9ae6b191bda7d06d0a` | OTA integration layer |
| [Foundries Update Server](https://github.com/foundriesio/update-server/tree/6da3313295010f1bb521a393f15dacf987050254) | v1.0-rc1, `6da3313295010f1bb521a393f15dacf987050254` | Bootstrap, enrollment, CLI, configuration selection, upload and rollout implementation |
| [Host composectl](https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098) | v96.3.0, `07a5b14b2e55f6882f7323ad6a32e62438aa5098` | Released host packaging tool, publication, ARM64 content download, Docker credential support |
| [Device composeapp](https://github.com/foundriesio/composeapp/tree/0af6d7702713f36848ae569dc7a6c7f05f1d2abe) | `0af6d7702713f36848ae569dc7a6c7f05f1d2abe` | Device tool revision selected by the pinned meta-foundries recipe |
| [aktualizr-lite](https://github.com/foundriesio/aktualizr-lite/tree/5d9371869bb83dff10f951d26247cdd4a531bbb7) | `5d9371869bb83dff10f951d26247cdd4a531bbb7` | OS-name derivation, app comparison and unchanged OS handling, matched to the v97 recipe |
| [lmp-device-register](https://github.com/foundriesio/lmp-device-register/tree/d8f39a6d95e20f5b64881ae014381682aa1c7aad) | `d8f39a6d95e20f5b64881ae014381682aa1c7aad` | `fio-device-register` flags, factory environment override, tag and Compose configuration |
| [M-05 diagnostic patch](https://github.com/foundriesio/foundries-open-update-tests/blob/10b030947f7fc30d513428129f36aecc4cd957bc/build/recipes/linux-arduino/0001-arm64-dts-qcom-qrb2210-arduino-imola-reserve-m05-boundary.patch) | Tests repository `10b030947f7fc30d513428129f36aecc4cd957bc` | Optional reservation for affected 4 GB UNO Q firmware |
| [Foundries containers](https://github.com/foundriesio/containers/tree/5be067eb56d1cb59dcbf82568f36986705af9a8a/shellhttpd) | `5be067eb56d1cb59dcbf82568f36986705af9a8a` | Existing shellhttpd Dockerfile, script, and Compose example |
| [Arduino documentation](https://github.com/arduino/docs-content/tree/dab66ecbd6ad52cd742da6c19c5b6330a7f2caae) | `dab66ecbd6ad52cd742da6c19c5b6330a7f2caae` | Bughopper connection, 115200 baud, Emergency Download (EDL) procedure, linked hardware illustrations |
| [kas](https://github.com/siemens/kas/tree/5.4) | 5.4 | Wrapper, schema, lock command, container version variable |
| [`qdl`](https://github.com/linux-msm/qdl/tree/v2.8) | 2.8 | Linux host binary and flashing syntax |

## October 10 Source Reconciliation

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
The pinned local server [normalizes the factory-prefixed authorization scope](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/server/ui/api/handlers_oauth2.go#L68-L82)
and [preserves the certificate subject](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/server/ui/api/handlers_devices_create.go#L92-L108).
The factory label is client/certificate metadata; it does not select a separate namespace on this server.

The optional M-05 layer copies the diagnostic patch unchanged:
SHA-256 `69d982aa158e7741b39087519d134b1748010a6c39931f68dadb703e7290c560`.
Its append targets `linux-arduino_7.0`, matching the source test fixture.
On October 10, `git apply --check` of the patch against `arch/arm64/boot/dts/qcom/qrb2210-arduino-imola-base.dts` passed.
It was run at the kernel source the retained Arduino pin selects (linux-arduino 7.0, `122c2c2` from `35f3dfd`).
That is a textual check only.
Building, the compiled device-tree contents, the live reservation, and update behavior remain unverified for this guide.
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
These are source checks; hardware execution remains pending.

## Relationship to the Upstream Server Documentation

The guide follows these documents, checked at the pinned server revision:

- [`quick-start.md`](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/quick-start.md): development bootstrap and device registration.
- [`build-an-update.md`](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/build-an-update.md): image publication, Compose app publication, and offline content download.
- [`updates.md`](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/updates.md): upload, target versioning, and rollout.
- [`fiocli.md`](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/fiocli.md): CLI authentication and contexts.

The upstream QLI/meta-foundries build subsection is unfinished at this revision.
This guide adds the Wrynose configuration and follows the native development-server bootstrap.
The downloaded server and CLI use the same release.
The host packaging tool uses the released composectl binary with publication enabled.

The current CLI takes an update name, such as `unoq-001`, for rollout commands.
The guide follows the CLI implementation for rollout arguments.
The guide downloads and uploads app blobs; supplying only `--apps name=digest` would not supply the required content.

## Design Choices

- QLI, Qualcomm BSP, and core dependency layers use Wrynose; BitBake uses 2.18.
- meta-foundries had no Wrynose branch at the original build-source review date. Its pinned revision declares Wrynose compatibility.
- The Arduino layer had only `main` at the original build-source review date. Its pinned revision declares Wrynose compatibility.
- A kas lockfile captures the remaining floating Wrynose references before the first build.
  The selected M-05 overlay and its local source bytes, when used, are recorded separately and reused for OS version 2.
- The walkthrough uses an x86-64 Linux host for building, flashing, and running the local server.
- The released server, CLI, and packaging tool run under the host account.
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

## Execution Still Required

This source review did not run a guide build or hardware walkthrough.
No native server launch, QLI compilation, firmware flashing, registration, or rollout is claimed as tested.

Before calling the guide hardware-validated, record the following results with the generated lockfile:

| Check | Required evidence | Status |
| --- | --- | --- |
| Wrynose build | kas lockfile, build result, manifests, flash bundle, OS repository | Not run |
| M-05 on affected 4 GB board | Board/RAM and firmware identity, matching kernel recipe, successful patch/build, compiled and booted device-tree reservation at `0x7b8ff000` of size `0x1100000`, update/reboot logs | Not run |
| M-05 removal | Released fixed firmware identity and passing reservation-free memory/update validation | Pending released firmware and validation |
| Bughopper path | Record Bughopper revision and tool version; verify installation, permissions, serial discovery, EDL enumeration, successful `qdl` write, reset to normal boot, and working serial console | Not run |
| Jumper flashing path | EDL pin sequence, USB enumeration, successful `qdl` write, jumper removal, and normal boot | Not run |
| ADB path | Device enumeration, root shell, Wi-Fi setup | Not run |
| Linux host | Docker Engine, Compose, Buildx, and native USB access | Not run |
| Native server and tools | Linux binaries run, `composectl publish` is available, host registry authentication works, initialization succeeds, and restart preserves the data directory | Not run |
| Enrollment | Successful board command, device identifier, `unoq-lab` certificate OU, `wrynose` tag, Compose package-manager type, heartbeat over gateway | Not run |
| App selection | fioconfig delivery and requested app list | Not run |
| First rollout | shellhttpd version 1 response and server result | Not run |
| Second rollout | New OS build ID, changed boot ID/deployment, version 2 response, server success with `pacman.os` unset and the same memory-workaround selection | Not run |
| Add a second application | Both HTTP apps respond; original app digest, OS checksum/build ID, and boot ID retained | Not run |
| Update only the existing app | New image's HTTP header and message; second app digest, OS checksum/build ID, and boot ID retained | Not run |

The host resource allowance is a planning estimate, not a measured minimum.
The kas override is a newly authored companion configuration; its complete build remains pending.

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
Vale and the container-based Yocto checks were not rerun: this review environment has no Vale, Docker, Podman, or kas-container installed.
No new commit was created, so there is no new commit-message check or CI result for this review diff.

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

The local environment has no Docker, Podman, or installed kas-container.
The repository's container-based `yocto-patchreview` and `yocto-check-layer` checks could not run.
Run those checks through CI or a configured Linux environment before marking the contribution ready for review.

## Illustrations

The diagrams are original Mermaid source embedded in Markdown.
Hardware images link to Arduino's published documentation at the recorded revision, with attribution and alt text.
They require network access when the Markdown viewer loads them.
No generated hardware image or invented UI screenshot is used.
