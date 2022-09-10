TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

ifeq ($(detected_OS),Darwin)
    export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
endif

TWEAK_NAME = StagePad

${TWEAK_NAME}_FILES = $(shell find Sources/${TWEAK_NAME} -name '*.swift') $(shell find Sources/${TWEAK_NAME}C -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
${TWEAK_NAME}_SWIFTFLAGS = -ISources/${TWEAK_NAME}C/include
${TWEAK_NAME}_CFLAGS = -fobjc-arc -ISources/${TWEAK_NAME}C/include
${TWEAK_NAME}_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardHome


include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk