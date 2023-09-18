*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SOLID_ID DC.B 4, -1

GENERATE_COLIMAP:
    MOVEM.L D0-D2/D6-D7/A0-A2, -(SP)

    MOVE.L CURRENTMAPDIR, A0
    LEA INTERACT_MAP, A1
    MOVE.L (A0), A2

    MOVE.W 6(A0), D7
    SUBQ.W #1, D7
    _GENERATE_LOOP_Y:
        MOVE.W 4(A0), D6
        SUBQ.W #1, D6
        _GENERATE_LOOP_X:
            MOVE.B (A2)+, D0
            MOVE.B #0, D2
            LEA SOLID_ID, A3
            _SOLID_ID_LOOP:
                MOVE.B (A3)+, D1
                CMP.B #-1, D1
                BEQ _EXIT_SOLID_ID_LOOP
                CMP.B D0, D1
                BNE _SOLID_ID_LOOP
                MOVE.B #-1, D2
            _EXIT_SOLID_ID_LOOP:
            MOVE.B D2, (A1)+
        DBRA D6, _GENERATE_LOOP_X
    DBRA D7, _GENERATE_LOOP_Y

    MOVEM.L (SP)+, A2-A0/D7-D6/D2-D0
    RTS

CALCULATE_COLISSION_BBOX:
    ;X_TOP (LOCAL)      42
    ;Y_TOP (LOCAL)      40
    ;X_BOT (LOCAL)      38
    ;Y_BOT (LOCAL)      36              
    ;X_GLOBAL (ENTIDAD) 34
    ;Y_GLOBAL (ENTIDAD) 32
    ;return:  
    ; W.(LOWBYTE) 00 (UL)(UR)(DL)(DR)----

    MOVEM.L D0-D4/D7/A0, -(SP)

    MOVE.W 42(SP), D1
    MOVE.W 40(SP), D2
    MOVE.W 38(SP), D3
    MOVE.W 36(SP), D4

    ADD.W 34(SP), D1
    ADD.W 34(SP), D3

    ADD.W 32(SP), D2
    ADD.W 32(SP), D4

    LEA INTERACT_MAP, A0
    MOVE.L CURRENTMAPDIR, A1

    LSR.W #6, D1  ;DIVU.W #64, D1
    LSR.W #6, D2
    LSR.W #6, D3
    LSR.W #6, D4

    MULU.W 4(A1), D2
    MULU.W 4(A1), D4

    CLR.W D7

    MOVE.W D1, D0
    ADD.W D2, D0

    CMP.B #-1, (A0, D0)
    BNE _NO_COLI_UPL
    BSET.L #7, D7
    _NO_COLI_UPL:

    MOVE.W D3, D0
    ADD.W D2, D0

    CMP.B #-1, (A0,D0)
    BNE _NO_COLI_UPR
    BSET.L #6, D7
    _NO_COLI_UPR:

    MOVE.W D1, D0
    ADD.W D4, D0

    CMP.B #-1, (A0,D0)
    BNE _NO_COLI_DWL
    BSET.L #5, D7
    _NO_COLI_DWL:

    MOVE.W D3, D0
    ADD.W D4, D0

    CMP.B #-1, (A0,D0)
    BNE _NO_COLI_DWR
    BSET.L #4, D7
    _NO_COLI_DWR:

    MOVE.W D7, 32(SP)

    MOVEM.L (SP)+, A0/D7/D4-D0
    RTS


CALCULATE_INTERACT:
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
