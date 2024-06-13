export TARGET := iphone:clang:16.5
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless
export SYSROOT = $(THEOS)/sdks/iPhoneOS16.5.sdk
ARCH = arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = controlCenter

controlCenter_FILES = Tweak.x settings.m
controlCenter_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += controlcenterprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

