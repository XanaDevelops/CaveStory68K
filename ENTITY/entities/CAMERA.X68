*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CAMERA_START:
    MOVEM.L A1-A2, -(SP)
    
    ;OTRAS FUNCIONES DEPENDEN DE
    ;SCREEN_X Y SCREEN_Y
    MOVE.W  38(SP), (SCREEN_X)
    MOVE.W  36(SP), (SCREEN_Y)
    CLR.L   SPRITEINDEX(A0)

    BSR     PREVENT_SCREEN_OOB

    ;BUSCAR LA INSTANCIA A LA QUE
    ;FOCUSEAR, INSTANCIAR ANTES QUE
    ;CAMERA
    MOVE.L  #-1, ENTFOCUS(A0)

    MOVE.L  40(SP), A1
    CMP.L   #-1, A1
    BLE     .NOINST
    MOVE.W  ID(A1), -(SP)
    SUBQ.L  #4, SP
    BSR     FIND_FIRST_ID

    MOVE.L  (SP)+, A2
    ADDQ.L  #2, SP
    CMP.L   #-1, A2
    BEQ     .NOINST
    MOVE.L  A2, ENTFOCUS(A0)
    .NOINST:

    MOVEM.L (SP)+, A2-A1
    RTS

CAMERA_UPDATE:
    MOVEM.L D0-D1/A1, -(SP)

    MOVE.L  ENTFOCUS(A0), A1
    CMP.L   #-1, A1
    BEQ     CMENDUP ;NO VA .ET
    
    ;ESTA PENSADO PARA PLAYER
    ;SI OTRAS ENTIDADES
    ;TODO: PROGRAMAR CENTRADO
    
    MOVE.W  YPOS(A1), D0
    SUB.W   (SCREEN_Y), D0
    ;MOVE.W #SCREEN_HEIGHT/2, D2

    CMP.W   #(SCREEN_HEIGHT/2)-10, D0
    BGE     .NOSKUP
        MOVE.W  (SCR_SPEED_Y), D1
        SUBQ.W  #2, D1
        CMP.W   #-2, D1
        BLT     .NOMXSKUP
            MOVE.W  #-2, D1
        .NOMXSKUP:
        MOVE.W  D1, (SCR_SPEED_Y)
    .NOSKUP:

    CMP.W   #(SCREEN_HEIGHT/2)+10, D0
    BLE     .NOKSDW
        MOVE.W  (SCR_SPEED_Y), D1
        ADDQ.W  #2, D1
        MOVE.W  D1, (SCR_SPEED_Y)
    .NOKSDW:

    MOVE.W  XPOS(A1), D0
    SUB.W   (SCREEN_X), D0
    
    CMP.B   #0, LOOKDIRLR(A1)                    ;Scroll horizontal
    BEQ     .PNLEFT
        SUB.W   #130-TILESIZE, D0
        ASR.W   #3, D0
        CMP.W   #SCREEN_MAXVX, D0
        BLT     .NOMX
        MOVE.W  #SCREEN_MAXVX, D0
        .NOMX:
        MOVE.W  D0, (SCR_SPEED_X)    
    BRA .ENDCAM
    .PNLEFT:
        SUB.W   #SCREEN_WIDTH-130, D0
        ASR.W   #3, D0
        CMP.W   #-SCREEN_MAXVX, D0
        BGT     .NOMX2
        MOVE.W  #-SCREEN_MAXVX, D0
        .NOMX2:
        MOVE.W  D0, (SCR_SPEED_X)
    .ENDCAM:


    MOVE.W  (SCR_SPEED_X), D0
    MOVE.W  (SCR_SPEED_Y), D1
    
    REDUCE_SCRLL_SPEED D0
    REDUCE_SCRLL_SPEED D1

    LIMIT_SCRLL_SPEED D0, MAX_SCRLL_SPEEDX
    LIMIT_SCRLL_SPEED D1, MAX_SCRLL_SPEEDY

    ORI.B   #$F0, SCREEN_ST

    JSR     PREVENT_SCREEN_OOB

    ADD.W   D0, SCREEN_X
    ADD.W   D1, SCREEN_Y

    MOVE.W  D0, SCR_SPEED_X
    MOVE.W  D1, SCR_SPEED_Y

    CMENDUP:
    ;CONTROLAR TRANS
    BTST.B  #0, TRANS_STATUS(A0) ;SI 0 O 2
    BEQ     .NOTRANS

    MOVE.L  SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
    MOVE.W  TIMERSPRITE(A0), D2                   
    SUBQ.W  #1, D2
    BNE     .NOTIMER
    MOVE.W  #ANIMSPEED, D2
    
    BTST.B  #1, TRANS_STATUS(A0)
    ;SI 1 O 3 
    ADDQ.L  #1, D1
    MOVE.L  AD_SPRITE(A0), A1
    CMP.L   (A1), D1
    BLT     .NOOF
    MOVE.L  #0, D1
    .NOOF:
    MOVE.L  D1, SPRITE_INDEX(A0)

    .NOTIMER:
    MOVE.W  D2, TIMERSPRITE(A0)


    .NOTRANS:
    MOVEM.L (SP)+, A1/D1-D0
    RTS

TRANS_DRAW:
    CMP.B   #0, TRANS_STATUS(A0)
    BEQ     .END
    ;DIBUJAR EFECTO TRANSICION

    .END:
    RTS

CAMERA:
    DC.W 2                                          ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;COLISION_BOX 44
    DC.L CAMERA_START, CAMERA_UPDATE, TRANS_DRAW    ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L SQR_TRANS                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1

ENTFOCUS        EQU AUX_DATA   ;L
INDEX_TRANS     EQU AUX_DATA+4 ;B
TRANS_STATUS    EQU AUX_DATA+5 ;B 0:NO 1:DO 2:DONE 3:UNDO->0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
