*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TS_START:
    MOVEM.W D1/D7, -(SP)

    BSET.B #4, (GAMEFLAGS)
    ;INSTANCIAR NUBES
    SUBA.L #10, SP
    MOVE.W #3, D7
    MOVE.W #236, D1
    MOVE.L #CLOUD, (SP)
    .DLOOP:
    MOVE.W D7, 8(SP)
    MOVE.W #0, 6(SP)
    MOVE.W D1, 4(SP)
    JSR INSTANCE_ENTITY

    ADD.W #CLOUDXSIZE, 6(SP)
    JSR INSTANCE_ENTITY
    IFNE XPMODE
    ADD.W #CLOUDXSIZE, 6(SP)
    JSR INSTANCE_ENTITY
    ENDC

    ADD.W #50, D1

    DBRA D7, .DLOOP

    
    ADDA.L #10, SP
    MOVEM.W (SP)+, D7/D1
    RTS
TS_UPDATE:
    ;ESPERA Z
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ .NOSTART
    ;CARGA MAPA
    MOVE.W #1, -(SP) ;TODO PARTIDA GUARDADA
    JSR LOAD_MAP
    ADDQ.L #2, SP
    ;MUESTRA HUD
    BCLR.B #4, (GAMEFLAGS)
    BRA .END
    .NOSTART:


    .END:
    RTS

TS_DRAW:
    
    RTS

TITLESCREEN:
    DC.W 91                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;COLISION_BOX 44
    DC.L TS_START, TS_UPDATE, TS_DRAW               ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
