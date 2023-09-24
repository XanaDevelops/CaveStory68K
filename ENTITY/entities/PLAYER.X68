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

    MOVE.L A0, -(SP)

    ADDQ.W #G, 10(A0)                   ;GRAVEDAD
    CMP.W #MAX_FALL_SPEED, 10(A0)
    BLE .NOMXSPED
        MOVE.W #MAX_FALL_SPEED, 10(A0)
    .NOMXSPED:

    BTST.B #KEYM_LEFT, (KEY_PRESS_PLAYER) ;MOVIMIENTO
    BEQ .NOLEFT
    SUBQ.W #2, 8(A0)
    CLR.B 44(A0)
    .NOLEFT:
    
    BTST.B #KEYM_RIGHT, (KEY_PRESS_PLAYER) ;AÑADIR LIMITADORES
    BEQ .NORIGHT
    ADDQ.W #2, 8(A0) 
    MOVE.B #4, 44(A0)
    .NORIGHT:

    CLR.W D0
    BTST.B #KEYM_UP, (KEY_PRESS_PLAYER)
    BEQ .NOUP
    ADDQ.W #8, D0
    .NOUP:

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
        MOVE.B #18, 45(A0)
    .NOS:
    BTST.B #KEYM_Z, (KEY_PRESS_PLAYER)      ;SALTO BASE  
    BEQ .NOZ
    BTST.B #3, 13(A0)
    BNE .SIS
    CMP.B #0, 45(A0)
    BLE .ENDZ
    .SIS:
    MOVE.W #-9, 10(A0)   ;VEL SALTO
    SUBQ.B #1, 45(A0)
    BRA .ENDZ
    .NOZ:
    CLR.B 45(A0)
    .ENDZ:
    BCLR.B #3, 13(A0)

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
    BSR UPDATE_PHYSICS

    BSR CAMERA_MOVE

    ADDQ.L #4, SP
    MOVE.L (SP)+, D0
    RTS

PLAYER_PAINT:
    MOVEM.L D0-D2/A1-A2, -(SP)

    MOVE.L 34(A0), A1
    MOVE.L 38(A0), D1

    ASL.L #2, D1
    MOVE.L 4(A1, D1), A2

    MOVE.L A2, -(SP)
    MOVE.W 4(A0), D0
    SUB.W (SCREEN_Y), D0
    MOVE.W D0, -(SP)
    MOVE.W 2(A0), D0
    SUB.W (SCREEN_X), D0
    MOVE.W D0, -(SP)

    BSR FASTSPRITE

    ADDQ.L #8, SP

    

    MOVEM.L (SP)+, A2-A1/D2-D0
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
    DC.W 0                                          ;STATUS 00UDLR(AIRBONE)---
    DC.W 8,2, 58,64                                 ;COLISION_BOX
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT  ;@
    DC.L QUOTE_WALK_RN                              ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;42.W (timer sprite)
    DS.W 1                                          ;44.B (lookdir) 0:left 4:right (+8 up) 
                                                    ;45.B (timer jump)













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
