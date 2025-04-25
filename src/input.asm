INCLUDE "hardware.inc"

SECTION "Input Variables", WRAM0

wCurKeys:: DS 1
wNewKeys:: DS 1

SECTION "Input Functions", ROM0

ReadInput::
    ld a, P1F_GET_BTN
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl 
    and $0F
    swap a
    ld b, a

    ld a, P1F_GET_DPAD
    ld [rP1], a 
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and $0F
    or b
    
    ;Reset joypad
    ld b, a
    ld a, P1F_GET_NONE
    ldh [rP1], a

    ;Calculate newly pressed keys
    ld a, b
    ld c, a
    ld a, [wCurKeys]
    cpl 
    and c
    ld [wNewKeys], a

    ;Update current keys
    ld a, b
    ld [wCurKeys], a
    ret

IsKeyPressed::
    ld b, a
    ld a, [wCurKeys]
    and b
    ret

IsKeyJustPressed::
    ld b, a
    ld a, [wNewKeys]
    and b
    ret
