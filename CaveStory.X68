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
    MOVE.W #0, WORLD_Y

    MOVE.W #0, CURRENTMAPID
    LEA MAPAS, A0
    MOVE.W CURRENTMAPDIR, D0
    ASL.W #2, D0                ;MULU #4
    ADDA.W CURRENTMAPID, A0
    MOVE.L (A0), CURRENTMAPDIR

TESTLOOP:


    
PAINTLOOP:
    BSR UPDATE_KEYS

    MOVE.L CURRENTMAPDIR, -(SP)
    BSR DRAW_MAP
    ADDQ.L #4, SP


    REPAINT
    CLRSCREEN
        
    ADD.W #2, WORLD_X
    ADD.W #3, WORLD_Y

    MOVE.W #23, D0      ;WAIT
    MOVE.L #1, D1
    TRAP #15

ENDTESTLOOP:
    BRA TESTLOOP


    SIMHALT             ; halt simulator


SPEED_X         DC.W 0
SPEED_Y         DC.W 0

    INCLUDE "VARS.X68"
    INCLUDE "TECLADO.X68"
    INCLUDE "SYSTEM.X68"
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
