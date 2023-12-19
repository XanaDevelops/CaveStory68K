*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
ENTSTCSTART:

    ;LEA     BULLET_POLARSTAR, A0
    ;CLR.B   BLT_ONSCREEN(A0)
    ;MOVE.B  #2, MAX_BLT_ONSCR(A0) ;BUGGG
    CLR.B   (BULLET_POLARSTAR+BLT_ONSCREEN)
    MOVE.B  #2, (BULLET_POLARSTAR+MAX_BLT_ONSCR)

    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
