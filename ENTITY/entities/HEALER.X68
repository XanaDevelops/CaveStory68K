*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HEALER_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS

    MOVE.W  28(SP), YPOS(A0)
    MOVE.W  30(SP), XPOS(A0)
    RTS

HEALER_UPDATE:
    RTS

HEALER_DRAW:
    RTS

HEALER_INTERACT:
    RTS

HEALER:
    DC.W 52                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0 64,64                                  ;COLISION_BOX 44
    DC.L HEALER_START, HEALER_UPDATE, HEALER_DRAW      ;@
    DC.L HEALER_INTERACT                             ;@
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
