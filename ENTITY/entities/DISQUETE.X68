*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DISKQ_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  #DSKANIM, ET_TSPRT(A0)
    RTS

DISKQ_UPDATE:
    MOVEM.L D1-D2/A1, -(SP)

    MOVE.L  ET_ISPR(A0), D1                   ;ANIM_INDEX
        MOVE.W  ET_TSPRT(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W  #1, D2
        BNE     .NOTIMER
            MOVE.W  #DSKANIM, D2
            ADDQ.L  #1, D1
            MOVE.L  ET_SPRITE(A0), A1
            CMP.L   (A1), D1
            BLT     .NOOF
            MOVE.L  #0, D1
            .NOOF:
            MOVE.L  D1, ET_ISPR(A0)
        .NOTIMER:
        MOVE.W  D2, ET_TSPRT(A0)
    .ENDUPDATE:    

    MOVEM.L (SP)+, A1/D2-D1
    RTS

DISKQ_INTERACT:
    ;TODO: GUARDAR POS SPAWN
    
    MOVE.W  #4, -(SP)
    JSR     START_DBOX
    ADDQ.L  #2, SP

    MOVE.W  ET_XPOS(A0), SPAWNX
    MOVE.W  ET_YPOS(A0), SPAWNY

    JSR     GAME_SAVE

    RTS

DISQUETE:
    DC.W 51                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                 ;ET_HBOX 44
    DC.L DISKQ_START, DISKQ_UPDATE, DEFAULT_PAINT   ;@
    DC.L DISKQ_INTERACT                             ;@
    DC.L DISKQ_SPR                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
                                         
       

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
