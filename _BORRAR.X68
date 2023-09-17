*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    INCLUDE "CONST.X68"
    INCLUDE "MACROS.X68"
    ORG    $1000
START:                  ; first instruction of program
    
* Put program code here
    BSR SYSTEM_INIT
    
    MOVE.W #81, D0
    MOVE.L #$00FF00FF, D1
    TRAP #15

    MOVE.W #89, D0
    MOVE.L #03, D1
    MOVE.W #03, D2
    TRAP #15

    BSR SET_SCROLL_TEXT
    MOVE.W #0, -(SP)
    BSR SCROLL
    
    REPAINT
    
    
    SIMHALT             ; halt simulator

* Put variables and constants here
    INCLUDE "SYSTEM.X68"
    INCLUDE "ScreenScroll.x68"

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
