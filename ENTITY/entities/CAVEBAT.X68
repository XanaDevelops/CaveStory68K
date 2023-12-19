*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
BAT_START:
    ;30(SP) ET_YPOS 
    ;28(SP) ET_XPOS

    ;EL BUG ERA YO, CALCULABA MAL UNA DIRECCIÓN
    ;QUE MODIFICABA LA INSTRUCCIÓN, JUSTAMENTE AQUÍ
    MOVE.W  28(SP), ET_YPOS(A0) ;LONG?
    MOVE.W  30(SP), ET_XPOS(A0)

    CLR.B   VELDIR(A0)

    MOVE.W  #BATANMSPD, ET_TSPRT(A0)

    BSET.B  #2, ET_BSTATE(A0) ;DISABLE GRAV

    RTS

BAT_UPDATE:
    MOVEM.L D1-D2/A1, -(SP)

    TST.W   ET_HP(A0)
    BGT     .NOKILL
    KILL_ET_ENEMY #$2F, #0, #1
    BRA     .ENDUPDATE
    .NOKILL:

    TST.W   ET_YSPEED(A0)
    BNE     .NOIMP
    NOT.B   VELDIR(A0)
    BMI     .ESNEG
        ADD.W   #BATMY, ET_YSPEED(A0)
        BRA     .NOIMP
    .ESNEG:
        SUB.W   #BATMY, ET_YSPEED(A0)
    .NOIMP:

    TST.W   ET_YSPEED(A0)
    BMI     .ESNEG2
        SUBQ.W  #1, ET_YSPEED(A0)
        BRA     .ESZERO
    .ESNEG2:
        ADDQ.W  #1, ET_YSPEED(A0)
    .ESZERO:

    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS
    
    SUBQ.L  #4, SP
    BSR     COLLISION_ENT_PLR
    MOVE.L  (SP)+, A1
    
    CMP.L   #-1, A1
    BEQ     .NOCOLIE
    
    MOVE.W  #BATATK, -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  ET_REVDAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP
    .NOCOLIE:
    ADDQ.L  #4, SP

    MOVE.L  ET_ISPR(A0), D1                   ;ANIM_INDEX
        MOVE.W  ET_TSPRT(A0), D2                   ;CONTROLAR SALTO TODO
        SUBQ.W  #1, D2
        BNE     .NOTIMER
            MOVE.W  #BATANMSPD, D2
            ADDQ.L  #1, D1
            MOVE.L  ET_SPRITE(A0), A1
            CMP.L   (A1), D1
            BLT     .NOOF
            MOVE.L  #0, D1
            .NOOF:
            MOVE.L  D1, ET_ISPR(A0)
        .NOTIMER:
        MOVE.W  D2, ET_TSPRT(A0)

    .ENDUPDATE:

    MOVEM.L (SP)+, A1/D2-D1
    RTS

BAT_DAMAGE:
    ; 12(SP).L @ENT
    ; 16(SP).W DAMAGE
    MOVEM.L D0/A0, -(SP)
    MOVE.L  12(SP), A0

    MOVE.W  16(SP), D0
    SUB.W   D0, ET_HP(A0)

    MOVE.W  #36, -(SP)
    MOVE.W  #1, -(SP)
    BSR     PLAY_SFX
    ADDQ.L  #4, SP

    MOVEM.L (SP)+, A0/D0
    RTS

BAT:
    DC.W -1                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 3                                          ;ET_HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00UDLR(!AIRBONE)(!GRAV)--
    DC.W 4,4, 42,48                                 ;ET_HBOX
    DC.L BAT_START, BAT_UPDATE, DEFAULT_PAINT       ;@
    DC.L BAT_DAMAGE                                 ;@
    DC.L BAT_FLY_L                                  ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
    DC.W 0                                          ;ET_ZORD
                                         ;
    

VELDIR      EQU ET_DATA    ;B


BATATK      EQU 2






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
