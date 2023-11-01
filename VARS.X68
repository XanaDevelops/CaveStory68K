*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

GAMEFLAGS   DC.B 0 ;(UPD_ENT)(END_DBOX)(CR_DBOX)-----
FTOSKIP     DC.B 0

SCREEN_X        DS.W 1
SCREEN_Y        DS.W 1
SCR_SPEED_X     DC.W 0
SCR_SPEED_Y     DC.W 0

RNGVAL         DS.L 1

                ;CAN?
                 ;UDLR---(FSKIP)
SCREEN_ST   DC.B 0
            DC.W 0
SCRBGCOLOR  DC.L $00202020

CURRENTMAPDIR   DS.L 1

MINCHK      DC.W $8000
MAXCHK      DC.W $7FFF
            DS.W 0

INTERACT_MAP DCB.B 100*100,0

ENTITY_FIND_ALL     DCB.L NUM_ENT,-1
ENTITY_MEM          DCB.L NUM_ENT*ENT_SIZE_L,0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
