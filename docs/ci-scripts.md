# Running the `ci/` Check Scripts

Layer checks that run inside `kas-container`, matching how CI validates the
layer. Requires `kas-container` on your `PATH` (or set `KAS_CONTAINER`). Run
all checks from the repository root.

## Checks at a Glance

Run through these before opening a pull request:

- [ ] `ci/yocto-check-layer.sh` — runs `yocto-check-layer` against the layer
      (structure, signatures, and README compliance).
- [ ] `ci/yocto-patchreview.sh` — runs OpenEmbedded-Core patchreview over the
      layer's patches against the Yocto Project patch guidelines.
- [ ] `vale --config=docs/.vale.ini docs/` — lints the `docs/` prose with Vale
      (runs on the host, not in `kas-container`).

`ci/kas-container-shell-helper.sh` is a helper, not a check: it runs a given
script inside the CI container and passes the repo and work directories to it.

## Running Each Check

### Layer Check and Patch Review

Wrap these with the helper so they run in the CI container:

```sh
ci/kas-container-shell-helper.sh ci/yocto-check-layer.sh
ci/kas-container-shell-helper.sh ci/yocto-patchreview.sh
```

The helper passes the repo and work directories to the script for you.

### Linting Docs With Vale

Prose under `docs/` is linted with [Vale](https://vale.sh). CI runs it on every
pull request via `.github/workflows/lint-docs.yml` (reporting through reviewdog,
`fail_on_error: false` — it annotates but does not block the PR). Unlike the
checks above, Vale runs on the host, not in `kas-container`.

Install it with the [Vale install guide](https://vale.sh/docs/install). The
config at `docs/.vale.ini` pulls the shared `Fio-docs` style; sync it once (and
again when the style updates):

```sh
vale --config=docs/.vale.ini sync
```

This downloads styles into `docs/.styles`. Then lint from the repository root:

```sh
vale --config=docs/.vale.ini docs/               # whole folder, like CI
vale --config=docs/.vale.ini docs/ci-scripts.md  # a single file
```

`MinAlertLevel` is `suggestion`, so expect suggestions, warnings, and errors.
CI will not fail on them, but fix what you can before opening the PR.
