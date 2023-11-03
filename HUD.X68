*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
HUD_DRAW:
    CLR.L D2
    MOVE.B (EQUIPARM), D2

    ;DEPENDE ARMA EQUIPADA
    MOVE.L #POLARSTARICO, -(SP)
    MOVE.W #20, -(SP)
    MOVE.W #20, -(SP)

    BSR FASTSPRITE
    ;MOVER CURSOR
    MOVE.B #11, D0
    MOVE.W #$0204, D1
    TRAP #15
    ;COLOR FONDO
    MOVE.B #81, D0
    MOVE.L #BLACK, D1
    TRAP #15
    
    MOVE.B #14, D0
    LEA .TEXTLVL, A1
    TRAP #15

    ;ARMA LVL XP
    MOVE.B #15, D0
    LEA ARMS_STS, A0
    MOVE.W (A0, D2), D1
    EXT.L D1
    MOVE.B #16, D2
    TRAP #15

    MOVE.B #11, D0
    MOVE.W #$0205, D1
    TRAP #15

    MOVE.B #14, D0
    LEA .TEXTHP, A1
    TRAP #15

    MOVE.B #3, D0
    MOVE.L (PLAYERREF), A0  ;COMPROBAR QUE EXISTA!
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
