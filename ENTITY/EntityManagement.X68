*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
INSTANCE_ENTITY:
    ; 20(SP) @ENT
    MOVEM.L D1/D7/A0-A1, -(SP)

    MOVE.L 20(SP), A0
    MOVE.W #0, -(SP)
    SUBA.L #4, SP

    BSR FIND_FIRST_ID

    MOVE.L (SP)+, A1
    ADDA.L #2, SP
    CMPA.L #-1, A1
    BEQ .ENDINST

    MOVE.W #(ENT_SIZE_L/4)-1, D7
    CLR.L D1
    .COPYLOOP:
        MOVE.L (A0)+, (A1, D1)
        ADDQ.W #4, D1
    DBRA D7, .COPYLOOP
    
    MOVE.L A1, A0
    MOVE.L 22(A0), A1
    JSR (A1)                          ;START
    .ENDINST:
    MOVE.L A0, 20(SP)
    
    MOVEM.L (SP)+, A1-A0/D7/D1
    RTS
    
DESTROY_ENTITY:
    ; (SP) @ENT A ELIMINAR
    MOVE.L A0, -(SP)
    
    MOVE.L 8(SP), A0
    CLR.W (A0)
    
    MOVE.L (SP)+, A0
    RTS

SLASHKILLA: ;/kill @e
    MOVEM.L D7/A0, -(SP)
    LEA ENTITY_MEM, A0
    MOVE.W #NUM_ENT-1, D7
    .KILLALOOP:
        MOVE.W #0, ID(A0)
        ADDA.L #ENT_SIZE_L, A0
    DBRA D7, .KILLALOOP
    
    MOVEM.L (SP)+, A0/D7
    RTS

UPDATE_ALL_ENT:
    MOVEM.L D7/A0-A1, -(SP)

    LEA ENTITY_MEM, A0
    MOVE.W #NUM_ENT-1, D7
    _UPDATE_ALL_LOOP:
        CMP.W #0, (A0)
        BEQ _ES_0_UPDLP
            MOVE.L 26(A0), A1
            JSR (A1)
        _ES_0_UPDLP:
        ADDA.L #ENT_SIZE_L, A0
        DBRA D7, _UPDATE_ALL_LOOP
    MOVEM.L (SP)+, A1-A0/D7
    RTS
DRAW_ALL_ENT:
    MOVEM.L D7/A0-A1, -(SP)

    LEA ENTITY_MEM, A0
    MOVE.W #NUM_ENT-1, D7
    _DRAW_ALL_LOOP:
        CMP.W #0, (A0)
        BEQ _ES_0_DRWLP
            MOVE.L 30(A0), A1
            JSR (A1)
        _ES_0_DRWLP:
        ADDA.L #ENT_SIZE_L, A0
        DBRA D7, _DRAW_ALL_LOOP
    MOVEM.L (SP)+, A1-A0/D7
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

    MOVEM.L (SP)+, A0/D7/D0
    RTS

FIND_ALL_ID:
    RTS

DEFAULT_PAINT:
    MOVE.L A0, -(SP)
    SUBA.L #2, SP
    
    BSR IS_OUT_DISPLAY
    ADDA.L #6, SP
    CMP.W #0, -6(SP)
    BNE .SKIPDP

    MOVEM.L D0-D1/A1-A2, -(SP)

    MOVE.L AD_SPRITE(A0), A1
    MOVE.L SPRITE_INDEX(A0), D1

    ASL.L #2, D1
    MOVE.L 4(A1, D1), A2

    MOVE.L A2, -(SP)
    MOVE.W YPOS(A0), D0
    SUB.W (SCREEN_Y), D0
    MOVE.W D0, -(SP)
    MOVE.W XPOS(A0), D0
    SUB.W (SCREEN_X), D0
    MOVE.W D0, -(SP)

    JSR FASTSPRITE

    ADDQ.L #8, SP

    IFNE DEBUG
        MOVE.B #90, D0
        ADDA.L #COLISION_BOX, A0
        MOVEM.W (A0)+, D1-D4
        SUBA.L #AD_START, A0
        ADD.W XPOS(A0), D1
        ADD.W XPOS(A0), D3
        ADD.W YPOS(A0), D2
        ADD.W YPOS(A0), D4
        SUB.W SCREEN_X, D1
        SUB.W SCREEN_X, D3
        SUB.W SCREEN_Y, D2
        SUB.W SCREEN_Y, D4
        TRAP #15
    ENDC

    MOVEM.L (SP)+, A2-A1/D1-D0
    .SKIPDP:
    RTS

IS_OUT_DISPLAY:
    ;DEVUELVE 1 SI SU HITBOX SE ENCUENTRA FUERA
    ;38(SP).L A0
    ;36(SP).W RET
    MOVEM.L D0-D6/A0, -(SP)

    CLR.W 36(SP)

    MOVE.L 38(SP), A0
    ADDA.L #14, A0
    MOVEM.W (A0)+, D2-D5 ;XY XY
    SUBA.L #22, A0

    MOVE.W XPOS(A0), D0
    MOVE.W YPOS(A0), D1
    SUB.W (SCREEN_X), D0
    SUB.W (SCREEN_Y), D1

    MOVE.W D0, D6
    ADD.W D2, D6
    CMP.W #SCREEN_WIDTH, D6
    BGT .OD
    MOVE.W D0, D6
    ADD.W D4, D6
    CMP.W #0, D6
    BLT .OD
    MOVE.W D1, D6
    ADD.W D3, D6
    CMP.W  #SCREEN_HEIGHT, D6
    BGT .OD
    MOVE.W D1, D6
    ADD.W D5, D6
    CMP.W #0, D6
    BGE .ENDOD
    .OD:
    MOVE.W #1, 36(SP)
    .ENDOD:
    MOVEM.L (SP)+, A0/D6-D0
    RTS

DEFAULT_RTS:
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
