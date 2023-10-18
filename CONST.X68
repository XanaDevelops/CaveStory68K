*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DEBUG           EQU 1

NUM_ENT         EQU 75
ENT_SIZE_L      EQU 64  ;MULTIPLO 4


TILESIZE        EQU 64

MAX_SCRLL_SPEEDX EQU 9
MAX_SCRLL_SPEEDY EQU 22

    IFEQ XPMODE         ;NOXP
    INCLUDE "NWCONST.X68"
    ENDC

    IFNE XPMODE
    INCLUDE "XPCONST.X68"
    ENDC

SCREEN_XSCROLL  EQU 4
SCREEN_YSCROLL  EQU 8
SCREEN_RSCROLL  EQU 0
SCREEN_CSCROLL  EQU 0
SCREEN_WSCROLL  EQU 255
SCREEN_HSCROLL  EQU 68

;ENTITY
ID              EQU 0
XPOS            EQU 2
YPOS            EQU 4
HP              EQU 6
XSPEED          EQU 8
YSPEED          EQU 10
STATUS          EQU 12
COLISION_BOX    EQU 14
AD_START        EQU 22
AD_UPDATE       EQU 26
AD_DRAW         EQU 30
AD_DODAM        EQU 34
AD_INTER        EQU AD_DODAM
AD_SPRITE       EQU 38
SPRITE_INDEX    EQU 42
AUX_DATA        EQU 46

;PLAYER
G               EQU 1

;DIALOGS
ITESTDIAG       EQU 0
IDIEDDIAG       EQU 1
OBVIODIAG       EQU 2

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


;TEXT CONTROL
LF              EQU $0A
CR              EQU $0D








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
