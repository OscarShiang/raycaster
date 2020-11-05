BIN = main
TBL_GEN = table_generator

CXXFLAGS = -std=c++11 -O2 -Wall -g

LOOKUP_TBL := raycaster_tables.h

TOOLS_DIR := tools

# SDL
CXXFLAGS += `sdl2-config --cflags`
LDFLAGS += `sdl2-config --libs`

# Control the build verbosity
ifeq ("$(VERBOSE)","1")
    Q :=
    VECHO = @true
else
    Q := @
    VECHO = @printf
endif

GIT_HOOKS := .git/hooks/applied
.PHONY: all clean

all: $(GIT_HOOKS) $(LOOKUP_TBL) $(BIN)

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo
	
OBJS := \
	game.o \
	raycaster_fixed.o \
	raycaster_float.o \
	renderer.o \
	main.o
deps := $(OBJS:%.o=.%.o.d)

TBL_GEN_OBJS := \
	tools/precalculator.o \
	tools/table_generator.o
deps := $(TBL_GEN_OBJS:%.o=.%.o.d)

%.o: %.cpp
	@mkdir -p .$(TOOLS_DIR)
	$(VECHO) "  CXX\t$@\n"
	$(Q)$(CXX) -o $@ $(CXXFLAGS) -c -MMD -MF .$@.d $<

$(BIN): $(OBJS)
	$(Q)$(CXX) -o $@ $^ $(LDFLAGS)

$(TBL_GEN): $(TBL_GEN_OBJS)
	$(VECHO) "  CXX\t$@\n"
	$(Q)$(CXX) -o $@ $^

$(LOOKUP_TBL): $(TBL_GEN)
	$(VECHO) "  GEN\t$@\n"
	$(Q)eval "./$^ $@"

clean:
	$(RM) $(BIN) $(OBJS) $(TBL_GEN) $(TBL_GEN_OBJS) $(deps)
	rm -rf .$(TOOLS_DIR)

-include $(deps)
