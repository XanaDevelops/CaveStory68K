*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CARTEL_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS
    ;32(SP) INTEACT_ID

    ADDS_ZORD

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  32(SP), INTERACT_ID(A0)

    RTS

CARTEL:
    DC.W 50                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 4,2, 60,64                                 ;ET_HBOX
    DC.L CARTEL_START, DEFAULT_RTS, DEFAULT_PAINT   ;@
    DC.L DEFAULT_INTERACTION                        ;@
    DC.L CARTELS                                    ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0        
    DC.W 100                                        ;ET_ZORD                                  
     

INTERACT_ID     EQU ET_DATA    ;W                                  

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
