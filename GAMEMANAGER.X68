*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_MAP:
    ; (SP).W ID MAP
    BSR SLASHKILLA

    MOVE.W #-1, (CURRENTTXTID) ;QUITA DBOX

    MOVEM.L D0/A0, -(SP)

    MOVE.W 12(SP), D0
    MOVE.W D0, CURRENTMAPID
    LEA MAPAS, A0
    ASL.W #2, D0                ;MULU #4
    MOVE.L (A0, D0), CURRENTMAPDIR

    BSR GENERATE_COLIMAP

    ;PASAR A OTRO LUGAR, GENERACION MAPA #0
    MOVE.W #41, -(SP)       ;MUSICA
    JSR SEND_BGM
    ADDQ.L #2, SP
    
    MOVE.W #$120, -(SP)
    MOVE.W #$380, -(SP)
    MOVE.L #BAT, -(SP)
    BSR INSTANCE_ENTITY     ;DEBUG BATS

    MOVE.W #$140, 6(SP)
    MOVE.W #$400, 4(SP)
    MOVE.L #CARTEL, (SP)
    BSR INSTANCE_ENTITY
    
    ;BRA .ENDGM

    MOVE.L #BAT, (SP)

    MOVE.W #$220, 6(SP)
    MOVE.W #$400, 4(SP)
    BSR INSTANCE_ENTITY

    MOVE.W #20, D0
    .LOOPBORRAR:
    ADD.W #$30, 6(SP)
    BSR INSTANCE_ENTITY
    DBRA D0, .LOOPBORRAR

    BRA .ENDGM
    SUB.W #$40, 4(SP)
    MOVE.W #$220, 6(SP)
    MOVE.W #20, D0
    .LOOPBORRAR2:
    ADD.W #$30, 6(SP)
    BSR INSTANCE_ENTITY
    DBRA D0, .LOOPBORRAR2

    .ENDGM:

    ADDA.L #8, SP       ;OJO CON ESTO, DEBUG BATS

    MOVE.L #PLAYER, -(SP)
    BSR INSTANCE_ENTITY

    ADDQ.L #4, SP


    MOVEM.L (SP)+, A0/D0
    RTS

GM_UPDATE:
    CMP.B #0, (PLYERDED)
    BEQ .ALIVE
    SUB.B #1, (WAITDED)
    BPL .WAIT
    CLR.B (WAITDED)

    BSET.B #7, (GAMEFLAGS)

    ;MOVE.B #11, D0
    ;MOVE.W #$1005, D1
    ;TRAP #15
    ;MOVE.B #14, D0
    ;LEA GOVERTEXT, A1
    ;TRAP #15
    CMP.W #-1, (CURRENTTXTID)
    BNE .NOBTXT
    MOVE.W #1, -(SP)
    BSR START_DBOX
    ADDQ.W #2, SP

    .NOBTXT:    
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ .NOZ
    MOVE.W CURRENTMAPID, D0
    MOVE.W D0, -(SP)
    BSR LOAD_MAP
    ADDQ.L #2, SP
    BCLR.B #7, (GAMEFLAGS)
    .NOZ:

    BRA .ALIVE
    .WAIT:
    CMP.B #0, (WAITDED)
    BNE .ALIVE
    MOVE.W #9, -(SP)
    JSR SEND_BGM
    ADDQ.L #2, SP
    .ALIVE:
    RTS

GM_PLYRDED:
    MOVE.B #1, (PLYERDED)
    MOVE.B #WAITDEDT, (WAITDED)

    JSR STOP_BGM

    RTS


PLAYERREF   DS.L 1
PLYERDED    DC.B 0
WAITDED     DC.B 0
GOVERTEXT  DC.B 'GAME OVER: PULSA Z PARA CONTINUAR',0







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
