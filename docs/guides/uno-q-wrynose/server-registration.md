---
title: Set Up the Server and Register UNO Q
description: Run the local update server, register the device, and select its applications.
type: page
doc-category: instructional
authors: David Griego, Codex:GPT-6
last-edited: 2026-10-07
license: MIT
access: public
references:
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/quick-start.md
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/cmd/server/dev_server.go
  - https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/fiocli.md
relations:
  prev: flash.md
  next: application-updates.md
  parent: README.md
---

# Set Up the Server and Register UNO Q

[Guide overview](README.md) · [Previous: Flash and connect](flash.md) · **Part 3 of 4**

Complete [flashing and board setup](flash.md) first.
The board must be running OS version 1, connected to your local area network (LAN), and accessible through your chosen console.

Use your local Linux® computer, with the complete guide directory and `GUIDE_DIR` set to its absolute path.
Keep this host Bash session open for the application exercises so `GUIDE_DIR` and `UNOQ_UUID` remain available.

> **Validation status:** Source-reviewed draft. The complete build and hardware walkthrough remain pending.
> See [sources and validation](validation.md).

- [Start the update server on your computer](#start-the-update-server-on-your-computer)
- [Register the UNO Q](#register-the-uno-q)
- [Select the applications the board should run](#select-the-applications-the-board-should-run)
- [Stop and restart the local server](#stop-and-restart-the-local-server)

## Start the Update Server on Your Computer

Run this section in a Bash shell on your **local Linux host** using your regular account.
It follows the upstream [development-server bootstrap](https://github.com/foundriesio/update-server/blob/6da3313295010f1bb521a393f15dacf987050254/docs/quick-start.md).

This is a local development server.
Its enrollment UI uses HTTP, and the UNO Q image enables development console access.
Use a trusted lab network and keep these ports off the public Internet.

### Give the Server a Name Reachable From the Board

Use the hostname **`unoq-update.test`** throughout this guide.
Run `ip -4 address` and find the computer's local area network (LAN) IPv4 address.
Reserve that address through your router's Dynamic Host Configuration Protocol (DHCP) settings if possible.

| Name used in this guide | Address it identifies |
| --- | --- |
| `UPDATE_SERVER_HOST_IP` | The computer running the Foundries Update Server |
| `UNOQ_DEVICE_IP` | The UNO Q board |

Enter the server computer's LAN address when prompted:

```bash
read -r -p "Enter the update-server computer's LAN IPv4 address: " UPDATE_SERVER_HOST_IP
printf '%s unoq-update.test\n' "$UPDATE_SERVER_HOST_IP"
```

Copy the **printed output** into `/etc/hosts` on both the computer and the UNO Q.
On the computer, edit the file with administrator privileges.
On the **UNO Q**, edit it as root:

```bash
vi /etc/hosts
```

Check resolution on **both the computer and the UNO Q**:

```bash
getent hosts unoq-update.test
```

The result must show the computer's LAN address.
If that address changes, update both hosts files; keeping the hostname preserves the certificate name.
Allow inbound Transmission Control Protocol (TCP) connections on ports **8080 and 8443** through the computer's firewall.

### Download and Initialize the Server

Download the x86-64 Linux server and CLI from
[release v1.0-rc1](https://github.com/foundriesio/update-server/releases/tag/v1.0-rc1),
the latest release at the source-review date.
Keep both tools on this release for the walkthrough.

```bash
mkdir -p "$GUIDE_DIR/workspace/bin"
curl -fL https://github.com/foundriesio/update-server/releases/download/v1.0-rc1/fioserver-linux-amd64 \
  -o "$GUIDE_DIR/workspace/bin/fioserver"
curl -fL https://github.com/foundriesio/update-server/releases/download/v1.0-rc1/fiocli-linux-amd64 \
  -o "$GUIDE_DIR/workspace/bin/fiocli"
chmod +x "$GUIDE_DIR/workspace/bin/fioserver" "$GUIDE_DIR/workspace/bin/fiocli"
export PATH="$GUIDE_DIR/workspace/bin:$PATH"
cd "$GUIDE_DIR/workspace"
./bin/fioserver --datadir=./datadir devserver-init --dnsname=unoq-update.test
```

Initialize the data directory **once**.
The bootstrap creates the public key infrastructure (PKI), The Update Framework (TUF) metadata,
and a local `admin` account with development password `admin`.
The explicit hostname sets the gateway certificate name used by the board.

Open a **second host terminal for the server**.
Set `GUIDE_DIR` to the same guide directory, then run:

```bash
cd "$GUIDE_DIR/workspace"
./bin/fioserver --datadir=./datadir serve
```

Leave this terminal open; the server runs in the foreground and prints its logs here.
Its data, keys, enrollment records, and updates persist in `workspace/datadir/`.
Open [the local server](http://unoq-update.test:8080/) and sign in as `admin` / `admin`.

Use the **first host terminal** for CLI and application commands throughout the guide.
Keep `GUIDE_DIR` and the tools directory on `PATH` in that terminal.
When opening another host shell for these commands, set `GUIDE_DIR` again and run
`export PATH="$GUIDE_DIR/workspace/bin:$PATH"`.
Keep the board's serial or Android Debug Bridge (ADB) shell separate from both host terminals.

## Register the UNO Q

On the **UNO Q**, stop the updater before enrollment, then run:

```bash
systemctl stop aktualizr-lite
fio-device-register \
  --device-api=http://unoq-update.test:8080/v1/devices \
  --oauth-api=http://unoq-update.test:8080/oauth2 \
  --name=unoq-01 \
  --tag=wrynose
```

Open the authorization link printed by the command in your computer's browser.
Sign in to the local update server, enter the displayed code if requested, and approve this device.
Wait for `fio-device-register` to report success on the board.
The `wrynose` tag must match the updates you upload later.

Check the services on the **UNO Q**:

```bash
systemctl start aktualizr-lite fioconfig
systemctl --no-pager status aktualizr-lite fioconfig docker
journalctl -u aktualizr-lite -n 50 --no-pager
```

The image's registration tool requests Compose application support.
Confirm `/var/sota/sota.toml` contains `type = "ostree+compose_apps"` in its `[pacman]` section.
Do not print or share the private key from this directory.

In the server UI, open **Devices** and find `unoq-01`.
Confirm a recent device heartbeat, then copy its universally unique identifier (**UUID**).
A completed browser authorization alone is insufficient if the board command failed.

Return to the terminal on the **computer running the update server**.
Use the first host terminal, where the tools directory is on `PATH`, and log the CLI into the server:

```bash
fiocli login unoq-local http://unoq-update.test:8080
```

Complete the browser authorization printed by `fiocli`.
Its login state persists in `$HOME/.config/fiocli.yaml`.
The login selects `unoq-local` as the active CLI context for the following commands.

```bash
fiocli devices list
export UNOQ_UUID='PASTE_THE_DEVICE_UUID'
```

## Select the Applications the Board Should Run

In the same **update-server computer terminal**, select `shellhttpd` for this device and keep its update tag on Wrynose:

```bash
fiocli configs updates --device "$UNOQ_UUID" \
  --tag wrynose --apps shellhttpd
```

This records the desired application selection.
The application starts after an update containing `shellhttpd` is uploaded and rolled out.
The first selection uses the CLI because a newly enrolled device may not yet have an app catalog in the UI.

For later changes, use these alternatives:

| Desired result | Value for `--apps` |
| --- | --- |
| Run shellhttpd | `shellhttpd` |
| Run two apps present in the update | `shellhttpd,another-app` |
| Run no apps | `,` |
| Remove this override and use the device's configured defaults | `-` |

For example, `fiocli configs updates --device "$UNOQ_UUID" --apps ','` disables all applications.
Changing the selection does not create application content; selected names must exist in the update.
Allow the configuration client and updater time to poll the server.

## Stop and Restart the Local Server

In the **server terminal**, press Ctrl+C to stop the foreground process.
To restart it with the saved data, run:

```bash
cd "$GUIDE_DIR/workspace"
./bin/fioserver --datadir=./datadir serve
```

Keep `workspace/datadir/` to retain the server's keys, enrollment records, and updates.
Run `serve` against that same directory each time; initialize a new directory only when starting a new lab.

**Next:** [Deploy and update applications](application-updates.md).
Leave the server running in its terminal and continue in the first host Bash session.
