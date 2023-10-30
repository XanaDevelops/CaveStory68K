*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CLOUD_START:
    ;28(SP) YPOS 
    ;30(SP) XPOS
    ;32(SP) TYPE

    MOVE.W 28(SP), YPOS(A0)
    MOVE.W 30(SP), XPOS(A0)

    MOVE.W 32(SP), D0
    ASL.W #1, D0
    MOVE.W D0, TYPE(A0)
    ASL.W #1, D0
    LEA CLOUDS, A1
    MOVE.L (A1, D0.W), AD_SPRITE(A0)

CLOUD_UPDATE:
    MOVE.W D0, -(SP)
    MOVE.W XPOS(A0), D0

    SUBQ.W #STARTVEL, D0
    ADD.W TYPE(A0), D0
    CMP.W #-CLOUDXSIZE, D0
    BGT .NOPAR
    MOVE.W #CLOUDXSIZE, D0
    .NOPAR:
    MOVE.W D0, XPOS(A0)

    MOVE.W (SP)+, D0
    RTS

CLOUD_PAINT:
    MOVE.L AD_SPRITE(A0), -(SP)
    MOVE.W YPOS(A0), -(SP) ;Y
    MOVE.W XPOS(A0), -(SP) ;X
    JSR FASTSPRITE
    ADDQ.L #8, SP
    RTS
    
CLOUD:
    DC.W 3                                          ;ID
    DC.W 0, 0                                       ;POSITION
    DC.W 0                                          ;HP
    DC.W 0, 0                                       ;SPEED
    DC.W 0                                          ;STATUS 00 UDLR(!AIRBONE)(!GRAV)--
    DC.W 0,0, 0,0                                   ;COLISION_BOX 44
    DC.L CLOUD_START, CLOUD_UPDATE, CLOUD_PAINT     ;@
    DC.L DEFAULT_RTS                                ;@
    DC.L NUBE0                                     ;@SPRITE DEFECTO
    DC.L 0                                          ;SPRITEINDEX
    DS.L 4                                          
    DS.W 1        
    
TYPE        EQU AUX_DATA

CLOUDXSIZE  EQU 640
STARTVEL    EQU 7


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
