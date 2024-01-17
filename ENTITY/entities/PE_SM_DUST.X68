*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

PESMDUST_START:
    ;28(SP) ET_YPOS 
    ;30(SP) ET_XPOS

    MOVE.W  28(SP), ET_YPOS(A0)
    MOVE.W  30(SP), ET_XPOS(A0)

    ;CONTADOR PARA INSTANCIAS PA_DUST
    MOVE.B  #10, PESMD_COUNTER(A0)

    RTS

PESMDUST_UPDATE:

    SUBI.B  #1, PESMD_COUNTER(A0)
    BPL     .NOKILL
    MOVE.L  A0, -(SP)
    JSR     DESTROY_ENTITY
    ADDQ.L  #4, SP
    BRA     .END
    .NOKILL:
    BTST.B  #0, PESMD_COUNTER(A0)
    BEQ     .END
    
    ;INSTANCIA
    MOVE.W  ET_YPOS(A0), -(SP)
    MOVE.W  ET_XPOS(A0), -(SP)
    MOVE.L  #PADUST, -(SP)

    ;OFFSET ALEATORIO
    BSR     .D0VAL
    ADD.W   D0, 4(SP)
    BSR     .D0VAL
    ADD.W   D0, 6(SP)

    JSR     INSTANCE_ENTITY
    ADDQ.L  #8, SP
    .END:
    RTS

    .D0VAL:
    TRAP    #TRNG
    MOVE.L  (RNGVAL), D0
    AND.L   #$8000000F, D0
    BPL     .NONEG
    NEG.W   D0
    .NONEG:
    RTS


PESMDUST:
    DC.W 40                                          ;ET_ID
    DC.W 0, 0                                       ;ET_XPOS, ET_YPOS
    DC.W 0                                          ;ET_HP
    DC.W 0, 0                                       ;ET_XSPEED, ET_YSPEED
    DC.W 0                                          ;ET_MSTATE 00 
                                                    ;ET_BSTATE UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;ET_HBOX 44
    DC.L PESMDUST_START, PESMDUST_UPDATE, DEFAULT_RTS      ;@EXECUTES
    DC.L DEFAULT_RTS                             ;@INTERACT/EXTRA
    DC.L -1                                         ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DC.W 0                                          ;ET_TSPRT
    DC.W 0                                          ;ET_ZORD
    DS.W 1                                         

PESMD_COUNTER   EQU ET_DATA ;B
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
