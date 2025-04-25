INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
    jp EntryPoint
    ds $150 - @, 0

SECTION "Entry Point", ROM0[$150]
EntryPoint:
    ;This disables interrupts
    di 

    ;FFFE is the very top of the stack, we load this into the stack pointer
    ld sp, $FFFE
    
    ;We then call our first loop
    call WaitVBlank

;This is the frameLoop that enables the game to run
.gameLoop:
    halt
    nop 
    jr .gameLoop

WaitVBlank:
    ;This loads the current scanline into a
    ldh a, [rLY]
    ;This compares against the amount of scanlines the Game Boy has: 144
    cp 144
    ;This jumps if the carry flag is set
    jr c, WaitVBlank
    ret
