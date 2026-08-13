DESCRIPTION = "A CLI utility to manage compose apps"
HOMEPAGE = "https://github.com/foundriesio/composeapp"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=504a5c2455c8bb2fc5b7667833ab1a68"

GO_IMPORT = "github.com/foundriesio/composeapp"
GO_IMPORT_PROTO ?= "https"

PV = "97+git"
BRANCH ?= "lmp-97"
SRCREV = "cc9ef57a9986f768aa659e53142860d9b3818cdc"

SRC_URI = "git://${GO_IMPORT};protocol=${GO_IMPORT_PROTO};branch=${BRANCH};destsuffix=${GO_SRCURI_DESTSUFFIX}"

inherit go-mod

RDEPENDS:${PN}-dev = "make"
GO_INSTALL = "${GO_IMPORT}/cmd/composectl"
GO_EXTRA_LDFLAGS = "\
    -X '${GO_IMPORT}/cmd/composectl/cmd.storeRoot=/var/sota/reset-apps' \
    -X '${GO_IMPORT}/cmd/composectl/cmd.composeRoot=/var/sota/compose-apps' \
    -X '${GO_IMPORT}/cmd/composectl/cmd.baseSystemConfig=/usr/lib/docker' \
    -X '${GO_IMPORT}/cmd/composectl/cmd.commit=${SRCREV}' \
"

do_install:append() {
    cd ${D}/${bindir}
    ln -sf composectl aklite-apps
}
