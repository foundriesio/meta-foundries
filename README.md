# meta-foundries

A collection of recipes that make up the Foundries.io update solution.

## Getting in Contact

* [Report an Issue on GitHub](../../issues) — for bugs, build failures, and
  feature requests.
* To report a security vulnerability, follow the process in
  [SECURITY.md](SECURITY.md).

## Maintainer(s)

- Daiane Angolini <daiane.angolini@oss.qualcomm.com>
- Mike Scott <mike.scott@oss.qualcomm.com>

## License

- *meta-foundries* is licensed under the [MIT](COPYING.MIT) license.

## Layer Dependencies

This layer depends on:

```text
URI: https://git.openembedded.org/openembedded-core
layers: meta
branch: master
revision: HEAD
```

This layer has an optional dependency on the meta-arm layer:

```text
URI: https://git.yoctoproject.org/meta-arm
layers: meta-arm, meta-arm-bsp
branch: main
revision: HEAD
```

The dependency is optional, and only required for the `qemuarm64-secureboot`
machine. When that machine is not used (e.g. an Intel target), the layer is not
needed and does not have to be enabled in BBLAYERS.

## Adding the meta-foundries layer to your build

Run 'bitbake-layers add-layer meta-foundries'

## Contributing

Please submit any patches against the `meta-foundries` layer by using the
GitHub pull-request feature. Fork the repo, create a branch, do the work,
rebase from upstream, and create the pull request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute, including the
checks to run before submitting a pull request.
