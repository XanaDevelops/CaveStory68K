*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
; --- DBOX CODES --- ;
; COLOR CODES
CDBCCOL     EQU $A0 ;PINTA -> COLOR
CDBCRED     EQU $A1 ;PINTA ROJO
CDBBLACK    EQU $A2 ;PINTA NEGRO
CDBWHITE    EQU $A3 ;PINTA BLANCO (DEFAULT)
;TODO RESTO

; CONTROL CODES
CDBDIAG     EQU $B0 ;SALTA A DIAG -> ID.W
CDBEXE      EQU $B1 ;SALTA A SUBR -> DIR.L
CDBPUSHNW   EQU $B2 ;PUSH SP VALOR -> N.W
CDBPUSHDW   EQU $B3 ;PUSH SP VALOR -> (D.L).W
CDBSING     EQU $B4 ;EJECUTA UNA VEZ LOS COMANDOS
CDBDSINGEND EQU $B5 ;HASTA SINGEND
CDBWAITZ    EQU $B6 ;ESPERA Z
CDBWAITT    EQU $B7 ;ESPERA T FRAMES -> T.B 
CDBASKYN    EQU $B8 ;PREGUNTA SI/NO (Z/X)-> ID.W (Y) ID.W (N)
CDBSFX      EQU $B9 ;SFX MAX PRIO -> ID.W
CDBBGM      EQU $BA ;SET BMG -> ID.B






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
