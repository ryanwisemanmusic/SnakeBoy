.SUFFIXES:

# Directory constants
BINDIR := bin
OBJDIR := obj
DEPDIR := dep

# Program constants
RM_RF := rm -rf
MKDIR_P := mkdir -p

# RGBDS tools
RGBASM  := rgbasm
RGBLINK := rgblink
RGBFIX  := rgbfix

# ROM details
ROMNAME := GameBoyDev
ROMEXT  := gb
ROM := $(BINDIR)/$(ROMNAME).$(ROMEXT)

# Compilation flags
INCDIRS := src/ src/include/ src/bin/
ASFLAGS := -v -p 0xFF $(addprefix -I,$(INCDIRS))
LDFLAGS := -p 0xFF
FIXFLAGS := -p 0xFF -v -i "GBDV" -k "HB" -l 0x33 -m 0x00 -n 0 -r 0x00 -t GAMEBOYDEV

# Source files
SRCS := $(wildcard src/*.asm)
OBJS := $(patsubst src/%.asm,$(OBJDIR)/%.o,$(SRCS))

# Default target
all: $(ROM)
.PHONY: all

# Create directories
directories:
	$(MKDIR_P) $(BINDIR)
	$(MKDIR_P) $(OBJDIR)
	$(MKDIR_P) $(DEPDIR)
.PHONY: directories

# Clean target
clean:
	$(RM_RF) $(BINDIR)
	$(RM_RF) $(OBJDIR)
	$(RM_RF) $(DEPDIR)
.PHONY: clean

# Rebuild target
rebuild: clean all
.PHONY: rebuild

# Compile .asm to .o
$(OBJDIR)/%.o: src/%.asm | directories
	$(RGBASM) $(ASFLAGS) -o $@ $<

# Build date object
$(OBJDIR)/build_date.o: src/res/build_date.asm | directories
	$(RGBASM) $(ASFLAGS) -o $@ $<

# Link objects into ROM
$(ROM): $(OBJS) $(OBJDIR)/build_date.o | directories
	$(RGBLINK) $(LDFLAGS) -m $(BINDIR)/$(ROMNAME).map -n $(BINDIR)/$(ROMNAME).sym -o $@ $^
	$(RGBFIX) $(FIXFLAGS) $@

# Catch non-existent files
%:
	@echo "No rule to make target '$@'"
	@false
