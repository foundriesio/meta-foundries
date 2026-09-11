# Common Customizations

Each customization below is a kas fragment: save it as its own YAML file (or add the block to one you already maintain) and list it in `KAS_YAMLS` alongside the machine file you build with, e.g.:

```sh
export KAS_YAMLS="ci/qemuarm64-secureboot.yml:my-fragment.yml"
kas-container build "${KAS_YAMLS}"
```

See [Prerequisites](./prereqs.md) for getting `kas-container` running.

## Set default Update Server settings

`ci/include/base.yml` sets these under its own `fio-device-register:` fragment.
Override them in your own fragment to point a build at your Update Server instance:

```yaml
  update-server: |
    FIO_DEVICE_API = "https://example.com/v1/devices"
    FIO_OAUTH_API = "https://example.com/oauth2"
    LMP_FACTORY = "myproductname"
```

`FIO_DEVICE_API` and `FIO_OAUTH_API` are compiled into `fio-device-register`.
`LMP_FACTORY` is recorded into the image's `/etc/os-release` and used for a client certificates "OU" field.
See [Update Server Integration](./update-server.md) for how these tie into registering a device.

## Include `sudo` in your image

`core-image-full-cmdline`, the target every `ci/*.yml` machine file builds, does not install `sudo`.
Add it with:

```yaml
sudo: |
    IMAGE_INSTALL:append = " sudo"
```

## Aktualizr-lite and Fioconfig Polling Interval

Update client logic polls the server every 5 minutes by default.
You can this by adding new files, so they live in your own layer (a kas `local_conf_header` fragment cannot ship files, only `local.conf` lines).

Add a fragment recipe:
```
recipes-sota/sota-fragment/sota-fragment_0.1.bb
recipes-sota/sota-fragment/sota-fragment/90-sota-fragment.toml
```

`sota-fragment_0.1.bb`:
```
SUMMARY = "SOTA configuration fragment"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch

SRC_URI = " \
        file://90-sota-fragment.toml \
"

S = "${WORKDIR}"

do_install() {
        install -m 0700 -d ${D}${libdir}/sota/conf.d
        install -m 0644 ${WORKDIR}/90-sota-fragment.toml ${D}${libdir}/sota/conf.d/90-sota-fragment.toml
}

FILES:${PN} += "${libdir}/sota/conf.d/90-sota-fragment.toml"
```

`90-sota-fragment.toml`:

```toml
[uptane]
polling_sec = <seconds>
```

**fioconfig** reads `DAEMON_INTERVAL` from `/etc/default/fioconfig` (`EnvironmentFile=` in `fioconfig.service`).
Add a bbappend instead of a new recipe, since it only adds a file to an existing package:

```
recipes-support/fioconfig/fioconfig_%.bbappend
recipes-support/fioconfig/fioconfig/fioconfig.conf
```

`fioconfig.conf`:

```
DAEMON_INTERVAL=<seconds>
```

`fioconfig_%.bbappend`:

```
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://fioconfig.conf"

do_install:append() {
    install -Dm 0644 ${WORKDIR}/fioconfig.conf ${D}${sysconfdir}/default/fioconfig
}
```

## Include an NFS server in your image

Add it with:

```yaml
nfs: |
    IMAGE_INSTALL:append = " nfs-utils"
```
