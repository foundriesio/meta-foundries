SUMMARY = "Foundries.io OTA+ device components"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\
    aktualizr-lite \
    fio-device-register \
    fioconfig \
    ${@d.getVar('COMPOSE_APP_MANAGER') or ''} \
"
