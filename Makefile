TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk


include $(THEOS)/makefiles/common.mkgit

TWEAK_NAME = StagePad

StagePad_FILES = $(shell find Sources/StagePad -name '*.swift') $(shell find Sources/StagePadC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
StagePad_SWIFTFLAGS = -ISources/StagePadC/include
StagePad_CFLAGS = -fobjc-arc -ISources/StagePadC/include
StagePad_PRIVATE_FRAMEWORKS = SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk
