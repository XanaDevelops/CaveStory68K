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
    ;40(SP) ET_YPOS
    ;42(SP) ET_XPOS
    MOVEM.L D0/A1, -(SP)
    CMP.B   #MAX_BLT_ONSCR, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BLE     .NOAB
    MOVE.L  A0, -(SP)
    BSR     DESTROY_ENTITY
    ADDQ.L  #4, SP
    BRA     .ENDS
    .NOAB:
    ADDQ.B  #1, (BULLET_POLARSTAR+BLT_ONSCREEN)

    MOVE.W  42(SP), ET_XPOS(A0)
    MOVE.W  40(SP), ET_YPOS(A0)

    BSET.B  #2, ET_BSTATE(A0) ;DISABLE GRAV
    
    

    MOVE.W  38(SP), D0
    MOVE.B  D0, LEVELPOWER(A0)
    
    ;SEGUN NIVEL, 
    MOVE.B  #10, MAX_T_SCREEN(A0)
    ;AQUI SE MIRARIA EL DAÑO POR NIVEL, MIENTRAS...
    LEA     .DAMAGES, A1
    ASL.W   #1, D0
    MOVE.W  (A1, D0), DAMAGE(A0)
    
    ;CAJA DE COLISION
    ;TODO
    ASL.W   #1, D0  ;POR ASL.W #1 DE ANTES!
    LEA     PSTAR_BULLETS, A1
    MOVE.L  (A1, D0), ET_SPRITE(A0) ;LOAD SPRITE
    
    LEA     .HBOXS, A1
    MOVE.L  (A1, D0), A1
    MOVE.W  36(SP), D0
    MOVE.B  D0, TRAVEL_DIR(A0)

    CMP.B   #2, D0
    BGE .NOV
        MOVE.L  #0, ET_ISPR(A0)
        MOVE.W 0(A1), ET_HBOX+4(A0)
        MOVE.W 2(A1), ET_HBOX+6(A0)
        BRA     .ENDIR
    .NOV:
        MOVE.L  #1, ET_ISPR(A0)
        MOVE.W  2(A1), ET_HBOX+4(A0)   ;HBOX DEPENDIENTE NIVEL
        MOVE.W  0(A1), ET_HBOX+6(A0)
    .ENDIR:

    .ENDS:
    MOVEM.L (SP)+, A1/D0
    RTS
    .DAMAGES:   DC.W 1,2,4
    .HBOXS:     DC.L .HBOX1, .HBOX2, .HBOX3
    .HBOX1:     DC.W 64,4
    .HBOX2:     DC.W 64,16
    .HBOX3:     DC.W 64,34

BLT_PS_UPDATE:
    MOVEM.L D0/A1, -(SP)
    CLR.L   D0

    TST.B   MAX_T_SCREEN(A0)
    BGE     .NOTUP
    MOVE.L  A0, -(SP)
    SUBQ.B  #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BSR     DESTROY_ENTITY
    ADDA.L  #4, SP
    BRA     .ENDBLTPSUP
    .NOTUP:

    LEA     VSPEEDPS, A1
    MOVE.B  TRAVEL_DIR(A0), D0
    ASL.W   #2, D0
    MOVE.W  (A1, D0), ET_XSPEED(A0)
    MOVE.W  2(A1, D0), ET_YSPEED(A0)

    MOVE.L  A0, -(SP)
    BSR     UPDATE_PHYSICS
    
    SUBQ.L  #4, SP
    BSR     COLLISION_ENT_ENM

    MOVE.L  (SP)+, A1
    CMP.L   #-1, A1       ;CHECK COLI
    BEQ     .NOCOLIE
    
    MOVE.W  DAMAGE(A0), -(SP)
    MOVE.L  A1, -(SP)
    MOVE.L  ET_REVDAM(A1), A1
    JSR     (A1)
    ADDQ.L  #6, SP

    ;SE QUEDA EN SP A0
    SUBQ.B  #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
    BSR     DESTROY_ENTITY
    
    ADDA.L  #4, SP
    BRA     .ENDBLTPSUP 
    
    .NOCOLIE:

    CLR.L   D0
    MOVE.B  ET_BSTATE(A0), D0
    ANDI.B  #%11110000, D0
    TST.B   D0
    BEQ     .NOHIT
        SUBQ.B  #1, (BULLET_POLARSTAR+BLT_ONSCREEN)
        BSR     DESTROY_ENTITY
    .NOHIT:

    ADDA.L  #4, SP

    SUBQ.B  #1, MAX_T_SCREEN(A0)

    .ENDBLTPSUP:
    
    MOVEM.L (SP)+, A1/D0
    RTS

BULLET_POLARSTAR:
    DC.W 10                                         ;ET_ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;ET_HP (damage dealt)
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;ET_MSTATE 00 UDLR(AIRBONE)(!GRAV)--
    DC.W 0,0, 64,4                                  ;ET_HBOX
    DC.L BLT_PS_START, BLT_PS_UPDATE, DEFAULT_PAINT ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L PSTAR_BULLET_1                             ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0
                                              ;46.B (level) 012
                                                    ;47.B (time onscreen)
                                                    ;48.W (traveldistance)
                                                    ;49.B (dir) 0123 LRUD
;STATIC VALUES                    
MAX_BLT_ONSCR       DS.B 1
                    DS.W 0

DAMAGE              EQU ET_HP

LEVELPOWER          EQU ET_DATA   ;B
MAX_T_SCREEN        EQU ET_DATA+1 ;B
MAX_TRVL_DIST       EQU ET_DATA+2 ;W
TRAVEL_DIR          EQU ET_DATA+4 ;B
BLT_ONSCREEN        EQU ET_DATA+5 ;B
MAX_BLT_ONSCR       EQU ET_DATA+6 ;B






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
