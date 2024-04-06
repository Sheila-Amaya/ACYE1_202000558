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
    MOV tablero[SI], 64     

ENDM

printTablero MACRO
    clearConsole
    llenarTablero
    printCadena saltoLinea
    printTableroJuego

    printCadena saltoLinea
    printCadena entradafila
    getOp row

    CMP row, 32
    JE Salir

    printCadena entradaColumna
    getOp col

    CMP col, 32
    JE Salir

    RowMajor
ENDM

pedirMov MACRO
    printCadena entradafila
    getOp row

    CMP row, 32
    JE Salir

    printCadena entradaColumna
    getOp col

    CMP col, 32
    JE Salir

    RowMajor
ENDM

printPuntajes MACRO

ENDM

printReportes MACRO

ENDM



;---------------------------------------------------------
.MODEL small

.STACK 64h

.DATA 
    messageInit db 10, 13, " UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10, 13, " FACULTAD DE INGENIERIA", 10, 13 ," ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13," ARQUITECTURA DE COMPUTADORAS 1", 10, 13, " PRACTICA 3", 10, 13, "$"
    messageInit1 db " SECCION A", 10, 13," Primer Semestre 2024", " Sheila Amaya" , 10, 13," 202000558", 10, 13," Practica 3", 10, 13, "$"

    messageMenu db 10, 10, 13,"    MENU PRICIPAL", 10, 13 , 10, " 1. Nuevo Juego", 10, 13, " 2. Puntajes", 10, 13, " 3. Reportes", 10, 13, " 4. Salir", 10, 13, "    Seleccione una opcion: ", "$"
    op db 1 dup("$")                                ; variable para almacenar la opcion seleccionada del menu
    saltoLinea db 10, 13, "$"     
    tabulador db 9, "$"              
    def_columnas db "   A B C D E F G H ", "$"
    def_Filas db "12345678 ", "$"        
    tablero db 64 dup(32)                           ; matriz de 8x8 para el tablero
    delimitacion db "   - - - - - - - -   ", "$"
    entradafila db 10,13, "Ingrese la fila: ", "$"
    entradaColumna db 10,13,"Ingrese la columna: ", "$"
    row db 1 dup("$")                               ; variable para almacenar la fila
    col db 1 dup("$")                               ; variable para almacenar la columna


.CODE
    MOV AX, @data
    MOV DS, AX

    Main  PROC                                    ; metodo Inicio del programa
        clearConsole
        printCadena messageInit 
        printCadena messageInit1

        Menu:
            printCadena  messageMenu
            getOp op                              ; obtiene la opcion seleccionada
            
            CMP op, 49                            ; compara si la opcion seleccionada es 1
            JE printTableroMacro

            CMP op, 50                            ; compara si la opcion seleccionada es 2
            JMP printPuntajesMacro

            CMP op, 51                           ; compara si la opcion seleccionada es 3 
            JE printReportesMacro

            CMP op, 52                           ; compara si la opcion seleccionada es 4
            JE Salir

            JMP Menu

        printTableroMacro:
            printTablero
            JMP Menu
            
        pedirMovMacro:
            pedirMov
            JMP Menu

        printPuntajesMacro:
            printPuntajes
            JMP Menu

        printReportesMacro: 
            printReportes
            JMP Menu

        Salir:
            MOV Ax, 4C00h                     ; Termina el programa
            INT 21h

    Main ENDP

END


