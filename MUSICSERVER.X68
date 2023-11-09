*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    INCLUDE "XPMODE.X68"
    INCLUDE "MACROS.X68"
    INCLUDE "CONST.X68"

    ORG    $1000
START:                  ; first instruction of program

    ;INT OFF
    ORI.W   #%0000011100000000, SR

    BSR     START_SERVER
    MOVE.B  #13, D0
    LEA     TXTOK, A1
    TRAP    #15
    .CMDLOOP:
    SUBQ.L  #2, SP
    BSR     READ_DATA
    MOVE.W  (SP)+, D0
    
    MOVE.W  D0, D1
    MOVE.W  D0, -(SP)
    MOVE.B  #17, D0
    LEA     TXTCMD, A1
    TRAP    #15
    MOVE.W  (SP)+, D0
    
    CMP.W   #CMDPBGM, D0
    BNE     .NOPLAY
    ADDQ.L  #2, SP
    BSR     READ_DATA
    BSR     PLAY_BGM
    ADDQ.L  #2, SP
    BRA     .CMDLOOP
    
    .NOPLAY:
    CMP.W   #CMDSTOP, D0
    BNE     .CMDLOOP
    BSR     STOP_SFX
    ;AQUI COMANDO
    BRA     .CMDLOOP
EXIT:
    SIMHALT             ; halt simulator

* Put variables and constants here

    INCLUDE "TCPCLIENT.X68"
    INCLUDE "MUSIC.X68"
    INCLUDE "DATA/SOUNDS.X68"

    END    START        ; last line of source

GETHBEAT    DC.B 0
CHECKHBEAT:
    CMP.B   #0, (GETHBEAT)
    BNE     .REV
    BSR     STOP_SFX
    BRA     EXIT
    .REV:
    CLR.B   (GETHBEAT)
    RTE

CHECKRATE   EQU     HBEATRATE<<1









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
