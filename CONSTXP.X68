*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

;SCREEN CONST
SCREEN_WIDTH    EQU 800 ;800 prevent screen tearing ;1024
SCREEN_HEIGHT   EQU 600 ;600                        ;768

;DEPENDE SCREEN SIZE
SCREEN_XTILE    EQU 13 ;13 10 ;16
SCREEN_YTILE    EQU 10 ;10 8  ;12

;DBOX
DBOXTS          EQU $0A13 ;$0A13
MAXLINES        EQU 8     ;8

SCREEN_MAXVX    EQU 6

TARGETFPS       EQU 60
SCREEN_UPTIME   EQU 1000/TARGETFPS ;4

;GAME MANAGER
WAITDEDT        EQU 40



;PLAYER
ANIMSPEED       EQU 4

MAX_PLYR_SPEED  EQU 5
MAX_FALL_SPEED  EQU 15

INVTIME         EQU 50

;BULLET
BLT_PS_SPEED   EQU 35

;BAT
BATMY       EQU 20
BATANMSPD   EQU 3

;DISQUETE
DSKANIM         EQU 5

;HEART
HRTANMSPD   EQU 4

;DORITO
DRTANMSPD   EQU 2







;?
M_KCFW      EQU 40





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
