---
title: Troubleshoot the UNO Q Walkthrough
description: Checks for build, console, enrollment, networking, and application update failures.
date: 2026-09-23
status: Source-reviewed draft; hardware walkthrough pending
---

# Troubleshoot the UNO Q Walkthrough

[Guide overview](README.md)

## Troubleshoot a Failed Checkpoint

| Symptom | Check |
| --- | --- |
| Build uses development branches | Use `kas/uno-q-wrynose.yml` and inspect the lockfile; avoid the standalone upstream CI command. |
| Layer compatibility error | Verify the pinned Arduino, Qualcomm Linux® (QLI), meta-foundries, and Wrynose dependency revisions. Do not bypass `LAYERSERIES_COMPAT`. |
| `pytactl list` finds no Bughopper | Check its USB data cable and connection; confirm the installed `pytactl` version and inspect the host's USB enumeration. |
| `pytactl` reports access denied or a missing native library | Complete [Bughopper tool installation](flash.md#install-bughopper-tools), including native libraries and device permissions; reconnect Bughopper after installing the rules. |
| `qdl` waits for a device | Complete [Emergency Download (EDL) entry](flash.md#enter-edl-mode) using Bughopper or a jumper. Verify `05c6:9008`, the UNO Q USB-C data cable, and host USB permissions. |
| Board stays in EDL after flashing with Bughopper | After `qdl` succeeds, run `pytactl oneshot reset --serial "$BUGHOPPER_SERIAL"` on the host to clear EDL and boot normally. |
| No Android Debug Bridge (ADB) device after boot | Check that the flashed image contains the enabled ADB configuration; verify USB permissions and normal boot rather than EDL. |
| Serial output is unreadable or input fails | Verify the Bughopper port, 115200/8N1 settings, and disabled hardware/software flow control. |
| Enrollment page opens but registration fails | Read the board's command result; check factory name, clock, server logs, and duplicate device name. |
| Board cannot reach the server | Check the local-network IP address, hosts entry, published ports, host firewall, and Wi-Fi client isolation. |
| TLS hostname error | Verify that `devserver-init --dnsname` matches the hostname in device configuration and hosts entries. |
| CLI works, but no device heartbeat | Check Transmission Control Protocol (TCP) port 8443 and certificate hostname resolution on the board; CLI access only establishes the 8080 path. |
| App packaging reports unauthorized | Check the separate `.registry-auth/config.json` credentials and package permissions. |
| App downloads fail after upload | Confirm the upload contained the entire `apps/` tree from `composectl pull --arch arm64`; a digest alone supplies no blobs. |
| An application-only rollout attempts an OS download or reboot | Confirm `--ostree-hash` exactly matches the board's booted OS checksum; an omitted hash does not mean retain the current OS. |
| An existing app disappears after adding another | Include both app digests in the target and both names in the device's explicit selection. |
| Uploaded update never installs | Check that a rollout targets the correct universally unique identifier (UUID), the tag is `wrynose`, the hardware ID is `uno-q`, and the version increases. |
| App exists but does not run | Check `--apps shellhttpd`, successful fioconfig delivery, updater logs, ARM64 packaging, and available board disk space. |
| Browser shows the server UI instead of shellhttpd | Use the UNO Q's IP for the app; `unoq-update.test:8080` is the server UI. |

Record the source lockfile, component revisions, host OS, board model, command output, and service logs when reporting a problem.
Exclude registry tokens, device private keys, and server private keys from shared logs.
