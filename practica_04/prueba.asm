; Define la macro para generar un número aleatorio entre 1 y 3
generateRandomNumber MACRO numVar
    ; Inicialización del generador de números aleatorios
    mov ah, 2Ch
    int 21h
    xor dx, dx

    mov ah, 0
    int 1Ah
    and dx, 2  ; dx ahora está en el rango 0-2
    add dl, 1  ; Ajusta el valor para que esté en el rango 1-3
    mov numVar, dl
ENDM

; Define la macro para imprimir el número
convertToAsciiF MACRO numVar
    mov dl, numVar
    add dl, '0'  ; Convierte a ASCII
    mov [fila], dl
ENDM

asignarC MACRO numVar
    mov dl, numVar
    add dl, '0'  ; Convierte a ASCII
    mov [columna], dl
ENDM

printCadena MACRO registrop 
    MOV AH, 09h 
    LEA DX, registrop
    INT 21h
ENDM


.MODEL small
.STACK 64h
.RADIX 16

.DATA 
    numRandom1 db 00
    numRandom2 db 00
    fila db 00
    columna db 00  

.CODE

    MOV AX, @data
    MOV DS, AX
    
    main PROC

        ; Genera dos números aleatorios entre 1 y 3
        generateRandomNumber numRandom1

        ; Introduce un pequeño retraso
        mov cx, 0FFFFh
        delayLoop:
            loop delayLoop
        
        generateRandomNumber numRandom2
        
        ; Imprime los números
        convertToAsciiF numRandom1
        convertToAsciiC numRandom2
        
        printCadena fila
        printCadena columna

        ; Termina el programa
        mov ah, 4Ch
        int 21h
    main ENDP

END