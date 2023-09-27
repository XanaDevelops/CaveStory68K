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

    MOVE.L #PLAYER, -(SP)
    BSR INSTANCE_ENTITY

    ADDQ.L #4, SP

    BSR GENERATE_COLIMAP

    MOVEM.L (SP)+, A0/D0
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
