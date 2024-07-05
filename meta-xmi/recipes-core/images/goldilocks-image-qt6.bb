DESCRIPTION = "Sample image for Goldilocks Mamabear app"
LICENSE = "MIT"

require dynamic-layers/qt6-layer/recipes-fsl/images/imx-image-full.bb

IMAGE_INSTALL += "\
"
IMAGE_ROOTFS_EXTRA_SPACE = "640000"

IMAGE_INSTALL:append = "\
"


# rsync is only used during development
IMAGE_INSTALL += "rsync"

