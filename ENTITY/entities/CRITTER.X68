*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CRITTER_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)
    
    CLR.W   ET_TSPRT(A0)

    CLR.L   ET_ISPR(A0)
    ; 0:SLEEP
    ; 1:WARNING
    ; 2:DO ATK
    ; 3:REST

    RTS

CRITTER_UPDATE:

    ;CHECK ET_HP
    TST.W   ET_HP(A0)
    BGT     .NOKILL
    KILL_ET_ENEMY #$2F, #0, #1
        BRA     .ENDUPDATE
    .NOKILL:


    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS

    SUBQ.L  #4, -(SP)
    BSR     COLLISION_ENT_PLR
    MOVE.L  (SP)+, A1
    
    CMP.L   #-1, A1
    BEQ     .NOCOLIE
    
    MOVE.W  #CRTATK, -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  ET_REVDAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP
    .NOCOLIE:
    ADDQ.L  #4, SP

    ;CALCULAR DISTANCIA
    MOVE.L  A0, -(SP)
    SUBQ.W  #2, SP
    BSR     DIST_PLYR
    MOVE.W  (SP)+, D0
    ADDQ.L  #4, SP
    TST.W   D0      ;-1 NO DIST, 
    BMI     .NOATK 
    ;OPERAR ESTADOS
    CMP.W   #AGRO, D0
    BLT     .DOAGRO
    CLR.L   ET_ISPR(A0) ;SLEEP
    BRA     .NOATK
    .DOAGRO:
    MOVE.L  #1, ET_ISPR(A0) ;WARN
    CMP.W   #ATKRANGE, D0
    BGT     .NOATK
    MOVE.L  #2, ET_ISPR(A0) ;ATK
    BTST.B  #3, ET_BSTATE(A0)
    BEQ     .ENDDIST
    ADD.W   #CRITTER_JS, ET_YSPEED(A0)
    MOVE.W  #MAX_PLYR_SPEED-4, ET_XSPEED(A0) ;PLACEHOLDER!!!
    ;MIRAR DIRECCION
    MOVE.W  ET_XPOS(A0), D0
    MOVE.L  (PLAYERREF), A1
    SUB.W   ET_XPOS(A1), D0
    BMI     .NONEG3
    NEG.W   ET_XSPEED(A0)
    .NONEG3:
    BRA     .ENDDIST
    .NOATK:
    CLR.W   ET_XSPEED(A0)
    .ENDDIST:
    .ENDUPDATE:
    RTS

CRITTER_DAMAGE:
    ; 12(SP).L @ENT
    ; 16(SP).W DAMAGE
    MOVEM.L D0/A0, -(SP)
    MOVE.L  12(SP), A0

    MOVE.W  16(SP), D0
    SUB.W   D0, ET_HP(A0)

    MOVE.W  #36, -(SP)
    MOVE.W  #1, -(SP)
    BSR     PLAY_SFX
    ADDQ.L  #4, SP

    MOVEM.L (SP)+, A0/D0
    RTS

CRITTER:
    DC.W -3                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 10                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,14, 64,64                                 ;ET_HBOX 44
    DC.L CRITTER_START, CRITTER_UPDATE, DEFAULT_PAINT ;@
    DC.L CRITTER_DAMAGE                             ;@
    DC.L CRITTER_L                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
                                      


CRTATK      EQU 4
AGRO        EQU 375
ATKRANGE    EQU 250











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
