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
    RTS
HEART_PAINT:
    RTS
HEART_INTERACT:
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
