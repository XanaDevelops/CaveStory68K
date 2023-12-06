*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

GAMEFLAGS       DC.B 0 ;(UPD_ENT)(END_DBOX)(CR_DBOX)-----
FTOSKIP         DC.B 0

FIXFILEBUG      DC.B 0 ;INTENTA ARREGLAR EL BUG DE FICHERO
                DS.W 0

SCREEN_X        DS.W 1
SCREEN_Y        DS.W 1
SCR_SPEED_X     DC.W 0
SCR_SPEED_Y     DC.W 0

RNGVAL          DS.L 1

                ;CAN?
                 ;UDLR---(FSKIP)
SCREEN_ST       DC.B 0
                DC.W 0
SCRBGCOLOR      DC.L $00202020

CURRENTMAPDIR   DS.L 1

DBGWORD1        DS.W 1
DBGWORD2        DS.W 1

;TRANS
TRANS_STATUS    DC.B 0 ;0:NO 1:DO 2:DONE 3:UNDO->0
                DS.W 0
TRANS_INDEX     DC.W 0 

;COLISION ENTIDADES
MINCHK          DC.W $8000
MAXCHK          DC.W MAXWP
                DS.W 0

INTERACT_MAP    DCB.B 100*100,0

ENTITY_FIND_ALL DCB.L NUM_ENT,-1

	ORG     (*+ENT_SIZE_L-1)&-ENT_SIZE_L
ENTITY_MEM      DCB.L NUM_ENT*ENT_SIZE_L,0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
