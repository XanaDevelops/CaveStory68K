*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
;KEY MASKS
KEYM_UP         EQU 7 
KEYM_DOWN       EQU 6
KEYM_LEFT       EQU 5
KEYM_RIGHT      EQU 4
KEYM_Z          EQU 3
KEYM_X          EQU 2
KEYM_A          EQU 1
KEYM_S          EQU 0
KEYM_Q          EQU 7
KEYM_W          EQU 6
KEYM_ESC        EQU 5
KEYM_F11        EQU 4


;KEY REG
KEY_PRESS_PLAYER    DS.B 1 ;UDLRZXAS
KEY_PRESS_MENU      DS.B 1 ;QW(ESC)(F11?)----
KEY_HOLD_PLAYER     DS.B 1 ;SAME
KEY_HOLD_MENU       DS.B 1 

UPDATE_KEYS:
    MOVEM.L D0-D3, -(SP)

    CLR.L   D2

    MOVE.B  #19, D0
    MOVE.L  #KEY_UP<<24+KEY_DOWN<<16+KEY_LEFT<<8+KEY_RIGHT, D1
    TRAP    #15

    BSR     .CONVERT

    MOVE.B  #19, D0
    MOVE.L  #'Z'<<24+'X'<<16+'A'<<8+'S', D1
    TRAP    #15

    BSR     .CONVERT

    MOVE.B  (KEY_HOLD_PLAYER), D0
    NOT.B   D0
    AND.B   D2, D0
    MOVE.B  D2, (KEY_HOLD_PLAYER)
    MOVE.B  D0, (KEY_PRESS_PLAYER)

    MOVE.B  #19, D0
    MOVE.L  #'Q'<<24+'W'<<16+KEY_ESC<<8+KEY_F11, D1
    TRAP    #15

    BSR     .CONVERT

    LSL.B   #4, D2  ;COLOCAR EN SU SITIO

    MOVE.B  (KEY_HOLD_MENU), D0
    NOT.B   D0
    AND.B   D2, D0
    MOVE.B  D2, (KEY_HOLD_MENU)
    MOVE.B  D0, (KEY_PRESS_MENU)

    

    MOVEM.L (SP)+, D3-D0
    RTE

    .CONVERT:             ; TRANSFORMA D1.L A D2.B
    MOVE.W  #3, D3                   
    .LOOP:
    LSL.L   #8, D1                   
    ROXL.B  #1, D2                   
    DBRA.W  D3, .LOOP
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
