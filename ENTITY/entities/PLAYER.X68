*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
PLAYER_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.L  A0, (PLAYERREF)
    CLR.B   (PLYERDED)

    ADDS_ZORD

    CMP.W   #-1, (SPAWNX) ;SI TIENE ASIGNADO SPAWN EN RUNTIME
    BEQ     .NOSPAWN
    MOVE.W  (SPAWNX), ET_XPOS(A0)
    MOVE.W  (SPAWNY), ET_YPOS(A0)
    BRA     .CNT
    .NOSPAWN:
    MOVE.W  30(SP), ET_XPOS(A0) ;O ENTISDATA
    MOVE.W  28(SP), ET_YPOS(A0)

    .CNT:

    MOVE.W  (PMAXHP), MAXHEALTH(A0) 
    MOVE.W  (PACTHP), ET_HP(A0)

    MOVE.W  #ANIMSPEED, ET_TSPRT(A0) 
    MOVE.B  #4, LOOKDIRLR(A0)
    RTS

PLAYER_UPDATE:
    MOVEM.L D0-D1, -(SP)

    TST.W   ET_HP(A0)        ;KILL?
    BGT     .LIVE
        CLR.W   ET_HP(A0)   ;EVITAR VIDA NEGATIVA
        JSR     GM_PLYRDED

        MOVE.W  ET_XPOS(A0), -(SP)
        MOVE.W  ET_YPOS(A0), -(SP)
        MOVE.L  #PEXLDUST, -(SP)
        BSR     INSTANCE_ENTITY
        ADDQ.L  #8, SP

        MOVE.W  #66, -(SP)
        MOVE.W  #1, -(SP)
        BSR     PLAY_SFX
        MOVE.L  A0, -(SP)
        BSR     DESTROY_ENTITY
        ADDQ.L  #8, SP

        ;QUITAR REF
        MOVE.L  #-1, (PLAYERREF)
        BRA     .ENDUPDATE
    .LIVE:

    CLR.L   D1
    MOVE.B  (KEY_PRESS_PLAYER), D1
    OR.B    (KEY_HOLD_PLAYER),  D1

    BTST.L  #KEYM_LEFT, D1
    BEQ     .NOLEFT
    SUBQ.W  #2, ET_XSPEED(A0)
    CLR.B   LOOKDIRLR(A0)
    .NOLEFT:

    BTST.L  #KEYM_RIGHT, D1
    BEQ     .NORIGHT
    ADDQ.W  #2, ET_XSPEED(A0) 
    MOVE.B  #4, LOOKDIRLR(A0)
    .NORIGHT:

    CLR.B   LOOKDIRUD(A0)
    CLR.W   D0

    BTST.L  #KEYM_UP, D1
    BEQ     .NOUP
    MOVE.W  #8, D0
    MOVE.B  #8, LOOKDIRUD(A0)
    .NOUP:

    BTST.L  #KEYM_DOWN, D1
    BEQ     .NODW
    .SIDW:
    BTST.B  #3, ET_BSTATE(A0)
    BEQ     .LKOBK
        TST.W   ET_XSPEED(A0)
        BNE     .NODW
            MOVE.W  #16, D0                  ;16 BACK 24 LKDOWN
            MOVE.B  #12, LOOKDIRUD(A0)
            CLR.L   ET_ISPR(A0)          ;FIXBUG

            ;MIRAR SI INTERACTUA ALGO
            MOVE.L  A0, -(SP)
            SUBQ.L  #4, SP
            BSR     COLLISION_ENT_INT

            MOVE.L  (SP)+, A1
            ADDQ.L  #4, SP
            CMP.L   #-1, A1
            BEQ     .NODW

            MOVE.L  A0, -(SP)
            MOVE.L  A1, -(SP)
            MOVE.L  ET_INTER(A1), A1
            JSR     (A1)
            ADDQ.L  #8, SP
            BRA     .NODW
    .LKOBK:
            MOVE.W  #24, D0
            MOVE.B  #12, LOOKDIRUD(A0)
            CLR.L   ET_ISPR(A0)          ;FIXBUG
    .NODW:

    LEA     QUOTE_ANIM_V, A1
    ADD.B   LOOKDIRLR(A0), D0
    MOVE.L  (A1, D0.W), ET_SPRITE(A0)

    TST.W   ET_XSPEED(A0)
    BEQ     .ESZERO
    BMI     .ESNEG
        SUBQ.W  #1, ET_XSPEED(A0)
        BRA     .ESZERO
    .ESNEG:
        ADDQ.W  #1, ET_XSPEED(A0)
    .ESZERO:

    ;CMP.B #20, TIMERINVI(A0)
    ;BGT .NOMMAX

    CMP.W   #MAX_PLYR_SPEED, ET_XSPEED(A0)
    BLE     .NOMAX
        MOVE.W  #MAX_PLYR_SPEED, ET_XSPEED(A0)
    .NOMAX:
    CMP.W   #-MAX_PLYR_SPEED, ET_XSPEED(A0)
    BGE     .NOMMAX
        MOVE.W  #-MAX_PLYR_SPEED, ET_XSPEED(A0)
    .NOMMAX:

    ;SALTO
    BTST.B  #3, ET_BSTATE(A0)
    BEQ .NOS
        MOVE.B  #JUMPTIME, TIMERJUMP(A0)
    .NOS:
    BTST.L  #KEYM_Z, D1                 ;SALTO BASE
    BEQ     .NOZ
    BTST.B  #7, ET_BSTATE(A0)
    BEQ .SIZ
    CLR.B   TIMERJUMP(A0)
    BRA     .ENDJ
    .SIZ:
    BTST.B  #3, ET_BSTATE(A0)
    BNE     .SIS
    TST.B   TIMERJUMP(A0)
    BLE     .ENDZ
    .SIS:
    CMP.W   #22, TIMERJUMP(A0)
    BNE     .NOSFXJ
    MOVE.W  #68, -(SP)
    MOVE.W  #0, -(SP)
    JSR     PLAY_SFX
    ADDQ.L  #4, SP

    .NOSFXJ:
    MOVE.W  #JUMPSPEED, ET_YSPEED(A0)   ;VEL SALTO
    SUBQ.B  #1, TIMERJUMP(A0)
    BRA     .ENDZ
    .NOZ:
    CLR.B   TIMERJUMP(A0)
    .ENDZ:
    BCLR.B  #3, ET_BSTATE(A0)
    .ENDJ:

    BTST.B  #KEYM_X, (KEY_PRESS_PLAYER)
    BEQ     .NOX
    BSR     BULLET_SHOT
    .NOX:

    TST.W   ET_XSPEED(A0)
    BEQ     .NOANIM
        MOVE.L  ET_ISPR(A0), D1                   ;ANIM_INDEX
        MOVE.W  ET_TSPRT(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W  #1, D2
        BNE     .NOTIMER
            MOVE.W  #ANIMSPEED, D2
            ADDQ.L  #1, D1
            MOVE.L  ET_SPRITE(A0), A1
            CMP.L   (A1), D1
            BLT     .NOOF
            MOVE.L  #0, D1
            .NOOF:
            MOVE.L  D1, ET_ISPR(A0)

            BTST.B  #3, ET_BSTATE(A0)
            BNE     .NOSFXWALK
            MOVE.W  #69, -(SP)
            MOVE.W  #0, -(SP)
            BSR     PLAY_SFX
            ADDQ.L  #4, SP
            .NOSFXWALK:
        .NOTIMER:
        MOVE.W  D2, ET_TSPRT(A0)
    BRA .ENDANIM
    .NOANIM:
        CLR.L   ET_ISPR(A0)
    .ENDANIM:

    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS
    ADDQ.L  #4, SP
    
    SUBQ.B  #1, TIMERINVI(A0)
    BPL     .NOZIN
    CLR.B   TIMERINVI(A0)
    .NOZIN:

    .ENDUPDATE:
    MOVEM.L (SP)+, D1-D0
    RTS

PLAYER_PAINT:
    BTST.B  #1, TIMERINVI(A0)
    BNE     .SKIPDP
    
    MOVEM.L D0-D2/A1-A2, -(SP)


    MOVE.L  ET_SPRITE(A0), A1
    MOVE.L  ET_ISPR(A0), D1

    ASL.L   #2, D1
    MOVE.L  4(A1, D1), A2

    LEA     ARM_POLARSTAR, A1
    CLR.W   D0

    ADD.B   LOOKDIRUD(A0), D0
    ADD.B   LOOKDIRLR(A0), D0
    CMP.B   #12, LOOKDIRUD(A0)
    BNE     .NOADD
        ADDQ.B  #4, D0
    .NOADD:

    MOVE.L  (A1, D0), -(SP)

    MOVE.W  ET_YPOS(A0), D0
    SUB.W   (SCREEN_Y), D0
    MOVE.W  D0, -(SP)
    MOVE.W  ET_XPOS(A0), D0
    SUB.W   (SCREEN_X), D0
    MOVE.W  D0, -(SP)

    JSR     FASTSPRITE      ;ARMA

    MOVE.L  A2, 4(SP)

    JSR     FASTSPRITE      ;CHARA

    ADDQ.L  #8, SP

    IFNE DEBUG
        MOVE.B #90, D0
        ADDA.L #ET_HBOX, A0
        MOVEM.W (A0)+, D1-D4
        SUBA.L #ET_START, A0
        ADD.W ET_XPOS(A0), D1
        ADD.W ET_XPOS(A0), D3
        ADD.W ET_YPOS(A0), D2
        ADD.W ET_YPOS(A0), D4
        SUB.W SCREEN_X, D1
        SUB.W SCREEN_X, D3
        SUB.W SCREEN_Y, D2
        SUB.W SCREEN_Y, D4
        TRAP #15
    ENDC

    MOVEM.L (SP)+, A2-A1/D2-D0
    .SKIPDP:
    RTS

PLAYER_DAMAGE:
    ; (SP).W DAMAGE
    MOVEM.L D0/A0, -(SP)
    MOVE.L  12(SP), A0
    ;COMPROBAR INVENCIBILIDAD
    TST.B   TIMERINVI(A0)
    BNE     .CNTDAMG

    ;RESTAR XP ARMA
    MOVE.W  #-5, -(SP)
    JSR     GM_UPD_BLTXP
    ADDQ.L  #2, SP

    ;RESTAR VIDA
    MOVE.W  16(SP), D0
    SUB.W   D0, ET_HP(A0)

    ADD.B   #INVTIME, TIMERINVI(A0)

    ;KNOCKBACK    
    MOVE.W  ET_XSPEED(A0), D0
    ADD.W   D0, D0
    NEG.W   D0
    MOVE.W  D0, ET_XSPEED(A0)
    ;NEG.W ET_YSPEED(A0)

    MOVE.W  #67, -(SP)
    MOVE.W  #1, -(SP)
    BSR     PLAY_SFX

    ADDQ.L  #4, SP

    .CNTDAMG:
    MOVEM.L (SP)+, A0/D0
    RTS

BULLET_SHOT:
    MOVEM.L D0-D2/A1, -(SP)
    CLR.L   D0

    LEA     ALLARMS, A1
    LEA     ARMS_STS, A2
    CLR.L   D1
    CLR.L   D2
    MOVE.B  (EQUIPARM), D1
    MOVE.L  (A1, D1), A1
    MOVE.W  (A2, D1), D2 ;NIVEL,XP
    MOVE.B  MAX_BLT_ONSCR(A1), D1
    CMP.B   BLT_ONSCREEN(A1), D1
    BLE     .ENDBS
    ;EXTRAER NIVEL D2
    LSR.W   #8, D2
    SUBQ.W  #1, D2

    ;DEPENDE ARMA/NIVEL
    MOVE.W  #62, -(SP)
    MOVE.W  #1, -(SP)
    JSR     PLAY_SFX
    ADDQ.L  #4, SP

    MOVE.W  ET_XPOS(A0), -(SP)
    MOVE.W  ET_YPOS(A0), -(SP)

    ADD.W   #24, (SP)     ;OFFSET Y
    TST.B   LOOKDIRLR(A0)
    BEQ     .NOXOF
        ADD.W   #40, 2(SP)
    .NOXOF:

    MOVE.W  D2, -(SP)    ;NIVEL
    
    TST.B   LOOKDIRUD(A0)
    BEQ     .NOUD
    MOVE.B  LOOKDIRUD(A0), D0
    SUB.W   #24, 2(SP)    ;DES OF Y
    BRA     .ENDDIR
    .NOUD:
    MOVE.B  LOOKDIRLR(A0), D0
    .ENDDIR:
    ASR.W   #2, D0
    MOVE.W  D0, -(SP)    ;DIRECCION
    
    MOVE.L  A1, -(SP)
    BSR     INSTANCE_ENTITY
    ADDA.L  #12, SP

    .ENDBS:
    MOVEM.L (SP)+, A1/D2-D0
    RTS

PLAYER:
    DC.W 1                                          ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 8,4, 58,64                                 ;ET_HBOX
    DC.L PLAYER_START, PLAYER_UPDATE, PLAYER_PAINT  ;@
    DC.L PLAYER_DAMAGE                              ;@
    DC.L QUOTE_WALK_RN                              ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W -256                                       ;ET_ZORD
                                              ;46.W (timer sprite)
                                              ;47.B (lookdir) 0:left 4:right 
                                                    ;48.B (lookdir) 8:up 12:down
                                                    ;49.B (timer jump)
                                                    ;50.B (equipped arm)
LOOKDIRLR       EQU ET_DATA+0  ;B
LOOKDIRUD       EQU ET_DATA+1  ;B
TIMERJUMP       EQU ET_DATA+2  ;B
TIMERINVI       EQU ET_DATA+3  ;B
MAXHEALTH       EQU ET_DATA+4  ;W

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
