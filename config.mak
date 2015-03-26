# uskee.org

ifeq ($(OS),Android)
HOST := arm-linux-androideabi-
else
HOST :=
endif

CC := $(HOST)gcc
CXX := $(HOST)g++
AR := $(HOST)ar crs
STRIP := $(HOST)strip
RM := rm -f

# for CPPFLAGS
CPPFLAGS += -Wall -O2 
CPPFLAGS += -MMD
CPPFLAGS += -DLinux

# for arm
ifeq ($(ARCH),arm)
CPPFLAGS += -DWEBRTC_ARCH_ARM

ifeq ($(ARCH_ARM_HAVE_NEON),true)
CPPFLAGS += -DWEBRTC_ARCH_ARM_NEON -flax-vector-conversions
WEBRTC_BUILD_NEON_LIBS := true
endif

ifeq ($(ARCH_ARM_HAVE_ARMV7A),true)
CPPFLAGS += -DWEBRTC_ARCH_ARM_V7A
endif
endif

# for LDFLAGS
LDFLAGS := -fPIC
