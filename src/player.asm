INCLUDE "hardware.inc"

;Definitions of snake sprite
DEF SNAKE_LENGTH   EQU 3
DEF SNAKE_START_X  EQU 10
DEF SNAKE_START_Y  EQU 8
;Definitions of snake direction constants
DEF DIR_RIGHT      EQU 0
DEF DIR_LEFT       EQU 1
DEF DIR_UP         EQU 2
DEF DIR_DOWN       EQU 3
DEF SNAKE_SPEED    EQU 1

SECTION "Snake Data", WRAM0
wSnakeBody: DS SNAKE_LENGTH * 2
wSnakeDirection: DS 1

SECTION "Snake Code", ROM0
;Initialize the snake
InitSnake::
    ld hl, wSnakeBody
    ld a, SNAKE_START_X
    ld b, SNAKE_LENGTH

;Initialize the snake body starting point
.initBodyLoop:
    ld [hl+], a
    ld a, SNAKE_START_Y
    ld [hl+], a
    ld a, SNAKE_START_X
    dec a
    dec b
    jr nz, .initBodyLoop
)
    xor a 
    ld [wSnakeDirection], a

    ret

;Draws the snake
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

SECTION "Snake Movement", ROM0
HandleInput::
    ld a, PADF_RIGHT
    call IsKeyPressed
    jr z, .notRight
    ld a, [wSnakeDirection]

    cp DIR_LEFT

    jr z, .notRight
    ld a, DIR_RIGHT
    ld [wSnakeDirection], a
    jr .inputDone

.notRight:
    ld a, PADF_LEFT
    call IsKeyPressed
    jr z, .notLeft
    ld a, [wSnakeDirection]
    cp DIR_RIGHT
    jr z, .notLeft
    ld a, DIR_LEFT
    ld [wSnakeDirection], a
    jr .inputDone

.notLeft:
    ld a, PADF_UP
    call IsKeyPressed
    jr z, .notUp
    ld a, [wSnakeDirection]
    cp DIR_DOWN
    jr z, .notUp
    ld a, DIR_UP
    ld [wSnakeDirection], a
    jr .inputDone
.notUp:
    inc hl
    ld a, [hl]
    add SNAKE_SPEED
    ld [hl], a
    dec hl

.notDown:

.inputDone:
    ret

.moveLoop:
    dec c
    jr z, .moveLoopDone
    
    push hl   
    
    ld a, [de]
    ld b, a
    inc de
    ld a, [de]
    ld c, a
    inc de

    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl], a

    pop hl
    inc hl
    inc hl
    jr .moveLoop

.moveLoopDone:
    pop hl
    pop de
    pop bc
    ret

UpdateSnake::
    push bc
    push de
    push hl
    
    ld a, [wSnakeDirection]
    
    or a
    jr z, .skipMovement
    
    ld hl, wSnakeBody
    
    cp DIR_RIGHT
    jr nz, .notRight
    inc [hl]
    jr .directionDone
    
.notRight:
    cp DIR_LEFT
    jr nz, .notLeft
    dec [hl]
    jr .directionDone
    
.notLeft:
    cp DIR_UP
    jr nz, .notUp
    inc hl
    dec [hl]
    dec hl
    jr .directionDone
    
.notUp:
    inc hl
    inc [hl]
    dec hl
    
.directionDone:
    call DrawSnake
    
    pop hl
    pop de
    pop bc
    ret

.skipMovement:
    call DrawSnake
    
    pop hl
    pop de
    pop bc
    ret
