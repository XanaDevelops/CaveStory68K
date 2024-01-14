*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

START_DBOX:
    ; 4(SP).W ET_ID
    MOVE.W  4(SP), (CURRENTTXTID) 

    ANDI.B  #%00010111, (GAMEFLAGS)
    BSET.B  #7, (GAMEFLAGS)
    CLR.W   (HASPORTTR)
    CLR.W   (TXTINDEX)
    CLR.W   (DIAGINDEX)
    CLR.W   (MORELINES)
    CLR.W   (SPOFFSET)
    CLR.B   (CUNIC)
    CLR.W   (SINRQ)     ;W PARA SINGR
    CLR.B   (TWAIT)

    JSR     SET_SCROLL_TEXT

    RTS
UPDATE_DBOX:
    ;COMPRUEBA SI EXISTE UN DIALOGO ACTIVO
    CMP.W   #-1, (CURRENTTXTID)
    BEQ     .NONLINE
    ;COMPRUEBA FLAG DBOX END
    BTST.B  #6, (GAMEFLAGS)
    BEQ     .NOEND
    ;ESPERA Z
    BTST.B  #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ     .NONLINE
    ;ESTABLECE FLAGS
    MOVE.W  #-1, (CURRENTTXTID)
    BCLR.B  #7, (GAMEFLAGS)
    BCLR.B  #KEYM_Z, (KEY_PRESS_PLAYER)  ;BUG SALTO SALIR DBOX
    BCLR.B  #KEYM_Z, (KEY_HOLD_PLAYER)
    RTS                 ;A VER QUE TAL RTS AHÍ, POR SI LUEGO MUEVO REGISTROS
    .NOEND:
    ;SKIP UPDATE?
    BTST.B  #3, (GAMEFLAGS)
    BNE     .NONLINE
    .NOWZ:
    ;AVANCE RAPIDO
    BTST.B  #KEYM_X, (KEY_HOLD_PLAYER)
    BNE     .SITIM
    SUBQ.W  #1, (TXTDELAYV)
    BPL     .NOTIM
    .SITIM:
        MOVE.W  #TXTDELAY, (TXTDELAYV)
        ADDQ.W  #1, (TXTINDEX)
    .NOTIM:
    ;COMPRUEBA FLAG LINEA
    BTST.B  #5, (GAMEFLAGS)
    BNE     .SILINE
    ;PREVIENE LINEAS MUY LARGAS
    CMP.W   #38, (TXTINDEX)
    BLT     .NONLINE
    .SILINE:
    ;AVANZA LINEA
    CLR.W   (TXTINDEX)
    BCLR.B  #5, (GAMEFLAGS)
    ;COMPRUEBA SI SCROLL
    CMP.W   #MAXLINES-1, (MORELINES)
    BLT     .NOSCR
    ;INCIO DE LINEA
    ADDQ.W  #1, (DIAGINDEX)
    BRA     .NONLINE
    .NOSCR:
    ;NUMERO DE LINEAS A DIBUJAR
    ADDQ.W  #1, (MORELINES)
    .NONLINE:
    RTS

DRAW_DBOX:
    MOVEM.L D0-D4, -(SP)

    CMP.W   #-1, (CURRENTTXTID)
    BEQ     .END

    ;COM SINGLE
    CLR.B   (CUNIC)

    ;COLORES RECUADRO
    MOVE.B  #80, D0
    MOVE.L  #WHITE, D1
    TRAP    #15
    ADDQ.B  #1, D0
    MOVE.L  #BLACK, D1
    TRAP    #15

    ADDQ.B  #6, D0           ;Recuadro
    MOVE.W  #.DBOXX1, D1
    MOVE.W  #.DBOXY1, D2
    MOVE.W  #.DBOXX2, D3
    MOVE.W  #.DBOXY2, D4
    TRAP    #15

    ;POSICION INICIAL TEXTO
    MOVE.W  #DBOXTS, D3

    CLR.L   D1                    ;CARGA FRASES DIALOGO
    MOVE.W  (CURRENTTXTID), D1
    LSL.W   #2, D1

    LEA     ALLDIALOGS, A6
    MOVE.L  (A6, D1), A6

    MOVE.W  (MORELINES), D4
    ;SUBQ.W  #1, D4

    MOVE.W  (DIAGINDEX), D2  ;FRASE INICIAL
    LSL.W   #2, D2

    .LOOPDBOX:
    MOVE.B  #11, D0          ;POS INICIAL
    MOVE.W  D3, D1 ;081B  (COL|FILA)
    TRAP    #15

    ;FRASE A ESCRIBIR
    MOVE.L  (A6, D2.W), A1
    CMP.L   #-1, A1
    BEQ     .ENDF
    TST.W   D4
    BEQ     .LASTLINEA
    MOVE.W   #40, D5  ;MAX CARACTERS -1
    BRA     .LOOPFRASE
    .LASTLINEA:
    ;CARACTERS DE LA LINEA FINAL
    MOVE.W  (TXTINDEX), D5
    ;SUBQ.W  #1, D5
    .LOOPFRASE:
    ;NO TOCAR D2, D3, D4, D5
    CLR.L   D1
    MOVE.B  (A1), D1 ;SIGUENTE CARACTER
    CMP.W   #CDBCCOL, D1 ;COMPARACIONES EN W
    BLT     .NOCODE
    ;EJECUTA DBCODE
    MOVE.W  D1, -(SP)
    BSR     DBCODES
    MOVE.W  (SP)+, D1
    ;FORZAR SALIDA? CDBDIAG O SIMILAR?
    CMP.W #0, D1
    BEQ .END
    ADDQ.W  #1, D5 ;POR CONSUMIR CODIGO
    DBRA    D5, .LOOPFRASE
    .NOCODE:
    CMP.B #0, D1
    BNE .NOENDL
    ;MARCA SIGUIENTE LINEA
    CLR.W   D5 ;FORZAR SALTO LINEA
    TST.W   D4  ;SOLO MARCAR NUEVA LINEA SI ULTIMA LINEA
    BNE     .NOENDL
    BSET.B  #5, (GAMEFLAGS)
    .NOENDL:
    ;PINTAR CARACTER
    MOVE.B  #1, D0
    MOVE.W  #1, D1
    TRAP    #15
    ADDQ.L  #1, A1

    ;NO SND SI PAUSA
    BTST.B  #3, (GAMEFLAGS)
    BNE     .NOSND
    ;SONIDO TEXTO
    MOVE.L  A1, D1
    BTST.L  #0, D1
    BEQ     .NOSND
    MOVE.W  #6, -(SP)
    MOVE.W  #0, -(SP)
    JSR     PLAY_SFX
    ADDQ.L  #4, SP
    .NOSND:
    DBRA    D5, .LOOPFRASE

    ADDQ.W  #1, D3          ;BAJAR LINEA
    ADDQ.L  #4, D2          ;SIGUIENTE LINEA AD
    DBRA    D4, .LOOPDBOX   ;SIGUIENTE LINEA
    BRA     .END
    .ENDF:
    ;MARCA FINAL
    BSET.B  #6, (GAMEFLAGS)
    BSET.B  #3, (GAMEFLAGS)
    .END:
    MOVEM.L (SP)+, D4-D0
    RTS

.DBOXX1          EQU 20
.DBOXX2          EQU SCREEN_WIDTH-20
.DBOXY1          EQU (SCREEN_HEIGHT/2)+80
.DBOXY2          EQU SCREEN_HEIGHT-20

DBCODES:
    ;EJECUTA LOS DIFERENTES DB CODES
    ;NOTAS:
    ;   TODO OPTIMIZAR VALORES SINGLE
    ;   SIGLE CON PARAMETROS DESPLAZAR A1 IGUALMENTE
    ; (SP) ET_ID DB CODE >=$A0 -> 0 SI SALIDA DRAW_DBOX
    ; MODIFICA A1, D1
    
    MOVEM.L D0/D2-D3/D7/A0, -(SP)
    
    ;AVANZA A1
    ADDQ.L  #1, A1

    ;OBTIENE ET_ID
    MOVE.W  24(SP), D7
    BRA     .DECODE

    .NEXTCODE:
    MOVE.B (A1)+, D7
    ;NECESARIO ACTUALIZAR LOS VALORES
    MOVE.B  D0, (CUNIC)
    MOVE.B  D2, (SINRQ)
    MOVE.B  D3, (SINGR)
    .DECODE:
    ;COMPRUEBA CDBCCOL
    CMP.W   #CDBCCOL, D7
    BNE     .NOCCOL
    ;LEE COLOR EN D2, CAMBIA COLOR
    BSR     .READLD2
    MOVE.L  D2, -(SP)
    JSR     SET_COLOR_TEXT
    ADDQ.L  #4, SP
    BRA     .ENDCLR
    .NOCCOL:
    ;COMPRUEBA COLORES PREFIJADOS
    CMP.W   #CDBDIAG, D7
    BGT     .NOPCOL
    SUB.W   #$A1, D7
    ASL.W   #2, D7
    LEA     .CDBCOLORS, A0
    MOVE.L  (A0, D7), -(SP)
    JSR     SET_COLOR_TEXT
    ADDQ.L  #4, SP
    BRA     .ENDCLR
    .NOPCOL:

    ;SALTO $BX
    SUB.W   #$B0, D7
    ASL.W   #2, D7
    LEA     .JMPTABLE, A0
    MOVE.L  (A0, D7), A0
    ;VALORES SINGLE
    MOVE.B  (CUNIC), D0
    MOVE.B  (SINRQ), D2
    MOVE.B  (SINGR), D3
    JMP     (A0)
.END:
    MOVE.B  D0, (CUNIC)
    MOVE.B  D2, (SINRQ)
    MOVE.B  D3, (SINGR)
.ENDCLR:
    MOVEM.L (SP)+, A0/D7/D3-D2/D0
    RTS

.CDIAG:
    ;
    BRA     .END
.CEXE:
    ;SALTA SUBR -> @.L
    MOVE.B  D2, D7
    CMP.B   D0, D7
    BNE     .NOEXEC
    ;EXEC
    ADDQ.B  #1, D7
    ADDQ.B  #1, D3

    BSR     .READLD2
    MOVE.L  D2, A0
    JSR     (A0)
    ADD.W   (SPOFFSET), SP
    CLR.W   (SPOFFSET)
    BRA     .ENDEXE
    .NOEXEC:
    ;ADDQ.L  #4, A1
    BSR     .READLD2  ;PONER PARIDAD PARCHE
    .ENDEXE:
    ADDQ.B  #1, D0
    MOVE.B  D7, D2

    BRA     .END
.CPUSHNW:
    ;PUSH WORD A SP -> N.W
    MOVE.B  D2, D7

    CMP.B   D0, D7
    BNE     .NOPUSHNW
    ADDQ.B  #1, D7
    ADDQ.B  #1, D3

    ADDQ.W  #2, (SPOFFSET)
    BSR     .READWD2
    MOVE.W  D2, -(SP)
    BRA     .ENDPSHNW
    .NOPUSHNW:
    ;ADDQ.L  #2, A1
    BSR     .READWD2  ;PONER PARIDAD PARCHE
    .ENDPSHNW:
    ADDQ.B  #1, D0
    MOVE.B  D7, D2
    BRA     .NEXTCODE ;MODIFICADA LA PILA, NO RTS!
.CPUSHDW:
    ;PUSH SP WORD EN @, -> (@.L).W
    MOVE.B  D2, D7

    CMP.B   D0, D7
    BNE     .NOPUSHDW
    ADDQ.B  #1, D7
    ADDQ.B  #1, D3

    ADDQ.W  #2, (SPOFFSET)
    BSR     .READLD2
    MOVE.L  D2, A0
    MOVE.W  (A0), -(SP)
    BRA     .ENDPSHDW
    .NOPUSHDW:
    ;ADDQ.L  #4, A1
    BSR     .READLD2  ;PONER PARIDAD PARCHE
    .ENDPSHDW:
    ADDQ.B  #1, D0
    MOVE.B  D7, D2
    BRA     .NEXTCODE
.CSINGLE:
    ; MARCA LA EJECUCION UNICA HASTA CDBSINGEND
    CMP.B   D0, D2
    BEQ     .SISIN
    ;YA SE HA EJECUTADO
    ;AVANZAR HASTA CDBSINGEND
    CMP.B   D0, D3
    BNE     .NOLOOP
    ADDQ.B  #1, D3
    .NOLOOP:
    MOVE.B  (A1)+, D7
    CMP.B   #CDBDSINGEND, D7
    BNE     .NOLOOP
    BRA     .END
    .SISIN:
    ADDQ.B  #1, D2

    .ENDCSG:
    ADDQ.B  #1, D0
    
    BRA     .END
.CSINGLEN:
    ;CODIGO MARCADOR, NO HACE NADA
    BRA     .END
.CWAITZ:
    ;
    CMP.B   D0, D2
    BEQ     .WAIT
    CMP.B   D0, D3
    BNE     .PREEND
    BTST.B  #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ     .DEXIT
    ADDQ.B  #1, D3
    BCLR.B  #3, (GAMEFLAGS)
    BRA     .PREEND
    .WAIT:
    ;ACTIVAR ESPERA
    ADDQ.B  #1, D2
    BSET.B  #3, (GAMEFLAGS)
    .DEXIT:
    CLR.W  24(SP) ;QUEREMOS SALIR 
    .PREEND:
    ADDQ.B  #1, D0
    BRA     .END
.CWAITT:
    ;ESPERA FRAMES -> N.B
    MOVE.B  (TWAIT), D7

    CMP.B   D0, D2
    BEQ     .SWAIT
    ;BAJAR FRAME **MIRAR XPMODE
    CMP.B   D0, D3
    BNE     .WAITTS
    SUBQ.B  #1, D7
    BMI     .ENDWAIT
    CLR.W   24(SP)
    BRA     .WAITTS
    .ENDWAIT:
    CLR.B   D7
    BCLR.B  #3, (GAMEFLAGS)
    ADDQ.B  #1, D3
    BRA     .WAITTS
    .SWAIT:
    ;REALIZAR ESPERA
    MOVE.B  (A1)+, D7
    ADDQ.B  #1, D2
    BSET.B  #3, (GAMEFLAGS)
    BRA     .ENDWT
    .WAITTS:
    ADDQ.L  #1, A1
    .ENDWT:
    MOVE.B  D7, (TWAIT)

    ADDQ.B  #1, D0
    BRA     .END
.CASKYN:
    BRA     .END
.CSFX:
    BRA     .END
.CBGM:
    ;REPRODUCE BGM -> ET_ID.B
    CMP.B   D0, D2
    BNE     .NOBGM

    ADDQ.B  #1, D2
    ADDQ.B  #1, D3
    
    CLR.L D7
    MOVE.B  (A1)+, D7
    MOVE.W  D7, -(SP)
    JSR     SEND_BGM
    ADDQ.L  #2, SP
    BRA     .ENDBGM
    .NOBGM:
    ADDQ.L  #1, A1  ;DESPLAZAR IGUALMENTE
    .ENDBGM:
    ADDQ.B  #1, D0
    BRA     .END
.CHPM:
    ;CURA AL JUGADOR AL MAXIMO
    CMP.B   D0, D2
    BNE     .ENDHPM
    ADDQ.B  #1, D2
    ADDQ.B  #1, D3
    MOVE.L  (PLAYERREF), A0
    MOVE.W  MAXHEALTH(A0), ET_HP(A0)

    .ENDHPM:
    ADDQ.B  #1, D0
    BRA     .END

    ;-- COMANDOS AUXILIARES ---;
    ;LEER BYTE A BYTE POR PARIDAD, REHACER POR NO USAR DC.B
    .READWD2:
        MOVE.W  D7, -(SP)
        MOVE.W  #1, D7
        ADDQ.W  #2, D1
        BRA     .READD2
    .READLD2:
        MOVE.W  D7, -(SP)
        MOVE.W  #3, D7
        ADDQ.W  #4, D1
    .READD2:
        MOVE.L  A1, D2
        ;A1 DEBERIA SER PAR
        BTST.L  #0, D2
        BEQ     .PAR
        ADDQ.L #1, A1
        .PAR:
        CLR.L   D2
        .READLP:
        ASL.L   #8, D2
        MOVE.B  (A1)+, D2
        DBRA    D7, .READLP
        MOVE.W (SP)+, D7
        RTS

    .CDBCOLORS:     DC.L RED, BLACK, WHITE
    .JMPTABLE:      DC.L .CDIAG, .CEXE, .CPUSHNW, .CPUSHDW, .CSINGLE, .CSINGLEN, .CWAITZ, .CWAITT
                    DC.L .CASKYN, .CSFX, .CBGM, .CHPM
CURRENTTXTID    DS.W 1
HASPORTTR       DS.W 1
TXTINDEX        DS.W 1
DIAGINDEX       DS.W 1
MORELINES       DS.W 1
TXTDELAYV       DS.W 1
SPOFFSET        DS.W 1
SINRQ           DS.B 1  ;QUE SE DEBEN EJECUTAR
SINGR           DS.B 1  ;UNA VEZ
CUNIC         DS.B 1  ;CONTROLA CODIGOS 
TWAIT           DS.B 1
                DS.W 0

TXTDELAY        EQU 1

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
