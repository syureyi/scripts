# uskee.org

ROOT = $(shell pwd)/../../..

TARGET := libname
TS := a
PS := cc

#
# set flags
CPPFLAGS += -DPOSIX -DLINUX
LDFLAGS  += 

#
# set lib dirs and include dirs
LIBDIRS :=
LIBS := 

LOCAL_PATH := .
INCLUDES := . ../interface ../.. spreadsortlib

include $(ROOT)/config.mak


#
# source files
#SOURCE := $(wildcard *.$(PS))
SOURCE := \
    map.cc 
#
# build objects
include $(ROOT)/subdir.mak