*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DEBUG           EQU 1

NUM_ENT         EQU 75
ENT_SIZE_L      EQU 64  ;MULTIPLO 4

;SCREEN CONST
SCREEN_WIDTH    EQU 640
SCREEN_HEIGHT   EQU 512

SCREEN_XTILE    EQU 10
SCREEN_YTILE    EQU 8
TILESIZE        EQU 64

MAX_SCRLL_SPEED EQU 10

SCREEN_UPTIME   EQU 4

SCREEN_XSCROLL  EQU 4
SCREEN_YSCROLL  EQU 8
SCREEN_RSCROLL  EQU 0
SCREEN_CSCROLL  EQU 0
SCREEN_WSCROLL  EQU 255
SCREEN_HSCROLL  EQU 68



;PLAYER
ANIMSPEED       EQU 3
MAX_PLYR_SPEED  EQU 8

G               EQU 1
MAX_FALL_SPEED  EQU 10

;COLORS              XXBBGGRR
BLACK           EQU $00000000 
MAROON          EQU $00000080 
GREEN           EQU $00008000 
OLIVE           EQU $00008080 
NAVY            EQU $00800000 
PURPLE          EQU $00800080 
TEAL            EQU $00808000 
GRAY            EQU $00808080 
RED             EQU $000000FF 
LIME            EQU $0000FF00 
YELLOW          EQU $0000FFFF 
BLUE            EQU $00FF0000 
FUCHSIA         EQU $00FF00FF 
AQUA            EQU $00FFFF00 
LTGRAY          EQU $00C0C0C0 
WHITE           EQU $00FFFFFF 

;KEYS
KEY_Z           EQU $5A
KEY_X           EQU $58
KEY_A           EQU $41
KEY_S           EQU $53

KEY_LEFT        EQU $25
KEY_UP          EQU $26
KEY_RIGHT       EQU $27
KEY_DOWN        EQU $28      
F11             EQU $7A
ESC             EQU $1B






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
