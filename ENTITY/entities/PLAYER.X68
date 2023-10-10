*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PLAYER_START:
    MOVE.L A0, (PLAYERREF)
    CLR.B (PLYERDED)

    MOVE.W #128, XPOS(A0)
    MOVE.W #128, YPOS(A0)

    MOVE.W #SCREEN_WIDTH/2-32, (SCREEN_X)
    MOVE.W #SCREEN_HEIGHT/2-32+300, (SCREEN_Y)
    
    MOVE.W #ANIMSPEED, TIMERSPRITE(A0)
    MOVE.W #10, HP(A0)
    MOVE.B #4, LOOKDIRLR(A0)
    RTS

PLAYER_UPDATE:
    MOVEM.L D0-D1, -(SP)

    CMP.W #0, HP(A0)        ;KILL?
    BNE .LIVE
        BSR GM_PLYRDED
        MOVE.W #66, -(SP)
        MOVE.W #1, -(SP)
        BSR PLAY_SFX
        MOVE.L A0, -(SP)
        BSR DESTROY_ENTITY
        ADDQ.L #8, SP
        BRA .ENDUPDATE
    .LIVE:

    CLR.L D1
    MOVE.B (KEY_PRESS_PLAYER), D1
    OR.B   (KEY_HOLD_PLAYER),  D1

    BTST.L #KEYM_LEFT, D1
    BEQ .NOLEFT
    SUBQ.W #2, XSPEED(A0)
    CLR.B LOOKDIRLR(A0)
    .NOLEFT:

    BTST.L #KEYM_RIGHT, D1
    BEQ .NORIGHT
    ADDQ.W #2, XSPEED(A0) 
    MOVE.B #4, LOOKDIRLR(A0)
    .NORIGHT:

    CLR.B LOOKDIRUD(A0)
    CLR.W D0

    BTST.L #KEYM_UP, D1
    BEQ .NOUP
    MOVE.W #8, D0
    MOVE.B #8, LOOKDIRUD(A0)
    .NOUP:

    BTST.L #KEYM_DOWN, D1
    BEQ .NODW
    .SIDW:
    BTST.B #3, STATUS+1(A0)
    BEQ .LKOBK
        CMP.W #0, XSPEED(A0)
        BNE .NODW
            MOVE.W #16, D0                  ;16 BACK 24 LKDOWN
            MOVE.B #12, LOOKDIRUD(A0)
            CLR.L SPRITE_INDEX(A0)          ;FIXBUG
            BRA .NODW
    .LKOBK:
            MOVE.W #24, D0
            MOVE.B #12, LOOKDIRUD(A0)
            CLR.L SPRITE_INDEX(A0)          ;FIXBUG
    .NODW:

    LEA QUOTE_ANIM_V, A1
    ADD.B LOOKDIRLR(A0), D0
    MOVE.L (A1, D0.W), AD_SPRITE(A0)

    CMP.W #0, XSPEED(A0)
    BEQ .ESZERO
    BMI .ESNEG
        SUBQ.W #1, XSPEED(A0)
        BRA .ESZERO
    .ESNEG:
        ADDQ.W #1, XSPEED(A0)
    .ESZERO:

    ;CMP.B #20, TIMERINVI(A0)
    ;BGT .NOMMAX

    CMP.W #MAX_PLYR_SPEED, XSPEED(A0)
    BLE .NOMAX
        MOVE.W #MAX_PLYR_SPEED, XSPEED(A0)
    .NOMAX:
    CMP.W #-MAX_PLYR_SPEED, XSPEED(A0)
    BGE .NOMMAX
        MOVE.W #-MAX_PLYR_SPEED, XSPEED(A0)
    .NOMMAX:

    BTST.B #3, STATUS+1(A0)
    BEQ .NOS
        MOVE.B #22, TIMERJUMP(A0)
    .NOS:
    BTST.L #KEYM_Z, D1                 ;SALTO BASE
    BEQ .NOZ
    .SIZ:
    BTST.B #3, STATUS+1(A0)
    BNE .SIS
    CMP.B #0, TIMERJUMP(A0)
    BLE .ENDZ
    .SIS:
    CMP.W #22, TIMERJUMP(A0)
    BNE .NOSFXJ
    MOVE.W #68, -(SP)
    MOVE.W #0, -(SP)
    JSR PLAY_SFX
    ADDQ.L #4, SP

    .NOSFXJ:
    MOVE.W #-9, YSPEED(A0)   ;VEL SALTO
    SUBQ.B #1, TIMERJUMP(A0)
    BRA .ENDZ
    .NOZ:
    CLR.B TIMERJUMP(A0)
    .ENDZ:
    BCLR.B #3, STATUS+1(A0)

    BTST.B #KEYM_X, (KEY_PRESS_PLAYER)
    BEQ .NOX
    BSR BULLET_SHOT
    .NOX:

    CMP.W #0, XSPEED(A0)
    BEQ .NOANIM
        MOVE.L SPRITE_INDEX(A0), D1                   ;ANIM_INDEX
        MOVE.W TIMERSPRITE(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W #1, D2
        BNE .NOTIMER
            MOVE.W #ANIMSPEED, D2
            ADDQ.L #1, D1
            MOVE.L AD_SPRITE(A0), A1
            CMP.L (A1), D1
            BLT .NOOF
            MOVE.L #0, D1
            .NOOF:
            MOVE.L D1, SPRITE_INDEX(A0)

            BTST.B #3, STATUS+1(A0)
            BNE .NOSFXWALK
            MOVE.W #69, -(SP)
            MOVE.W #0, -(SP)
            BSR PLAY_SFX
            ADDQ.L #4, SP
            .NOSFXWALK:
        .NOTIMER:
        MOVE.W D2, TIMERSPRITE(A0)
    BRA .ENDANIM
    .NOANIM:
        CLR.L SPRITE_INDEX(A0)
    .ENDANIM:

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    ADDQ.L #4, SP
    
    BSR CAMERA_MOVE

    SUBQ.B #1, TIMERINVI(A0)
    BPL .NOZIN
    CLR.B TIMERINVI(A0)
    .NOZIN:

    .ENDUPDATE:
    MOVEM.L (SP)+, D1-D0
    RTS

PLAYER_PAINT:
    BTST.B #1, TIMERINVI(A0)
    BNE .SKIPDP
    
    MOVEM.L D0-D2/A1-A2, -(SP)


    MOVE.L AD_SPRITE(A0), A1
    MOVE.L SPRITE_INDEX(A0), D1

    ASL.L #2, D1
    MOVE.L 4(A1, D1), A2

    LEA ARM_POLARSTAR, A1
    CLR.W D0

    ADD.B LOOKDIRUD(A0), D0
    ADD.B LOOKDIRLR(A0), D0
    CMP.B #12, LOOKDIRUD(A0)
    BNE .NOADD
        ADDQ.B #4, D0
    .NOADD:

    MOVE.L (A1, D0), -(SP)

    MOVE.W YPOS(A0), D0
    SUB.W (SCREEN_Y), D0
    MOVE.W D0, -(SP)
    MOVE.W XPOS(A0), D0
    SUB.W (SCREEN_X), D0
    MOVE.W D0, -(SP)

    BSR FASTSPRITE      ;ARMA

    MOVE.L A2, 4(SP)

    BSR FASTSPRITE      ;CHARA

    ADDQ.L #8, SP

    MOVEM.L (SP)+, A2-A1/D2-D0
    .SKIPDP:
    RTS

PLAYER_DAMAGE:
    ; (SP).W DAMAGE
    MOVEM.L D0/A0, -(SP)
    MOVE.L 12(SP), A0

    CMP.B #0, TIMERINVI(A0)
    BNE .CNTDAMG

    MOVE.W 16(SP), D0
    SUB.W D0, HP(A0)

    ADD.B #INVTIME, TIMERINVI(A0)
    
    MOVE.W XSPEED(A0), D0
    ADD.W D0, D0
    NEG.W D0
    MOVE.W D0, XSPEED(A0)
    ;NEG.W YSPEED(A0)

    MOVE.W #67, -(SP)
    MOVE.W #1, -(SP)
    BSR PLAY_SFX

    ADDQ.L #4, SP

    .CNTDAMG:
    MOVEM.L (SP)+, A0/D0
    RTS

BULLET_SHOT:
    MOVE.L D0, -(SP)
    CLR.L D0

    ;DEPENDE ARMA/NIVEL
    MOVE.W #62, -(SP)
    MOVE.W #1, -(SP)
    JSR PLAY_SFX
    ADDQ.L #4, SP

    MOVE.W XPOS(A0), -(SP)
    MOVE.W YPOS(A0), -(SP)

    ADD.W #32, (SP)     ;OFFSET Y
    CMP.B #0, LOOKDIRLR(A0)
    BEQ .NOXOF
        ADD.W #40, 2(SP)
    .NOXOF:

    MOVE.W #2, -(SP)    ;NIVEL
    
    CMP.B #0, LOOKDIRUD(A0)
    BEQ .NOUD
    MOVE.B LOOKDIRUD(A0), D0
    SUB.W #32, 2(SP)    ;DES OF Y
    BRA .ENDDIR
    .NOUD:
    MOVE.B LOOKDIRLR(A0), D0
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

    MOVE.W YPOS(A0), D0
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

    MOVE.W XPOS(A0), D0
    SUB.W (SCREEN_X), D0
    
    CMP.B #0, LOOKDIRLR(A0)                    ;Scroll horizontal
    BEQ .PNLEFT
        SUB.W #130-TILESIZE, D0
        ASR.W #3, D0
        CMP.W #SCREEN_MAXVX, D0
        BLT .NOMX
        MOVE.W #SCREEN_MAXVX, D0
        .NOMX:
        MOVE.W D0, (SCR_SPEED_X)    
    BRA .ENDCAM
    .PNLEFT:
        SUB.W #SCREEN_WIDTH-130, D0
        ASR.W #3, D0
        CMP.W #-SCREEN_MAXVX, D0
        BGT .NOMX2
        MOVE.W #-SCREEN_MAXVX, D0
        .NOMX2:
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
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT  ;@
    DC.L PLAYER_DAMAGE                              ;@
    DC.L QUOTE_WALK_RN                              ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          ;46.W (timer sprite)
    DS.W 1                                          ;47.B (lookdir) 0:left 4:right 
                                                    ;48.B (lookdir) 8:up 12:down
                                                    ;49.B (timer jump)
                                                    ;50.B (equipped arm)
TIMERSPRITE     EQU AUX_DATA    ;W
LOOKDIRLR       EQU AUX_DATA+2  ;B
LOOKDIRUD       EQU AUX_DATA+3  ;B
TIMERJUMP       EQU AUX_DATA+4  ;B
TIMERINVI       EQU AUX_DATA+5  ;B





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
