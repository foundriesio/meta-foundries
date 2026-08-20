SUMMARY = "Foundries.io OTA+ platform components"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\
    ${@d.getVar('SOTA_CLIENT') or ''} \
    fio-device-register \
    fioconfig \
"
