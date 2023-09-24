*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
BLT_SPEED   EQU 40
VSPEEDPS DC.W 0,-BLT_SPEED, 0,BLT_SPEED, -BLT_SPEED,0, BLT_SPEED,0
BLT_PS_START:
    ;36(SP) DIR
    ;38(SP) LEVEL
    ;40(SP) YPOS
    ;42(SP) XPOS
    MOVEM.L D0/A1, -(SP)
    
    MOVE.W 42(SP), 2(A0)
    MOVE.W 40(SP), 4(A0)

    BSET.B #2, 13(A0) ;DISABLE GRAV
    
    MOVE.W 38(SP), D0
    MOVE.B D0, 42(A0)

    ;AQUI SE MIRARIA EL DAÑO POR NIVEL, MIENTRAS...
    MOVE.W #1, 6(A0)

    LEA PSTAR_BULLETS, A1
    ASL.W #2, D0
    MOVE.L (A1, D0), 34(A0) ;LOAD SPRITE

    MOVE.W 36(SP), D0
    MOVE.B D0, 46(A0)

    MOVEM.L (SP)+, A1/D0
    RTS

BLT_PS_UPDATE:
    MOVEM.L D0/A1, -(SP)

    LEA VSPEEDPS, A1
    MOVE.B 46(A0), D0
    ASL.W #2, D0
    MOVE.W (A1, D0), 8(A0)
    MOVE.W 2(A1, D0), 10(A0)

    MOVE.L A0, -(SP)
    BSR UPDATE_PHYSICS
    ADDA.L #4, SP

    MOVEM.L (SP)+, A1/D0
    RTS
BLT_PS_PAINT:
    RTS

BULLET_POLARSTAR:
    DC.W 10                                         ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP (damage dealt)
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00UDLR(AIRBONE)---
    DC.W 0,0, 64,4                                  ;COLISION_BOX
    DC.L BLT_PS_START, BLT_PS_UPDATE, DEFALUT_PAINT ;@
    DC.L PSTAR_BULLET_1                             ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 5                                          ;42.B (level) 012
    DS.W 1                                          ;43.B (max onscreen)
                                                    ;44.W (max traveldistance)
                                                    ;46.B (dir) 0123 UDLR
                                                    



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
