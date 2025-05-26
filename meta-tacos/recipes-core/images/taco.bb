SUMMARY = "A robust radiation hardened image"

IMAGE_INSTALL = "packagegroup-core-boot"

IMAGE_LINGUAS = " "

inherit core-image

IMAGE_FEATURES += "\
    tools-debug \
    allow-empty-password \
    allow-root-login \
    empty-root-password \
    "
IMAGE_CLASSES += "qemuboot"
