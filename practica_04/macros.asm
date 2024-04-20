
;----------------------------------------------
clearConsole MACRO 
    MOV AX, 03H
    INT 10H
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

printCadena MACRO registrop 
    MOV AH, 09h 
    LEA DX, registrop
    INT 21h
ENDM


;---------------------------------------------- guardar player
obtenerCadena MACRO regBuffer, maxLength
    LOCAL leer_caracter_bucle, fin_lectura
    ; Inicializar índice y contador de longitud
    xor si, si

    ; Bucle para leer caracteres
    leer_caracter_bucle:
        ; Leer un carácter sin eco
        mov ah, 01h
        int 21h

        ; Verificar si es un enter (carácter ASCII 13)
        cmp al, 13
        je fin_lectura

        ; Almacenar el carácter en el buffer
        mov [regBuffer + si], al

        ; Incrementar índice y contador de longitud
        inc si
        cmp si, maxLength
        jge fin_lectura                  ; Si hemos alcanzado la longitud máxima, terminamos la lectura

        jmp leer_caracter_bucle            ; Si no, volvemos a leer otro carácter

    fin_lectura:

ENDM
