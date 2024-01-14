*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

TESTCUBO_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    ADDS_ZORD

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)
    RTS

TESTCUBO_UPDATE:
    MOVEM.L D1-D2/A1, -(SP)

    MOVE.L  ET_ISPR(A0), D1                   ;ANIM_INDEX
        MOVE.W  ET_TSPRT(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W  #1, D2
        BNE     .NOTIMER
            MOVE.W  #BLNDANIM, D2 ;TSPRT
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


TESTCUBO:
    DC.W 127                                         ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 128,128, 512,480                           ;ET_HBOX 44
    DC.L TESTCUBO_START, TESTCUBO_UPDATE, DEFAULT_PAINT   ;@EXECUTES
    DC.L DEFAULT_RTS                                ;@INTERACT/EXTRA
    DC.L SPR_LOL                               ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W BLNDANIM                                   ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD                                     

    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
