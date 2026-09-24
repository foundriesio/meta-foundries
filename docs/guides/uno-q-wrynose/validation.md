---
title: Sources and Validation
description: Source revisions, authoring checks, and pending execution evidence for the UNO Q walkthrough.
type: page
doc-category: record
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-01
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/4dbe7efc08aef350f247aca83e518a9197c9a31a
  - https://github.com/qualcomm-linux/meta-qcom-distro/tree/c3e4c471ddf7874b95a9d417a61019af25aa2c5b
  - https://github.com/qualcomm-linux/meta-qcom/tree/18fe56873dc425b0bb6c3a7e7b01af0c14005288
  - https://github.com/qualcomm-linux/meta-qcom-arduino/tree/35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd
  - https://github.com/uptane/meta-updater/tree/92f4788c30fdcab2d376eb9ae6b191bda7d06d0a
  - https://github.com/foundriesio/update-server/tree/6da3313295010f1bb521a393f15dacf987050254
  - https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098
  - https://github.com/foundriesio/composeapp/tree/0af6d7702713f36848ae569dc7a6c7f05f1d2abe
  - https://github.com/foundriesio/aktualizr-lite/tree/7bb558258bd64214abf27e4bb6567a17f9cf7854
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
This record describes the guide's evidence and outstanding execution checks.

## Source Baseline

| Source | Revision or version | Used for |
| --- | --- | --- |
| [meta-foundries](https://github.com/foundriesio/meta-foundries/tree/4dbe7efc08aef350f247aca83e518a9197c9a31a) | `4dbe7efc08aef350f247aca83e518a9197c9a31a` | UNO Q CI entrypoint, package groups, Android Debug Bridge (ADB) configuration, client recipes |
| [meta-qcom-distro](https://github.com/qualcomm-linux/meta-qcom-distro/tree/c3e4c471ddf7874b95a9d417a61019af25aa2c5b) | Wrynose, `c3e4c471ddf7874b95a9d417a61019af25aa2c5b` | Qualcomm® Linux® (QLI) 2.1 configuration, `qcom-distro-sota`, Wrynose dependency branches |
| [meta-qcom](https://github.com/qualcomm-linux/meta-qcom/tree/18fe56873dc425b0bb6c3a7e7b01af0c14005288) | Wrynose, `18fe56873dc425b0bb6c3a7e7b01af0c14005288` | BitBake 2.18, firmware mixin, ADB image class |
| [`meta-qcom-arduino`](https://github.com/qualcomm-linux/meta-qcom-arduino/tree/35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd) | `35f3dfdd4dca56d0df60b621ff8fd70a8043bcfd` | UNO Q machine and Wrynose compatibility declaration |
| [meta-updater](https://github.com/uptane/meta-updater/tree/92f4788c30fdcab2d376eb9ae6b191bda7d06d0a) | Wrynose, `92f4788c30fdcab2d376eb9ae6b191bda7d06d0a` | OTA integration layer |
| [Foundries Update Server](https://github.com/foundriesio/update-server/tree/6da3313295010f1bb521a393f15dacf987050254) | v1.0-rc1, `6da3313295010f1bb521a393f15dacf987050254` | Bootstrap, enrollment, CLI, configuration selection, upload and rollout implementation |
| [Host composectl](https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098) | v96.3.0, `07a5b14b2e55f6882f7323ad6a32e62438aa5098` | Released host packaging tool, publication, ARM64 content download, Docker credential support |
| [Device composeapp](https://github.com/foundriesio/composeapp/tree/0af6d7702713f36848ae569dc7a6c7f05f1d2abe) | `0af6d7702713f36848ae569dc7a6c7f05f1d2abe` | Device tool revision selected by the pinned meta-foundries recipe |
| [aktualizr-lite](https://github.com/foundriesio/aktualizr-lite/tree/7bb558258bd64214abf27e4bb6567a17f9cf7854) | `7bb558258bd64214abf27e4bb6567a17f9cf7854` | App reference comparison and unchanged OS handling, matched to meta-foundries' recipe |
| [Foundries containers](https://github.com/foundriesio/containers/tree/5be067eb56d1cb59dcbf82568f36986705af9a8a/shellhttpd) | `5be067eb56d1cb59dcbf82568f36986705af9a8a` | Existing shellhttpd Dockerfile, script, and Compose example |
| [Arduino documentation](https://github.com/arduino/docs-content/tree/dab66ecbd6ad52cd742da6c19c5b6330a7f2caae) | `dab66ecbd6ad52cd742da6c19c5b6330a7f2caae` | Bughopper connection, 115200 baud, Emergency Download (EDL) procedure, linked hardware illustrations |
| [kas](https://github.com/siemens/kas/tree/5.4) | 5.4 | Wrapper, schema, lock command, container version variable |
| [`qdl`](https://github.com/linux-msm/qdl/tree/v2.8) | 2.8 | Linux host binary and flashing syntax |

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

The authoring computer has no Docker runtime or connected UNO Q available for this task.
No native server launch, QLI compilation, firmware flashing, registration, or rollout is claimed as tested.

Before calling the guide hardware-validated, record the following results with the generated lockfile:

| Check | Required evidence | Status |
| --- | --- | --- |
| Wrynose build | kas lockfile, build result, manifests, flash bundle, OS repository | Not run |
| Bughopper path | Record Bughopper revision and tool version; verify installation, permissions, serial discovery, EDL enumeration, successful `qdl` write, reset to normal boot, and working serial console | Not run |
| Jumper flashing path | EDL pin sequence, USB enumeration, successful `qdl` write, jumper removal, and normal boot | Not run |
| ADB path | Device enumeration, root shell, Wi-Fi setup | Not run |
| Linux host | Docker Engine, Compose, Buildx, and native USB access | Not run |
| Native server and tools | Linux binaries run, `composectl publish` is available, host registry authentication works, initialization succeeds, and restart preserves the data directory | Not run |
| Enrollment | Successful board command, device identifier, heartbeat over gateway | Not run |
| App selection | fioconfig delivery and requested app list | Not run |
| First rollout | shellhttpd version 1 response and server result | Not run |
| Second rollout | New OS build ID, changed boot ID/deployment, version 2 response, server success | Not run |
| Add a second application | Both HTTP apps respond; original app digest, OS checksum/build ID, and boot ID retained | Not run |
| Update only the existing app | New image's HTTP header and message; second app digest, OS checksum/build ID, and boot ID retained | Not run |

The host resource allowance is a planning estimate, not a measured minimum.
The kas override is a newly authored companion configuration; its complete build remains pending.

## Authoring Checks Completed

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
