*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_MAP:
    ; (SP).W ID MAP
    MOVEM.L D0/A0, -(SP)

    MOVE.W #-1, (CURRENTTXTID) ;QUITA DBOX

    JSR SLASHKILLA
    
    MOVE.W 12(SP), D0
    MOVE.W D0, CURRENTMAPID
    LEA MAPAS, A0
    ASL.W #2, D0                ;MULU #4
    MOVE.L (A0, D0), CURRENTMAPDIR

    BSR GENERATE_COLIMAP

    MOVE.W #41, -(SP)       ;MUSICA
    JSR SEND_BGM
    ADDQ.L #2, SP

    LEA ENTINSTADA, A0      ;CARGAR ENTIDADES A
    MOVE.L (A0, D0.W), A0   ;INSTANCIAR

    .INSTMLOOP:
    MOVE.W (A0)+, D0
    MOVE.W D0, D1
    CMP.W #-1, D0
    BEQ .ENDINSTS
    .ILOOP:
    MOVE.W (A0)+, -(SP)
    DBRA D0, .ILOOP
    BSR INSTANCE_ENTITY
    ADDQ.W #1, D1
    LSL.W #1, D1
    ADD.L D1, SP
    BRA .INSTMLOOP

.ENDINSTS:
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
