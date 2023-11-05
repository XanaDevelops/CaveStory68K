*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

DRAW_MAP:
    ; (SP) @map -> A0
    ; lee word coords y tile loop
    ; dividir por tilesize
        ;parte entera, desplazamiento @mapdata -> A1
        ;-residuo, "offset"
    MOVEM.L D0-D6/A0-A2, -(SP)

    MOVE.L  44(SP), A0
    MOVE.L  (A0), A1

    CLR.L   D0
    CLR.L   D1
    CLR.L   D2

    MOVE.W  SCREEN_X, D1
    MOVE.W  SCREEN_Y, D2

    DIVU.W  #TILESIZE, D1
    DIVU.W  #TILESIZE, D2
    SWAP    D1
    SWAP    D2
    MOVE.W  D1, D3
    MOVE.W  D2, D4
    NEG.W   D3        ;OFFSET X
    NEG.W   D4        ;OFFSET Y
    SWAP    D1         ;DESP X
    SWAP    D2         ;DESP Y

    MULU.W  4(A0), D2

    ADD.W   D2, D1


    SUBQ.L  #8, SP
    MOVE.L  #0, (SP)
    
    MOVE.W  D4, 2(SP)

    MOVE.W  #SCREEN_YTILE, D6
    .LOOPDMY:
        MOVE.W  D3, 0(SP)
        MOVE.W  #SCREEN_XTILE, D5
        .LOOPDMX:
            MOVE.B  0(A1, D1), D0
            LEA     SPRITES, A2
            MOVE.L  (A2, D0), 4(SP)
            BSR     FASTSPRITE
            
            
            ADD.W   #TILESIZE, 0(SP)
            ADDQ.W  #1, D1
            DBRA    D5, .LOOPDMX
        ADD.W   #TILESIZE, 2(SP)
        ADD.W   4(A0), D1
        SUB.W   #SCREEN_XTILE+1, D1
        DBRA    D6, .LOOPDMY
    
    ADDQ.L  #8, SP

    MOVEM.L (SP)+, A2-A0/D6-D0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
