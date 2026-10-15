SRC_URI += " \
    file://dockerd-daemon-use-default-system-config-when-none-i.patch;patchdir=src/import \
    file://tarexport-Optimize-image-loading-on-local-host.patch;patchdir=src/import \
    file://registry-increase-TLS-and-connection-timeouts.patch;patchdir=src/import \
    file://layer-Ensure-layer-files-are-synced-to-disk.patch;patchdir=src/import \
    file://daemon.json \
"

# moby v29.7.0 moved the containerd supervisor. Both wrynose lockfiles pin
# v29.3.0, so only the patch for the old path ships.
SRC_URI += "file://remote_daemon-increase-containerd-default-timeouts_v29.5.patch;patchdir=src/import"

do_install:append() {
    install -d ${D}${libdir}/docker
    install -m 0644 ${UNPACKDIR}/daemon.json ${D}${libdir}/docker/daemon.json
}

FILES:${PN} += "${libdir}/docker/daemon.json"
