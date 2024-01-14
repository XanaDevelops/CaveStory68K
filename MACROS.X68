REPAINT MACRO
    MOVE.B  #94, D0
    TRAP    #15

    ENDM

CLRSCREEN MACRO
    MOVE.B  #11, D0
    MOVE.W  #$FF00, D1
    TRAP    #15

    MOVE.B  #81, D0
    MOVE.L  (SCRBGCOLOR), D1
    TRAP    #15
    MOVE.B  #89, D0
    CLR.W   D1
    CLR.W   D2
    TRAP    #15

    ENDM

UPDPHGETHB  MACRO
    ;OBTENER HBOX
    ADDA.L  #ET_HBOX, A0
    MOVEM.W (A0)+, D1-D4    ;X1,Y1 X2,Y2
    ADD.W   D5, D1    ;X1
    ADD.W   D5, D3    ;X2
    ADD.W   D6, D2    ;Y1
    ADD.W   D6, D4    ;Y2
    SUBA.L  #ET_START, A0

    ENDM

COLIMAPD1D4 MACRO
    ;DIV 64
    ASR.W   #6, D1
    ASR.W   #6, D2
    ASR.W   #6, D3
    ASR.W   #6, D4
    ;MIRAR DE CAMBIAR POR ASL
    MULU.W  8(A1), D2
    MULU.W  8(A1), D4

    ENDM

DBG_HBOXP   MACRO
    MOVE.B  #90, D0
    SUB.W   SCREEN_X, D1
    SUB.W   SCREEN_X, D3
    SUB.W   SCREEN_Y, D2
    SUB.W   SCREEN_Y, D4
    TRAP    #15
    ADD.W   SCREEN_X, D1
    ADD.W   SCREEN_X, D3
    ADD.W   SCREEN_Y, D2
    ADD.W   SCREEN_Y, D4
    
    ENDM

REDUCE_SCRLL_SPEED MACRO
    IFNE NARG-1
        FAIL ERROR REDUCE_SCRLL_SPEED, NO DATAREG
        MEXIT
    ENDC
    TST.W   \1
    BGT     MSPEED\@
    BLT     PSPEED\@
    BRA     ENDSPEED\@
MSPEED\@:
    SUBQ.W  #1, \1
    BRA     ENDSPEED\@
PSPEED\@:
    ADDQ.W  #1, \1
ENDSPEED\@:

    ENDM

LIMIT_SCRLL_SPEED MACRO
    IFNE NARG-2
        FAIL ERROR LIMIT_SCRLL_SPEED, ARGUMENTOS INSUFICIENTES
    ENDC
    CMP.W   #\2, \1
    BLE     NOMAXSPEED\@
    MOVE.W  #\2, \1
    NOMAXSPEED\@:
    CMP.W   #-\2, \1
    BGE     NOMMAXSPEED\@
    MOVE.W  #-\2, \1
    NOMMAXSPEED\@:

    ENDM

KILL_ET_ENEMY MACRO
    ; MATA, y dropea, ENEMIGO
    ; 1.B RNG SEPARATOR
    ; 2,W HEART TYPE (0)
    ; 3.W DORITO TYPE (1)
    IFNE NARG-3
        FAIL ERROR KILL_ET_ENEMY, ARGUMENTOS INSUFICIENTES
        MEXIT
    ENDC
    ;DROP
    SUBQ.L  #2, SP ;RESERVA TIPO
    MOVE.W  ET_XPOS(A0), -(SP)
    MOVE.W  ET_YPOS(A0), -(SP)

    TRAP    #14
    MOVE.L  (RNGVAL), D1
    ANDI.L  #$FF, D1
    CMP.B   \1, D1
    BHI     .NOHEART\@
    MOVE.W  \2, 4(SP) ;TEST
    MOVE.L  #HEART, -(SP)
    BRA     .ENDDROP\@
    .NOHEART\@:
    MOVE.W  \3, 4(SP) ;TEST
    MOVE.L  #DORITO, -(SP)
    .ENDDROP\@:
    JSR     INSTANCE_ENTITY
    ADDA.L  #10, SP
    
    MOVE.L  A0, -(SP)
    JSR     DESTROY_ENTITY
    ADDQ.L  #4, SP

    ENDM

ADDS_ZORD   MACRO
    ;AÑADE ENTIDAD A ZORDER
    MOVE.L  A0, -(SP)
    JSR     ZORD_ADD
    ADDQ.L  #4, SP

    ENDM
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
