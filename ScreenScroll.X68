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
    MOVEM.L D2-D4/A0, -(SP)

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

    MOVEM.L (SP)+, A0/D4-D2
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
