*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

START_DBOX:
    MOVE.W #0, (CURRENTTXTID) ;temp #0

    ANDI.B #%1001111, (GAMEFLAGS)
    CLR.W (HASPORTTR)
    CLR.W (TXTINDEX)
    CLR.W (DIAGINDEX)
    CLR.W (MORELINES)

    RTS
UPDATE_DBOX:
    CMP.W #-1, (CURRENTTXTID)
    BEQ .NONLINE

    BTST.B #6, (GAMEFLAGS)
    BEQ .NOEND
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ .NONLINE
    MOVE.W #-1, (CURRENTTXTID)
    RTS                 ;A VER QUE TAL RTS AHÍ, POR SI LUEGO MUEVO REGISTROS
    .NOEND:
    BTST.B #KEYM_X, (KEY_HOLD_PLAYER)
    BNE .SITIM
    SUBQ.W #1, (TXTDELAYV)
    BPL .NOTIM
    .SITIM:
        MOVE.W #TXTDELAY, (TXTDELAYV)
        ADDQ.W #1, (TXTINDEX)
    .NOTIM:
    BTST.B #5, (GAMEFLAGS)
    BNE .SILINE
    CMP.W #35, (TXTINDEX)
    BLT .NONLINE
    .SILINE:
    CLR.W (TXTINDEX)
    BCLR.B #5, (GAMEFLAGS)

    CMP.W #MAXLINES-1, (MORELINES)
    BLT .NOSCR
    ADDQ.W #1, (DIAGINDEX)
    BRA .NONLINE
    .NOSCR:
    ADDQ.W #1, (MORELINES)
    .NONLINE:
    RTS

DRAW_DBOX:
    CMP.W #-1, (CURRENTTXTID)
    BEQ .END_DBOX

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

    MOVE.W #DBOXTS, D3

    MOVE.B #81, D0
    MOVE.L #BLACK, D1
    TRAP #15

    CLR.L D1                    ;CARGA FRASES DIALOGO
    MOVE.W (CURRENTTXTID), D1
    LSL.W #2, D1

    LEA ALLDIALOGS, A6
    MOVE.L (A6, D1), A6

    MOVE.W (MORELINES), D4

    MOVE.W (DIAGINDEX), D2  ;FRASE
    LSL.W #2, D2

    .LOOPDBOX:
    MOVE.B #11, D0          ;POS PROVISIONAL
    MOVE.W D3, D1 ;081B
    TRAP #15

    MOVE.B #1, D0               ;SELECCIONA FRASE
    MOVE.L (A6, D2.W), A1

    CMP.L #-1, A1
    BNE .NOEND
    BSET.B #6, (GAMEFLAGS)
    BRA .END_DBOX
    .NOEND:
    CMP.W #0, D4
    BEQ .LASTLINEA
    MOVE.W #255, D1
    ADDQ.W #4, D2
    BRA .PAINTLINEA 
    .LASTLINEA: 
    MOVE.W (TXTINDEX), D1
    CMP.B #0, (A1, D1)
    BNE .PAINTLINEA
    BSET.B #5, (GAMEFLAGS)
    .PAINTLINEA:       
    TRAP #15
    
    ADDQ.W #1, D3
    SUBQ.W #1, D4
    BGE .LOOPDBOX
    .END_DBOX:
    RTS

CURRENTTXTID    DS.W 1
HASPORTTR       DS.W 1
TXTINDEX        DS.W 1
DIAGINDEX       DS.W 1
MORELINES       DS.W 1
TXTDELAYV       DS.W 1

TXTDELAY        EQU 1
DBOXX1          EQU 20
DBOXX2          EQU SCREEN_WIDTH-20
DBOXY1          EQU (SCREEN_HEIGHT/2)+80
DBOXY2          EQU SCREEN_HEIGHT-20



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
