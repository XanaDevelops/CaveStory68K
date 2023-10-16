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
    CLR.W (DIAGINDEX)
    CLR.W (MORELINES)

    RTS
UPDATE_DBOX:
    MOVE.W #1, (MORELINES) ;TEST
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

    ADDQ.B #6, D0           ;Recuadro
    MOVE.W #DBOXX1, D1
    MOVE.W #DBOXY1, D2
    MOVE.W #DBOXX2, D3
    MOVE.W #DBOXY2, D4
    TRAP #15

    MOVE.B #11, D0          ;POS PROVISIONAL
    MOVE.W #$0411, D1 ;081B
    TRAP #15

    MOVE.B #81, D0
    MOVE.L #BLACK, D1
    TRAP #15

    CLR.L D1
    MOVE.W (CURRENTTXTID), D1
    LSL.W #2, D1

    LEA ALLDIALOGS, A6
    MOVE.L (A6, D1), A6

    MOVE.B #1, D0
    MOVE.W (DIAGINDEX), D2
    LSL.W #2, D2
    MOVE.L (A6, D2.W), A1
    
    MOVE.W (TXTINDEX), D1
    TRAP #15
    
    RTS

CURRENTTXTID    DS.W 1
HASPORTTR       DS.W 1
TXTINDEX        DS.W 1
DIAGINDEX       DS.W 1
MORELINES       DS.W 1
TXTDELAYV       DS.W 1

TXTDELAY       EQU 1

DBOXX1          EQU 20
DBOXX2          EQU SCREEN_WIDTH-20
DBOXY1          EQU (SCREEN_HEIGHT/2)+80
DBOXY2          EQU SCREEN_HEIGHT-20


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
