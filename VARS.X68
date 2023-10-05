*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

GAMEFLAGS   DC.B 0 ;(UPDENT)

SCREEN_X    DS.W 1
SCREEN_Y    DS.W 1

                ;CAN?
                 ;UDLR---(FSKIP)
SCREEN_ST   DC.B 0
            DC.W 0
SCRBGCOLOR  DC.L $00202020

CURRENTMAPDIR   DS.L 1
CURRENTMAPID    DC.W 0

INTERACT_MAP DCB.B 100*100,0

ENTITY_FIND_ALL     DCB.L NUM_ENT,-1
ENTITY_MEM          DCB.L NUM_ENT*ENT_SIZE_L,0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
