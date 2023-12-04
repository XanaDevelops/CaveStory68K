*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CRITTER_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS

    MOVE.W  28(SP), YPOS(A0)
    MOVE.W  30(SP), XPOS(A0)
    
    CLR.W   TIMERSPRITE(A0)

    CLR.L   SPRITE_INDEX(A0)
    ; 0:SLEEP
    ; 1:WARNING
    ; 2:DO ATK

    RTS

CRITTER_UPDATE:
    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS

    SUBQ.L  #4, -(SP)
    BSR     COLLISION_ENT_PLR
    MOVE.L  (SP)+, A1
    
    CMP.L   #-1, A1
    BEQ     .NOCOLIE
    
    MOVE.W  #CRTATK, -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  AD_DODAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP
    .NOCOLIE:
    ADDQ.L  #4, SP

    RTS

CRITTER_DAMAGE:
    ; 12(SP).L @ENT
    ; 16(SP).W DAMAGE
    MOVEM.L D0/A0, -(SP)
    MOVE.L  12(SP), A0

    MOVE.W  16(SP), D0
    SUB.W   D0, HP(A0)

    MOVE.W  #36, -(SP)
    MOVE.W  #1, -(SP)
    BSR     PLAY_SFX
    ADDQ.L  #4, SP

    MOVEM.L (SP)+, A0/D0
    RTS

CRITTER:
    DC.W -3                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 10                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 64,48                                 ;COLISION_BOX 44
    DC.L CRITTER_START, CRITTER_UPDATE, DEFAULT_PAINT ;@
    DC.L CRITTER_DAMAGE                             ;@
    DC.L CRITTER_L                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

CRTATK  EQU 4

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
