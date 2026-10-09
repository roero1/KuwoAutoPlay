ARCHS = arm64
TARGET = iphone:clang:17:15.0
THEOS_PACKAGE_SCHEME = rootless
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KuwoAutoPlay

KuwoAutoPlay_FILES = Tweak.x
KuwoAutoPlay_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
