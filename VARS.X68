*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

SCREEN_X     DS.W 1
SCREEN_Y     DS.W 1

CURRENTMAPDIR   DS.L 1
CURRENTMAPID    DC.W 0

PLAYER_X        DC.W 0
PLAYER_Y        DC.W 0
PLAYER_SPEED_X  DC.W 0
PLAYER_SPEED_Y  DC.W 0

                 ;CAN?
                 ;UDLR
PLAYER_ST   DC.B %00000000
            DS.W 0

INTERACT_MAP DCB.B 100*100,0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
