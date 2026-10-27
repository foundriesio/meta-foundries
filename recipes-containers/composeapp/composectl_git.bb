DESCRIPTION = "A CLI utility to manage compose apps"
HOMEPAGE = "https://github.com/foundriesio/composeapp"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=504a5c2455c8bb2fc5b7667833ab1a68"

GO_IMPORT = "github.com/foundriesio/composeapp"
GO_IMPORT_PROTO ?= "https"

# PV follows the upstream tags, which sort below the earlier LmP-numbered 97.
PE = "1"
PV = "96.3.0+git"
BRANCH ?= "main"
SRCREV = "df10d55328a672d81e3e75a16cb3d9547dea8de8"

SRC_URI = "git://${GO_IMPORT};protocol=${GO_IMPORT_PROTO};branch=${BRANCH};destsuffix=${GO_SRCURI_DESTSUFFIX}"

inherit go-mod go-mod-update-modules

require ${BPN}-go-mods.inc
require ${BPN}-licenses.inc

RDEPENDS:${PN}-dev = "make"
GO_INSTALL = "${GO_IMPORT}/cmd/composectl"

COMPOSE_APP_STORE_ROOT ?= "/var/sota/reset-apps"
COMPOSE_APP_COMPOSE_ROOT ?= "/var/sota/compose-apps"

GO_EXTRA_LDFLAGS = "\
    -X '${GO_IMPORT}/cmd/composectl/cmd.storeRoot=${COMPOSE_APP_STORE_ROOT}' \
    -X '${GO_IMPORT}/cmd/composectl/cmd.composeRoot=${COMPOSE_APP_COMPOSE_ROOT}' \
    -X '${GO_IMPORT}/cmd/composectl/cmd.Commit=${SRCREV}' \
"

do_install:append() {
    cd ${D}${bindir}
    ln -sf composectl aklite-apps
}

PACKAGES =+ "${PN}-aklite-apps"

FILES:${PN} = "${bindir}/composectl"
FILES:${PN}-aklite-apps = "${bindir}/aklite-apps"

RDEPENDS:${PN}-aklite-apps = "${PN}"
