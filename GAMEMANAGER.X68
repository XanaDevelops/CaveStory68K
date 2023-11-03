*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_SAVE:
    ;CARGA LA PARTIDA GUARDADA, SI EXISTE
    MOVEM.L D0-D1, -(SP)

    MOVE.L #SAVEFPTH, -(SP)
    JSR OPEN_READ
    MOVE.L (SP)+, D0
    CMP.L #0, D0
    BNE .DEFAULT_SAVE
    ;LEER MAGIKN
    MOVE.L D0, -(SP)
    MOVE.L #IOFILEW, -(SP)
    MOVE.W #2, -(SP)
    JSR READ_FILE
    MOVE.W (SP)+, D1
    CMP.W #0, D1
    BEQ .NOERR
    .ERR:
    ;ERROR LECTURA
    ADDQ.L #4, SP
    JSR CLOSE
    ADDQ.L #4, SP
    BRA .DEFAULT_SAVE
    .NOERR:
    MOVE.W (IOFILEW), D1
    CMP.W #MAGIKN, D1
    BNE .ERR
    ;LEER PARTIDA GUARDADA
    MOVE.L #GAMEDATA, (SP)
    MOVE.W #GAMEDATASIZE, -(SP)
    JSR READ_FILE
    MOVE.W (SP)+, D1
    CMP.W #0, D1
    BNE .ERR
    ADDQ.L #4, SP
    JSR CLOSE
    ADDQ.L #4, SP

    BRA .END
    .DEFAULT_SAVE:
    MOVE.W #0,  (PLOTID)
    MOVE.W #1,  (CURRENTMAPID)
    MOVE.W #5,  (PACTHP)
    MOVE.W #10, (PMAXHP)
    MOVE.W #$0300, (ARMS_STS+0)
    MOVE.W #0,  (INVI_STS)
    MOVE.B #0,  (EQUIPARM)
   
    .END:
    MOVEM.L (SP)+, D1-D0
    RTS

GAME_SAVE:
    MOVEM.L D0-D1/A0, -(SP)

    ;GUARDA VALORES EN GAMEDATA
    MOVE.L (PLAYERREF), A0
    MOVE.W HP(A0), PACTHP

    ;ABRE ARCHIVO PARTIDA GUARDADA
    ;O LO CREA
    MOVE.L #SAVEFPTH, -(SP)
    JSR OPEN_WRITE
    MOVE.L (SP)+, D0
    CMP.L #0, D0
    BNE .ERR
    ;ESCRIBIR  MAGIKN
    MOVE.L D0, -(SP)
    MOVE.W #MAGIKN, (IOFILEW)
    MOVE.L #IOFILEW, -(SP)
    MOVE.W #2, -(SP)
    JSR WRITE_FILE
    MOVE.W (SP)+, D1
    CMP.W #0, D1
    BNE .ERR
    MOVE.L #GAMEDATA, (SP)
    MOVE.W #GAMEDATASIZE, -(SP)
    JSR WRITE_FILE
    MOVE.W (SP)+, D1
    CMP.W #0, D1
    BNE .ERR
    BRA .CLOSE
    .ERR:
    
    .CLOSE:
    ADDQ.L #4, SP
    JSR CLOSE
    ADDQ.L #4, SP

    MOVEM.L (SP)+, A0/D1-D0
    RTS

LOAD_MAP:
    ; 16(SP).W ID MAP
    MOVEM.L D0-D1/A0, -(SP)

    MOVE.W #-1, (CURRENTTXTID) ;QUITA DBOX

    JSR SLASHKILLA
    
    MOVE.W 16(SP), D0
    MOVE.W D0, CURRENTMAPID
    LEA MAPAS, A0
    ASL.W #2, D0                ;MULU #4
    MOVE.L (A0, D0), CURRENTMAPDIR

    BSR GENERATE_COLIMAP

    ;MUSICA
    LEA BGMMUS, A0
    ASR.W #2, D0
    CLR.L D1
    MOVE.B (A0, D0), D1 
    MOVE.W D1, -(SP)       
    JSR SEND_BGM
    ADDQ.L #2, SP
    ASL.W #2, D0

    LEA ENTINSTADA, A0      ;CARGAR ENTIDADES A
    MOVE.L (A0, D0.W), A0   ;INSTANCIAR
    
    CLR.L D1    ;MAS DE DOS HORAS CON TRACE PARA SABER QUE FALLABA ESTO, CAGONTO
    
    .INSTMLOOP:
    MOVE.W (A0)+, D0
    MOVE.W D0, D1
    CMP.W #-1, D0
    BEQ .ENDINSTS
    .ILOOP:
    MOVE.W (A0)+, -(SP)
    DBRA D0, .ILOOP
    JSR INSTANCE_ENTITY
    ADDQ.W #1, D1
    LSL.W #1, D1
    ADD.L D1, SP
    BRA .INSTMLOOP

.ENDINSTS:
    MOVEM.L (SP)+, A0/D1-D0
    RTS

GM_UPDATE:
    CMP.B #0, (PLYERDED)
    BEQ .ALIVE
    SUB.B #1, (WAITDED)
    BPL .WAIT
    CLR.B (WAITDED)

    BSET.B #7, (GAMEFLAGS)

    CMP.W #-1, (CURRENTTXTID)
    BNE .NOBTXT
    ;MUESTRA MENSAJE MUERTE
    MOVE.W #1, -(SP)
    BSR START_DBOX
    ADDQ.W #2, SP

    .NOBTXT:    
    ;ESPERA Z PLAYER
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ .NOZ
    ;REVIVE JUGADOR
    ;CARGA PARTIDA GUARDADA
    JSR LOAD_SAVE
    ;CARGA MAPA
    MOVE.W (CURRENTMAPID), D0
    MOVE.W D0, -(SP)
    BSR LOAD_MAP
    ADDQ.L #2, SP
    BCLR.B #7, (GAMEFLAGS)
    .NOZ:
    BRA .ALIVE
    
    .WAIT:
    ;ESPERA PARA SFX MUERTE
    CMP.B #0, (WAITDED)
    BNE .ALIVE
    ;REPRODUCE SFX
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
SAVEFPTH    DC.B 'SAVE.DAT',0
            DS.W 0
GAMEDATA:
    PLOTID:         DS.W 1 
    CURRENTMAPID:   DS.W 1
    PACTHP:         DS.W 1
    PMAXHP:         DS.W 1
    ARMS_STS:       DCB.B 10,0 ;(NIVEL).B(XP).B * 10 ARMAS (si las hago todas...)
    INVI_STS:       DS.W 1
    EQUIPARM:       DS.B 1
                    DS.W 0
    .ENDGAMEDATA:
GAMEDATASIZE    EQU .ENDGAMEDATA-PLOTID









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
