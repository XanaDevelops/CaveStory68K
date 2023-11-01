*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
VSPEEDPS DC.W  -BLT_PS_SPEED,0, BLT_PS_SPEED,0, 0,-BLT_PS_SPEED, 0,BLT_PS_SPEED
BLT_PS_START:
    ;36(SP) DIR
    ;38(SP) LEVEL
    ;40(SP) YPOS
    ;42(SP) XPOS
    MOVEM.L D0/A1, -(SP)
    CMP.B #MAX_BLT_ONSCR, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BLE .NOAB
    MOVE.L A0, -(SP)
    BSR DESTROY_ENTITY
    ADDQ.L #4, SP
    BRA .ENDS
    .NOAB:
    ADDQ.B #1, (BULLET_POLARSTAR+BLT_ONSCREEN)

    MOVE.W 42(SP), XPOS(A0)
    MOVE.W 40(SP), YPOS(A0)

    BSET.B #2, STATUS+1(A0) ;DISABLE GRAV
    
    LEA PSTAR_BULLETS, A1

    MOVE.W 38(SP), D0
    MOVE.B D0, LEVELPOWER(A0)
    
    ;SEGUN NIVEL, 
    MOVE.B #10, MAX_T_SCREEN(A0)
    ;AQUI SE MIRARIA EL DAÑO POR NIVEL, MIENTRAS...
    MOVE.W #4, DAMAGE(A0)
    
    ;CAJA DE COLISION
    ;TODO
    ASL.W #2, D0
    MOVE.L (A1, D0), AD_SPRITE(A0) ;LOAD SPRITE
    
    MOVE.W 36(SP), D0
    MOVE.B D0, TRAVEL_DIR(A0)

    CMP.B #2, D0
    BGE .NOV
        MOVE.L #0, SPRITE_INDEX(A0)
        BRA .ENDIR
    .NOV:
        MOVE.L #1, SPRITE_INDEX(A0)
        MOVE.W #4, COLISION_BOX+4(A0)   ;HBOX DEPENDIENTE NIVEL
        MOVE.W #64, COLISION_BOX+6(A0)
    .ENDIR:

    .ENDS:
    MOVEM.L (SP)+, A1/D0
    RTS

BLT_PS_UPDATE:
    MOVEM.L D0/A1, -(SP)
    CLR.L D0

    CMP.B #0, MAX_T_SCREEN(A0)
    BGE .NOTUP
    MOVE.L A0, -(SP)
    SUBQ.B #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BSR DESTROY_ENTITY
    ADDA.L #4, SP
    BRA .ENDBLTPSUP
    .NOTUP:

    LEA VSPEEDPS, A1
    MOVE.B TRAVEL_DIR(A0), D0
    ASL.W #2, D0
    MOVE.W (A1, D0), XSPEED(A0)
    MOVE.W 2(A1, D0), YSPEED(A0)

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    
    ;MOVE.L #-1, -(SP)
    SUBQ.L #4, SP
    BSR COLLISION_ENT_ENM

    MOVE.L (SP)+, A1
    CMP.L #-1, A1       ;CHECK COLI
    BEQ .NOCOLIE

    ;CMP.W #0, (A1)      ;CHECK ENEMIGO
    ;BGE .NOCOLIE
    
    MOVE.W DAMAGE(A0), -(SP)
    MOVE.L A1, -(SP)
    MOVE.L AD_DODAM(A1), A1
    JSR (A1)
    ADDQ.L #6, SP

    ;SE QUEDA EN SP A0
    SUBQ.B #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BSR DESTROY_ENTITY
    
    ADDA.L #4, SP
    BRA .ENDBLTPSUP 
    
    .NOCOLIE:

    CLR.L D0
    MOVE.B STATUS+1(A0), D0
    ANDI.B #%11110000, D0
    CMP.B #0, D0
    BEQ .NOHIT
        SUBQ.B #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
        BSR DESTROY_ENTITY
    .NOHIT:

    ADDA.L #4, SP

    SUBQ.B #1, MAX_T_SCREEN(A0)

    .ENDBLTPSUP:
    
    MOVEM.L (SP)+, A1/D0
    RTS

BLT_PS_PAINT:
    RTS
BLT_PS_DAMAGE:
    RTS

BULLET_POLARSTAR:
    DC.W 10                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP (damage dealt)
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(AIRBONE)(!GRAV)--
    DC.W 0,0, 64,4                                  ;COLISION_BOX
    DC.L BLT_PS_START, BLT_PS_UPDATE, DEFAULT_PAINT ;@
    DC.L BLT_PS_DAMAGE                              ;@
    DC.L PSTAR_BULLET_1                             ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          ;46.B (level) 012
    DS.W 1                                          ;47.B (time onscreen)
                                                    ;48.W (traveldistance)
                                                    ;49.B (dir) 0123 LRUD
                                                    


DAMAGE              EQU HP

LEVELPOWER          EQU AUX_DATA   ;B
MAX_T_SCREEN        EQU AUX_DATA+1 ;B
MAX_TRVL_DIST       EQU AUX_DATA+2 ;W
TRAVEL_DIR          EQU AUX_DATA+4 ;B
BLT_ONSCREEN        EQU AUX_DATA+5 ;B
MAX_BLT_ONSCR       EQU AUX_DATA+6 ;B




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
