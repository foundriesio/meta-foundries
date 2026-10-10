---
title: Troubleshoot the UNO Q Walkthrough
description: Checks for build, console, enrollment, networking, and application update failures.
type: page
doc-category: informational
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-10
license: MIT
access: public
references:
  - https://github.com/foundriesio/meta-foundries/tree/ff40dc16da368d471e890dd19fe945a220ef3ce2
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/quick-start.md
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/updates.md
  - https://github.com/foundriesio/composeapp/tree/07a5b14b2e55f6882f7323ad6a32e62438aa5098
  - https://github.com/arduino/docs-content/tree/dab66ecbd6ad52cd742da6c19c5b6330a7f2caae
relations:
  parent: README.md
---

# Troubleshoot the UNO Q Walkthrough

[Guide overview](README.md)

## Troubleshoot a Failed Checkpoint

| Symptom | Check |
| --- | --- |
| Build uses development branches | Use `kas/uno-q-wrynose.yml` and inspect the lockfile; avoid the standalone upstream CI command. |
| Layer compatibility error | Verify the pinned Arduino, Qualcomm Linux® (QLI), meta-foundries, and Wrynose dependency revisions. Do not bypass `LAYERSERIES_COMPAT`. |
| OS update fails to finalize after reboot | Confirm meta-foundries `ff40dc1` in the resolved configuration (`kas-container dump --resolve-refs kas/uno-q-wrynose.yml`). On the UNO Q, confirm `aktualizr-lite --version` prints `5d93718`. Then inspect the booted deployment and updater logs. The guide relies on the client's OS-name derivation with `pacman.os` unset. |
| You need a RAM dump after a kernel crash | Rebuild with the optional diagnostic overlay `kas/diag-download-mode.yml` appended to `GUIDE_KAS`. It sets `qcom_scm.download_mode=1`: a crash then leaves the board in Qualcomm RAM-dump mode until power-cycled, instead of resetting. Leave it out for normal use. |
| Synchronous external abort during deployment on an affected 4 GB board | Check the recorded firmware and [M-05 selection](build.md#select-the-boards-memory-configuration). Preserve logs and confirm the reservation in the booted image before retrying. |
| M-05 overlay reports a dangling append or failed patch | Stop and check the selected `linux-arduino_7.0` recipe and source. The workaround's applicability to this guide still needs build validation; do not disable the error or widen the append to other versions. |
| Registration rejects `--factory` | Use the documented `DEVICE_FACTORY=unoq-lab` environment assignment; this build has no `--factory` option. |
| `pytactl list` finds no Bughopper | Check its USB data cable and connection; confirm the installed `pytactl` version and inspect the host's USB enumeration. |
| `pytactl` reports access denied or a missing native library | Complete [Bughopper tool installation](flash.md#install-bughopper-tools), including native libraries and device permissions; reconnect Bughopper after installing the rules. |
| `qdl` waits for a device | Complete [Emergency Download (EDL) entry](flash.md#enter-edl-mode) using Bughopper or a jumper. Verify `05c6:9008`, the UNO Q USB-C data cable, and host USB permissions. |
| Board stays in EDL after flashing with Bughopper | After `qdl` succeeds, run `pytactl oneshot reset --serial "$BUGHOPPER_SERIAL"` on the host to clear EDL and boot normally. |
| No Android Debug Bridge (ADB) device after boot | Check that the flashed image contains the enabled ADB configuration; verify USB permissions and normal boot rather than EDL. |
| Serial output is unreadable or input fails | Verify the Bughopper port, 115200/8N1 settings, and disabled hardware/software flow control. |
| Enrollment page opens but registration fails | Read the board's command result; check clock, server-terminal logs, and duplicate device name. |
| Board cannot reach the server | Check the local-network IP address, hosts entry, listening ports, host firewall, and Wi-Fi client isolation. |
| TLS hostname error | Verify that `devserver-init --dnsname` matches the hostname in device configuration and hosts entries. |
| CLI works, but no device heartbeat | Check Transmission Control Protocol (TCP) port 8443 and certificate hostname resolution on the board; CLI access only establishes the 8080 path. |
| App packaging reports unauthorized | Check host Docker login, credential helpers, `DOCKER_CONFIG`, and package permissions. |
| App downloads fail after upload | Confirm the upload contained the entire `apps/` tree from `composectl pull --arch arm64`; a digest alone supplies no blobs. |
| An application-only rollout attempts an OS download or reboot | Confirm `--ostree-hash` exactly matches the board's booted OS checksum; an omitted hash does not mean retain the current OS. |
| An existing app disappears after adding another | Include both app digests in the target and both names in the device's explicit selection. |
| Uploaded update never installs | Check that a rollout targets the correct universally unique identifier (UUID), the tag is `wrynose`, the hardware ID is `uno-q`, and the version increases. |
| App exists but does not run | Check `--apps shellhttpd`, successful fioconfig delivery, updater logs, ARM64 packaging, and available board disk space. |
| Browser shows the server UI instead of shellhttpd | Use the UNO Q's IP for the app; `unoq-update.test:8080` is the server UI. |

Record the source lockfile, component revisions, host OS, board model, command output, and service logs when reporting a problem.
Exclude registry tokens, device private keys, and server private keys from shared logs.
