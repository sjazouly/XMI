SUMMARY = "sdc-tests"
DESCRIPTION = "SDC test files"
LICENSE = "CLOSED"

SRC_URI = "\
    file://Moldova.wav \
    file://wifi-bt.sh \
    file://test.sh \
"



do_install () {
    install -d ${D}${sysconfdir}/sdc/
    install -m 0644 ${WORKDIR}/Moldova.wav ${D}${sysconfdir}/sdc
    install -m 0755 ${WORKDIR}/wifi-bt.sh  ${D}${sysconfdir}/sdc
    install -m 0755 ${WORKDIR}/test.sh  ${D}${sysconfdir}/sdc
}


