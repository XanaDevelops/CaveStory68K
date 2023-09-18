*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_MOMEMENT:
    LEA PLAYER_BBOX, A0
    MOVE.W 0(A0), -(SP)
    MOVE.W 2(A0), -(SP)
    MOVE.W 4(A0), -(SP)
    MOVE.W 6(A0), -(SP)
    MOVE.W PLAYER_X, -(SP)
    MOVE.W PLAYER_Y, -(SP)

    BSR CALCULATE_COLISSION_BBOX

    MOVE.W (SP)+, D7
    ADDA.L #10, SP

    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
