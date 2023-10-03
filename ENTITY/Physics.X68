*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

UPDATE_PHYSICS:
    ; (SP) @ENT
    ; fisicas de colision por hitbox continuas por implementación
    ; del algoritmo de bresenham
    MOVEM.L D0-D7/A1-A2, -(SP)

    MOVE.L 44(SP), A0
    LEA INTERACT_MAP, A2
    MOVE.L CURRENTMAPDIR, A1
    
    AND.B #%00001111, STATUS+1(A0)

    BTST.B #2, STATUS+1(A0)
    BNE .NOGRAV
        ADDQ.W #G, YSPEED(A0)                   ;GRAVEDAD
        CMP.W #MAX_FALL_SPEED, YSPEED(A0)
        BLE .NOMXSPED
            MOVE.W #MAX_FALL_SPEED, YSPEED(A0)
        .NOMXSPED:
    .NOGRAV:
    
    MOVE.W XPOS(A0), D0
    ADD.W XSPEED(A0), D0
    MOVE.W D0, -(SP)

    MOVE.W YPOS(A0), D0
    ADD.W YSPEED(A0), D0
    MOVE.W D0, -(SP)

.BRESENHAM:
    ;XPOS(A0)  X0
    ;YPOS(A0)  Y0
    ;2(SP)  X1 -> 6(SP)
    ;0(SP)  Y1 -> 4(SP)
    ;D0     DX
    ;D1     DY
    ;D2     SX
    ;D3     SY
    ;D4     E1
    ;D5     E2
    MOVE.W XPOS(A0), D0
    SUB.W 2(SP), D0
    BPL .NO_ABS
        NEG D0
    .NO_ABS:
    MOVE.W YPOS(A0), D1
    SUB.W 0(SP), D1
    BMI .SI_ABS  ;-ABS
        NEG D1
    .SI_ABS:
    MOVE.W #-1, D2
    MOVE.W 2(SP), D6
    CMP.W XPOS(A0), D6
    BLE .NO_SX
        MOVE.W #1, D2
    .NO_SX:
    MOVE.W #-1, D3
    MOVE.W 0(SP), D6
    CMP.W YPOS(A0), D6
    BLE .NO_SY
        MOVE.W #1, D3
    .NO_SY:

    MOVE.W D0, D4
    ADD.W D1, D4

    SUBA.L #4, SP ;ESPACIO WORDS 0(SP) DESPX, 2(SP) DESPY

    _BRESENLOOP:
        MOVE.W XPOS(A0), D6
        MOVE.W YPOS(A0), D7

        CLR.L (SP)

        CMP.W 6(SP), D6
        BNE _NO_EQ_1
            CMP.W 4(SP), D7
            BNE _NO_EQ_1
                BRA _EXIT_BRESENHAM
        _NO_EQ_1:

        MOVE.W D4, D5
        LSL.W #1, D5


        CMP.W D5, D0
        BLT _NO_IF_2
            CMP.W 4(SP), D7
            BEQ _EXIT_BRESENHAM
            ADD.W D0, D4
            ADD.W D3, YPOS(A0)         
            MOVE.W D3, 2(SP)
            BSR COLICHECK
            BRA _BRESENLOOP
        _NO_IF_2:
        CMP.W D5, D1
        BGT _NO_IF_1
            CMP.W 6(SP), D6
            BEQ _EXIT_BRESENHAM
            ADD.W D1, D4
            ADD.W D2, XPOS(A0)         ;X
            MOVE.W D2, 0(SP)
            BSR COLICHECK
            BRA _BRESENLOOP
        _NO_IF_1:
        

    ;BSR COLICHECK
    
    BRA _BRESENLOOP

    _EXIT_BRESENHAM:
    ADDQ.L #8, SP

    .ENDPHSC:
    MOVEM.L (SP)+, A2-A1/D7-D0
    RTS


COLICHECK:
    ;PENSAR
    ;COLISION LATERAL, PUNTOS SUPERIORES SI SUELO
    ;SINO TAMBIEN
    MOVEM.L D0-D4/D6-D7, -(SP)

    ADDA.L #14, A0
    MOVEM.W (A0)+, D1-D4
    SUBA.L #22, A0

    ADD.W XPOS(A0), D1
    ADD.W XPOS(A0), D3
    
    ADD.W YPOS(A0), D2
    ADD.W YPOS(A0), D4

    ;TEST
    ADDQ.W #1, D1
    ADDQ.W #1, D3
    SUBQ.W #1, D2
    SUBQ.W #1, D4

    LSR.W #6, D1  ;DIVU.W #64, D1
    LSR.W #6, D2
    LSR.W #6, D3
    LSR.W #6, D4

    MULU.W 4(A1), D2
    MULU.W 4(A1), D4

    CLR.W D7

    MOVE.W D1, D0
    ADD.W D2, D0

    CMP.B #-1, (A2, D0)
    BNE .NO_COLI_UPL
    BSET.L #7, D7
    .NO_COLI_UPL:

    MOVE.W D3, D0
    ADD.W D2, D0

    CMP.B #-1, (A2,D0)
    BNE .NO_COLI_UPR
    BSET.L #6, D7
    .NO_COLI_UPR:

    MOVE.W D1, D0
    ADD.W D4, D0

    CMP.B #-1, (A2,D0)
    BNE .NO_COLI_DWL
    BSET.L #5, D7
    .NO_COLI_DWL:

    MOVE.W D3, D0
    ADD.W D4, D0

    CMP.B #-1, (A2,D0)
    BNE .NO_COLI_DWR
    BSET.L #4, D7
    .NO_COLI_DWR:

    ;MOVE.W D7, 32(SP)   ;CAMBIAR 32(SP), 
    ;Poc
    OR.B D7, STATUS+1(A0)

    CMP.W #0, D7
    BEQ .NOCOLI
        
        CMP.W #0, 34(SP)
        BEQ .NOYMOVE
            MOVE.W 34(SP), D6
            SUB.W D6, YPOS(A0)
            MOVE.W #0, YSPEED(A0)
            MOVE.W YPOS(A0), D6
            MOVE.W D6, 36(SP)
            BTST #5, D7
            BNE .SETGROUND
            BTST #4, D7
            BNE .SETGROUND
            BRA .NOYMOVE
            .SETGROUND:
                BSET.B #3, STATUS+1(A0)
        .NOYMOVE:
        CMP.W #0, 32(SP)
        BEQ .NOXMOVE
            MOVE.W 32(SP), D6
            SUB.W D6, XPOS(A0)
            MOVE.W #0, XSPEED(A0)
            MOVE.W XPOS(A0), D6
            MOVE.W D6, 38(SP)
        .NOXMOVE:
    .NOCOLI:

    MOVEM.L (SP)+, D7-D6/D4-D0
    RTS



COLLISION_ENTITY:
    ; (SP) A0
    ; (SP) @COLI, SINO -1
    
    

    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
