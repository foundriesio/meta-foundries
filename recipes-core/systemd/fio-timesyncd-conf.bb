SUMMARY = "systemd-timesyncd tuning for the Foundries.io OTA client"
DESCRIPTION = "systemd-timesyncd starts before the network is up, fails, and \
waits 30 seconds by default before trying again, so a board without a \
battery-backed RTC keeps an epoch-era clock long after the link is usable \
and TLS to the device gateway fails. This drop-in retries every 5 seconds."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch

do_install() {
    install -d ${D}${systemd_unitdir}/timesyncd.conf.d
    printf '[Time]\nConnectionRetrySec=5\n' \
        > ${D}${systemd_unitdir}/timesyncd.conf.d/10-${PN}.conf
}

FILES:${PN} = "${systemd_unitdir}/timesyncd.conf.d/"
