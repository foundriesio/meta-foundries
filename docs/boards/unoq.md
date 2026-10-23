# Building for the Arduino UNO Q

See [Prerequisites](../prereqs.md) first.

## Build

```sh
git clone https://github.com/foundriesio/meta-foundries.git
export KAS_WORK_DIR="${KAS_WORK_DIR:-$PWD/kas-work}"
export DL_DIR="${DL_DIR:-$PWD/downloads}"
export SSTATE_DIR="${SSTATE_DIR:-$PWD/sstate-cache}"
mkdir -p "${KAS_WORK_DIR}" "${DL_DIR}" "${SSTATE_DIR}"
kas-container build meta-foundries/ci/uno-q.yml
```

`ci/uno-q.yml` builds `core-image-full-cmdline` for the `uno-q` machine and enables `adbd` on it by default, so there is a console even without a Bughopper attached (see [Tips](#tips)).

## Install QDL

Flashing the board needs [`qdl`](https://github.com/linux-msm/qdl).
Download a release for your host from the
[QDL releases page](https://github.com/linux-msm/qdl/releases), or build it from source per that repo's instructions, and put it on your `PATH`.

## Flash

```sh
cd build/tmp/deploy/images/uno-q/core-image-full-cmdline-uno-q.rootfs.qcomflash
qdl --storage emmc --debug prog_firehose_ddr.elf rawprogram0.xml patch0.xml
```

Run this from the `${KAS_WORK_DIR}` you built in, with the board in EDL (download) mode and connected over USB.

## Tips

- **adb as root** — if `adb shell` does not land you as `root`, restart `adbd` on your host computer with root privileges and reconnect:

  ```sh
  adb root
  adb shell
  ```

- **Wi-Fi via `nmcli`** — the image installs NetworkManager. Connect from an
  `adb shell`:

  ```sh
  nmcli device wifi rescan
  nmcli device wifi list
  nmcli device wifi connect "<ssid>" password "<password>"
  ```

  Once connected, `nmcli connection up id "<ssid>"` reuses the saved profile without the password.
