*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
READ_SD:
    ; (SP).W RET VALUE -1 ERR, 0 OK
    ;OPEN FILE
    MOVE.B #51
    LEA .SAVEFPTH, A1
    TRAP #15
    ;CHECK ERR
    CMP #0, D1
    BEQ .NOERR
    ;RET ERR
    MOVE.W #-1, (SP)
    BRA .END
    .NOERR:
    MOVE.L D1, (.FDESC)
    ;READ FILE 
    ;CHECK MAGIKN
    MOVE.B #53, D0
    LEA .IOBUF, A1
    MOVE.L #2, D2
    TRAP #15
    .END:
    RTS
WRITE_SD:
    RTS

.SAVEFPTH   DC.B 'SAVE.DAT',0
.IOBUF      DS.L 1
.FDESC      DS.L 1
MAGIKN  EQU $0901
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
