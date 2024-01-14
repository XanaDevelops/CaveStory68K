*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

BLANK_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    ADDS_ZORD

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)
    RTS

BLANK_UPDATE:
    RTS

BLANK_DRAW:
    RTS

BLANK_INTERACT:
    RTS

BLANK:
    DC.W 0                                          ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L BLANK_START, BLANK_UPDATE, BLANK_DRAW      ;@EXECUTES
    DC.L BLANK_INTERACT                             ;@INTERACT/EXTRA
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0                                          ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD
                                         

    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
