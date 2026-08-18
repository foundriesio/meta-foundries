SUMMARY = "Foundries.io OTA+ device diagnostic tool"
DESCRIPTION = "Shell script that collects the state of the update client, the \
device certificates, the container runtime, and the connectivity to the \
Foundries.io services"
HOMEPAGE = "https://github.com/foundriesio/lmp-tools/tree/master/device-scripts"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

BRANCH ?= "master"
SRCREV = "068c4566306efbca6cc8749c07decc4a8e9a2625"

SRC_URI = "git://github.com/foundriesio/lmp-tools;protocol=https;branch=${BRANCH}"

inherit allarch

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${S}/device-scripts/fio-diag.sh ${D}${sbindir}
}
