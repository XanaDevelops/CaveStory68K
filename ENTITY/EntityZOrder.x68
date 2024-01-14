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
    MOVEM.L D7/A0, -(SP)

    MOVE.L  #-1, (BOTNODE)
    LEA     NODEVECTOR, A0
    MOVE.W  #NUM_ENT-1, D7
    .LOOP:
    MOVE.L  #-1, (A0)
    ADD.L   #NODESIZE, A0
    DBRA    D7, .LOOP

    MOVEM.L (SP)+, A0/D7
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
    ;24(SP).L @ET
    MOVEM.L A0/A2-A3, -(SP)

    MOVE.L  16(SP), A2

    MOVE.L  (BOTNODE), A0
    MOVE.L  #-1, A3
    .LOOP:
    CMP.L   #0, A0
    BMI     .END
    CMP.L   (A0), A2
    BEQ     .REM
    MOVE.L  A0, A3
    MOVE.L  4(A0), A0
    BRA     .LOOP
    .REM:
    MOVE.L  #-1, (A0)
    CMP.L   #0, A3
    BMI     .NOA3
    MOVE.L  4(A0), 4(A3)
    BRA     .END
    .NOA3:
    MOVE.L  4(A0), (BOTNODE)
    .END:
    
    MOVEM.L (SP)+, A3-A2/A0
    RTS

ZORD_UPDATE:    MACRO
    ;ACTUALIZA POS ENTIDAD
    ;MACRO POR A0 EN STACK
    
    BSR ZORD_REMOVE
    BSR ZORD_ADD

    ENDM

BOTNODE     DC.L  -1
NODEVECTOR  DCB.L NUM_ENT*2,-1

NODESIZE    EQU 8  ;EN BYTES











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
