# Update Server Integration

Devices built from this layer register with, and pull updates from, the Foundries.io™ [Update Server](https://github.com/foundriesio/update-server).
Point a build at your own instance with the [Update Server settings customization](./customize.md#set-default-update-server-settings).

## Registering a device

`packagegroup-foundries-platform` installs `fio-device-register` (see [Components](./COMPONENTS.md)).
On first boot, run it on the device:

```sh
fio-device-register --factory <factory> --name <device-name> --tags <tag>
```

`<factory>` must match a factory the target server knows about.
See the [Quick Start guide](https://github.com/foundriesio/update-server/blob/main/docs/quick-start.md) for setting up a factory and registering a device against it.

## Building and pushing an update

A meta-foundries build produces OSTree content under `${KAS_WORK_DIR}/build/tmp/deploy/images/<machine>/ostree_repo`.
That directory combined with any compose apps you may have, is what an Update Server upload consumes.
`fiocli`, the Update Server's CLI, uploads it:

```sh
fiocli updates upload <tag> <build-number> tmp/deploy/images/<machine> \
    --version <version>
```

Pass `--version` explicitly as a monotonically increasing integer used by TUF and aktualizr-lite.

See the Update Server's [Build an Update](https://github.com/foundriesio/update-server/blob/main/docs/build-an-update.md) and [Updates](https://github.com/foundriesio/update-server/blob/main/docs/updates.md) guides for what to pass for each field, and how compose apps are laid out alongside the OSTree repo.
