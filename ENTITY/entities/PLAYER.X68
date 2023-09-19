*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_START:
    MOVE.W #SCREEN_HEIGHT/2-32, 2(A0)
    MOVE.W #SCREEN_WIDTH/2-32, 4(A0)
    RTS
PLAYER_UPDATE:
    RTS
PLAYER_PAINT:
    MOVE.L D0, -(SP)

    MOVE.L #QUOTE_L_0, -(SP)
    MOVE.W #SCREEN_HEIGHT/2-32, -(SP)
    MOVE.W #SCREEN_WIDTH/2-32, -(SP)

    BSR FASTSPRITE

    ADDQ.L #8, SP
    MOVE.L (SP)+, D0
    RTS
PLAYER:
    DC.W 1          ;ID
    DC.W 0, 0       ;POSITION
    DC.W 0, 0       ;SPEED
    DC.W 0          ;STATUS ;CAN? ;00UDLR----
    DC.W 0,0, 64,64 ;COLISION_BOX
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT
    DC.L QUOTE_WALK_L
    DC.W 0
    DS.L 5
    DS.W 1



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
