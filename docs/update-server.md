# Update Server Integration

Devices built from this layer use the Foundries.io™ [Update Server] (https://github.com/foundriesio/update-server) for registering and pulling updates.
Point a build at your instance by customizing the [Update Server settings](./customize.md#set-default-update-server-settings).

## Registering a Device

`packagegroup-foundries-platform` installs `fio-device-register` (see [Components](./COMPONENTS.md)).
On first boot, run it on the device:

```sh
fio-device-register --factory <factory> --name <device-name> --tags <tag>
```

`<factory>` must match a Factory the target server knows about.
See the [Quick Start guide](https://github.com/foundriesio/update-server/blob/main/docs/quick-start.md) for setting up an Update Server and registering a device against it.

## Building and Pushing an Update

A meta-foundries build produces OSTree content under `${KAS_WORK_DIR}/build/tmp/deploy/images/<machine>/ostree_repo`.
That directory combined with any compose apps you have, is what an Update Server upload consumes.
`fiocli`, the Update Server's CLI, uploads it:

```sh
fiocli updates upload <tag> <build-number> tmp/deploy/images/<machine> \
    --version <version>
```

Pass `--version` explicitly as a monotonically increasing integer used by TUF and aktualizr-lite.

See the Update Server's [Build an Update](https://github.com/foundriesio/update-server/blob/main/docs/build-an-update.md) and [Updates](https://github.com/foundriesio/update-server/blob/main/docs/updates.md) guides for what to pass for each field, and how compose apps are laid out alongside the OSTree repo.
