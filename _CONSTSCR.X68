*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
; ---- README -----
; COPIAR _CONSTSCR.X68 A CONSTSCR.X68
; ES DEBIDO A .GITIGNORE
; -----------------

;CONFIGURA TAMAÑO PANTALLA
SCRTYPE         EQU 0  ;TIPO RES PANTALLA
                        ;-1 WINDOWS10/11
                        ;0 WINDOWS XP
                        ;1 ALTA RESOLUCION (AFECTA RENDIMIENTO)

;CONSTANTES DE PANTALLA
    IFLT    SCRTYPE ; -1 INTENDED FOR !XPMODE
    ;SCREEN CONST
SCREEN_WIDTH    EQU 640
SCREEN_HEIGHT   EQU 480 ;512

SCREEN_XTILE    EQU 10
SCREEN_YTILE    EQU 8

;DBOX
DBOXTS          EQU $0410 ;0411
MAXLINES        EQU 5
    ENDC

    IFEQ    SCRTYPE ; 0 ;INTENDED FOR XPMODE 
;SCREEN CONST
SCREEN_WIDTH    EQU 800 
SCREEN_HEIGHT   EQU 600 

;DEPENDE SCREEN SIZE
SCREEN_XTILE    EQU 13
SCREEN_YTILE    EQU 10

;DBOX
DBOXTS          EQU $0A13 ;$0410 $0A13
MAXLINES        EQU 8     ;6      8
    ENDC

    IFGT    SCRTYPE ;1
;SCREEN CONST
SCREEN_WIDTH    EQU 1024 
SCREEN_HEIGHT   EQU 768  

;DEPENDE SCREEN SIZE
SCREEN_XTILE    EQU 16
SCREEN_YTILE    EQU 12 

;DBOX
DBOXTS          EQU $0A13 
MAXLINES        EQU 8     

    ENDC





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
