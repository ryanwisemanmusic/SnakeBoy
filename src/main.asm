INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
    jp EntryPoint

    ;This generates the Nintendo logo. It's a macro we can call to
    NINTENDO_LOGO

    ;We use 0x0100 through 0x014F to store ROM data, this is said data
    DB "SNAKEBOY"
    DS 11-10, 0
    DB CART_COMPATIBLE_DMG_GBC
    DB "HB"
    DB CART_INDICATOR_GB
    DB CART_ROM_32KB
    DB CART_SRAM_NONE
    DB CART_DEST_NON_JAPANESE
    DB $33
    DB 0
    DB 0
    DW 0

    ds $150 - @, 0

SECTION "Entry Point", ROM0[$150]
EntryPoint:
    ;This disables interrupts
    di 

    ;FFFE is the very top of the stack, we load this into the stack pointer
    ld sp, $FFFE
    
    ;We then call our first loop
    call WaitVBlank
    
    ;We initialize input variables in this section
    xor a
    ld [wCurKeys], a
    ld [wNewKeys], a

;This is the frameLoop that enables the game to run
.gameLoop:
    call WaitVBlank
    call ReadInput 
    jr .gameLoop

WaitVBlank:
    ;This loads the current scanline into a
    ldh a, [rLY]
    ;This compares against the amount of scanlines the Game Boy has: 144
    cp 144
    ;This jumps if the carry flag is set
    jr c, WaitVBlank
    ret
