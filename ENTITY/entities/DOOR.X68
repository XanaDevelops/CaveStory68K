*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DOOR_START:
    ;28(SP).W YPOS 
    ;30(SP).W XPOS
    ;34(SP).W NEXTY
    ;36(SP).W NEXTX
    ;33(SP).W NEXTID

    MOVE.W  28(SP), YPOS(A0)
    MOVE.W  30(SP), XPOS(A0)

    MOVE.W  34(SP), NEXTY(A0)
    MOVE.W  36(SP), NEXTX(A0)
    MOVE.W  32(SP), NEXTID(A0)

    RTS

DOOR_INTERACT:
    ;8(SP).L SELF DIR
    MOVE.L  A0, -(SP)

    MOVE.L  8(SP), A0
    
    MOVE.W  NEXTX(A0), (SPAWNX)
    MOVE.W  NEXTY(A0), (SPAWNY)

    MOVE.W  NEXTID(A0), -(SP)
    JSR LOAD_MAP
    ADDQ.L  #2, SP

    MOVE.L  (SP)+, A0
    RTS

DOOR:
    DC.W 53                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                 ;COLISION_BOX 44
    DC.L DOOR_START, DEFAULT_RTS, DEFAULT_PAINT     ;@
    DC.L DOOR_INTERACT                              ;@
    DC.L DOOR_SPR                                   ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

NEXTX   EQU AUX_DATA ;W
NEXTY   EQU AUX_DATA+2 ;W
NEXTID  EQU AUX_DATA+4
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
