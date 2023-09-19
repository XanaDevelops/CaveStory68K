*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SCROLL:
;   MUEVE LA PANTALLA
;   20(SP).W SCROLL DIR
;       0:UP
;       1:DOWN
;       2:LEFT
;       3:RIGHT
    MOVEM.L D0-D3, -(SP)
    MOVE.B #25, D0
    MOVE.L #SCREEN_RSCROLL*$10000+SCREEN_CSCROLL, D1
    MOVE.L #SCREEN_HSCROLL*$10000+SCREEN_WSCROLL, D2
    MOVE.W 20(SP), D3
    TRAP #15

    MOVEM.L (SP)+, D3-D0
    RTS

PREVENT_SCREEN_OOB:
    MOVEM.L D2-D4/A0, -(SP)

    CMP.W #0, D1
    BGE _NO_OOB_UP
        CMP.W #MAX_SCRLL_SPEED, SCREEN_Y
        BGE _NO_OOB_UP
            MOVE.W D1, D3
            NEG D3
            CMP.W SCREEN_Y, D3
            BLT _NO_OOB_UP
                MOVE.W SCREEN_Y, D3
                NEG D3
                MOVE.W D3, D1
                BCLR.B #KEYM_UP, SCREEN_ST
    _NO_OOB_UP:

    CMP.W #0, D1                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BLE _NO_OOB_DOWN
        MOVE.W SCREEN_Y, D4
        ADDI.W #SCREEN_YTILE*(TILESIZE), D4
        MOVE.L CURRENTMAPDIR, A0
        MOVE.W 6(A0), D3
        SUBQ.W #1, D3
        ;ADDQ.W #1, D3

        MULU.W #TILESIZE, D3
        SUB.W D4, D3
        CMP.W #MAX_SCRLL_SPEED, D3
        BGT _NO_OOB_DOWN
            CMP.W D3, D1
            BLT _NO_OOB_DOWN
                ;SUBQ.W #1, D3
                MOVE.W D3, D1
                BCLR.B #KEYM_DOWN, SCREEN_ST
    _NO_OOB_DOWN:

    CMP.W #0, D0
    BGE _NO_OOB_LEFT
        CMP.W #MAX_SCRLL_SPEED, SCREEN_X
        BGE _NO_OOB_LEFT
            MOVE.W D0, D2
            NEG D2
            CMP.W SCREEN_X, D2
            BLT _NO_OOB_LEFT
                MOVE.W SCREEN_X, D2
                NEG D2
                MOVE.W D2, D0
                BCLR.B #KEYM_LEFT, SCREEN_ST
    _NO_OOB_LEFT:

    CMP.W #0, D0                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BLE _NO_OOB_RIGHT
        MOVE.W SCREEN_X, D4
        ADDI.W #SCREEN_XTILE*TILESIZE, D4
        MOVE.L CURRENTMAPDIR, A0
        MOVE.W 4(A0), D2
        SUBQ.W #1, D2
        MULU.W #TILESIZE, D2
        SUB.W D4, D2
        CMP.W #MAX_SCRLL_SPEED, D2
        BGT _NO_OOB_RIGHT
            MOVE.W D2, D0
            BCLR.B #KEYM_RIGHT, SCREEN_ST
    _NO_OOB_RIGHT:

    MOVEM.L (SP)+, A0/D4-D2
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
