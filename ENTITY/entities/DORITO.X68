*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DORITO_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS
    ;32(SP) TYPE

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    MOVE.W #DRTANMSPD, TIMERSPRITE(A0)
    
    ;CMP.W #0, 32(SP)
    ;BEQ .TPEQ
    ;MOVE.W #BGDORITO, HP(A0)
    ;BRA .ENDHSTART
    .TPEQ:
    ;MOVE.W #SMDORITO, HP(A0)
    ;DEF DORITO_SM
    MOVE.W #MDORITO, HP(A0)
    .ENDHSTART:
    RTS

DORITO_UPDATE:
    ;MIRAR SI INTERACTUA ALGO
    MOVE.L A0, -(SP)
    SUBQ.L #4, SP
    BSR COLLISION_ENT_PLR

    MOVE.L (SP)+, A1
    ADDQ.L #4, SP
    CMP.L #-1, A1
    BEQ .NODW

    ;CMP.W #1, ID(A1)
    ;BNE .NODW

    MOVE.W HP(A0), -(SP)
    MOVE.L A1, -(SP)
    BSR DORITO_INTERACT
    ADDQ.L #6, SP

    MOVE.L A0, -(SP)
    JSR DESTROY_ENTITY
    ADDQ.L #4, SP
    BRA .ENDUPDATE
    .NODW: 

    BCLR.B #3, STATUS+1(A0)

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    ADDQ.L #4, SP

    ;COMPROBAR SUELO
    CLR.L D0
    BTST.B #3, STATUS+1(A0)
    BEQ .NOHIT
        MOVE.W #-10, YSPEED(A0)
    .NOHIT:

    MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #DRTANMSPD, D2
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
    RTS
DORITO_PAINT:
    RTS
DORITO_INTERACT:
    MOVEM.L D0/A0, -(SP)

    MOVE.L 12(SP), A0
    MOVE.W 16(SP), D0
    
    ADD.W HP(A0), D0
    CMP.W MAXHEALTH(A0), D0
    BLE .NOOV
    MOVE.W MAXHEALTH(A0), D0
    .NOOV:
    MOVE.W D0, HP(A0)

    MOVEM.L (SP)+, A0/D0
    RTS

DORITO:
    DC.W 71                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 6,6, 50,64                                 ;COLISION_BOX 44
    DC.L DORITO_START, DORITO_UPDATE, DEFAULT_PAINT ;@
    DC.L DORITO_INTERACT                            ;@
    DC.L DORITO_M                                   ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        

INTERACT_ID     EQU AUX_DATA    ;


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
