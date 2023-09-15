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

    MOVE.L #0, D7
TESTLOOP:
    ADDQ.W #1, D7
    BTST.L #0, D7
    BEQ _TEST1
    LEA TEST, A0
    BRA PAINTLOOP
    _TEST1:
    LEA TEST2, A0
PAINTLOOP:
    SUBQ.L #8, SP
    MOVE.L A0, 4(SP)
    MOVE.L #0, (SP)
    MOVE.W OFFSET_TEST, (SP)
    MOVE.W OFFSET_TEST, 2(SP)

    MOVE.W #13, D6
    _LOOPY:
        MOVE.W OFFSET_TEST, 2(SP)
        MOVE.W #10, D5
        _LOOPX:
            BSR FASTSPRITE
            ADD.W #64, 2(SP)
            DBRA D5, _LOOPX
        ADD.W #64, 0(SP)
        DBRA D6, _LOOPY
    
    ADDQ.L #8, SP

    REPAINT

    MOVE.W #23, D0
    MOVE.L #1, D1
    ;TRAP #15

    SUBQ.W #4, OFFSET_TEST

    CMP.W #-64, OFFSET_TEST
    BNE TESTLOOP
    MOVE.W #0, OFFSET_TEST
    BRA TESTLOOP


    SIMHALT             ; halt simulator

OFFSET_TEST DC.W 0

    INCLUDE "SYSTEM.X68"
    INCLUDE "data/sprites.x68"
    INCLUDE "ScreenScroll.X68"
    INCLUDE "FastSprite.x68"


    END    START        ; last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
