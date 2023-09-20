*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
VECTOR DC.W 50,50, -1,-1
TEST    DC.W 20
START:                  ; first instruction of program
    MOVE.B #80, D0
    MOVE.L #$000000FF, D1
    TRAP #15
    
    LEA VECTOR, A0
    LOOP:
    MOVE.W #20, -(SP)
    MOVE.W #20, -(SP)
    MOVEM.W (A0)+, D0-D1
    CMP.W #-1, D0
    BEQ .EXIT
    MOVE.W D0, -(SP)
    MOVE.W D1, -(SP)

    BSR BRESENHAM
    ADDA.L #8, SP
    BRA LOOP
    .EXIT:
    SIMHALT             ; halt simulator

BRESENHAM:
    ;10 X0
    ;8  Y0
    ;6  X1
    ;4  Y1
    ;D0 DX
    ;D1 DY
    ;D2 SX
    ;D3 SY
    ;D4 E1
    ;D5 E2
    MOVE.W 10(SP), D0
    SUB.W 6(SP), D0
    BPL _NO_ABS_D0
        NEG D0
    _NO_ABS_D0:
    MOVE.W 8(SP), D1
    SUB.W 4(SP), D1
    BMI _NO_ABS_D1  ;-ABS
        NEG D1
    _NO_ABS_D1:
    MOVE.W #-1, D2
    MOVE.W 6(SP), D6
    CMP.W 10(SP), D6
    BLE _NO_SX
        MOVE.W #1, D2
    _NO_SX:
    MOVE.W #-1, D3
    MOVE.W 4(SP), D6
    CMP.W 8(SP), D6
    BLE _NO_SY
        MOVE.W #1, D3
    _NO_SY:

    MOVE.W D0, D4
    ADD.W D1, D4

    _BRESENLOOP:
        MOVE.W 10(SP), D6
        MOVE.W 8(SP), D7
        MOVE.W D6, -(SP)
        MOVE.W D7, -(SP)
        BSR PAINT
        ADDA.L #4, SP
        
        CMP.W 6(SP), D6
        BNE _NO_EQ_1
            CMP.W 4(SP), D7
            BNE _NO_EQ_1
                BRA _EXIT_BRESENHAM
        _NO_EQ_1:

        MOVE.W D4, D5
        LSL.W #1, D5

        CMP.W D5, D1
        BGT _NO_IF_1
            CMP.W 6(SP), D6
            BEQ _EXIT_BRESENHAM
            ADD.W D1, D4
            ADD.W D2, 10(SP) ;SE PUEDEN COMENTAR SIM PROBLEMAS
        _NO_IF_1:
        CMP.W D5, D0
        BLT _NO_IF_2
            CMP.W 4(SP), D7
            BEQ _EXIT_BRESENHAM
            ADD.W D0, D4
            ADD.W D3, 8(SP)
        _NO_IF_2:
        
        ;SUB.W #1, (TEST)
        ;CMP.W #0, (TEST)
        ;BNE _TEST
        ;MOVE.W 8(SP), D7
        ;MOVE.W D7, 4(SP)
        ;BRA BRESENHAM
        ;_TEST:
        BRA _BRESENLOOP

    _EXIT_BRESENHAM:
    RTS
PAINT:
    MOVEM.L D0-D2, -(SP)
    MOVE.B #82, D0
    MOVE.W 18(SP), D1
    MOVE.W 16(SP), D2
    TRAP #15

    MOVEM.L (SP)+, D2-D0
    RTS
* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
