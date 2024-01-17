*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

BALROG_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    ADDS_ZORD
    
    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)
    
    CLR.W   ET_TSPRT(A0)

    CLR.L   ET_ISPR(A0)
    CLR.B   ET_MSTATE(A0)
    ; 0:SLEEP
    ; 1:WARNING
    ; 2:DO ATK
    ; 3:REST

    CLR.W   CR_WAITATK(A0)
    CLR.B   CR_LOOKDIR(A0)

    RTS

BALROG_UPDATE:
    MOVEM.L D0-D1, -(SP)

    ;CHECK ET_HP
    TST.W   ET_HP(A0)
    BGT     .NOKILL
    ;
    MOVE.W  ET_XPOS(A0), -(SP)
    MOVE.W  ET_YPOS(A0), -(SP)
    MOVE.L  #PE_XL_DUST, -(SP)
    JSR     INSTANCE_ENTITY
    ADDQ.L  #8, SP

    KILL_ET_ENEMY #$2F, #0, #1

    MOVE.W  #7, -(SP)
    JSR     LOAD_MAP
    ADDQ.L  #2, SP

    BRA     .ENDUPDATE
    .NOKILL:

    CLR.L   D1
    
    ;CALCULAR DISTANCIA
    MOVE.L  A0, -(SP)
    SUBQ.W  #2, SP
    BSR     DIST_PLYR
    MOVE.W  (SP)+, D0
    ADDQ.L  #4, SP
    TST.W   D0      ;-1 NO DIST, 
    BMI     .STEND 
    ;OPERAR ESTADOS
    MOVE.B  CR_LOOKDIR(A0), D1

    ;MOVE.W  ET_ISPR+2(A0), (DBGWORD1)

    TST.B   ET_MSTATE(A0)
    BEQ     .ST0
    CMP.B   #2, ET_MSTATE(A0)
    BEQ     .ST2
    BLT     .ST1
.ST3:
    SUBQ.W  #1, CR_WAITATK(A0)
    BPL     .NOST1
    MOVE.B  #1, ET_MSTATE(A0)
    .NOST1:
    BTST.B  #3, ET_BSTATE(A0)
    BEQ     .AIRBONE
    MOVE.L  #1, ET_ISPR(A0) ;WARN
    CLR.W   ET_XSPEED(A0)
    BRA     .STEND
    .AIRBONE:
    MOVE.L  #2, ET_ISPR(A0) ;PREV OVERFLOW POR D1
    BRA     .STEND
.ST0:
    CMP.W   #AGRO, D0
    BLT     .DOAGRO
    CLR.L   ET_ISPR(A0) ;SLEEP
    BRA     .STEND
    .DOAGRO:
    MOVE.L  #0, ET_ISPR(A0) ;WARN
    MOVE.B  #1, ET_MSTATE(A0)
    BRA     .STEND
.ST1:
    MOVE.L  #0, ET_ISPR(A0) ;PREV BUG
    CMP.W   #ATKRANGE, D0
    BLE     .JST2
    CMP.W   #AGRO, D0
    BLT     .STEND
    ;CLR.B   ET_MSTATE(A0)
    BRA     .STEND
    .JST2:
    MOVE.B  #2, ET_MSTATE(A0)
    BRA     .STEND
.ST2:
    BTST.B  #3, ET_BSTATE(A0) ;SUELO
    BNE     .DOATK
    ;EN EL AIRE
    MOVE.B  #1, ET_MSTATE(A0)
    BRA     .STEND
    .DOATK:
    MOVE.L  #1, ET_ISPR(A0) ;ATK

    MOVE.B  #3, ET_MSTATE(A0)
    MOVE.W  #2, CR_WAITATK(A0)

    ADD.W   #CRITTER_JS+5, ET_YSPEED(A0)
    MOVE.W  #MAX_PLYR_SPEED-4, ET_XSPEED(A0) ;PLACEHOLDER!!!
    ;MIRAR DIRECCION
    MOVEQ.L #3, D1 ;Nº SPRITES POR DIR
    MOVE.W  ET_XPOS(A0), D0
    MOVE.L  (PLAYERREF), A1
    
    SUB.W   ET_XPOS(A1), D0
    BMI     .NONEG3
    NEG.W   ET_XSPEED(A0)
    CLR.L   D1
    .NONEG3:
.STEND:

    ADD.L   D1, ET_ISPR(A0)

    ;MOVE.W  ET_ISPR+2(A0), (DBGWORD2)

    MOVE.B  D1, CR_LOOKDIR(A0)
    ;ACTUALIZAR FISICAS Y COLISION
    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS

    SUBQ.L  #4, -(SP)
    BSR     COLLISION_ENT_PLR
    MOVE.L  (SP)+, A1
    
    CMP.L   #-1, A1
    BEQ     .NOCOLIE
    
    MOVE.W  #5, -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  ET_REVDAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP
    .NOCOLIE:
    ADDQ.L  #4, SP

    .ENDUPDATE:
    MOVEM.L (SP)+, D1-D0
    RTS

BALROG_DAMAGE:
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

BALROG:
    DC.W -3                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 8                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 4,16, 60,64                                 ;ET_HBOX 44
    DC.L BALROG_START, BALROG_UPDATE, DEFAULT_PAINT ;@
    DC.L BALROG_DAMAGE                             ;@
    DC.L BALROG_L                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W 0                                          ;ET_ZORD
                                      

CR_WAITATK  EQU ET_DATA   ;W
CR_LOOKDIR  EQU ET_DATA+2 ;B

CRWAITATK   EQU 50 ;SPLIT CONST? WAIT X FRAMES
CRTATK      EQU 4
AGRO        EQU 425
ATKRANGE    EQU 275














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
