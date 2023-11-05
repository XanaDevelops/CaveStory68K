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
    ADDA.L  #COLISION_BOX, A0
    MOVEM.W (A0)+, D1-D4    ;X1,Y1 X2,Y2
    ADD.W   D5, D1    ;X1
    ADD.W   D5, D3    ;X2
    ADD.W   D6, D2    ;Y1
    ADD.W   D6, D4    ;Y2
    SUBA.L  #AD_START, A0

    ENDM

COLIMAPD1D4 MACRO
    ;DIV 64
    ASR.W   #6, D1
    ASR.W   #6, D2
    ASR.W   #6, D3
    ASR.W   #6, D4
    ;MIRAR DE CAMBIAR POR ASL
    MULU.W  4(A1), D2
    MULU.W  4(A1), D4

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
    CMP.W   #0, \1
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

UPDATE_KEY MACRO
    IFNE NARG-4
        FAIL ERROR UPDATE_KEY, ARGUMENTOS INSUFICIENTES
        MEXIT
    ENDC
    BTST.L  \1, D1
    BNE     SIK\@
    BCLR.B  \2, \3
    BCLR.B  \2, \4
    BRA     END\@
    SIK\@:
    BTST.B  \2, \3
    BNE     HOLD\@
    BTST.B  \2, \4
    BNE     HOLD\@
    BSET.B  \2, \3
    BCLR.B  \2, \4
    BRA     END\@
    HOLD\@:
    BCLR.B  \2, \3
    BSET.B  \2, \4
    END\@:

    ENDM