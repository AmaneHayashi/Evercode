DATA     SEGMENT
SNO      DB  021H,0DDH,0F4H,0D9H,0F4H,0FDH
COUNT    EQU $-SNO
SL       DB  ?
DATA     ENDS

STACK    SEGMENT STACK 'STACK'
         DB  100 DUP(?)
STACK    ENDS

CODE     SEGMENT
         ASSUME CS:CODE,DS:DATA,SS:STACK

;DELAY    PROC
;         PUSH CX
;         MOV  CX,0001H
;DELAY1:  PUSH CX
;         MOV  CX,0001H
;DELAY2:  LOOP DELAY2
;         POP  CX
;         LOOP DELAY1
;         POP  CX
;         RET
;DELAY    ENDP

START:   MOV  AX,DATA
         MOV  DS,AX
NEXT:    MOV  CX,COUNT
         LEA  BX,SNO
         MOV  SL,01H
AGAIN:   MOV  AL,80H
         MOV  DX,0E803H
         OUT  DX,AL
         MOV  AL,SL
         MOV  DX,0E801H
         OUT  DX,AL
         MOV  AL,[BX]
         MOV  DX,0E800H
         OUT  DX,AL
         MOV  AL,00H
         MOV  DX,0E800H
         OUT  DX,AL
         INC  BX
         SHL  SL,1
         LOOP AGAIN
         MOV  AH,0BH
         INT  21H
         OR   AL,AL
         JZ   NEXT
         MOV  AX,4C00H
         INT  21H
CODE     ENDS
         END  START
