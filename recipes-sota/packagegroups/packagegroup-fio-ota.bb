SUMMARY = "Foundries.io OTA+ device components"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\
    aktualizr-lite \
    fio-device-register \
    ${@d.getVar('COMPOSE_APP_MANAGER') or ''} \
"
