*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HEALER_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    CLR.L SPRITE_INDEX(A0)

    RTS

HEALER_UPDATE:
    MOVE.L  D0, -(SP)
    
    TRAP    #14
    MOVE.L  (RNGVAL), D0
    ANDI.L  #1, D0
    MOVE.L  D0, SPRITE_INDEX(A0)
    
    MOVE.L (SP)+, D0
    RTS


HEALER_INTERACT:
    MOVEM.L D0/A0, -(SP)

    ;CURAR JUGADOR
    ;MOVE.L  16(SP), A0
    ;MOVE.W  MAXHEALTH(A0), ET_HP(A0)

    MOVE.W #IHEALDIAG, -(SP)
    JSR START_DBOX
    ADDQ.L #2, SP

    MOVEM.L (SP)+, A0/D0
    RTS

HEALER:
    DC.W 52                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                  ;COLISION_BOX 44
    DC.L HEALER_START, HEALER_UPDATE, DEFAULT_PAINT ;@
    DC.L HEALER_INTERACT                            ;@
    DC.L HEALER_SPR                                 ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
