*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

BA_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    RTS

BA_UPDATE:

    TST.B   BA_INDEX(A0)
    BNE     .NO0

    .NO0:

    .END:

    RTS

BA_DRAW:
    RTS

BA_INTERACT:
    RTS

BA:
    DC.W 0                                          ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L BA_START, BA_UPDATE, DEFAULT_RTS      ;@EXECUTES
    DC.L DEFAULT_RTS                             ;@INTERACT/EXTRA
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0                                          ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD
    DS.W 1                                         

BA_INDEX   EQU ET_DATA ;B
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
