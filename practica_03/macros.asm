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
;------------------------------------------------------------- 

obtenerCadena MACRO regBuffer, maxLength
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
        mov byte ptr [regBuffer + si], "$"
    ENDM


;-------------------------------------------------------------
printTableroJuego MACRO
    LOCAL fila, columna

    MOV BX, 0                       ; indice de las filas
    XOR SI, SI                      ; indice para el tablero

    printCadena tabulador
    printCadena def_columnas        ; imprime las columnas
    
    
    printCadena saltoLinea
    printCadena tabulador
    printCadena delimitacion
    
    MOV CL, 0                       ; contador de las columnas

    fila:
        printCadena saltoLinea
        printCadena tabulador  
        
        MOV AH, 02h                 
        MOV DL, def_Filas[BX]       ; obtiene la fila  
        INT 21h                     ; imprime la fila

        MOV DL, 32                  ; imprime un espacio
        MOV AH,02h
        int 21h


        MOV DL, 124                 
        INT 21h

        columna:
            MOV DL, tablero[SI]     ; obtiene el valor de la matriz
            INT 21h

            MOV DL, 124
            INT 21h
            
            INC CL 
            INC SI

            CMP CL, 8               ; compara si ya se imprimieron las 8 columnas
            JB columna

            MOV CL, 0               ; reinicia el contador de las columnas
            INC BX

            CMP BX, 8               ; compara si ya se imprimieron las 8 filas
            JB fila

            printCadena saltoLinea
            printCadena tabulador
            printCadena delimitacion
ENDM

llenarTablero MACRO
    LOCAL peon1, peon2, Piezas1, Piezas2

    MOV SI, 0                       ; indice para el tablero
    MOV CH, 0                       ; contador de peones


    Piezas1:
        MOV DL, 116                 ; almacena la torre 
        MOV tablero[SI], DL	        ; almacena el peon 
        PUSH DX                     ; almacena el valor en la pila
        INC SI                      ; incrementa el indice

        MOV DL, 99                  ; almacena el caballo 
        MOV tablero[SI], DL	        
        PUSH DX
        INC SI

        MOV DX, 97                  ; almacena el alfil 
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DL, 114                 ; almacena la rey 
        MOV tablero[SI], DL
        INC SI

        MOV DX, 35                  ; almacena la reina 
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

    llenarPeon1:
        MOV tablero[SI], 112                ; almacena el peon 
        INC SI
        INC CH

        CMP CH, 8                           ; compara si ya se llenaron los 8 peones
        JB llenarPeon1

        MOV CH, 0                           ; reinicia el contador de peones
        MOV SI, 48        
    
    llenarPeon2:
        MOV tablero[SI], 80                 ; almacena el peon 
        INC SI
        INC CH

        CMP CH, 8                           ; compara si ya se llenaron los 8 peones
        JB llenarPeon2

    Piezas2:
        MOV DL, 84                   ; almacena la torre 
        MOV tablero[SI], DL	         ; almacena el peon 
        PUSH DX                      ; almacena el valor en la pila
        INC SI                       ; incrementa el indice

        MOV DL, 67                   ; almacena el caballo 
        MOV tablero[SI], DL	        
        PUSH DX
        INC SI

        MOV DL, 65                   ; almacena el alfil 
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DL, 82                   ; almacena la rey 
        MOV tablero[SI], DL
        INC SI

        MOV DL, 42                   ; almacena la reina 
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI
ENDM

RowMajor MACRO
    MOV AL, row             ; obtiene la fila
    MOV BL, col             ; obtiene la columna

    SUB AL, 49              ; convierte la fila a numero
    SUB BL, 65              ; convierte la columna a numero

    MOV BH, 8               ; almacena el numero de columnas

    MUL BH                  ; multiplica la fila por el numero de columnas
    ADD AL, BL              ; suma la columna

    MOV SI, AX              ; almacena el resultado en SI
    MOV tablero[SI], 64     ; almacena la ficha en la posicion seleccionada

ENDM


;-------------------------------------------------------------

validarRangoFila MACRO
    ; Solicitar y validar p_row
    printCadena PosibleFila
    getOp p_row

    CMP p_row, 49      ; Compara con 49 (el código ASCII de '1')
    JL _Errorfila      ; Si es menor que 0, salta a la etiqueta de error

    CMP p_row, 56      ; Compara con 56 (el código ASCII de '8')
    JG _Errorfila      ; Si es mayor que 8, salta a la etiqueta de error

    CMP p_row, 32      ; Compara con 32 (el código ASCII de ' ')
    JE _Errorfila      ; Si es igual a 32, salta a la etiqueta de errorfila
    JMP _ContinueFila 

_Errorfila:
    Errorfila
_ContinueFila:
ENDM

validarRangoColumna MACRO
    ; Solicitar y validar p_col
    printCadena PosibleColumna
    getOp p_col

    CMP p_col, 65          ; Compara con 65 (el código ASCII de 'A')
    JL _ErrorColumna        ; Si es menor que 0, salta a la etiqueta de error

    CMP p_col, 72           ; Compara con 72 (el código ASCII de 'H')
    JG _ErrorColumna        ; Si es mayor que 8, salta a la etiqueta de error
    JMP _ContinueColumna

    CMP p_col, 32           ; Compara con 32 (el código ASCII de ' ')
    JE _ErrorColumna        ; Si es igual a 32, salta a la etiqueta de errorcolumna
    JMP _ContinueColumna

_ErrorColumna: 
    errorColumna
_ContinueColumna:
ENDM

Errorfila MACRO
    MOV AH, 09h
    LEA DX, ErrorMessageF
    INT 21h
    JMP Menu
ENDM

errorColumna MACRO
    MOV AH, 09h
    LEA DX, ErrorMessageC
    INT 21h
    JMP Menu
ENDM

;------------------------------------------------------------- tiempo
inicioTiempo MACRO
    ; Guardar la hora inicial
    mov ah, 2Ch
    int 21h
    mov horaInicial, ch
    mov minutoInicial, cl
    mov segundoInicial, dh
ENDM

finTiempo MACRO
    ; Guardar la hora final
    mov ah, 2Ch
    int 21h
    mov horaFinal, ch
    mov minutoFinal, cl
    mov segundoFinal, dh

    ; Calcular la duración en minutos y segundos
    mov al, minutoFinal
    sub al, minutoInicial
    mov duracionMin, al
    mov al, segundoFinal
    sub al, segundoInicial
    mov duracionSeg, al
ENDM

imprimirTiempo MACRO
    ; Convertir la duración a una cadena
    mov ah, 0
    mov al, duracionMin
    mov bl, 10
    div bl
    add ah, '0'
    mov duracionStr[0], ah
    add al, '0'
    mov duracionStr[1], al
    mov al, ':'
    mov duracionStr[2], al
    mov ah, 0
    mov al, duracionSeg
    div bl
    add ah, '0'
    mov duracionStr[3], ah
    add al, '0'
    mov duracionStr[4], al
    mov al, '$'
    mov duracionStr[5], al

    ; Imprimir la duración
    mov ah, 09h
    lea dx, duracionStr
    int 21h
ENDM