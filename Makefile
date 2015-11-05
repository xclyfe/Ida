#####################################
# Copyright (c) 2015
# # All rights reserved.
# ######################################

# Make file for next-muduo examples.

# #目标（可执行文档）名称，源文件目录, 库（譬如stdcx,iostr,mysql等），头文件路径
DESTINATION := echo_server # The name of example
SRCDIRS := examples/echo_server next_muduo next_muduo/threads
LIBS := pthread
INCLUDES := .

RM := rm -f
#C,CC或CPP文件的后缀
PS=cc
# GNU Make的隐含变量定义
CC=g++
CPPFLAGS = -g -Wall -O3 -march=x86-64
CPPFLAGS += $(addprefix -I,$(INCLUDES))
CPPFLAGS += -MMD
#CXXFLAGS = $(CPPFLAGS)
CXXFLAGS += -std=c++11 -Wall

#SOURCE
ifeq ($(SRCDIRS),)
	SRCDIRS = .
endif
SOURCE := $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(PS))))
OBJS := $(patsubst %.$(PS),%.o,$(SOURCE))
DEPS := $(patsubst %.o,%.d,$(OBJS))
MISSING_DEPS := $(filter-out $(wildcard $(DEPS)),$(DEPS))
MISSING_DEPS_SOURCES := $(wildcard $(patsubst %.d,%.$(PS),$(MISSING_DEPS)))

.PHONY : all deps objs clean rebuild

all : $(DESTINATION)

deps : $(DEPS)
		$(CC) -MM -MMD $(SOURCE)

objs : $(OBJS)

clean :
		@$(RM) $(OBJS) $(DEPS) $(DESTINATION)

rebuild: clean all 

ifneq ($(MISSING_DEPS),)
$(MISSING_DEPS) :
		@$(RM) $(patsubst %.d,%.o,$@)
endif

-include $(DEPS)

$(DESTINATION) : $(OBJS)
		$(CC) -o $(DESTINATION) $(OBJS) $(addprefix -l,$(LIBS))
#End
