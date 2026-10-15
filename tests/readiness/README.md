# Readiness Check for meta-foundries Images

`fio-readiness` checks whether an existing Yocto Project image has the components and configuration that Foundries OS Update or Foundries Full Update needs. A BSP integrator copies the script onto a running board and runs it as root. It needs no network connection, no build tree, and no package manager on the device.

The script prints a capability matrix and writes a plain-text report that can be shared with the Foundries team. Each check records its expected value, observed value, and diagnostic evidence. The report does not suggest fixes.

The current version is a prototype for Yocto Project Wrynose on ARM64 and x86-64.

## Run the Check

```sh
sh fio-readiness                         # Full Update profile (default)
sh fio-readiness --profile os            # OS Update profile
sh fio-readiness --report /data/readiness.txt
sh fio-readiness --help
```

Options:

| Option | Purpose |
| --- | --- |
| `--profile full\|os` | Composition to check. Full Update is the default |
| `--report PATH` | Report path. The default is `./fio-readiness-<host>-<UTC time>.txt` |
| `--client NAME` | Update client executable name. The default is `aktualizr-lite` |
| `--state-dir PATH` | Update-state directory. The default is `/var/sota` |
| `--timeout SECONDS` | Limit for each local query. The default is 10 |

A fresh, unregistered image can pass. The check verifies registration prerequisites and never registers the device.

## Read the Results

| Result | Meaning |
| --- | --- |
| `PASS` | The stated condition was observed. A `PASS` does not prove that updates, rollback, or registration succeed |
| `FAIL` | Evidence shows that a required component or setting is absent or incorrect |
| `BLOCKED` | A named prerequisite check failed, so this check did not run |
| `UNKNOWN` | The evidence cannot establish the condition, or the criterion is not defined yet |

Independent checks always run. A failure blocks only the checks that depend on it.

The `SCOPE` column separates requirements for the first release, the Minimum Viable Product (MVP), from later ones. Post-MVP rows still run their inspection and record what they found. Until after the first release they report `PASS`, and the explanation states the result that the inspection would otherwise give. The Extensible Firmware Interface (EFI) variable rows (`BOOT-02`, `BOOT-03`) and the firmware-update rows (`FW-01` to `FW-04`) are post-MVP.

In the OS Update profile, container checks are omitted. If the image contains container components anyway, the report header lists them as not needed for OS Update. Their presence is never a failure.

Exit codes in this prototype: 0 when the matrix completed, whatever the results; 2 for usage errors; 130 when the run was interrupted. An interrupted run still writes a report that is marked incomplete.

## Checks

| Group | IDs | What they cover |
| --- | --- | --- |
| Harness | `ENV-01` to `ENV-05` | Root privileges, architecture, declared Wrynose provenance, one row per required shell tool (`ENV-04`), and report destination |
| OS update | `OS-01` to `OS-12` | Update client and unit, OSTree deployment, update-state storage, image configuration, registration tool, fioconfig, storage, and NetworkManager |
| Boot | `BOOT-01` to `BOOT-06` | Unified Extensible Firmware Interface (UEFI) boot, EFI variables (post-MVP), boot-health wiring, EFI system partition, and watchdog metadata |
| Applications | `APP-01` to `APP-06`, `APP-08` | Docker and Compose, dockerd autostart, storage driver, composectl, app storage roots, early application startup, and container-storage recovery. Full Update only |
| Firmware update | `FW-01` to `FW-04` | fwupd, EFI System Resource Table (ESRT), capsule staging, and fallback metadata (post-MVP) |

`BOOT-04`, `BOOT-06`, `APP-06`, and `APP-08` report `UNKNOWN` until their criteria are defined.

## What the Check Never Does

The script only reads files and runs local version and status queries. It never:

- starts or stops services
- registers the device
- pulls container images or launches applications
- applies updates or refreshes firmware metadata
- writes EFI variables or opens `/dev/watchdog`
- runs `fio-diag`, which contacts Foundries services

Docker client queries run with `DOCKER_HOST` pointed at a socket that does not exist, so they cannot start dockerd through `docker.socket`. The Docker server is queried only after `systemctl` reports `docker.service` as active.

Each query has a time limit. Parsing uses full command output; the report shows bounded evidence with secrets redacted.

Testing can still leave a device in an unknown state. If you need a known-good device afterward, restore it from a known-good image.

## Command Safety Basis

Each product command was checked against the source revision that this layer's recipe pins:

| Component | Command | Basis |
| --- | --- | --- |
| aktualizr-lite | `--version` | Prints and exits during option parsing, before configuration is loaded (`src/main.cc`, `check_info_options`) |
| composectl | `version`, `--help` | Prints the build commit or flag defaults. Initialization reads Docker configuration files only (`cmd/composectl/cmd/root.go`) |
| fioconfig | `version` | Has no global pre-run hook and prints the commit (`main.go`) |
| fio-device-register | `--help-advanced` | Prints options and returns before any HTTP call. It exits with status 255 by design (`src/options.cpp`) |
| ostree | `--version`, `admin status` | Read-only local queries |
| dockerd, Docker CLI, Compose plugin | `--version` or `version` | Client-only queries that cannot reach the daemon. Compose plugin side effects were not verified in source |
| fwupd | not executed | `fwupdmgr` can activate the fwupd service over D-Bus, so `FW-01` checks presence only |

`OS-12` reads the Go build settings that are embedded in the fioconfig binary and does not run the binary. It detects build settings by the `-compiler=` entry, which Go always records. Yocto builds with `-trimpath`, and Go omits `-ldflags` in that mode. This was verified with Go 1.24 binaries, including `-trimpath` and stripped builds.

## Test on a Device

1. Copy the script to the device:

   ```sh
   scp fio-readiness root@<device>:/tmp/
   ```

   On a device without SSH root access, use `adb push fio-readiness /tmp/`.

2. Record the active units before the run:

   ```sh
   systemctl list-units --type=service,socket --state=active --no-legend > /tmp/units-before.txt
   ```

3. Run both profiles:

   ```sh
   sh /tmp/fio-readiness --report /tmp/readiness-full.txt
   sh /tmp/fio-readiness --profile os --report /tmp/readiness-os.txt
   ```

4. Record the active units again and compare them. Any new active unit is a defect:

   ```sh
   systemctl list-units --type=service,socket --state=active --no-legend > /tmp/units-after.txt
   diff /tmp/units-before.txt /tmp/units-after.txt && echo "no unit changes"
   ```

On an image built with the current layer defaults, `OS-09` and `OS-12` fail. The fioconfig recipe does not enable its `vpn` option by default. The `factory-config-vpn` handler and the `vpn` build tag are therefore absent. `OS-11` also fails if the image does not include NetworkManager.

## Fixture Tests

`run-tests.sh` builds a fake image tree for each scenario and replaces `systemctl`, `id`, and `uname` with stubs. It runs the script with a restricted `PATH`, so that missing tools can be simulated. It needs a Linux® host. It does not need a board, a network connection, or root.

```sh
./run-tests.sh dash
./run-tests.sh bash
docker run --rm -v "$PWD":/w:ro -e TMPDIR=/tmp/t busybox:1.36 \
    sh -c 'mkdir -p /tmp/t && /w/run-tests.sh /bin/sh'
docker run --rm -v "$PWD":/w:ro koalaman/shellcheck:stable -s sh -S warning \
    /w/fio-readiness /w/run-tests.sh
```

The scenarios cover the following:

- a healthy, unregistered Full Update image
- a stopped dockerd, which fails without starting the daemon
- a missing composectl, which blocks only its dependent checks
- fioconfig without VPN support, built with and without `-trimpath`
- a fioconfig binary without embedded build settings
- the OS Update profile
- missing firmware tooling
- `/var` on tmpfs
- a non-root run
- a missing timeout facility
- a hung query
- undeclared provenance
- an unwritable report path
- an interrupted run

## Known Limitations

- Only one image has run the check so far. Arduino UNO Q and QEMU images are next.
- `APP-03` reads `daemon.json` by text extraction, not with a JSON parser.
- `BOOT-05` reports `UNKNOWN` when no EFI system partition is mounted. The check does not mount it.
- Storage thresholds are not defined. `OS-10` reports quantities and fails only on read-only mounts or zero free space.
- `ENV-04` reports one row per shell tool, which inflates the `PASS` count.
