ARCHS = arm64
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = Kuwo
THEOS_PACKAGE_SCHEME = rootless

THEOS_MAKE_PATH = $(THEOS)/makefiles
include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = KuwoAutoPlay
KuwoAutoPlay_FILES = Tweak.x
KuwoAutoPlay_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
