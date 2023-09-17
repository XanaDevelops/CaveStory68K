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

    MOVE.W #0, WORLD_X
    MOVE.W #64*40, WORLD_Y
    MOVE.W #0, SPEED_X
    MOVE.W #0, SPEED_Y

    MOVE.W #0, CURRENTMAPID
    LEA MAPAS, A0
    MOVE.W CURRENTMAPDIR, D0
    ASL.W #2, D0                ;MULU #4
    ADDA.W CURRENTMAPID, A0
    MOVE.L (A0), CURRENTMAPDIR

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
        
    ;ADD.W #2, WORLD_X
    ;ADD.W #3, WORLD_Y

    BTST.B #KEYM_UP, KEY_PRESS_PLAYER
    BEQ _NOKUP
    BTST.B #KEYM_UP, PLAYER_ST
    BEQ _NOKUP
    SUBQ.W #2, SPEED_Y
    _NOKUP:
    BTST.B #KEYM_DOWN, KEY_PRESS_PLAYER
    BEQ _NOKDOWN
    ADDQ.W #2, SPEED_Y
    _NOKDOWN:
    BTST.B #KEYM_LEFT, KEY_PRESS_PLAYER
    BEQ _NOKLEFT
    SUBQ.W #2, SPEED_X
    _NOKLEFT:
    BTST.B #KEYM_RIGHT, KEY_PRESS_PLAYER
    BEQ _NOKRIGHT
    ADDQ.W #2, SPEED_X
    _NOKRIGHT:

    MOVE.W SPEED_X, D0
    MOVE.W SPEED_Y, D1
    
    REDUCE_SCRLL_SPEED D0
    REDUCE_SCRLL_SPEED D1

    LIMIT_SCRLL_SPEED D0
    LIMIT_SCRLL_SPEED D1

    ORI.B #$F0, PLAYER_ST

    CMP.W #MAX_SCRLL_SPEED, WORLD_Y
    BGE _NO_OOB_UP
        CMP.W #0, D1
        BPL _NO_OOB_UP
            MOVE.W D1, D3
            NEG D3
            CMP.W WORLD_Y, D3
            BLT _NO_OOB_UP
                MOVE.W WORLD_Y, D3
                NEG D3
                MOVE.W D3, D1
                BCLR.B #KEYM_UP, PLAYER_ST
    _NO_OOB_UP:

    CMP.W #0, D1                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BMI _NO_OOB_DOWN
        MOVE.W WORLD_Y, D4
        ADDI.W #SCREEN_YTILE*TILESIZE, D4
        MOVE.L CURRENTMAPDIR, A0
        MOVE.W 6(A0), D3
        SUBQ.W #1, D3
        MULU.W #TILESIZE, D3
        SUB.W D4, D3
        CMP.W #MAX_SCRLL_SPEED, D3
        BGT _NO_OOB_DOWN
            MOVE.W D3, D1
            BCLR.B #KEYM_DOWN, PLAYER_ST
    _NO_OOB_DOWN:

    CMP.W #MAX_SCRLL_SPEED, WORLD_X
    BGE _NO_OOB_LEFT
        CMP.W #0, D0
        BPL _NO_OOB_LEFT
            MOVE.W D0, D2
            NEG D2
            CMP.W WORLD_X, D2
            BLT _NO_OOB_LEFT
                MOVE.W WORLD_X, D2
                NEG D2
                MOVE.W D2, D0
                BCLR.B #KEYM_LEFT, PLAYER_ST
    _NO_OOB_LEFT:

    CMP.W #0, D0                            ;DEJAR MARGEN 1px BAJO/DERECHA
    BMI _NO_OOB_RIGHT
        MOVE.W WORLD_X, D4
        ADDI.W #SCREEN_XTILE*TILESIZE, D4
        MOVE.L CURRENTMAPDIR, A0
        MOVE.W 4(A0), D2
        ;SUBQ.W #1, D2
        MULU.W #TILESIZE, D2
        SUB.W D4, D2
        CMP.W #MAX_SCRLL_SPEED, D2
        BGT _NO_OOB_RIGHT
            MOVE.W D2, D0
            BCLR.B #KEYM_RIGHT, PLAYER_ST
            

    _NO_OOB_RIGHT:


    ADD.W D0, WORLD_X
    ADD.W D1, WORLD_Y

    MOVE.W D0, SPEED_X
    MOVE.W D1, SPEED_Y

    


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


SPEED_X         DC.W 0
SPEED_Y         DC.W 0

    INCLUDE "VARS.X68"
    INCLUDE "TECLADO.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "PLAYER/PLAYER.X68"
    INCLUDE "ScreenScroll.X68"
    INCLUDE "FastSprite.x68"
    INCLUDE "DRAWMAP.x68"
    INCLUDE "data/DATA.x68"
    INCLUDE "data/sprites.x68"
    INCLUDE "data/maps.x68"


    END    START        ; last line of source


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
