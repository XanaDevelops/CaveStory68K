*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START_TCP_CLIENT:
    ; 24(SP) -1 SI ERROR
    MOVEM.L D0-D1/D7/A1-A2, -(SP)

    MOVE.B  #14, D0
    LEA     TXTINIT, A1
    TRAP    #15

    REPAINT

    MOVE.W  #RETRIES-1, D7
    .RETRYC:
    MOVE.B  #100, D0
    MOVE.L  #(TCPPORT<<16+1), D1
    LEA     DEFIP, A2
    TRAP    #15
    
    TST.L   D0
    BEQ     .NOERR

    MOVE.B  #14, D0
    LEA     TXTDOT, A1
    TRAP    #15

    MOVE.B  #23, D0  ;WAIT
    MOVE.L  #10, D1
    TRAP    #15

    REPAINT

    DBRA    D7, .RETRYC

    .FAILC:
        MOVE.B  #13, D0
        LEA     TXTFAIL, A1
        TRAP    #15
        MOVE.W  #-1, 24(SP)
    BRA .ENDTCPC
    
    .NOERR:
    
    REPAINT

    MOVE.W  #HANDCODE, -(SP)
    BSR     SEND_DATA
    MOVE.W  (SP)+, D0

    TST.W   D0
    BNE     .FAILC

    SUBQ.L  #2, SP
    BSR     READ_DATA
    MOVE.W  (SP)+, D0

    CMP.W   #HANDCODE2, D0
    BNE     .FAILC

    MOVE.B  #13, D0
    LEA     TXTOK, A1
    TRAP    #15

    .ENDTCPC:
    
    REPAINT

    MOVE.B  #23, D0  ;WAIT
    MOVE.L  #150, D1
    TRAP    #15

    
    MOVEM.L (SP)+, A2-A1/D7/D1-D0
    RTS

START_TCP_SERVER:
    MOVEM.L D0-D1/A1-A2, -(SP)

    MOVE.B  #14, D0
    LEA     TXTINIT, A1
    TRAP    #15

    MOVE.B  #101, D0
    MOVE.L  #(TCPPORT<<16+1), D1
    LEA     DEFIP, A2
    TRAP    #15

    TST.W   D0
    BEQ     .NOERRS
    .ERR:
    MOVE.B  #13, D0
    LEA     TXTFAIL, A1
    TRAP    #15
    ;ERROR
    
    .NOERRS:

    SUBQ.L  #2, SP
    BSR     READ_DATA
    MOVE.W  (SP)+, D0
    CMP.W   #HANDCODE, D0
    BNE     .ERR

    MOVE.W  #HANDCODE2, -(SP)
    BSR     SEND_DATA
    MOVE.W  (SP)+, D0

    TST.W   D0
    BNE     .ERR

    MOVEM.L (SP)+, A2-A1/D1-D0
    RTS

READ_DATA:
    MOVEM.L D0-D1/A1-A2, -(SP)

    LEA     TCPBUFFER, A1
    LEA     IPBUFFER, A2
    .NODATA:
    MOVE.B  #23, D0
    MOVE.L  #1, D1
    TRAP    #15

    MOVE.B  #107, D0
    MOVE.L  #(TCPPORT<<16+4), D1
    TRAP    #15
    TST.W   D0
    BEQ     .NOERRRD
        ILLEGAL 
    .NOERRRD:
    TST.W   D1
    BEQ     .NODATA
    MOVE.W  (A1), 20(SP)

    MOVEM.L (SP)+, A2-A1/D2-D1
    RTS

SEND_DATA:
    MOVEM.L D0-D1/A1-A2, -(SP)

    MOVE.B  #106, D0
    MOVE.L  #(TCPPORT<<16+4), D1
    LEA     TCPBUFFER, A1
    MOVE.W  20(SP), (A1)
    TRAP    #15

    MOVE.W  D0, 20(SP)

    MOVEM.L (SP)+, A2-A1/D1-D0
    RTS

RETRIES     EQU 2
TCPPORT     EQU 6666
HANDCODE    EQU $1234
HANDCODE2   EQU $5678

TCPBUFFER   DS.W 1
DEFIP       DC.B 'localhost',0
IPBUFFER    DS.B 20


TXTINIT     DC.B 'ESTABLECIENDO CONEXION',0
TXTDOT      DC.B '.',0
TXTOK       DC.B LF,CR,'OK! DISFRUTA DE MUSICA DE FONDO!!',0
TXTFAIL     DC.B LF,CR,'CONEXION FALLIDA',0
TXTSALUDO   DC.B 'SALUDO RECIBIDO',0
TXTCMD      DC.B LF,CR,'DATO RECIBIDO:',LF,CR,0
            DS.W 0








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
