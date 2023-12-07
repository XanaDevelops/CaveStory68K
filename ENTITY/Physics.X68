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
        ADDQ.W #G, ET_YSPEED(A0)                  
        CMP.W #MAX_FALL_SPEED, ET_YSPEED(A0)
        BLE .NOMXSPED
            MOVE.W #MAX_FALL_SPEED, ET_YSPEED(A0)
        .NOMXSPED:
    .NOGRAV:

    ;POS FUTURA SOLO Y
    MOVE.W  ET_XPOS(A0), D5
    MOVE.W  ET_YPOS(A0), D6
    ADD.W   ET_YSPEED(A0), D6

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
    CMP.B   #-1, (A2, D0)
    BNE     .NOTPL
    BSET.L  #7, D7
    BRA     .COLIUP
    .NOTPL:
    ;TOPRIGHT
    MOVE.W  D3, D0
    ADD.W   D2, D0
    CMP.B   #-1, (A2, D0)
    BNE     .NOUP
    BSET.L  #7, D7
    BRA     .COLIUP
    ;AJUSTAR POS
    .COLIUP:
    ANDI.W  #MAXWP-$3F, D6 ;MOD 64
    ADD.W   #TILESIZE, D6
    SUB.W   COLISION_BOX+2(A0), D6
    CLR.W   ET_YSPEED(A0)
    .NOUP:

    
    ;DOWNLEFT
    MOVE.W  D1, D0
    ADD.W   D4, D0
    CMP.B   #-1, (A2, D0)
    BNE     .NODWL 
    BSET.L  #6, D7
    .NODWL:
    ;DOWNRIGHT
    MOVE.W  D3, D0
    ADD.W   D4, D0
    CMP.B   #-1, (A2, D0)
    BNE     .NODWR
    BSET.L  #6, D7
    .NODWR:
    ;AJUSTAR POS
    BTST.L  #6, D7
    BEQ     .NODOWN
    ANDI.W  #MAXWP-$3F, D6 ;MOD 64
    ADD.W   #TILESIZE, D6
    SUB.W   COLISION_BOX+6(A0), D6
    ;AÑADIR Y SI PENDIENTE
    BSET.L  #3, D7
    CLR.W   ET_YSPEED(A0)
    .NODOWN:    


    ;POS FUTURA SOLO X
    ADD.W   ET_XSPEED(A0), D5

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
    CMP.B   #-1, (A2, D0)
    BNE     .NOTPL2
    BSET.L  #5, D7
    .NOTPL2:
    ;DOWNLEFT
    MOVE.W  D1, D0
    ADD.W   D4, D0
    MOVE.W  #-1, D1  ;VALOR DEFECTO
    CMP.B   #-1, (A2, D0)
    BGT     .NODWL2
    BEQ     .NOS1

    
    MOVE.W  #0, -(SP)
    BSR     SLOPECALC
    ;D1 YA HA CUMPLIDO SU MISION
    MOVE.W  (SP)+, D1
    TST.W   D1
    BMI     .NODWL2
    BRA     .NOUP2

    .NOS1:
    BSET.L  #5, D7
    .NODWL2:

    ;AJUSTAR POS
    BTST.L  #5, D7
    BEQ     .NOUP2

    ;TEST AYUDA 
    MOVE.W  D7, -(SP)
    MOVE.W  D6, D7
    AND.W   #$3F, D7
    CMP.W   #1, D7
    BNE     .NOH2
    ;SUBQ.W  #1, D6
    MOVE.W  (SP)+, D7
    BRA     .NOUP2
    .NOH2:
    MOVE.W  (SP)+, D7

    ANDI.W  #MAXWP-$3F, D5 ;MOD 64
    ADD.W   #TILESIZE, D5
    ;TENER EN CUENTA HBOX
    SUB.W   COLISION_BOX(A0), D5
    CLR.W   ET_XSPEED(A0)
    .NOUP2:

    ;TOPRIGHT
    MOVE.W  D3, D0
    ADD.W   D2, D0
    CMP.B   #-1, (A2, D0)
    BNE     .NOTPR2
    BSET.L #4, D7
    .NOTPR2:
    ;DOWNRIGHT
    MOVE.W  #-1, D2

    MOVE.W  D3, D0
    ADD.W   D4, D0
    CMP.B   #-1, (A2, D0)
    BGT     .NODWR2
    BEQ     .NOS2
    
    MOVE.W  #4, -(SP)
    BSR     SLOPECALC
    ;D2 YA HA CUMPLIDO SU MISION
    MOVE.W  (SP)+, D2
    TST.W   D2
    BMI     .NODWR2

    BRA     .NODOWN2
    .NOS2:
    BSET.L  #4, D7
    .NODWR2:
    BTST.L  #4, D7
    BEQ     .NODOWN2

    ;TEST AYUDA 
    MOVE.W  D7, -(SP)
    MOVE.W  D6, D7
    AND.W   #$3F, D7
    CMP.W   #1, D7
    BNE     .NOH
    ;SUBQ.W  #1, D6
    MOVE.W  (SP)+, D7
    BRA     .NODOWN2
    .NOH:
    MOVE.W  (SP)+, D7

    ANDI.W  #MAXWP-$3F, D5 ;MOD 64
    ADD.W   #TILESIZE, D5
    SUB.W   COLISION_BOX+4(A0), D5
    CLR.W   ET_XSPEED(A0)

    .NODOWN2:

    ;SLOPE CHECK
    CMP.W   #-1, D1
    BGT     .SLOPEY
    CMP.W   #-1, D2
    BGT     .SLOPEY
    BRA     .SVAR
    .SLOPEY:
    CMP.W   D1, D2
    BGT     .NOCHG
    MOVE.W  D1, D2
    .NOCHG:
    SUBQ.W  #1, D6 ;HACK!?
    ANDI.W  #MAXWP-$3F, D6 ;MOD 64
    ADD.W   #TILESIZE, D6
    SUB.W   COLISION_BOX+6(A0), D6
    ;AÑADIR Y SI PENDIENTE
    ;HACK
    SUB.W   #64, D2
    NEG.W   D2
    ADD.W   D2, D6
    
    BSET.L  #3, D7
    CLR.W   ET_YSPEED(A0)

    .SVAR:
    MOVE.W  D5, ET_XPOS(A0)
    MOVE.W  D6, ET_YPOS(A0)
    MOVE.B  D7, STATUS+1(A0)

    MOVEM.L (SP)+, A2-A0/D7-D0
    RTS

SLOPECALC:
    ; CALCULA Y RESPECTO X 
    ; NO TOCAR
    ; (A2,D0).B -> SLOPE
    ; D5,D6.W -> X,Y
    ; D7.B  -> STATUS
    ; A0.L @ENT
    ; (SP).W -> PRE:0 IZQ, 4 DER -> RET: NUEVA +Y, -1 NO COLI
    MOVEM.L D0-D5, -(SP)

    CLR.L   D1
    MOVE.B  (A2, D0), D1

    CMP.B   #-6, D1
    BEQ     .LEFT
    CMP.B   #-7, D1
    BEQ     .LEFT
    CMP.B   #-8, D1     ;TEST
    BEQ     .RIGHT
    CMP.B   #-9, D1
    BEQ     .RIGHT
    
    ;NOT IMPLEMENTED
    MOVE.W  #-1, D2
    BRA     .EXITSLPCALC
    .LEFT:
    CLR.W   D0  ;IZQ
    BRA     .EXEC
    .RIGHT:  
    MOVE.W   #1, D0 ;DER
    

    .EXEC: 
    ;EXTRAER Y
    BSR     .GYRIGHT

    ;OBTENER VALOR DE Y RESPECTO X, O COMO SEA
    TST.W   D0
    BNE     .DOR
    BSR     .FXLEFT
    BRA     .ENDOR
    .DOR:
    BSR     .FXRIGHT ;VALOR EN D3
    .ENDOR:
    
    CMP.W   D2, D3
    BGT     .UP
    MOVE.W  #-1, D2
    BRA     .DBGVAR
    .UP:
    MOVE.W  D3, D2
    .DBGVAR:

    TST.W   28(SP)
    BNE     .DBG
    MOVE.W  D2, (DBGWORD1)
    BRA     .EXITSLPCALC
    .DBG:
    MOVE.W  D2, (DBGWORD2)

    ;DBG
    ;MOVE.W  #-1, D2
    ;DGB

    .EXITSLPCALC:
    MOVE.W  D2, 28(SP) ;TEST!!!
    MOVEM.L (SP)+, D5-D0
    RTS

.GYRIGHT:
    MOVE.W  D6, D2 ;Y
    ADD.W   COLISION_BOX+6(A0), D2
    ANDI.W  #$3F, D2 ;Y MOD
    BNE     .NOADD
    ADD.W   #64, D2
    .NOADD:
    SUB.W   #64, D2
    NEG.W   D2      ;Y HEIGHT
    
    RTS

.FXLEFT:
    MOVE.W  D5, D3  ;MOD X
    TST.W   32(SP) ;IZQ/DER PUNTO HBOX
    BEQ     .ADDR2
    ;ADD.W   COLISION_BOX(A0), D3
    MOVE.W  #32, D3 ;PROBAR
    BRA     .X2
    .ADDR2:     
    ADD.W   COLISION_BOX(A0), D3
    
    ANDI.W  #$3F, D3 ;Y HEIGHT
    BNE     .NOADD22
    ;ADD.W   #63, D3 ;mirar
    .NOADD22:
    ASR.W   #1, D3  ;DIV 2

    SUB.W   #32, D3
    NEG.W   D3

    .X2:
    CMP.B   #-6, D1 ;PENDIENTE ALTA
    BNE     .NOUPS2
    ADD.W   #32, D3
    .NOUPS2:

    RTS

.FXRIGHT:
    MOVE.W  D5, D3  ;MOD X
    TST.W   32(SP) ;IZQ/DER PUNTO HBOX
    BNE     .ADDR
    ;ADD.W   COLISION_BOX(A0), D3
    MOVE.W  #32, D3 ;PROBAR
    BRA     .X
    .ADDR:     
    ADD.W   COLISION_BOX+4(A0), D3
    
    ANDI.W  #$3F, D3 ;Y HEIGHT
    BNE     .NOADD2
    ;ADD.W   #63, D3 ;mirar
    .NOADD2:
    ASR.W   #1, D3  ;DIV 2

    .X:
    CMP.B   #-9, D1 ;PENDIENTE ALTA
    BNE     .NOUPS
    ADD.W   #32, D3
    .NOUPS:

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
    ; (MINCHK).W ET_ID >= MINCHK DEF $8000
    ; (MAXCHK).W ET_ID <= MAXCHK DEF &7FFF
    ; DEFAULT AL FINALIZAR
    
    MOVEM.L D0-D7/A0, -(SP)

    MOVE.L 44(SP), A0
    MOVE.L #-1, 40(SP)
    LEA ENTITY_MEM, A1
    
    ADDA.L #COLISION_BOX, A0
    MOVEM.W (A0)+, D0-D3
    SUB.L #COLISION_BOX+8, A0

    ADD.W ET_XPOS(A0), D0
    ADD.W ET_XPOS(A0), D2
    ADD.W ET_YPOS(A0), D1
    ADD.W ET_YPOS(A0), D3

    MOVE.W #NUM_ENT-1, D7
    .LOOPCE:
    MOVE.W ET_ID(A1), D6
    CMP.W #0, D6
    BEQ .JNEXT

    CMP.W (MINCHK), D6
    BLT .JNEXT
    CMP.W (MAXCHK), D6
    BGT .JNEXT

    MOVE.W ET_XPOS(A1), D4
    MOVE.W D4, D5
    ADD.W COLISION_BOX(A1), D4
    ADD.W COLISION_BOX+4(A1), D5

    CMP.W D4, D2
    BLT .JNEXT
    CMP.W D5, D0
    BGT .JNEXT

    MOVE.W ET_YPOS(A1), D4
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
