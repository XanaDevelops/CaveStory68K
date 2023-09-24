*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
;KEY MASKS
KEYM_UP         EQU 7 
KEYM_DOWN       EQU 8
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
    MOVEM.L D0-D1, -(SP)

    MOVE.B #19, D0
    MOVE.L #KEY_UP<<24+KEY_DOWN<<16+KEY_LEFT<<8+KEY_RIGHT, D1
    TRAP #15

    UPDATE_KEY #24, #KEYM_UP, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #16, #KEYM_DOWN, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #8, #KEYM_LEFT, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #0, #KEYM_RIGHT, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER

    MOVE.L #KEY_Z<<24+KEY_X<<16+KEY_A<<8+KEY_S, D1
    TRAP #15

    UPDATE_KEY #24, #KEYM_Z, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #16, #KEYM_X, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #8, #KEYM_A, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER
    UPDATE_KEY #0, #KEYM_S, KEY_PRESS_PLAYER, KEY_HOLD_PLAYER


    MOVEM.L (SP)+, D1-D0

    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
