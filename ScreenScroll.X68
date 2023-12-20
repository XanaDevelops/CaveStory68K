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

_PREVENT_SCREEN_OOB:
    ;D0 SCR_SPEED_X
    ;D1 SCR_SPEED_Y
    
    MOVEM.L D2-D4/A0, -(SP)

    ;;MOVE.W  (SCR_SPEED_Y), D1
    ;;MOVE.W  (SCR_SPEED_X), D0

    TST.W   D1
    BGE     .NO_OOB_UP
        CMP.W   #MAX_SCRLL_SPEEDY, SCREEN_Y
        BGE     .NO_OOB_UP
            MOVE.W  D1, D3
            NEG     D3
            CMP.W   SCREEN_Y, D3
            BLT     .NO_OOB_UP
                MOVE.W  SCREEN_Y, D3
                NEG     D3
                MOVE.W  D3, D1
                BCLR.B  #KEYM_UP, SCREEN_ST
    .NO_OOB_UP:

    TST.W   D1                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BLE     .NO_OOB_DOWN
        MOVE.W  SCREEN_Y, D4
        ADDI.W  #SCREEN_YTILE*(TILESIZE), D4
        MOVE.L  CURRENTMAPDIR, A0
        MOVE.W  10(A0), D3
        SUBQ.W  #1, D3
        ;ADDQ.W #1, D3

        MULU.W  #TILESIZE, D3
        SUB.W   D4, D3
        CMP.W   #MAX_SCRLL_SPEEDY, D3
        BGT     .NO_OOB_DOWN
            CMP.W   D3, D1
            BLT     .NO_OOB_DOWN
                ;SUBQ.W #1, D3
                MOVE.W  D3, D1
                BCLR.B  #KEYM_DOWN, SCREEN_ST
    .NO_OOB_DOWN:

    TST.W   D0
    BGE     .NO_OOB_LEFT
        CMP.W   #MAX_SCRLL_SPEEDX, SCREEN_X
        BGE     .NO_OOB_LEFT
            MOVE.W  D0, D2
            NEG     D2
            CMP.W   SCREEN_X, D2
            BLT     .NO_OOB_LEFT
                MOVE.W  SCREEN_X, D2
                NEG     D2
                MOVE.W  D2, D0
                BCLR.B  #KEYM_LEFT, SCREEN_ST
    .NO_OOB_LEFT:

    TST.W   D0                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BLE     .NO_OOB_RIGHT
        MOVE.W  SCREEN_X, D4
        ADDI.W  #SCREEN_XTILE*TILESIZE, D4
        MOVE.L  CURRENTMAPDIR, A0
        MOVE.W  8(A0), D2
        SUBQ.W  #1, D2
        MULU.W  #TILESIZE, D2
        SUB.W   D4, D2     
        CMP.W   #MAX_SCRLL_SPEEDX, D2
        BGT     .NO_OOB_RIGHT
            MOVE.W  D2, D0
            BCLR.B  #KEYM_RIGHT, SCREEN_ST
    .NO_OOB_RIGHT:

    ;MOVE.W  D1, (SCR_SPEED_Y)
    ;MOVE.W  D0, (SCR_SPEED_X)

    MOVEM.L (SP)+, A0/D4-D2
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
