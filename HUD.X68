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

    LEA .TEXTLVL, A1
    MOVE.B #95, D0
    MOVE.W #20, D1
    MOVE.W #85, D2
    TRAP #15

    LEA .TEXTHP, A1
    ADD.W #20, D2
    TRAP #15


    ADDA.L #8, SP 
    RTS


.TEXTLVL     DC.B 'LVL:',0
.TEXTHP      DC.B 'HP:',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
