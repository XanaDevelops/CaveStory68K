*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DOOR_START:
    ;28(SP).W ET_YPOS 
    ;30(SP).W ET_XPOS
    ;34(SP).W NEXTY
    ;36(SP).W NEXTX
    ;33(SP).W NEXTID

    ;38(SP).W HIDDEN MODE

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  34(SP), NEXTY(A0)
    MOVE.W  36(SP), NEXTX(A0)
    MOVE.W  32(SP), NEXTID(A0)

    CMP.W   #1, 38(SP)
    BNE     .NOHID
    MOVE.L  #DEFAULT_PAINT, ET_DRAW(A0)
    ADDS_ZORD
    .NOHID:
    CMP.W   #2, 38(SP)
    BNE     .NOLOCK
    MOVE.L  #DEFAULT_RTS, ET_REVDAM(A0)
    .NOLOCK:
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
    DC.W 53                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,64                                 ;ET_HBOX 44
    DC.L DOOR_START, DEFAULT_RTS, DEFAULT_RTS     ;@
    DC.L DOOR_INTERACT                              ;@
    DC.L DOOR_SPR                                   ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W 200                                        ;ET_ZORD                               
       

NEXTX   EQU ET_DATA ;W
NEXTY   EQU ET_DATA+2 ;W
NEXTID  EQU ET_DATA+4
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
