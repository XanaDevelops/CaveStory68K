*-----------------------------------------------------------
* Title      : Cave Story (Port)
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    INCLUDE "MACROS.X68"
    INCLUDE "CONST.X68"
    
    

    ORG    $1000
START:                  ; first instruction of program

    BSR SYSTEM_INIT
    BSR SET_SCROLL_TEXT

    MOVE.W #0, SCREEN_X
    MOVE.W #0, SCREEN_Y

    MOVE.W #SCREEN_WIDTH\2-32, PLAYER_X
    MOVE.W #SCREEN_HEIGHT\2-32, PLAYER_Y
    
    MOVE.W #0, SCR_SPEED_X
    MOVE.W #0, SCR_SPEED_Y

    MOVE.W #1, CURRENTMAPID
    LEA MAPAS, A0
    MOVE.W CURRENTMAPID, D0
    ASL.W #2, D0                ;MULU #4
    ADDA.W D0, A0
    MOVE.L (A0), CURRENTMAPDIR

    BSR GENERATE_COLIMAP

TESTLOOP:
    MOVE.B		#8,D0 ;GET TIEMPO EN MILIS
	TRAP		#15
	MOVE.L D1, -(SP) ;LO GUARDA PARA MÁS ADELANTE

    
PAINTLOOP:
    BSR UPDATE_KEYS

    MOVE.L CURRENTMAPDIR, -(SP)
    BSR DRAW_MAP
    ADDQ.L #4, SP

    BSR PAINT_PLAYER

    REPAINT
    CLRSCREEN
        
    ;ADD.W #2, SCREEN_X
    ;ADD.W #3, SCREEN_Y

    BTST.B #KEYM_UP, KEY_PRESS_PLAYER
    BEQ _NOKUP
    BTST.B #KEYM_UP, PLAYER_ST
    BEQ _NOKUP
    SUBQ.W #2, SCR_SPEED_Y
    _NOKUP:
    BTST.B #KEYM_DOWN, KEY_PRESS_PLAYER
    BEQ _NOKDOWN
    ADDQ.W #2, SCR_SPEED_Y
    _NOKDOWN:
    BTST.B #KEYM_LEFT, KEY_PRESS_PLAYER
    BEQ _NOKLEFT
    SUBQ.W #2, SCR_SPEED_X
    _NOKLEFT:
    BTST.B #KEYM_RIGHT, KEY_PRESS_PLAYER
    BEQ _NOKRIGHT
    ADDQ.W #2, SCR_SPEED_X
    _NOKRIGHT:

    MOVE.W SCR_SPEED_X, D0
    MOVE.W SCR_SPEED_Y, D1
    
    REDUCE_SCRLL_SPEED D0
    REDUCE_SCRLL_SPEED D1

    LIMIT_SCRLL_SPEED D0
    LIMIT_SCRLL_SPEED D1

    ORI.B #$F0, PLAYER_ST

    BSR PREVENT_SCREEN_OOB


    ADD.W D0, SCREEN_X
    ADD.W D1, SCREEN_Y

    MOVE.W D0, SCR_SPEED_X
    MOVE.W D1, SCR_SPEED_Y

    


ENDTESTLOOP:
    MOVE.L	(SP)+,D7 ;RECUPERA EL TIEMPO DE ANTES
    WAIT_REFRESH:
	MOVE.B		#8,D0	;OBTIENE EL TIEMPO
	TRAP		#15

	SUB.L		D7,D1 ;RESTA
	CMP.B		#SCREEN_UPTIME,D1	;COMPARA CON EL TIEMPO OBJETIVO
	BMI.S		WAIT_REFRESH ;SINO PUES ESO
    BRA TESTLOOP


    SIMHALT             ; halt simulator


SCR_SPEED_X         DC.W 0
SCR_SPEED_Y         DC.W 0

    INCLUDE "TECLADO.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "PLAYER/PLAYER.X68"
    INCLUDE "COLISSION.X68"
    INCLUDE "ScreenScroll.X68"
    INCLUDE "FastSprite.x68"
    INCLUDE "DRAWMAP.x68"
    INCLUDE "VARS.X68"
    INCLUDE "data/DATA.x68"
    INCLUDE "data/sprites.x68"
    INCLUDE "data/maps.x68"


    END    START        ; last line of source




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
