*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
FASTSPRITE:
    ;START X EN 36(SP)
    ;START Y EN 38(SP)
    ;40(SP) @SPRITE
    MOVEM.L D0-D4/A0-A2, -(SP)

    MOVE.L 40(SP), A0
    MOVE.L (A0), A1             ;COLOR
    MOVE.L 4(A0), A2            ;POS
    
    FASTSPRITELOOP:
        MOVE.B #80, D0          ;SET COLOR
        MOVE.L (A1)+, D1
        CMP.L #-1, D1
        BEQ EXITFASTSPRITE
        TRAP #15
        ADDQ.B #1, D0
        TRAP #15

        MOVE.B #87, D0
        MOVEM.W (A2)+, D1-D4    ;LOAD LOCAR COORDS

        ADD.W 36(SP), D1        ;ADD EXT COORDS
        ADD.W 36(SP), D3
        ADD.W 38(SP), D2
        ADD.W 38(SP), D4
        ;ADDQ.W #1, D4

        TRAP #15

        BRA FASTSPRITELOOP

    EXITFASTSPRITE:
    MOVEM.L (SP)+, A2-A0/D4-D0
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
