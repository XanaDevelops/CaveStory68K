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
; -- PARTE SISTEMA --- ;
    ;CARGAR CANCIONES PRIMERO
    BRA     .CFGSERVER
.CFGINT:
    ;CONFIGURAR INTERRUPCIONS
    ;INT OFF
    ORI.W   #%0000011100000000, SR
    ;INSTALL
    MOVE.L  #CHECKHBEAT, (INTBASE+(4*7))
    ;CONFIGURE
    ;CHECKRATE
    MOVE.B  #32, D0
    MOVE.B  #6, D1
    MOVE.B  #$87, D2
    MOVE.L  #CHECKRATE, D3
    TRAP    #15
    ;SET SR
    ANDI.W  #%1111100011111111, SR
    ;ENABLE
    MOVE.B  #32, D0
    MOVE.B  #5, D1
    TRAP    #15
    BRA     .CMDLOOP
; -- SERVIROR COMO TAL ---;
.CFGSERVER:
    BSR     START_SERVER
    MOVE.B  #13, D0
    LEA     TXTOK, A1
    TRAP    #15
    BRA     .CFGINT
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
    BNE     .NOSTOP
    BSR     STOP_SFX
    
    .NOSTOP:
    CMP.W   #CDMHBEAT, D0
    BNE     .CMDLOOP
    MOVE.B #1, (GETHBEAT)
    BRA     .CMDLOOP
EXIT:
    SIMHALT             ; halt simulator


GETHBEAT    DC.B 0
            DS.W 0
CHECKHBEAT:
    CMP.B   #0, (GETHBEAT)
    BNE     .REV
    BSR     STOP_SFX
    BRA     EXIT
    .REV:
    CLR.B   (GETHBEAT)
    RTE

    INCLUDE "TCPCLIENT.X68"
    INCLUDE "MUSIC.X68"
    INCLUDE "DATA/SOUNDS.X68"


    END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
