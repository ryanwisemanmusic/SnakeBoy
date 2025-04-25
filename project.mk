# This file contains project configuration

# Value that the ROM will be filled with
PADVALUE := 0xFF

## Header constants (passed to RGBFIX)

# ROM version
VERSION := 0

# 4-ASCII letter game ID
GAMEID := GBDV

# Game title, up to 11 ASCII chars
TITLE := GAMEBOYDEV

# New licensee, 2 ASCII chars
LICENSEE := HB
# Old licensee
OLDLIC := 0x33

# MBC type
MBC := 0x00

# SRAM size
SRAMSIZE := 0x00

# ROM name
ROMNAME := GameBoyDev
ROMEXT  := gb

# Disable automatic `nop` after `halt`
ASFLAGS += -h
