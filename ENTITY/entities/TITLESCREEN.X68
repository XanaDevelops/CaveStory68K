*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TS_START:
    BSET.B #4, (GAMEFLAGS)
    RTS
TS_UPDATE:
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)
    BEQ .NOSTART
    MOVE.W #1, -(SP) ;TODO PARTIDA GUARDADA
    JSR LOAD_MAP
    ADDQ.L #2, SP
    BCLR.B #4, (GAMEFLAGS)
    .NOSTART:
    RTS
TS_DRAW:
    MOVE.L #NUBE0, -(SP)
    MOVE.W #0, -(SP)
    MOVE.W #0, -(SP)
    JSR FASTSPRITE
    ADDQ.L #8, SP
    RTS

TITLESCREEN:
    DC.W 91                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;COLISION_BOX 44
    DC.L TS_START, TS_UPDATE, TS_DRAW           ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
