#
# for custom includes and libs
CPPFLAGS += $(addprefix -I,$(INCLUDES))
LDFLAGS += $(addprefix -L,$(LIBDIRS)) $(addprefix -l,$(LIBS))

#
# objects and build
OBJS := $(foreach ps,$(PS),$(patsubst %.$(ps),%.o,$(filter %.$(ps),$(SOURCE))))

DEPS := $(patsubst %.o,%.d,$(OBJS))
MISSING_DEPS := $(filter-out $(wildcard $(DEPS)),$(DEPS))
MISSING_DEPS_SOURCES := $(wildcard $(patsubst %.d,%.$(PS),$(MISSING_DEPS)))

.PHONY : all deps objs clean distclean rebuild

all : $(TARGET)

deps : $(DEPS)
	$(CC) -MM -MMD $(SOURCE)

objs : $(OBJS)

clean :
	@$(RM) $(OBJS)
	@$(RM) $(DEPS)

distclean : clean
	@$(RM) $(TARGET).$(TS)

rebuild: distclean all

ifneq ($(MISSING_DEPS),)
$(MISSING_DEPS) :
	@$(RM) $(patsubst %.d,%.o,$@)
endif

-include $(DEPS)

#
# generate target
ifeq ($(TS),so)
$(TARGET) : $(OBJS)
	$(CC) -shared -o $(TARGET).$(TS) $(OBJS) $(LDFLAGS)
	$(STRIP) $(TARGET).$(TS)
else
ifeq ($(TS),a)
$(TARGET) : $(OBJS)
	$(AR) $(TARGET).$(TS) $(OBJS)
else
$(TARGET) : $(OBJS)
	$(CC) -o $(TARGET) $(OBJS) $(LDFLAGS)
	$(STRIP) $(TARGET)
endif
endif