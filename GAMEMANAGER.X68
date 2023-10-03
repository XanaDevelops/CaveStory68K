*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
LOAD_MAP:
    ; (SP).W ID MAP
    BSR SLASHKILLA
    
    MOVEM.L D0/A0, -(SP)

    MOVE.W 12(SP), D0
    MOVE.W D0, CURRENTMAPID
    LEA MAPAS, A0
    ASL.W #2, D0                ;MULU #4
    MOVE.L (A0, D0), CURRENTMAPDIR


    BSR GENERATE_COLIMAP

    MOVE.L #PLAYER, -(SP)
    BSR INSTANCE_ENTITY

    ADDQ.L #4, SP

    MOVE.W #$120, -(SP)
    MOVE.W #$380, -(SP)
    MOVE.L #BAT, -(SP)
    BSR INSTANCE_ENTITY

    MOVE.W #$220, 6(SP)
    MOVE.W #$400, 4(SP)
    BSR INSTANCE_ENTITY

    MOVE.W #20, D0
    .LOOPBORRAR:
    ADD.W #$30, 6(SP)
    BSR INSTANCE_ENTITY
    DBRA D0, .LOOPBORRAR

    SUB.W #$40, 4(SP)
    MOVE.W #$220, 6(SP)
    MOVE.W #20, D0
    .LOOPBORRAR2:
    ADD.W #$30, 6(SP)
    BSR INSTANCE_ENTITY
    DBRA D0, .LOOPBORRAR2

    ADDA.L #8, SP

    MOVEM.L (SP)+, A0/D0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
