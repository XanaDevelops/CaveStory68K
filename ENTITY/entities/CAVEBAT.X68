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

    MOVE.W #BATANMSPD, TIMERSPRITE(A0)

    BSET.B #2, STATUS+1(A0) ;DISABLE GRAV

    RTS

BAT_UPDATE:
    MOVEM.L D1-D2, -(SP)

    CMP.W #0, HP(A0)
    BGT .NOKILL
        MOVE.L A0, -(SP)
        BSR DESTROY_ENTITY
        BRA .ENDUPDATE
    .NOKILL:

    CMP.W #0, YSPEED(A0)
    BNE .NOIMP
    NOT.B VELDIR(A0)
    BMI .ESNEG
        ADD.W #12, YSPEED(A0)
        BRA .NOIMP
    .ESNEG:
        SUB.W #12, YSPEED(A0)
    .NOIMP:

    CMP.W #0, YSPEED(A0)
    BMI .ESNEG2
        SUBQ.W #1, YSPEED(A0)
        BRA .ESZERO
    .ESNEG2:
        ADDQ.W #1, YSPEED(A0)
    .ESZERO:

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    ADDQ.L #4, SP
    
    MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #BATANMSPD, D2
            ADDQ.L #1, D1
            MOVE.L AD_SPRITE(A0), A1
            CMP.L (A1), D1
            BLT .NOOF
            MOVE.L #0, D1
            .NOOF:
            MOVE.L D1, SPRITE_INDEX(A0)
        .NOTIMER:
        MOVE.W D2, TIMERSPRITE(A0)

    .ENDUPDATE:
    MOVEM.L (SP)+, D2-D1

BAT_PAINT:
    RTS


BAT:
    DC.W -1                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 10                                         ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 4,4, 42,48                                 ;COLISION_BOX
    DC.L BAT_START, BAT_UPDATE, DEFAULT_PAINT       ;@
    DC.L BAT_FLY_L                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;
    DS.W 1                                          ;

BATANMSPD   EQU ANIMSPEED+1
TIMERSPRITE EQU AUX_DATA      ;W 
VELDIR      EQU AUX_DATA+2    ;B




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
