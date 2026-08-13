# Layer Components

Recipes this layer provides today. Add a row when a new component recipe
lands; the layer tree is the source of truth for what actually ships.

| Component | Upstream | Purpose |
|-----------|----------|---------|
| [`aktualizr-lite`](../recipes-sota/aktualizr-lite/aktualizr-lite_97.bb) | [`foundriesio/aktualizr-lite`](https://github.com/foundriesio/aktualizr-lite) | Foundries.io™ OTA+ update client |
| [`composectl`](../recipes-containers/composeapp/composectl_97.bb) | [`foundriesio/composeapp`](https://github.com/foundriesio/composeapp) | CLI utility to manage compose apps |
| [`fio-device-register`](../recipes-sota/fio-device-register/fio-device-register_97.bb) | [`foundriesio/lmp-device-register`](https://github.com/foundriesio/lmp-device-register) | Device registration tool for Foundries.io™ OTA+ |
| [`packagegroup-fio-ota`](../recipes-sota/packagegroups/packagegroup-fio-ota.bb) | — | Installs the update client and the registration tool together |
