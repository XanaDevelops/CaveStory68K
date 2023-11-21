*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SOLID_ID    DC.W 2, 33, 34, 42, 49, 50, -1
SLOPE_ID    DC.W 3,4,5,6, 19,20,21,22, -1

GENERATE_COLIMAP:
    MOVEM.L D0-D2/D6-D7/A0-A2, -(SP)

    MOVE.L  CURRENTMAPDIR, A0
    LEA     INTERACT_MAP, A1
    MOVE.L  (A0), A2

    MOVE.W  6(A0), D7
    SUBQ.W  #1, D7
    .GENERATE_LOOP_Y:
        MOVE.W  4(A0), D6
        SUBQ.W  #1, D6
        .GENERATE_LOOP_X:
            MOVE.W  (A2)+, D0
            MOVE.B  #0, D2
            ;COMPROBAR BLOQUES SOLIDOS, EN COLIMAP -1
            LEA SOLID_ID, A3
            .SOLID_ID_LOOP:
                MOVE.W  (A3)+, D1
                CMP.W   #-1, D1
                BEQ     .EXIT_SOLID_ID
                CMP.W   D0, D1
                BNE     .SOLID_ID_LOOP
                MOVE.B  #-1, D2
            .EXIT_SOLID_ID:
            MOVE.B  D2, (A1)+
        DBRA    D6, .GENERATE_LOOP_X
    DBRA    D7, .GENERATE_LOOP_Y

    MOVEM.L (SP)+, A2-A0/D7-D6/D2-D0
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
