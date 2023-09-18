*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_BBOX DC.W 0,0,64,64

PAINT_PLAYER:
    MOVE.L #QUOTE_L_0, -(SP)
    MOVE.W #SCREEN_HEIGHT/2-32, -(SP)
    MOVE.W #SCREEN_WIDTH/2-32, -(SP)

    BSR FASTSPRITE

    ADDQ.L #8, SP

    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
