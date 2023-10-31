*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TEXTDISP_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS
    ;32(SP) @TEXT

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    MOVE.L 32(SP), AD_TEXTO(A0)
    RTS

TEXTDISP_DRAW:
    MOVE.B #95, D0
    MOVE.W XPOS(A0), D1
    MOVE.W YPOS(A0), D2
    MOVE.L AD_TEXTO(A0), A1
    TRAP #15

    RTS

TEXTDISP:
    DC.W 4                                          ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;COLISION_BOX 44
    DC.L TEXTDISP_START, DEFAULT_RTS, TEXTDISP_DRAW ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L -1                                         ;@TEXTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        

AD_TEXTO    EQU AD_SPRITE

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
