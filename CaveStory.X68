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
    MOVE.W #TILESIZE*0, SCREEN_Y
    
    MOVE.W #0, SCR_SPEED_X
    MOVE.W #0, SCR_SPEED_Y

    MOVE.W #0, CURRENTMAPID
    LEA MAPAS, A0
    MOVE.W CURRENTMAPID, D0
    ASL.W #2, D0                ;MULU #4
    ADDA.W D0, A0
    MOVE.L (A0), CURRENTMAPDIR

    MOVE.L #PLAYER, -(SP)
    BSR INSTANCE_ENTITY

    ADDQ.L #4, SP

    BSR GENERATE_COLIMAP

    CLRSCREEN

TESTLOOP:
    MOVE.B		#8,D0 ;GET TIEMPO EN MILIS
	TRAP		#15
	MOVE.L D1, -(SP) ;LO GUARDA PARA MÁS ADELANTE

    
PAINTLOOP:
    BSR UPDATE_KEYS

    MOVE.L CURRENTMAPDIR, -(SP)
    BSR DRAW_MAP
    ADDQ.L #4, SP

    BSR DRAW_ALL_ENT

    REPAINT
    CLRSCREEN
    
    BSR UPDATE_ALL_ENT

    MOVE.W (SCR_SPEED_X), D0
    MOVE.W (SCR_SPEED_Y), D1
    
    REDUCE_SCRLL_SPEED D0
    REDUCE_SCRLL_SPEED D1

    LIMIT_SCRLL_SPEED D0, MAX_SCRLL_SPEEDX
    LIMIT_SCRLL_SPEED D1, MAX_SCRLL_SPEEDY

    ORI.B #$F0, SCREEN_ST

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
    INCLUDE "COLISSION.X68"
    INCLUDE "ScreenScroll.X68"
    INCLUDE "FastSprite.x68"
    INCLUDE "DRAWMAP.x68"
    INCLUDE "VARS.X68"
    INCLUDE "ENTITY/EntityIncluder.x68"
    INCLUDE "ENTITY/EntityManagement.x68"
    INCLUDE "ENTITY/Physics.X68"
    INCLUDE "data/DATA.x68"
    INCLUDE "data/sprites.x68"
    INCLUDE "data/maps.x68"


    END    START        ; last line of source



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
