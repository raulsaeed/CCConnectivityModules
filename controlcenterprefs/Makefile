export TARGET := iphone:clang:16.5
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = controlCenterPrefs

controlCenterPrefs_FILES = CONRootListController.m MEVOConnectivityOrderController.m
controlCenterPrefs_FRAMEWORKS = UIKit
controlCenterPrefs_PRIVATE_FRAMEWORKS = Preferences 

controlCenterPrefs_INSTALL_PATH = /Library/PreferenceBundles
controlCenterPrefs_CFLAGS = -fobjc-arc 

include $(THEOS_MAKE_PATH)/bundle.mk