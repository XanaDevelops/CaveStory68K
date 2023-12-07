*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TEXTDISP_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS
    ;32(SP) @TEXT

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.L  32(SP), AD_TEXTO(A0)
    RTS

TEXTDISP_DRAW:
    MOVEM.L D0-D2/A1, -(SP)

    MOVE.B  #95, D0
    MOVE.W  ET_XPOS(A0), D1
    MOVE.W  ET_YPOS(A0), D2
    MOVE.L  AD_TEXTO(A0), A1
    TRAP    #15

    MOVEM.L (SP)+, A1/D2-D0
    RTS

TEXTDISP:
    DC.W 4                                          ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L TEXTDISP_START, DEFAULT_RTS, TEXTDISP_DRAW ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L -1                                         ;@TEXTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        

AD_TEXTO    EQU ET_SPRITE

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
