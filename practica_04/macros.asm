
;----------------------------------------------
clearConsole MACRO 
    MOV AX, 03H
    INT 10H
ENDM

printCadena MACRO registrop 
    MOV AH, 09h 
    LEA DX, registrop
    INT 21h
ENDM


getOp MACRO registrOp
    MOV AH, 01h
    INT 21h
    MOV registrOp, AL
ENDM

;---------------------------------------------- imprimir en pantalla color
PrintColor MACRO rPrint, color
    MOV AH, 09h     
    MOV AL, ' '     
    MOV BH, 0       
    MOV BL, color   
    MOV CX, lengthof rPrint       
    INT 10h         ; Interrupción de video

    MOV AH, 09h     
    LEA DX, rPrint ; Carga la dirección de la cadena en DX
    INT 21h         
ENDM

;---------------------------------------------- modo texto y video
ModoVideo MACRO
    MOV AL, 13h
    MOV AH, 00h
    INT 10h    
ENDM

ModoTexto MACRO
    MOV AL, 03h
    MOV AH, 00h
    INT 10h
ENDM

