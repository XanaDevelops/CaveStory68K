*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
ISRSCREEN:
    ADDQ.B  #1, (FTOSKIP)
    RTE

PREVENT_SCREEN_OOB:
    ;PREVIENE QUE LA PANTALLA SALGA DE LOS LIMITES DEL MAPA
    ;SINO PETA...
    ;LLAMAR CON LA VEL YA SUMADA
    MOVEM.L D1-D4/A0, -(SP)

    MOVE.W  (SCREEN_X), D1
    MOVE.W  (SCREEN_Y), D2

    CLR.B   D3 ;#7 CLR SPDX, #6 CLR SPDY, ESTA SCREEN_ST

    TST.W   D1
    BPL     .NONEGX
    CLR.W   D1
    BSET.L  #7, D3
    .NONEGX:

    TST.W   D2
    BPL     .NONEGY
    CLR.W   D2
    BSET.L  #6, D3
    .NONEGY:

    MOVE.L  (CURRENTMAPDIR), A0

    MOVE.W  10(A0), D4
    SUBQ.W  #1, D4
    MULU.W  #TILESIZE, D4
    SUB.W  #SCREEN_HEIGHT+1, D4
    CMP.W   D2, D4
    BGT     .INBY
    MOVE.W  D4, D2
    BSET.L  #6, D3 
    .INBY:

    MOVE.W  8(A0), D4
    SUBQ.W  #1, D4
    MULU.W  #TILESIZE, D4
    SUB.W   #SCREEN_WIDTH+1, D4
    CMP.W   D1, D4
    BGT     .INBX
    MOVE.W  D4, D1
    BSET.L  #7, D3 
    .INBX:

    BTST.L  #7, D3
    BEQ     .NOX
    CLR.W   (SCR_SPEED_X)
    .NOX:
    BTST.L  #6, D3
    BEQ     .NOY
    CLR.W   (SCR_SPEED_Y)
    .NOY:

    MOVE.W  D1, (SCREEN_X)
    MOVE.W  D2, (SCREEN_Y)

    MOVEM.L (SP)+, D1-D4/A0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
