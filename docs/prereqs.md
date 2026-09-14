# Prerequisites

Building this layer uses `kas-container`, which runs the actual build inside a container so it does not depend on host tool versions.
You need:

- **git** — to clone this layer and the layers it pulls in.
- **A container runtime** — Docker or Podman.
  `kas-container` picks Docker when both are present.
- **`kas-container`** — get it from the
  [kas-container instructions](https://github.com/siemens/kas/blob/master/kas-container)
  and put it on your `PATH`.
  If it lives somewhere else, point at it instead:

  ```sh
  export KAS_CONTAINER=/abs/path/to/kas-container
  ```

## Verify the container runtime

Confirm the runtime works before starting a build.
Check Docker first:

```sh
docker run --rm hello-world
```

Then Podman, if you have it:

```sh
if command -v podman >/dev/null 2>&1; then
  podman run --rm hello-world
fi
```

Docker-only is fine if Podman is not installed.

## Work directories

Point `KAS_WORK_DIR`, `DL_DIR`, and `SSTATE_DIR` outside your checkout so downloads and shared state survive across clones and builds:

```sh
export KAS_WORK_DIR=/path/to/kas-work
export DL_DIR=/path/to/shared-cache/downloads
export SSTATE_DIR=/path/to/shared-cache/sstate-cache
mkdir -p "${DL_DIR}" "${SSTATE_DIR}" "${KAS_WORK_DIR}"
```

With those in place, see [Building for your hardware](./README.md#getting-started) for the actual build command.
