*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SCROLL:
;   MUEVE LA PANTALLA
;   20(SP).W SCROLL DIR
;       0:UP
;       1:DOWN
;       2:LEFT
;       3:RIGHT
    MOVEM.L D0-D3, -(SP)
    MOVE.B #25, D0
    MOVE.L #SCREEN_RSCROLL*$10000+SCREEN_CSCROLL, D1
    MOVE.L #SCREEN_HSCROLL*$10000+SCREEN_WSCROLL, D2
    MOVE.W 20(SP), D3
    TRAP #15

    MOVEM.L (SP)+, D3-D0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
