# Temporary protection for the affected UNO Q 4 GB firmware memory map.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:uno-q = " file://0001-arm64-dts-qcom-qrb2210-arduino-imola-reserve-m05-boundary.patch"
