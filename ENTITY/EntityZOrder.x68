*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
;------ Z ORDER ----- ;
; PARA TENER UN Z ORDER USO UNA LISTA ENLAZADA Y ORDENADA
; PERMITE FLEXIBILIDAD EN RUNTIME
; ESTRUCTURA NODE
;   DC.L @ET ;-1 LIBRE
;   DC.L @NEXT NODE -1 end

ZORD_CLEAR:
    ;LIMPIA LA LISTA 
    MOVE.L  #-1, (BOTNODE)
    MOVE.L  #-1, (NODEVECTOR)
    RTS

ZORD_ADD:
    ;AAAA
    ;POFA FUNCIONA CABECITA MIA
    MOVEM.L D0/A0-A4, -(SP)
    
    MOVE.L  28(SP), A2
    LEA     NODEVECTOR, A0
    .FNEW:                  ;BUSCAR ESPACIO NUEVO
    TST.L   (A0)
    BMI     .MFOUND
    ADDA.L  #NODESIZE, A0
    BRA     .FNEW           ;LIMITE?
    .MFOUND:
    MOVE.L  (BOTNODE), A1   
    MOVE.L  #-1, A3
    .LOOP:
    CMP.L   #0, A1
    BMI     .INSERT
    MOVE.L  (A1), A4        ;COMPARATIVAS
    MOVE.W  ET_ZORD(A4), D0
    CMP.W   ET_ZORD(A2), D0
    BLT     .INSERT
    MOVE.L  A1, A3
    MOVE.L  4(A1), A1
    BRA     .LOOP
    .INSERT:
    CMP.L   #0, A3
    BPL     .NONBNODE
    MOVE.L  A0, (BOTNODE)
    BRA     .SAVE
    .NONBNODE:
    MOVE.L  A0, 4(A3)
    .SAVE:
    MOVE.L  A2, (A0)    ;GUARDAR
    MOVE.L  A1, 4(A0)

    .END:
    MOVEM.L (SP)+, A4-A0/D0
    RTS

ZORD_REMOVE:
    ;ELIMINA ENTIDAD DE LA LISTA
    ;X(SP).L @ET

    LEA     NODEVECTOR, A0
    MOVE.L  -666(SP), A1
    .LOOP:
    CMP.L   (A0), A1
    BEQ     .FOUND
    MOVE.L  4(A0), A0
    BMI     .END
    BRA     .LOOP
    .FOUND:
    .END:
    RTS

ZORD_UPDATE:
    ;ACTUALIZA POS ENTIDAD

    BSR ZORD_REMOVE
    BRA ZORD_ADD

BOTNODE     DC.L  NODEVECTOR
NODEVECTOR  DCB.L NUM_ENT*2,-1

NODESIZE    EQU 8  ;EN BYTES










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
