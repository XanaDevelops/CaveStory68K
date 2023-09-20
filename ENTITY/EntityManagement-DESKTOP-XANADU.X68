*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
INSTANCE_ENTITY:
    ; (SP) @ENT

    MOVE.L (SP), A0
    MOVE.W (A0), -(SP)
    SUBA.L #4, SP

    BSR FIND_FIRST_ID

    MOVE.L (SP)+, A1
    ADDA.L #2, SP
    CMPA.L #-1, A1
    BEQ _EXIT_INSTANCIATION
    MOVE.W #(ENT_SIZE_L/4)-1, D7
    CLR.L D1
    _INSTANTIATION_COPYLOOP:
        MOVE.L (A0)+, (A1, D1)
        ADDQ.W #4, D1
    DBRA D7, _INSTANTIATION_COPYLOOP
    
    MOVE.L A1, A0
    JSR 20(A1)
    _EXIT_INSTANCIATION:
    RTS
    
DESTROY_ENTITY:
    RTS

FIND_FIRST_ID:
    ; 20(SP) ID
    ; 16(SP) @
    ;DEVUELVE @ CUYO ID==BUSCADO, ELSE -1
    MOVEM.L D0/D7/A0, -(SP)
    LEA ENTITY_MEM, A0
    MOVE.W 20(SP), D0
    MOVE.W #NUM_ENT-1, D7
    _FFID:
        CMP.W (A0), D0
        BEQ _FINDED_ID
        ADDA.L #ENT_SIZE_L, A0
    DBRA D7, _FFID
    MOVEA.L #-1, A0
    _FINDED_ID:
    MOVE.L A0, 16(SP)

    MOVEM.L (SP)+, A0/D7/A0
    RTS
FIND_ALL_ID:
    RTS

ENTITY_FIND_ALL     DCB.L NUM_ENT,-1
ENTITY_MEM          DCB.L NUM_ENT*ENT_SIZE_L,0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
