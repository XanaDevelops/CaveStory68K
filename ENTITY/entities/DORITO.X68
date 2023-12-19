*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DORITO_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS
    ;32(SP) TYPE

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    MOVE.W  #DRTANMSPD, ET_TSPRT(A0)
    
    ;CMP.W #0, 32(SP)
    ;BEQ .TPEQ
    ;MOVE.W #BGDORITO, ET_HP(A0)
    ;BRA .ENDHSTART
    .TPEQ:
    ;MOVE.W #SMDORITO, ET_HP(A0)
    ;DEF DORITO_SM
    MOVE.W  #MDORITO, ET_HP(A0)
    .ENDHSTART:
	
	;CALCULAR UNA ET_XSPEED ALEATORIA
	TRAP #14
	MOVE.L  (RNGVAL), D0
    ANDI.L  #$86, D0
    BCLR.L  #7, D0
    BEQ     .DONEG
    NEG.W   D0
    .DONEG:

    MOVE.W  D0, ET_XSPEED(A0)
	
    RTS

DORITO_UPDATE:
    ;MIRAR SI INTERACTUA JUGADOR
    MOVE.L  A0, -(SP)
    SUBQ.L  #4, SP
    BSR     COLLISION_ENT_PLR

    ;SI COLISIONA
    MOVE.L  (SP)+, A1
    ADDQ.L  #4, SP
    CMP.L   #-1, A1
    BEQ .NODW

    ;DAR XP ARMA AL JUGADOR
    MOVE.W  ET_HP(A0), -(SP)
    MOVE.L  A1, -(SP)
    BSR     DORITO_INTERACT
    ADDQ.L  #6, SP

    ;Y ELIMINARSE
    MOVE.L  A0, -(SP)
    JSR     DESTROY_ENTITY
    ADDQ.L  #4, SP
    BRA     .ENDUPDATE
    .NODW: 

    ;BCLR.B  #3, ET_BSTATE(A0) ;ESTO LO HACE UPDATE_PHYSICS?? -> SI

    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS
    ADDQ.L  #4, SP

    ;COMPROBAR SUELO
    CLR.L   D0
    BTST.B  #3, ET_BSTATE(A0)
    BEQ .NOHIT
        MOVE.W  #DRJMPSPD, ET_YSPEED(A0)
        ASR.W   ET_XSPEED(A0) ;BUGGY
    .NOHIT:

    MOVE.L  ET_ISPR(A0), D1                   ;ANIM_INDEX
        MOVE.W  ET_TSPRT(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W  #1, D2
        BNE     .NOTIMER
            MOVE.W  #DRTANMSPD, D2
            ADDQ.L  #1, D1
            MOVE.L  ET_SPRITE(A0), A1
            CMP.L   (A1), D1
            BLT     .NOOF
            MOVE.L  #0, D1
            .NOOF:
            MOVE.L  D1, ET_ISPR(A0)
        .NOTIMER:
        MOVE.W  D2, ET_TSPRT(A0)
    .ENDUPDATE:    
    RTS

DORITO_INTERACT:
    MOVEM.L D0/A0, -(SP)

    MOVE.W  ET_HP(A0), -(SP)
    JSR     GM_UPD_BLTXP
    ADDQ.L  #2, SP
    ;MOVE.L 12(SP), A0
    ;MOVE.W 16(SP), D0
    
    ;ADD.W ET_HP(A0), D0
    ;CMP.W MAXHEALTH(A0), D0
    ;BLE .NOOV
    ;MOVE.W MAXHEALTH(A0), D0
    ;.NOOV:
    ;MOVE.W D0, ET_HP(A0)

    MOVEM.L (SP)+, A0/D0
    RTS

DORITO:
    DC.W 71                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 12,16, 54,64                               ;ET_HBOX 44
    DC.L DORITO_START, DORITO_UPDATE, DEFAULT_PAINT ;@
    DC.L DORITO_INTERACT                            ;@
    DC.L DORITO_M                                   ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W -100                                          ;ET_ZORD                                     
            

INTERACT_ID     EQU ET_DATA    ;


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
