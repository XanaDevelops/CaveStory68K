*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
DEFAULT_INTERACTION:
    ; 8(SP) -> A0 ENDITDAD
    MOVEM.L D0/A0, -(SP)

    MOVE.L 12(SP), A0

    MOVE.W ID(A0), D0
    SUB.W #50, D0
    LEA .INTERACTIONS, A1
    LSL.W #2, D0
    JSR (A1, D0.W)
    
    MOVEM.L (SP)+, A0/D0
    RTS

.INTERACTIONS:  DC.L .TXTDIAG

.TXTDIAG:
    MOVE.W INTERACT_ID(A0), -(SP)
    BSR START_DBOX
    ADDQ.L #2, SP

    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
