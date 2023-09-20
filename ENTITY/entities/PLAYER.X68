*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_START:
    MOVE.W #SCREEN_HEIGHT/2-32, 2(A0)
    MOVE.W #SCREEN_WIDTH/2-32, 4(A0)
    MOVE.W #ANIMSPEED, 42(A0)
    RTS
PLAYER_UPDATE:
    RTS
PLAYER_PAINT:
    MOVEM.L D0-D2/A1-A2, -(SP)

    MOVE.L 34(A0), A1
    MOVE.L 38(A0), D1

    ASL.L #2, D1
    MOVE.L 4(A1, D1), A2


    ;MOVE.L #QUOTE_L_0, -(SP)
    MOVE.L A2, -(SP)
    MOVE.W 2(A0), D0
    MOVE.W D0, -(SP)
    MOVE.W 4(A0), D0
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
    DC.W 0,0, 64,64                                 ;COLISION_BOX
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT  ;@
    DC.L QUOTE_WALK_L                               ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;42.W (timer sprite)
    DS.W 1



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
