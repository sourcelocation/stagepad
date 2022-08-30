TARGET := iphone:clang:latest:12.2
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StagePad

StagePad_FILES = $(shell find Sources/StagePad -name '*.swift') $(shell find Sources/StagePadC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
StagePad_SWIFTFLAGS = -ISources/StagePadC/include
StagePad_CFLAGS = -fobjc-arc -ISources/StagePadC/include

include $(THEOS_MAKE_PATH)/tweak.mk
