*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HEART_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS
    ;32(SP) TYPE

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    MOVE.W #HRTANMSPD, TIMERSPRITE(A0)
    
    CMP.W #0, 32(SP)
    BEQ .TPEQ
    MOVE.W #BGHEART, HP(A0)
    BRA .ENDHSTART
    .TPEQ:
    MOVE.W #SMHEART, HP(A0)
    ;DEF HEART_SM
    .ENDHSTART:
    RTS
HEART_UPDATE:
    ;MIRAR SI INTERACTUA ALGO
    MOVE.L A0, -(SP)
    SUBQ.L #4, SP
    BSR COLLISION_ENTITY

    MOVE.L (SP)+, A1
    ADDQ.L #4, SP
    CMP.L #-1, A1
    BEQ .NODW
    CMP.W #1, ID(A1)
    BLT .NODW
    MOVE.W HP(A0), -(SP)
    MOVE.L A1, -(SP)
    BSR HEART_INTERACT
    ADDQ.L #6, SP

    MOVE.L A0, -(SP)
    JSR DESTROY_ENTITY
    ADDQ.L #4, SP
    BRA .ENDUPDATE
    .NODW: 

    MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #HRTANMSPD, D2
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
HEART_PAINT:
    RTS
HEART_INTERACT:
    MOVEM.L D0/A0, -(SP)

    MOVE.L 12(SP), A0
    MOVE.W 16(SP), D0
    ADD.W D0, HP(A0)

    MOVEM.L (SP)+, A0/D0
    RTS

HEART:
    DC.W 70                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 6,6, 50,50                                 ;COLISION_BOX 44
    DC.L HEART_START, HEART_UPDATE, DEFAULT_PAINT   ;@
    DC.L HEART_INTERACT                             ;@
    DC.L HEART_SM                                   ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        

INTERACT_ID     EQU AUX_DATA    ;


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
