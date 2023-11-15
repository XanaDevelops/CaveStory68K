*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


OPEN_READ:
    ; 16(SP).L @ARCHIVO A LEER -> FDESC (-1 ERR)
    MOVEM.L D0-D1/A1, -(SP)

    MOVE.B  #51, D0
    BRA     OPEN
OPEN_WRITE:
    ; 16(SP).L @ARCHIVO A LEER -> FDESC (-1 ERR)
    MOVEM.L D0-D1/A1, -(SP)
    MOVE.B  #52, D0
    BRA     OPEN
OPEN:
    ;ENTRE ABRIR L/S SOLO CAMBIA D0
    MOVE.L  16(SP), A1
    TRAP    #15
    TST.L   D0
    BEQ     .NOERR
    ;ERROR
    MOVE.L  #-1, 16(SP)
    BRA     .END
    .NOERR:
    MOVE.L  D1, 16(SP)
    
    .END:
    MOVEM.L (SP)+, A1/D1-D0
    RTS
READ_FILE:
    ; (SP).L FDESC
    ; (SP).L BUFF
    ; (SP).W BYTES -> -1 SI ERR
    MOVEM.L D0-D2/A1, -(SP)    
    
    MOVE.B  #53, D0
    BRA     RW_FILE
WRITE_FILE:
    ; 26(SP).L FDESC
    ; 22(SP).L BUFF
    ; 20(SP).W BYTES -> -1 SI ERR
    MOVEM.L D0-D2/A1, -(SP)

    MOVE.B  #54, D0
    BRA     RW_FILE

RW_FILE:
    MOVE.L  26(SP), D1
    MOVE.L  22(SP), A1
    MOVE.W  20(SP), D2
    TRAP    #15
    TST.W   D0
    BEQ     .NOERR
    MOVE.W  #-1, D0
    .NOERR:
    MOVE.W  D0, 20(SP)

    MOVEM.L (SP)+, A1/D2-D0
    RTS

CLOSEFILE:
    ; 12(SP) FDESC
    MOVEM.L D0-D1, -(SP)

    MOVE.B  #56, D0
    MOVE.L  12(SP), D1
    TRAP    #15
    
    MOVEM.L (SP)+, D1-D0
    RTS

CLOSEFILES:
    MOVE.W D0, -(SP)

    MOVE.B  #50, D0
    TRAP    #15

    MOVE.W (SP)+, D0
    RTS

IOFILEW DS.L 1









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
