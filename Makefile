TARGET := iphone:clang:latest:12.2
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchPad

SwitchPad_FILES = $(shell find Sources/SwitchPad -name '*.swift') $(shell find Sources/SwitchPadC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
SwitchPad_SWIFTFLAGS = -ISources/SwitchPadC/include
SwitchPad_CFLAGS = -fobjc-arc -ISources/SwitchPadC/include

include $(THEOS_MAKE_PATH)/tweak.mk
