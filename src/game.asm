INCLUDE "hardware.inc"

SECTION "Game Data", ROM0
BackgroundTile:
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

SnakeTile:
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

SECTION "Game Code", ROM0
InitGame::
    call WaitVBlank
    ld a, 0
    ld [rLCDC], a

    ld hl, BackgroundTile
    ld de, _VRAM8000
    ld bc, 16
    call CopyData
    
    ld hl, SnakeTile
    ld de, _VRAM8000 + 16
    ld bc, 16
    call CopyData

    ld a, 0
    ld hl, _OAMRAM
    ld bc, 160
    call FillMemory

    ld a, %11111111
    ld [rBGP], a
    
    ld a, %00000000
    ld [rOBP0], a

    ld a, 0
    ld hl, _SCRN0
    ld bc, SCRN_VX_B * SCRN_VY_B
    call FillMemory

    call InitSnake
    call DrawSnake

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a
    ret

UpdateGame::
    call HandleInput
    call UpdateSnake
    ret

CopyData::
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, CopyData
    ret

FillMemory::
    ld [hl+], a
    dec bc
    ld d, a
    ld a, b
    or c
    ld a, d
    jr nz, FillMemory
    ret
    
