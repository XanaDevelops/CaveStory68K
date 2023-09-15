*-----------------------------------------------------------
* Title      : Cave Story (Port)
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    INCLUDE "MACROS.X68"
    INCLUDE "CONST.X68"
    INCLUDE "VARS.X68"

    ORG    $1000
START:                  ; first instruction of program

    BSR SYSTEM_INIT
    BSR SET_SCROLL_TEXT

    MOVE.B #80, D0
    MOVE.L #$00FF00FF, D1
    TRAP #15
    ADDQ.B #1, D0
    TRAP #15

    MOVE.B #87, D0
    MOVE.L #0, D1
    MOVE.L #0, D2
    MOVE.W #SCREEN_WIDTH, D3
    MOVE.W #SCREEN_HEIGHT, D4
    TRAP #15
    
    REPAINT
    
    MOVE.W #3, -(SP)
    BSR SCROLL
    REPAINT
    
    
    ADDQ.L #2, SP

    SIMHALT             ; halt simulator

    INCLUDE "SYSTEM.X68"
    INCLUDE "ScreenScroll.X68"

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
