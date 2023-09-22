*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_START:
    MOVE.W #SCREEN_WIDTH/2-32, 2(A0)
    MOVE.W #SCREEN_HEIGHT/2-32, 4(A0)
    ;ADD.W #64, 4(A0)
    MOVE.W #ANIMSPEED, 42(A0)
    CLR.W 44(A0)
    RTS
PLAYER_UPDATE:
    MOVE.L D0, -(SP)

    MOVE.L A0, -(SP)

    ADDQ.W #1, 10(A0)                   ;GRAVEDAD
    CMP.W #MAX_SCRLL_SPEED, 10(A0)
    BLE .NOMXSPED
        MOVE.W #MAX_SCRLL_SPEED, 10(A0)
    .NOMXSPED:

    BTST.B #KEYM_LEFT, (KEY_PRESS_PLAYER) ;MOVIMIENTO
    BEQ .NOLEFT
    SUBQ.W #2, 8(A0)
    CLR.W 44(A0)
    .NOLEFT:
    
    BTST.B #KEYM_RIGHT, (KEY_PRESS_PLAYER) ;AÑADIR LIMITADORES
    BEQ .NORIGHT
    ADDQ.W #2, 8(A0) 
    MOVE.W #-1, 44(A0)
    .NORIGHT:

    CMP.W #0, 8(A0)
    BEQ .ESZERO
    BMI .ESNEG
        SUBQ.W #1, 8(A0)
        BRA .ESZERO
    .ESNEG:
        ADDQ.W #1, 8(A0)
    .ESZERO:

    CMP.W #MAX_SCRLL_SPEED, 8(A0)
    BLE .NOMAX
        MOVE.W #MAX_SCRLL_SPEED, 8(A0)
    .NOMAX:
    CMP.W #-MAX_SCRLL_SPEED, 8(A0)
    BGE .NOMMAX
        MOVE.W #-MAX_SCRLL_SPEED, 8(A0)
    .NOMMAX:

    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)      ;SALTO BASE
    BEQ .NOZ
    BTST.B #3, 13(A0)
    BEQ .NOZ
    SUBI.W #20, 10(A0) 
    .NOZ:

    BCLR.B #3, 13(A0)
    BSR UPDATE_PHYSICS

    MOVE.W 4(A0), D0                ;PANTALLA SEGUIR CAIDA
    SUB.W (SCREEN_Y), D0
    CMP.W #SCREEN_HEIGHT-175, D0
    BLT .NOSKDWY
        ADD.W #4, (SCR_SPEED_Y)     ;RPOBAR 4 A VER
    .NOSKDWY:
    CMP.W #SCREEN_HEIGHT-300, D0
    BGT .NOSKUPY
        SUB.W #4, (SCR_SPEED_Y)     ;RPOBAR 4 A VER
    .NOSKUPY:

    MOVE.W 8(A0), D0
    MOVE.W D0, (SCR_SPEED_X)


    ADDQ.L #4, SP
    MOVE.L (SP)+, D0
    RTS

PLAYER_PAINT:
    MOVEM.L D0-D2/A1-A2, -(SP)

    MOVE.L 34(A0), A1
    MOVE.L 38(A0), D1

    ASL.L #2, D1
    MOVE.L 4(A1, D1), A2


    ;MOVE.L #QUOTE_L_0, -(SP)
    MOVE.L A2, -(SP)
    MOVE.W 4(A0), D0
    SUB.W (SCREEN_Y), D0
    MOVE.W D0, -(SP)
    MOVE.W 2(A0), D0
    SUB.W (SCREEN_X), D0
    MOVE.W D0, -(SP)

    BSR FASTSPRITE

    ADDQ.L #8, SP

    ASR.W #2, D1                ;
    MOVE.W 42(A0), D2
    SUBQ.W #1, D2
    CMP.W #0, D2
    BNE .NOTIMER
        MOVE.W #ANIMSPEED, D2
        ADDQ.L #1, D1
        CMP.L (A1), D1
        BLT .NOOF
        MOVE.L #0, D1
        .NOOF:
        MOVE.L D1, 38(A0)
    .NOTIMER:
    MOVE.W D2, 42(A0)

    MOVEM.L (SP)+, A2-A1/D2-D0
    RTS

PLAYER:
    DC.W 1                                          ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(AIRBONE)---
    DC.W 8,2, 58,64                                 ;COLISION_BOX
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT  ;@
    DC.L QUOTE_WALK_L                               ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;42.W (timer sprite)
    DS.W 1                                          ;44.W (lookdir) 0:left -1:right





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
