*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DEBUG           EQU 1 ;DEBUG
DBG_ADV_HB      EQU 0 ;MUESTRA POS FUTURA
DGB_NODBUF      EQU 0 ;JUST DON'T 
DGBTRACE        EQU 0 ;AFECTA ENORMEMENTE EL RENDIMENTO

FLG_TRANS       EQU 1 ;HABILITA EFECTO TRANSICIÓN (AFECTA AL RENDIMIENTO)
MEME_MUSIC      EQU 0 ;REEMPLAZA LAS BGM POR RIPS DE ALTA CALIDAD (TODO, puede que no)

INTBASE         EQU $60 ;ES $64, PERO -4
TRAPBASE        EQU $80

RESETPRIOMS     EQU 30   ;ms RESET PRIO MUSIC
HBEATRATE       EQU 2000 ;ms HEARTBEAT SERVER
CHECKRATE       EQU HBEATRATE<<2

;IDENTIFICADOR SAVE FILE
MAGIKN          EQU $0901

TILESIZE        EQU 64

MAX_SCRLL_SPEEDX EQU 9
MAX_SCRLL_SPEEDY EQU 22

    IFEQ XPMODE         ;NOXP
    INCLUDE "CONSTNW.X68"
    ENDC

    IFNE XPMODE
    INCLUDE "CONSTXP.X68"
    ENDC

;HEALTHBAR
HBX             EQU 95
HBY             EQU 105
HBL             EQU 140
HBW             EQU 20

;ENTITY
ET_ID           EQU 0
ET_XPOS         EQU 2
ET_YPOS         EQU 4
ET_HP           EQU 6
ET_XSPEED       EQU 8
ET_YSPEED       EQU 10
ET_MSTATE       EQU 12 ;Machine STATE
ET_BSTATE       EQU 13 ;Body    STATE
ET_HBOX         EQU 14
ET_START        EQU 22
ET_UPDATE       EQU 26
ET_DRAW         EQU 30
ET_REVDAM       EQU 34  ;REcieVeDAMage
ET_INTER        EQU ET_REVDAM
ET_SPRITE       EQU 38
ET_ISPR         EQU 42
ET_TSPRT        EQU 46
ET_ZORD         EQU 48
ET_DATA         EQU 50

ENT_SIZE_L      EQU 64  ;MULTIPLO 4 
NUM_ENT         EQU 75


;PLAYER
G               EQU 1

;COLECT
SMHEART         EQU 3
BGHEART         EQU 5

SDORITO         EQU 1
MDORITO         EQU 3
BGDORITO        EQU 5

;DIALOGS
ITESTDIAG       EQU 0
IDIEDDIAG       EQU 1
OBVIODIAG       EQU 2
ISAVEDIAG       EQU 4
IHEALDIAG       EQU 5
ICOLORDIAG      EQU 6
IGOTO2DIAG      EQU 7

    INCLUDE "DBOXCODES.X68"

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

KEY_LEFT        EQU $25
KEY_UP          EQU $26
KEY_RIGHT       EQU $27
KEY_DOWN        EQU $28      
KEY_F11         EQU $7A
KEY_ESC         EQU $1B


;TEXT CONTROL
LF              EQU $0A
CR              EQU $0D

;NUMERIC VALUES
MAXBP           EQU $0000007F
MAXWP           EQU $00007FFF
MAXLP           EQU $7FFFFFFF









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
