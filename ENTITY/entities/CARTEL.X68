*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CARTEL_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS
    ;32(SP) INTEACT_ID

    MOVE.W  28(SP), YPOS(A0)
    MOVE.W  30(SP), XPOS(A0)

    MOVE.W  32(SP), INTERACT_ID(A0)

CARTEL:
    DC.W 50                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 4,2, 60,64                                 ;COLISION_BOX
    DC.L CARTEL_START, DEFAULT_RTS, DEFAULT_PAINT   ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L CARTELS                                    ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        

INTERACT_ID     EQU AUX_DATA    ;W                                  

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
