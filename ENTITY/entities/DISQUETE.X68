*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DISKQ_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    MOVE.W #DSKANIM, TIMERSPRITE(A0)
    RTS

DISKQ_UPDATE:
    MOVEM.L D1-D2/A1, -(SP)

    MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #DSKANIM, D2
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

    MOVEM.L (SP)+, A1/D2-D1
    RTS

DISKQ_INTERACT:
    JSR GAME_SAVE
    
    MOVE.W #4, -(SP)
    JSR START_DBOX
    ADDQ.L #2, SP
    RTS

DISQUETE:
    DC.W 51                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                 ;COLISION_BOX 44
    DC.L DISKQ_START, DISKQ_UPDATE, DEFAULT_PAINT   ;@
    DC.L DISKQ_INTERACT                             ;@
    DC.L DISKQ_SPR                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1     
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
