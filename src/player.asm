INCLUDE "hardware.inc"

DEF SNAKE_LENGTH EQU 3
DEF SNAKE_START_X EQU 10
DEF SNAKE_START_Y EQU 8

SECTION "Snake Data", WRAM0
wSnakeBody: DS SNAKE_LENGTH * 2

SECTION "Snake Code", ROM0

InitSnake::
    ld hl, wSnakeBody
    ld a, SNAKE_START_X
    ld b, SNAKE_LENGTH

.initBodyLoop:
    ld [hl+], a
    ld a, SNAKE_START_Y
    ld [hl+], a
    ld a, SNAKE_START_X
    dec a
    dec b
    jr nz, .initBodyLoop

    ret 

DrawSnake::
    push bc
    push de
    push hl

    ld hl, wSnakeBody
    ld b, SNAKE_LENGTH
    ld de, _OAMRAM 

.drawLoop:
    ld a, [hl+]
    add a, OAM_Y_OFS
    ld [de], a
    inc de

    ld a, [hl+]
    add a, OAM_X_OFS 
    ld [de], a
    inc de

    ld a, 1
    ld [de], a
    inc de

    ld a, OAMF_PAL0
    ld [de], a
    inc de

    dec b
    jr nz, .drawLoop

    pop hl
    pop de
    pop bc
    ret
