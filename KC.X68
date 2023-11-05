*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
KC_INIT:    ;POR UNA LINEA...
    CLR.W   (KC_C)
    ;CLR.B (KC_FW)
    RTS
KC_UPD:
    MOVEM.L D0-D1/A0, -(SP)
    ;CHECK TIMER
    SUBQ.B  #1, (KC_FW)
    BPL     .CANWAIT
    CLR.W   (KC_C)
    .CANWAIT:

    ;CHECK KEY
    LEA     KC_SEC, A0
    CLR.L   D0
    MOVE.B  (KC_C), D0
    ADDA.L  D0, A0
    MOVE.B  (A0), D1
    BTST.B  D1, (KEY_PRESS_PLAYER)
    BEQ .END
    ;OK
    ADDQ.B  #1, D0
    MOVE.B  #M_KCFW, (KC_FW)

    CMP.B   #M_KCC, D0
    BNE     .END
    BSR     KC_TRIGGER
    CLR.B   D0
    .END:
    MOVE.B  D0, (KC_C)

    MOVEM.L (SP)+, A0/D1-D0
    RTS
KC_TRIGGER:
    MOVE.W  #KCDIAGCD, -(SP)
    BSR     START_DBOX
    ADDQ.L  #2, SP

    CLR.B   (KC_C)
    RTS

KC_C    DC.B 0
KC_FW   DC.B 0

KC_SEC  DC.B KEYM_UP, KEYM_UP, KEYM_DOWN, KEYM_DOWN, KEYM_DOWN
        DC.B KEYM_LEFT, KEYM_RIGHT, KEYM_LEFT, KEYM_RIGHT, KEYM_Z, KEYM_X
        ;NO TENGO KEYM_START :(
        DS.W 0

M_KCC       EQU 11






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
