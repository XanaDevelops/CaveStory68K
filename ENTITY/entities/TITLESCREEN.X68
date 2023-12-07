*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TS_START:
    MOVEM.W D1/D7, -(SP)

    BSET.B  #4, (GAMEFLAGS)
    ;INSTANCIAR NUBES
    SUBA.L  #10, SP
    MOVE.W  #3, D7
    MOVE.W  #SCREEN_HEIGHT-274, D1
    MOVE.L  #CLOUD, (SP)
    .DLOOP:
    MOVE.W  D7, 8(SP)
    MOVE.W  #0, 6(SP)
    MOVE.W  D1, 4(SP)
    JSR     INSTANCE_ENTITY

    ADD.W   #CLOUDXSIZE, 6(SP)
    JSR     INSTANCE_ENTITY
    ;PANTALLA MÁS GRANDE, NUBE EXTRA
    IFNE XPMODE
    ADD.W   #CLOUDXSIZE, 6(SP)
    JSR     INSTANCE_ENTITY
    ENDC

    ADD.W   #50, D1

    DBRA    D7, .DLOOP
    ADDA.L  #10, SP
    
    MOVE.L  #.TEXTD, -(SP)
    MOVE.W  #SCREEN_WIDTH/2-80, -(SP)
    MOVE.W  #SCREEN_HEIGHT*3/4, -(SP)
    MOVE.L  #TEXTDISP, -(SP)
    JSR     INSTANCE_ENTITY
    ADDA.L  #12, SP

    MOVEM.W (SP)+, D7/D1
    RTS

    .TEXTD: DC.B 'PRESS Z TO PLAY',0
TS_UPDATE:
    ;ESPERA Z
    BTST.B  #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ     .NOSTART
    ;CARGA SAVE O NO, BUG SI SE HACE DESDE AQUI????
    TST.B   (FIXFILEBUG)
    BEQ     .FIXBUG
    JSR     LOAD_SAVE
    .FIXBUG:
    MOVE.B  #1, (FIXFILEBUG)
    ;CARGA MAPA
    MOVE.W  (SAVEMAPID), -(SP) 
    ;MOVE.W #2, -(SP)
    JSR     LOAD_MAP
    ADDQ.L  #2, SP
    
    BRA     .END
    .NOSTART:


    .END:
    RTS

TS_DRAW:
    MOVE.L  #TITLEFIX, -(SP)
    MOVE.W  #75, -(SP) ;Y
    
    MOVE.W  #SCREEN_WIDTH/2-275, -(SP) ;X
    
    JSR     FASTSPRITE
    ADDA.L  #8, SP
    RTS

TITLESCREEN:
    DC.W 91                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
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
