SUMMARY = "Foundries.io OTA+ platform components"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\
    aktualizr-lite \
    fio-device-register \
    fioconfig \
"
