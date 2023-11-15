*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_SAVE:
    ;CARGA LA PARTIDA GUARDADA, SI EXISTE
    MOVEM.L D0-D1, -(SP)

    MOVE.L  #SAVEFPTH, -(SP)
    JSR     OPEN_READ
    MOVE.L  (SP)+, D0
    CMP.L   #0, D0
    BNE     .DEFAULT_SAVE
    ;LEER MAGIKN
    MOVE.L  D0, -(SP)
    MOVE.L  #IOFILEW, -(SP)
    MOVE.W  #2, -(SP)
    JSR     READ_FILE       ;BUG SI MUSIC SERVER
    MOVE.W  (SP)+, D1
    CMP.W   #0, D1
    BEQ     .NOERR
    .ERR:
    ;ERROR LECTURA
    ADDQ.L  #4, SP
    JSR     CLOSEFILE
    ADDQ.L  #4, SP
    BRA     .DEFAULT_SAVE
    .NOERR:
    MOVE.W  (IOFILEW), D1
    CMP.W   #MAGIKN, D1
    BNE     .ERR
    ;LEER PARTIDA GUARDADA
    MOVE.L  #GAMEDATA, (SP)
    MOVE.W  #GAMEDATASIZE, -(SP)
    JSR     READ_FILE
    MOVE.W  (SP)+, D1
    CMP.W   #0, D1
    BNE     .ERR
    ADDQ.L  #4, SP
    JSR     CLOSEFILE
    ADDQ.L  #4, SP

    BRA .END
    .DEFAULT_SAVE:
    MOVE.W #0,  (PLOTID)
    MOVE.W #1,  (CURRENTMAPID)
    MOVE.W #-1, (SPAWNX)   ;TODO
    MOVE.W #-1, (SPAWNY)   ;TODO
    MOVE.W #5,  (PACTHP)
    MOVE.W #10, (PMAXHP)
    MOVE.W #$0100, (ARMS_STS+0)
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
    JSR CLOSEFILE
    ADDQ.L #4, SP

    MOVEM.L (SP)+, A0/D1-D0
    RTS

LOAD_MAP:
    ; (SP).W ID MAP
    MOVE.W  4(SP), (LOAD_MAP_ID)
    MOVE.B  #1, (LOAD_MAP_ST)
    BSET.B  #7, (GAMEFLAGS)
    IFNE    FLG_TRANS
    ;ACTIVAR TRANS
    MOVE.B  #1, (TRANS_STATUS)
    ENDC
    IFEQ    FLG_TRANS
    BSR DO_LOAD_MAP
    ENDC
    RTS

DO_LOAD_MAP:
    ; 16(SP).W ID MAP
    MOVEM.L D0-D1/A0, -(SP)

    MOVE.W  #-1, (CURRENTTXTID) ;QUITA DBOX
    BCLR.B   #7, (GAMEFLAGS)

    CLR.B   (LOAD_MAP_ST)

    ;GUARDAR VALORES PLAYER
    MOVE.L  (PLAYERREF), A0
    CMP.L   #0, A0
    BMI     .NOPREF
    MOVE.W  HP(A0), (PACTHP)
    .NOPREF:
    JSR     SLASHKILLA
    
    MOVE.W  (LOAD_MAP_ID), D0
    MOVE.W  D0, CURRENTMAPID
    LEA     MAPS, A0
    ASL.W   #2, D0                ;MULU #4
    MOVE.L  (A0, D0), CURRENTMAPDIR

    BSR     GENERATE_COLIMAP

    ;MUSICA
    LEA     BGMMUS, A0
    ASR.W   #2, D0
    CLR.L   D1
    MOVE.B  (A0, D0), D1 
    MOVE.W  D1, -(SP)       
    JSR     SEND_BGM
    ADDQ.L  #2, SP
    ASL.W   #2, D0

    LEA     ENTINSTDATA, A0      ;CARGAR ENTIDADES A
    MOVE.L  (A0, D0.W), A0   ;INSTANCIAR
    
    CLR.L   D1    ;MAS DE DOS HORAS CON TRACE PARA SABER QUE FALLABA ESTO, CAGONTO
    
    ;MUESTRA HUD, ANTES DE ENTIDAD POR SI DESABILITAN
    BCLR.B  #4, (GAMEFLAGS)

    .INSTMLOOP:
    MOVE.W  (A0)+, D0
    MOVE.W  D0, D1
    CMP.W   #-1, D0
    BEQ     .ENDINSTS
    .ILOOP:
    MOVE.W  (A0)+, -(SP)
    DBRA    D0, .ILOOP
    JSR     INSTANCE_ENTITY
    ADDQ.W  #1, D1
    LSL.W   #1, D1
    ADD.L   D1, SP
    BRA     .INSTMLOOP

.ENDINSTS:
    

    MOVEM.L     (SP)+, A0/D1-D0
    RTS

GM_UPDATE:
    CMP.B   #1, (LOAD_MAP_ST)
    BNE     .NOLMAP
    CMP.B   #2, (TRANS_STATUS)
    BNE     .NOLMAP
    MOVE.B  #3, (TRANS_STATUS)
    CLR.B   (LOAD_MAP_ST)
    BSR     DO_LOAD_MAP
    .NOLMAP:


    TST.B   (PLYERDED)
    BEQ     .ALIVE
    ;JUGADOR MUERTO
    SUB.B   #1, (WAITDED)
    BPL     .WAIT
    ;FIN ESPERA MUERTE
    CLR.B   (WAITDED)

    BSET.B  #7, (GAMEFLAGS)

    CMP.W   #-1, (CURRENTTXTID)
    BNE     .ALIVE
    ;MUESTRA MENSAJE MUERTE
    MOVE.W  #1, -(SP)
    BSR     START_DBOX
    ADDQ.W  #2, SP
    BRA     .ALIVE
    
    .WAIT:  ;LO DEJO POR SI ACASO...
    .ALIVE:

    RTS

GM_UPD_BLTXP:
    MOVEM.L D0-D3/A0, -(SP)
    ; (SP).W XP A ACTUALIZAR
    ; SOBRE ARMA ACTUAL    
    MOVE.W 24(SP), D0

    ;OBTENER XP, ARMA ACTUAL
    LEA ARMS_STS, A0
    CLR.L D1    ;ID ARMA
    CLR.L D2    ;XP
    CLR.L D3    ;LVL
    MOVE.B (EQUIPARM), D1
    MOVE.B D1, D3
    MOVE.W (A0, D1), D3
    MOVE.B D3, D2
    LSR.W #8, D3

    ;TODO DIFERENTES XP PARA SUBIR DE NIVEL
    ;AHORA SOLO SUMAR XP CAP 20 -> LVL UP
    ADD.W D0, D2
    BLT .LVLDOWN
    CMP.W #20, D2
    BLT .NOLVLUP
    ;SUBIR DE NIVEL, XP=0, LVL++ CAP.3
    CMP.W #3, D3
    BLT .NOMAXLVL
    ;MOVE.W #3, D3
    MOVE.W #20, D2
    BRA .END
    .NOMAXLVL:
    ADDQ.W #1, D3
    CLR.L D2
    .NOLVLUP:
    BRA .END

    .LVLDOWN:
    SUBQ.W #1, D3
    CMP.W #1, D3
    BGE .NOLVLZ
    MOVE.W #1, D3
    CLR.W D2
    BRA .END
    .NOLVLZ:
    ADD.W #20, D2
    .END:
    MOVE.B D2, 1(A0, D1)
    MOVE.B D3, (A0, D1)

    MOVEM.L (SP)+, A0/D3-D0
    RTS

GM_PLYRDED:
    MOVE.B #1, (PLYERDED)
    MOVE.B #WAITDEDT, (WAITDED)

    JSR STOP_BGM

    RTS


PLAYERREF   DS.L 1
PLYERDED    DC.B 0
WAITDED     DC.B 0
LOAD_MAP_ST DC.B 0 ;0: NADA, 1: ESPERA TRANS
            DS.W 0
LOAD_MAP_ID DC.W 0 ;ID A CARGAR
SAVEFPTH    DC.B 'SAVE.DAT',0
            DS.W 0
GAMEDATA:
    PLOTID:         DS.W 1 
    CURRENTMAPID:   DS.W 1
    SPAWNX:         DS.W 1
    SPAWNY:         DS.W 1
    PACTHP:         DS.W 1
    PMAXHP:         DS.W 1
    ARMS_STS:       DCB.B 10,0 ;(NIVEL).B(XP).B * 10 ARMAS lvl=0 BLOCK
    INVI_STS:       DS.W 1
    EQUIPARM:       DS.B 1
                    DS.W 0
    .ENDGAMEDATA:
GAMEDATASIZE    EQU .ENDGAMEDATA-PLOTID














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
