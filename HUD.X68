*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HUD_DRAW:
    MOVE.L #POLARSTARICO, -(SP)
    MOVE.W #20, -(SP)
    MOVE.W #20, -(SP)

    BSR FASTSPRITE

    MOVE.B #11, D0
    MOVE.W #$0204, D1
    TRAP #15

    MOVE.B #81, D0
    MOVE.L #BLACK, D1
    TRAP #15

    MOVE.B #14, D0
    LEA .TEXTLVL, A1
    TRAP #15

    MOVE.B #11, D0
    MOVE.W #$0205, D1
    TRAP #15

    MOVE.B #14, D0
    LEA .TEXTHP, A1
    TRAP #15

    MOVE.B #3, D0
    MOVE.L (PLAYERREF), A0
    CLR.L D1
    MOVE.W HP(A0), D1
    TRAP #15


    ADDA.L #8, SP 
    RTS


.TEXTLVL     DC.B 'LVL:',0
.TEXTHP      DC.B 'HP:',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
