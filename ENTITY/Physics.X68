*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
UPDATE_PHYSICS:
    ; ACTUALIZA LA POSICION ACORDE A LA VELOCIDAD Y 
    ; AL MAPA DE COLISIONES
    ; NO RESTA VELOCIDAD, PERO SI 0 SI COLI
    ; 48(SP).L @ENT
    MOVEM.L D0-D7/A0-A2, -(SP)

    ;CARGA DIRECCIONES
    MOVE.L  48(SP), A0
    MOVE.L  (CURRENTMAPDIR), A1
    LEA     INTERACT_MAP, A2

    ;OBTENER Y BAJAR FLAGS COLISION
    MOVE.B  STATUS+1(A0), D7
    ANDI.L  #%00000111, D7

     ;GRAVEDAD
    BTST.L #2, D7
    BNE .NOGRAV
        ADDQ.W #G, YSPEED(A0)                  
        CMP.W #MAX_FALL_SPEED, YSPEED(A0)
        BLE .NOMXSPED
            MOVE.W #MAX_FALL_SPEED, YSPEED(A0)
        .NOMXSPED:
    .NOGRAV:

    ;POS FUTURA SOLO Y
    MOVE.W  XPOS(A0), D5
    MOVE.W  YPOS(A0), D6
    ADD.W   YSPEED(A0), D6

    UPDPHGETHB

    ;MINIOFFSET
    ADDQ.W  #1, D1
    SUBQ.W  #1, D3

    COLIMAPD1D4

    IFNE DEBUG
    IFNE DGB_ADV_HB
        DBG_HBOXP
    ENDC
    ENDC

    ;TOPLEFT
    MOVE.W  D1, D0
    ADD.W   D2, D0
    TST.B   (A2, D0)
    BEQ     .NOTPL
    BSET.L  #7, D7
    BRA     .COLIUP
    .NOTPL:
    ;TOPRIGHT
    MOVE.W  D3, D0
    ADD.W   D2, D0
    TST.B   (A2, D0)
    BEQ     .NOUP
    BSET.L  #7, D7
    BRA     .COLIUP
    ;AJUSTAR POS
    .COLIUP:
    ANDI.W  #MAXWP-$3F, D6 ;MOD 64
    ADD.W   #TILESIZE, D6
    SUB.W   COLISION_BOX+2(A0), D6
    CLR.W   YSPEED(A0)
    .NOUP:

    ;DOWNLEFT
    MOVE.W  D1, D0
    ADD.W   D4, D0
    TST.B   (A2, D0)
    BEQ     .NODWL
    BSET.L  #6, D7
    .NODWL:
    ;DOWNRIGHT
    MOVE.W  D3, D0
    ADD.W   D4, D0
    TST.B   (A2, D0)
    BEQ     .NODWR
    BSET.L  #6, D7
    .NODWR:
    ;AJUSTAR POS
    BTST.L  #6, D7
    BEQ     .NODOWN
    ANDI.W  #MAXWP-$3F, D6 ;MOD 64
    ADD.W   #TILESIZE, D6
    SUB.W   COLISION_BOX+6(A0), D6
    BSET.L  #3, D7
    CLR.W   YSPEED(A0)
    .NODOWN:

    ;POS FUTURA SOLO X
    ADD.W   XSPEED(A0), D5

    UPDPHGETHB

    IFNE DEBUG
    IFNE DGB_ADV_HB
        DBG_HBOXP
    ENDC
    ENDC

    ;MINIOFFSET
    ADDQ.W  #1, D2
    SUBQ.W  #1, D4

    COLIMAPD1D4

    ;TOPLEFT
    MOVE.W  D1, D0
    ADD.W   D2, D0
    TST.B   (A2, D0)
    BEQ     .NOTPL2
    BSET.L  #5, D7
    .NOTPL2:
    ;DOWNLEFT
    MOVE.W  D1, D0
    ADD.W   D4, D0
    TST.B   (A2, D0)
    BEQ     .NODWL2
    BSET.L  #5, D7
    .NODWL2:
    ;AJUSTAR POS
    BTST.L  #5, D7
    BEQ     .NOUP2
    ANDI.W  #MAXWP-$3F, D5 ;MOD 64
    ADD.W   #TILESIZE, D5
    ;TENER EN CUENTA HBOX
    SUB.W   COLISION_BOX(A0), D5
    CLR.W   XSPEED(A0)
    .NOUP2:

    ;TOPRIGHT
    MOVE.W  D3, D0
    ADD.W   D2, D0
    TST.B   (A2, D0)
    BEQ     .NOTPR2
    BSET.L #4, D7
    .NOTPR2:
    ;DOWNRIGHT
    MOVE.W  D3, D0
    ADD.W   D4, D0
    TST.B   (A2, D0)
    BEQ     .NODWR2
    BSET.L  #4, D7
    .NODWR2:
    BTST.L  #4, D7
    BEQ     .NODOWN2
    ANDI.W  #MAXWP-$3F, D5 ;MOD 64
    ADD.W   #TILESIZE, D5
    SUB.W   COLISION_BOX+4(A0), D5
    CLR.W   XSPEED(A0)
    .NODOWN2:

    MOVE.W  D5, XPOS(A0)
    MOVE.W  D6, YPOS(A0)
    MOVE.B  D7, STATUS+1(A0)

    MOVEM.L (SP)+, A2-A0/D7-D0
    RTS

COLLISION_ENT_PLR:
    MOVE.W #1, (MINCHK)
    MOVE.W #1, (MAXCHK)
    BRA COLLISION_ENTITY
COLLISION_ENT_ENM:
    ;MOVE.W #8000, (MINCHK)
    MOVE.W #-1, (MAXCHK)
    BRA COLLISION_ENTITY
COLLISION_ENT_INT:
    MOVE.W #50, (MINCHK)
    MOVE.W #70, (MAXCHK)
    BRA COLLISION_ENTITY

COLLISION_ENTITY:
    ; 44(SP) A0
    ; 40(SP) @COLI, SINO -1
    ; (MINCHK).W ID >= MINCHK DEF $8000
    ; (MAXCHK).W ID <= MAXCHK DEF &7FFF
    ; DEFAULT AL FINALIZAR
    
    MOVEM.L D0-D7/A0, -(SP)

    MOVE.L 44(SP), A0
    MOVE.L #-1, 40(SP)
    LEA ENTITY_MEM, A1
    
    ADDA.L #COLISION_BOX, A0
    MOVEM.W (A0)+, D0-D3
    SUB.L #COLISION_BOX+8, A0

    ADD.W XPOS(A0), D0
    ADD.W XPOS(A0), D2
    ADD.W YPOS(A0), D1
    ADD.W YPOS(A0), D3

    MOVE.W #NUM_ENT-1, D7
    .LOOPCE:
    MOVE.W ID(A1), D6
    CMP.W #0, D6
    BEQ .JNEXT

    CMP.W (MINCHK), D6
    BLT .JNEXT
    CMP.W (MAXCHK), D6
    BGT .JNEXT

    MOVE.W XPOS(A1), D4
    MOVE.W D4, D5
    ADD.W COLISION_BOX(A1), D4
    ADD.W COLISION_BOX+4(A1), D5

    CMP.W D4, D2
    BLT .JNEXT
    CMP.W D5, D0
    BGT .JNEXT

    MOVE.W YPOS(A1), D4
    MOVE.W D4, D5
    ADD.W COLISION_BOX+2(A1), D4
    ADD.W COLISION_BOX+6(A1), D5

    CMP.W D4, D3
    BLT .JNEXT
    CMP.W D5, D1
    BGT .JNEXT

    CMP.L A0, A1
    BEQ .JNEXT

    MOVE.L A1, 40(SP)
    BRA .ENDCE

    .JNEXT:
    ADDA.L #ENT_SIZE_L, A1
    DBRA D7, .LOOPCE
    
    .ENDCE:
    MOVEM.L (SP)+, A0/D7-D0

    MOVE.W #$8000, (MINCHK)
    MOVE.W #MAXWP, (MAXCHK)

    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
