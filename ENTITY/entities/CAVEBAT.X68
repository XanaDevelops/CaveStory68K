*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
BAT_START:
    ;36(SP) YPOS 
    ;38(SP) XPOS

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    CLR.B VELDIR(A0)

    MOVE.B #ANIMSPEED, TIMERSPRITE(A0)

    RTS

BAT_UPDATE:
    MOVEM.L D1-D2, -(SP)

    MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #ANIMSPEED, D2
            ADDQ.L #1, D1
            MOVE.L AD_SPRITE(A0), A1
            CMP.L (A1), D1
            BLT .NOOF
            MOVE.L #0, D1
            .NOOF:
            MOVE.L D1, SPRITE_INDEX(A0)
        .NOTIMER:
        MOVE.W D2, TIMERSPRITE(A0)

    MOVEM.L (SP)+, D2-D1

BAT_PAINT:
    RTS


BAT:
    DC.W -1*1                                       ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 10                                         ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 8,2, 58,64                                 ;COLISION_BOX
    DC.L BAT_START, BAT_UPDATE, DEFAULT_PAINT       ;@
    DC.L BAT_FLY_L                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;
    DS.W 1                                          ;

TIMERSPRITE EQU AUX_DATA
VELDIR      EQU AUX_DATA+1    ;B

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
