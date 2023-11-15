*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SYSTEM_INIT:
    ;INT OFF
    ORI.W   #%0000011100000000, SR
    ;INSTALL
    MOVE.L  #UPDATE_KEYS, (TRAPBASE)
    MOVE.L  #UPDRNG, (TRAPBASE+(4*14))

    MOVE.L  #ISRSCREEN, (INTBASE+(4*7))
    MOVE.L  #RESETPRIO, (INTBASE+(4*6))
    MOVE.L  #HEARTBSV,  (INTBASE+(4*5))
    
    MOVE.L  #EXCADDRES, ($0C)
    MOVE.L  #IRQTRACE, ($24)
    
    ;CONFIGURE
    ;ISRSCREEN
    MOVE.B  #32, D0
    MOVE.B  #6, D1
    MOVE.B  #$87, D2
    MOVE.L  #SCREEN_UPTIME, D3
    TRAP    #15
    ;RESETPRIO
    MOVE.B  #$86, D2
    MOVE.L  #RESETPRIOMS, D3
    TRAP    #15
    ;HEARTBSV
    MOVE.B  #$85, D2
    MOVE.L  #HBEATRATE, D3
    TRAP    #15
    ;INT ON
    IFNE DGBTRACE
        ORI.W  #$8000, SR ;TRACE
    ENDC
    ANDI.W  #%1111100011111111, SR
    ;ENABLE
    MOVE.B  #32, D0
    MOVE.B  #5, D1
    TRAP    #15

    ;CIERRA ARCHIVOS BUGFIX?
    JSR CLOSEFILES

    ;ESTABLECE LA SEMILLA
    MOVE.B  #8, D0
    TRAP    #15
    MOVE.L  D1, (RNGVAL)

    ;CONFIGURE SCREEN
    MOVE.B  #33, D0
    MOVE.L  #SCREEN_WIDTH*$10000+SCREEN_HEIGHT, D1
    TRAP    #15
    IFEQ DGB_NODBUF
        MOVE.B  #92, D0  ;dbuf
        MOVE.B  #17, D1
        TRAP    #15  
    ENDC

    BSR SET_SCROLL_TEXT

    JSR     START_CLIENT

    MOVE.W  #-1, (CURRENTTXTID)

    MOVE.W  SR, -(SP)    ;PASA A USUARIO
    ANDI.W  #$DFFF, (SP) ;D8FF
    RTE

UPDRNG:
    ;ACTUALIZA RNGVAL 
    ;TRAP #14
    MOVEM.L D0-D2, -(SP)

    MOVE.L  (RNGVAL), D0
    MOVE.L  D0, D1
    
    MOVE.L  D0, D2
    LSR.L   #2, D2
    EOR.L   D2, D1

    MOVE.L  D0, D2
    LSR.L   #3, D2
    EOR.L   D2, D1

    MOVE.L  D0, D2
    LSR.L   #5, D2
    EOR.L   D2, D1

    LSR.L   #1, D0

    BTST.L  #0, D1
    BEQ     .SB
    BSET.L  #31, D0
    .SB:  
    MOVE.L  D0, (RNGVAL)
    
    MOVEM.L (SP)+, D2-D0
    RTE

SET_SCROLL_TEXT:
    MOVEM.L D0-D2, -(SP)

    MOVE.B  #21, D0
    MOVE.L  #WHITE, D1
    ;MOVE.L #$04060000, D2   ;Example: D2.L = $01090005 is Fixedsys, 9 point, Bold Underline 8px
    MOVE.L  #$04100000, D2
    TRAP    #15

    MOVEM.L (SP)+, D2-D0
    RTS
SET_COLOR_TEXT:
    ; 16(SP).L COLOR
    MOVEM.L D0-D2, -(SP)

    MOVE.B #21, D0
    MOVE.L 16(SP), D1
    MOVE.L  #$04100000, D2
    TRAP #15

    MOVEM.L (SP)+, D2-D0
    RTS

HEARTBSV:
    ;HEART BEAT SERVER
    ;ENVIA PERIODICAMENTE SEÑALES AL SERVER
    CMP.B   #0, (HASBGMSRV)
    BNE     .END
    MOVE.W  #CDMHBEAT, -(SP)
    JSR     SEND_DATA
    ADDQ.L  #2, SP
    .END:
    RTE
RESETPRIO:
    ;REINICIA LA PRIO DE SFX
    CLR.B   (CURRPRIO)
    RTE

EXCADDRES:
    MOVEM.L A7-D0, -(SP)
    ;CLS
    MOVE.B  #11, D0
    MOVE.W  #$FF00, D0
    TRAP    #15

    MOVE.B  #94, D0
    TRAP    #15

    LEA     .EXCADDRESTXT, A0
    MOVE.B  #13, D0
    MOVE.L  (A0)+, A1
    TRAP    #15

    MOVE.B  #94, D0
    TRAP    #15

    MOVE.B  #23, D0
    MOVE.L  #150, D1
    TRAP    #15

    MOVE.B  #16, D2
    MOVE.W  #15, D7
    .REGLOOP:
    MOVE.B  #14, D0
    MOVE.L  (A0)+, A1
    TRAP    #15
    ADDQ.B  #1, D0
    MOVE.L  (SP)+, D1
    TRAP    #15
    SUBQ.B  #1, D0
    LEA     .LFCR, A1
    TRAP    #15
    DBRA    D7, .REGLOOP
    ;SP
    MOVE.L  (A0)+, A1
    MOVE.L  A1, A2
    MOVE.W  #6, D7
    .SPLOOP:
    MOVE.B  #14, D0
    MOVE.L  A2, A1
    TRAP    #15
    ADDQ.B  #1, D0
    MOVE.W  (SP)+, D1
    EXT.L   D1
    TRAP    #15
    SUBQ.B  #1, D0
    LEA     .LFCR, A1
    TRAP    #15
    DBRA    D7, .SPLOOP
    
    MOVE.B  #94, D0
    TRAP    #15
    ;NO HAY NADA QUE PODAMOS HACER
    ;SI NO ES UNA "BONUS" ROOM...
    SIMHALT

    .EXCADDRESTXT:  DC.L .ERR, .D0, .D1, .D2, .D3, .D4, .D5, .D6, .D7
                    DC.L .A0, .A1, .A2, .A3, .A4, .A5, .A6, .A7, .SP
    .ERR: DC.B 'ADDRESS ERROR',0
    .D0:  DC.B 'D0: ',0
    .D1:  DC.B 'D1: ',0
    .D2:  DC.B 'D2: ',0
    .D3:  DC.B 'D3: ',0
    .D4:  DC.B 'D4: ',0
    .D5:  DC.B 'D5: ',0
    .D6:  DC.B 'D6: ',0
    .D7:  DC.B 'D7: ',0
    .A0:  DC.B 'A0: ',0
    .A1:  DC.B 'A1: ',0
    .A2:  DC.B 'A2: ',0
    .A3:  DC.B 'A3: ',0
    .A4:  DC.B 'A4: ',0
    .A5:  DC.B 'A5: ',0
    .A6:  DC.B 'A6: ',0
    .A7:  DC.B 'A7: ',0
    .AD:  DC.B 'AC AD: ',0
    .IR:  DC.B 'IR: ',0
    .PC:  DC.B 'PC: ',0
    .SP:  DC.B 'SP: ',0
    .LFCR: DC.B LF,CR,0
            DS.W 0
            
    .LASTPC:    DS.L 1
    

IRQTRACE:
    MOVE.L .PCTRACE3, .PCTRACE4
    MOVE.L .PCTRACE2, .PCTRACE3
    MOVE.L .PCTRACE1, .PCTRACE2 
    MOVE.L 2(SP), .PCTRACE1
    RTE

    .PCTRACE1:  DS.L 1
    .PCTRACE2:  DS.L 1
    .PCTRACE3:  DC.L 1
    .PCTRACE4:  DC.L 1
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
