*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

RECORD_START:
    ;INICIA EL GRABADO DE TECLADO EN OUTPUT.CDAT
    MOVE.L  #OUTCINE, -(SP)
    BSR     OPEN_WRITE
    TST.L   (SP)
    BPL     .NOERR
    ;ERROR
    BRA     .END
    .NOERR:
    MOVE.L  (SP), (CFILE)
    MOVE.L  #RNGSEED, (IOFILEW)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #4, -(SP)
    BSR     WRITE_FILE
    ADD.L   #10, SP
    BSET.B  #7, (CINEMASTS)
    CLR.L   (KEY_PRESS_PLAYER) ;ELIMINAR INPUTS ACTUALES
    .END:
    RTS

RECORD_UPDATE:
    BTST.B  #7, (CINEMASTS)
    BEQ     .END
    MOVE.W  (KEY_HOLD_PLAYER), (IOFILEW) ;APROVECHA CONTINUIDAD
    MOVE.L  (CFILE), -(SP)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #2, -(SP)
    BSR     WRITE_FILE
    ADD.L   #10, SP
    .END:
    RTS

RECORD_END:
    MOVE.W  #-1, (IOFILEW)
    MOVE.L  (CFILE), -(SP)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #2, -(SP)
    BSR     WRITE_FILE
    ADDQ.L  #6, SP
    BSR     CLOSEFILE
    ADDQ.L  #4, SP
    BCLR.B  #7, (CINEMASTS)
    MOVE.L  #-1, (CFILE)
    RTS

PLAYBACK_START:
    ;PONER PROPER ID
    ; 4(SP).W ID
    BTST.B  #6, (CINEMASTS)
    BNE     .END

    CLR.L   D0
    MOVE.W  4(SP), D0
    LSR.W   #2, D0
    LEA     CINEMATICS, A0
    MOVE.L  (A0, D0), -(SP)
    BSR     OPEN_READ
    TST.L   (SP)
    BPL     .NOERR
    ;ERR
    BRA     .END
    .NOERR:
    MOVE.L  (SP), (CFILE)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #4, -(SP)
    BSR     READ_FILE
    TST.W   (SP)
    BMI     .END ;ERR
    MOVE.L  (IOFILEW), (RNGVAL)
    ADD.L   #10, SP
    BSET.B  #6, (CINEMASTS)
    CLR.L   (KEY_PRESS_PLAYER) ;ELIMINAR INPUTS ACTUALES
    .END:
    RTS

PLAYBACK_UPDATE:
    BTST.B  #6, (CINEMASTS)
    BEQ     .END
    MOVE.L  (CFILE), -(SP)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #2, -(SP)
    BSR     READ_FILE
    MOVE.W  (SP)+, D0
    ADDQ.L  #8, SP
    TST.W   D0
    BMI     PLAYBACK_END
    TST.W   (IOFILEW)
    CMP.W   #-1, (IOFILEW) ;ESPECIFICAMENTE .1
    BEQ     PLAYBACK_END
    MOVE.W  (IOFILEW), (KEY_OVER_PLAYER)
    .END:
    RTS

PLAYBACK_END:
    BCLR.B  #6, (CINEMASTS)
    MOVE.L  (CFILE), -(SP)
    BSR     CLOSEFILE
    ADDQ.L  #4, SP

    RTS
    
CMID        DC.W 0  ;ID CINEMATICA ACTUAL
CFILE       DC.L -1 ;DESCRIPTOR ARCHIVO

CINEMATICS  DC.L  OUTCINE, .CATTRACK
.CATTRACK   DC.B 'DATA/CINEMATICS/ATTRACT.CDAT',0

OUTCINE     DC.B 'DATA/CINEMATICS/OUTPUT.CDAT',0

CINEMASTS   DC.B 0
;7 RECORD ON
;6 PLAYBACK ON
            DC.W 0

RNGSEED     EQU $77ABCDEF



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
