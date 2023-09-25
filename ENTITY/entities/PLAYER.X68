*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_START:
    MOVE.W #SCREEN_WIDTH/2-32, 2(A0)
    MOVE.W #SCREEN_HEIGHT/2-32, 4(A0)
    MOVE.W #ANIMSPEED, 42(A0)
    MOVE.W #10, 6(A0)
    MOVE.B #4, 44(A0)
    RTS

PLAYER_UPDATE:
    MOVE.L D0, -(SP)

    BTST.B #KEYM_LEFT, (KEY_PRESS_PLAYER) ;MOVIMIENTO
    BNE .SILEFT
    BTST.B #KEYM_LEFT, (KEY_HOLD_PLAYER)
    BEQ .NOLEFT
    .SILEFT:
    SUBQ.W #2, 8(A0)
    CLR.B 44(A0)
    .NOLEFT:
    
    BTST.B #KEYM_RIGHT, (KEY_PRESS_PLAYER) 
    BNE .SIRIGHT
    BTST.B #KEYM_RIGHT, (KEY_HOLD_PLAYER)
    BEQ .NORIGHT
    .SIRIGHT:
    ADDQ.W #2, 8(A0) 
    MOVE.B #4, 44(A0)
    .NORIGHT:

    CLR.B 45(A0)
    CLR.W D0

    BTST.B #KEYM_UP, (KEY_PRESS_PLAYER)
    BNE .SIUP
    BTST.B #KEYM_UP, (KEY_HOLD_PLAYER)
    BEQ .NOUP
    .SIUP:
    MOVE.W #8, D0
    MOVE.B #8, 45(A0)
    .NOUP:

    BTST.B #KEYM_DOWN, (KEY_PRESS_PLAYER)
    BNE .SIDW
    BTST.B #KEYM_DOWN, (KEY_HOLD_PLAYER)
    BEQ .NODW
    .SIDW:
    ;MOVE.W #12, D0
    MOVE.B #12, 45(A0)
    .NODW:

    LEA QUOTE_WALK_ANIM, A1
    ADD.B 44(A0), D0
    MOVE.L (A1, D0.W), 34(A0)

    CMP.W #0, 8(A0)
    BEQ .ESZERO
    BMI .ESNEG
        SUBQ.W #1, 8(A0)
        BRA .ESZERO
    .ESNEG:
        ADDQ.W #1, 8(A0)
    .ESZERO:

    CMP.W #MAX_PLYR_SPEED, 8(A0)
    BLE .NOMAX
        MOVE.W #MAX_PLYR_SPEED, 8(A0)
    .NOMAX:
    CMP.W #-MAX_PLYR_SPEED, 8(A0)
    BGE .NOMMAX
        MOVE.W #-MAX_PLYR_SPEED, 8(A0)
    .NOMMAX:

    BTST.B #3, 13(A0)
    BEQ .NOS
        MOVE.B #18, 46(A0)
    .NOS:
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)      ;SALTO BASE  
    BNE .SIZ
    BTST.B #KEYM_Z, (KEY_HOLD_PLAYER)
    BEQ .NOZ
    .SIZ:
    BTST.B #3, 13(A0)
    BNE .SIS
    CMP.B #0, 46(A0)
    BLE .ENDZ
    .SIS:
    MOVE.W #-9, 10(A0)   ;VEL SALTO
    SUBQ.B #1, 46(A0)
    BRA .ENDZ
    .NOZ:
    CLR.B 46(A0)
    .ENDZ:
    BCLR.B #3, 13(A0)

    BTST.B #KEYM_X, (KEY_PRESS_PLAYER)
    BEQ .NOX
    BSR BULLET_SHOT
    .NOX:

    CMP.W #0, 8(A0)
    BEQ .NOANIM
        MOVE.L 38(A0), D1                   ;ANIM_INDEX
        MOVE.W 42(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        CMP.W #0, D2
        BNE .NOTIMER
            MOVE.W #ANIMSPEED, D2
            ADDQ.L #1, D1
            MOVE.L 34(A0), A1
            CMP.L (A1), D1
            BLT .NOOF
            MOVE.L #0, D1
            .NOOF:
            MOVE.L D1, 38(A0)
        .NOTIMER:
        MOVE.W D2, 42(A0)
    BRA .ENDANIM
    .NOANIM:
        CLR.L 38(A0)
    .ENDANIM:

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    ADDQ.L #4, SP
    
    BSR CAMERA_MOVE

    
    MOVE.L (SP)+, D0
    RTS

PLAYER_PAINT:
    RTS

BULLET_SHOT:
    MOVE.L D0, -(SP)
    CLR.L D0

    MOVE.W 2(A0), -(SP)
    MOVE.W 4(A0), -(SP)

    ADD.W #32, (SP)     ;OFFSET Y
    CMP.B #0, 44(A0)
    BEQ .NOXOF
        ADD.W #64, 2(SP)
    .NOXOF:

    MOVE.W #1, -(SP)    ;NIVEL
    
    CMP.B #0, 45(A0)
    BEQ .NOUD
    MOVE.B 45(A0), D0
    SUB.W #32, 2(SP)    ;DES OF Y
    BRA .ENDDIR
    .NOUD:
    MOVE.B 44(A0), D0
    .ENDDIR:
    ASR.W #2, D0
    MOVE.W D0, -(SP)
    
    MOVE.L #BULLET_POLARSTAR, -(SP)

    BSR INSTANCE_ENTITY

    ADDA.L #12, SP
    MOVE.L (SP)+, D0
    RTS

CAMERA_MOVE:
    MOVE.L D1, -(SP)

    MOVE.W 4(A0), D0
    SUB.W (SCREEN_Y), D0
    ;MOVE.W #SCREEN_HEIGHT/2, D2

    CMP.W #(SCREEN_HEIGHT/2)-10, D0
    BGE .NOSKUP
        MOVE.W (SCR_SPEED_Y), D1
        SUBQ.W #2, D1
        CMP.W #-2, D1
        BLT .NOMXSKUP
            MOVE.W #-2, D1
        .NOMXSKUP:
        MOVE.W D1, (SCR_SPEED_Y)
    .NOSKUP:

    CMP.W #(SCREEN_HEIGHT/2)+10, D0
    BLE .NOKSDW
        MOVE.W (SCR_SPEED_Y), D1
        ADDQ.W #2, D1
        MOVE.W D1, (SCR_SPEED_Y)
    .NOKSDW:

    MOVE.W 2(A0), D0
    SUB.W (SCREEN_X), D0
    
    CMP.B #0, 44(A0)                    ;Scroll horizontal
    BEQ .PNLEFT
        SUB.W #130-TILESIZE, D0
        ASR.W #3, D0
        MOVE.W D0, (SCR_SPEED_X)    
    BRA .ENDCAM
    .PNLEFT:
        SUB.W #SCREEN_WIDTH-130, D0
        ASR.W #3, D0
        MOVE.W D0, (SCR_SPEED_X)
    .ENDCAM:
    MOVE.L (SP)+, D1
    RTS



PLAYER:
    DC.W 1                                          ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 8,2, 58,64                                 ;COLISION_BOX
    DC.L PLAYER_START, PLAYER_UPDATE, DEFALUT_PAINT  ;@
    DC.L QUOTE_WALK_RN                              ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;42.W (timer sprite)
    DS.W 1                                          ;44.B (lookdir) 0:left 4:right 
                                                    ;45.B (lookdir) 8:up 12:down
                                                    ;46.B (timer jump)
                                                    ;47.B (equipped arm)
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
