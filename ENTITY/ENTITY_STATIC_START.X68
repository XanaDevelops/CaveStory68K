*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
ENTSTCSTART:
    MOVE.L A0, -(SP)

    LEA BULLET_POLARSTAR, A0
    CLR.B BLT_ONSCREEN(A0)


    MOVE.L (SP)+, A0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
