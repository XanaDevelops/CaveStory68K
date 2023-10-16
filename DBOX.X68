*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

START_DBOX:
    MOVE.W #0, (CURRENTTXTID)
    CLR.W (HASPORTTR)
    CLR.W (TXTINDEX)

    RTS
UPDATE_DBOX:
    SUBQ.W #1, (TXTDELAYV)
    BPL .NOTIM
        MOVE.W #TXTDELAY, (TXTDELAYV)
        ADDQ.W #1, (TXTINDEX)
    .NOTIM:
    RTS
DRAW_DBOX:
    
    MOVE.B #80, D0
    MOVE.L #WHITE, D1
    TRAP #15
    ADDQ.B #1, D0
    MOVE.L #BLACK, D1
    TRAP #15

    ADDQ.B #6, D0
    MOVE.W #DBOXX1, D1
    MOVE.W #DBOXY1, D2
    MOVE.W #DBOXX2, D3
    MOVE.W #DBOXY2, D4

    TRAP #15
    
    RTS

CURRENTTXTID    DS.W 1
HASPORTTR       DS.W 1
TXTINDEX        DS.W 1
TXTDELAYV        DS.W 1

TXTDELAY       EQU 3

DBOXX1          EQU 20
DBOXX2          EQU SCREEN_WIDTH-20
DBOXY1          EQU (SCREEN_HEIGHT/2)+80
DBOXY2          EQU SCREEN_HEIGHT-20

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
