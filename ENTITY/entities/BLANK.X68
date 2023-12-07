*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

BLANK_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

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
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                    ;ET_HBOX 44
    DC.L BLANK_START, BLANK_UPDATE, BLANK_DRAW      ;@
    DC.L BLANK_INTERACT                             ;@
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
