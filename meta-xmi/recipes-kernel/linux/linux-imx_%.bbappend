FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://defconfig \
    file://imx8mp-ddr4-evk.dts \
"

# Override meta-imx's KBUILD_DEFCONFIG,
# thus ensuring "file://defconfig" is used
unset KBUILD_DEFCONFIG

do_override_files () {
    # custom defconfig
    install -Dm 0644 ${WORKDIR}/defconfig ${S}/arch/arm64/configs/imx_v8_defconfig

    # device-tree customizations
    install -Dm 0644 ${WORKDIR}/imx8mp-ddr4-evk.dts ${S}/arch/arm64/boot/dts/freescale/imx8mp-ddr4-evk.dts
}
addtask override_files after do_kernel_configme before do_configure

deltask kernel_localversion
deltask merge_delta_config
