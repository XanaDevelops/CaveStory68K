*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SOLID_ID    DC.W 2, 33, 34, 42, 49, 50, -1
SLOPE_ID    DC.W 3,-2,4,-2,  5,-2,6,-2,  19,7,-2,20,8,-2,  21,9,-2,22,10,-2, -1
;-2 SEPARA TIPO RAMPA, -1 FIN

GENERATE_COLIMAP:
    MOVEM.L D0-D4/D6-D7/A0-A2, -(SP)

    CLR.L D4
    .RELOAD:

    MOVE.L  (CURRENTMAPDIR), A0
    LEA     INTERACT_MAP, A1
    TST.W   D4
    BNE     .OTRACAPA
    MOVE.L  4(A0), A2
    BRA     .START
    .OTRACAPA:
    MOVE.L  0(A0), A2
    .START:
    MOVE.W  10(A0), D7
    SUBQ.W  #1, D7
    .GENERATE_LOOP_Y:
        MOVE.W  8(A0), D6
        SUBQ.W  #1, D6
        .GENERATE_LOOP_X:
            MOVE.W  (A2)+, D0
            TST.W   D4
            BEQ     .PCAPA
            MOVE.B  (A1), D2
            BRA     .CHECK
            .PCAPA:
            MOVE.B  #0, D2
            .CHECK:
            ;COMPROBAR BLOQUES SOLIDOS, EN COLIMAP -1
            LEA     SOLID_ID, A3
            .SOLID_ID_LOOP:
                MOVE.W  (A3)+, D1
                CMP.W   #-1, D1
                BEQ     .EXIT_SOLID_ID
                CMP.W   D0, D1
                BNE     .SOLID_ID_LOOP
                MOVE.B  #-1, D2
                BRA     .END_CHECK
            .EXIT_SOLID_ID:
            LEA     SLOPE_ID, A3
            MOVE.B  #-1, D3
            .SLADV:
            SUBQ.B  #1, D3 
            .SLOPE_ID_LOOP:
                MOVE.W  (A3)+, D1
                CMP.W   #-1, D1
                BEQ     .END_CHECK
                CMP.W   #-2, D1     ;RESTAR
                BEQ     .SLADV      ;BLT?
                CMP.W   D0, D1
                BNE     .SLOPE_ID_LOOP
                MOVE.B  D3, D2 ;CADA RAMPA SU ET_ID
                BRA     .END_CHECK
            .END_CHECK:
            MOVE.B  D2, (A1)+
        DBRA    D6, .GENERATE_LOOP_X
    DBRA    D7, .GENERATE_LOOP_Y

    TST.W   D4
    BNE     .END
    ADDQ.W  #1, D4
    BRA     .RELOAD

    .END:
    MOVEM.L (SP)+, A2-A0/D7-D6/D4-D0
    RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
