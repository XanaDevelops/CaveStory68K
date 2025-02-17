*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CAMERA_START:
    ;46(SP) X
    ;44(SP) Y
    ;48(SP) ENTFOCUS

    MOVEM.L D0-D1/A1-A2, -(SP)
    
    ;OTRAS FUNCIONES DEPENDEN DE
    ;SCREEN_X Y SCREEN_Y
    MOVE.W  46(SP), (SCREEN_X)
    MOVE.W  44(SP), (SCREEN_Y)

    CLR.L   ET_ISPR(A0)
    CLR.B   TRANS_STATUS(A0)

    CLR.L   (SCR_SPEED_X) ;TAMBIEN Y
    
    MOVE.W  #ANIMSPEED, ET_TSPRT(A0)
    

    ;BUSCAR LA INSTANCIA A LA QUE
    ;FOCUSEAR, INSTANCIAR ANTES QUE
    ;CAMERA
    MOVE.L  #-1, ENTFOCUS(A0)

    MOVE.L  48(SP), A1
    CMP.L   #-1, A1
    BLE     .NOINST
    MOVE.W  ET_ID(A1), -(SP)
    SUBQ.L  #4, SP
    BSR     FIND_FIRST_ID

    MOVE.L  (SP)+, A2
    ADDQ.L  #2, SP
    CMP.L   #-1, A2
    BEQ     .NOINST
    MOVE.L  A2, ENTFOCUS(A0)
    ;COLOCAR RESPECTO AL FOCUS
    MOVE.L  ET_XPOS(A2), (SCREEN_X) ;APROVECHAR CONTINUIDAD
    SUB.W  #SCREEN_WIDTH/2, (SCREEN_X)
    SUB.W  #SCREEN_HEIGHT/2, (SCREEN_Y)
    .NOINST:

    JSR     PREVENT_SCREEN_OOB

    MOVEM.L (SP)+, A2-A1/D1-D0
    RTS

CAMERA_UPDATE:
    MOVEM.L D0-D1/A1, -(SP)

    MOVE.L  ENTFOCUS(A0), A1
    CMP.L   #-1, A1
    BEQ     CMENDUP ;NO VA .ET
    
    ;ESTA PENSADO PARA PLAYER
    ;SI OTRAS ENTIDADES
    ;TODO: PROGRAMAR CENTRADO
    
    MOVE.W  ET_YPOS(A1), D0
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

    MOVE.W  ET_XPOS(A1), D0
    SUB.W   (SCREEN_X), D0
    
    TST.B   LOOKDIRLR(A1)                    ;Scroll horizontal
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

    ADD.W   D0, SCREEN_X
    ADD.W   D1, SCREEN_Y

    MOVE.W  D0, SCR_SPEED_X
    MOVE.W  D1, SCR_SPEED_Y

    JSR     PREVENT_SCREEN_OOB

    CMENDUP:
    
    MOVEM.L (SP)+, A1/D1-D0
    RTS



CAMERA:
    DC.W 2                                          ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L CAMERA_START, CAMERA_UPDATE, DEFAULT_RTS   ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L SQR_TRANS                                  ;@SPRITE DEFECTO
    DC.L MAXWP                                     ;SPRITEINDEX
    DC.W 0
    DC.W 0                                          ;ET_ZORD
                                              


ENTFOCUS        EQU ET_DATA   ;L









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
