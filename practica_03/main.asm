INCLUDE macros.asm

;---------------------------------------------------------
.MODEL small

.STACK 64h

.DATA 
    ; mensajes de inicio
    messageInit db 10, 13, " UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10, 13, " FACULTAD DE INGENIERIA", 10, 13, " ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13," ARQUITECTURA DE COMPUTADORAS 1", 10, 13, "$"
    messageInit1 db " SECCION A", 10, 13, " Primer Semestre 2024", 10, 13, " Sheila Amaya", 10, 13, " 202000558", 10, 13, " Practica 3", 10, 13, "$"
    
    ErrorMessageF db "    -> Error: fila fuera de rango", "$"
    ErrorMessageC db "    -> Error: columna fuera de rango", "$"

    nombreJugador db 50 dup(0)
    messageNombre db 10, 13, " Bienvenido ,Ingrese su nombre: ", "$"
    ms1 db " VS. IA    " , "$"
    buffer db 100 dup(0)

    TurnoIA db " Turno de: IA ", "$"
    TurnoJugador db " Turno de:  ", "$"

    ; menu
    messageMenu db 10, 10, 13,"    ======MENU PRICIPAL=====", 10, 13 , 10, " 1. Nuevo Juego", 10, 13, " 2. Puntajes", 10, 13, " 3. Reportes", 10, 13, " 4. Salir", 10, 13, "    Seleccione una opcion: ", "$"
    op db 1 dup("$")                                ; variable para almacenar la opcion seleccionada del menu
    saltoLinea db 10, 13, "$"     
    tabulador db 9, "$"   
    
    ; tablero de ajedrez          
    def_columnas db "   A B C D E F G H ", "$"
    def_Filas db "12345678 ", "$"        
    tablero db 64 dup(32)                           ; matriz de 8x8 para el tablero
    delimitacion db "   - - - - - - - -   ", "$"

    ; pedir movimiento posibles
    msPosibles db 10,13, " Posibles movimientos: ", "$"
    PosibleFila db 10,13, " Ingrese la fila: ", "$"
    PosibleColumna db 10,13," Ingrese la columna: ", "$"
    p_row db 1 dup("$")                               ; variable para almacenar la fila del posible movimiento
    p_col db 1 dup("$")                               ; variable para almacenar la columna del posible movimiento

    ;pedir movimiento
    msMovimiento db 10,13, " Ingrese el movimiento: ", "$"
    entradafila db 10,13, " Ingrese la fila: ", "$"
    entradaColumna db 10,13," Ingrese la columna: ", "$"
    row db 1 dup(32) ,  "$"                              ; variable para almacenar la fila
    col db 1 dup(32) ,  "$"                              ; variable para almacenar la columna


    msTiempo db " Tiempo: ", "$"
    horaInicial db ?
    minutoInicial db ?
    segundoInicial db ?
    horaFinal db ?
    minutoFinal db ?
    segundoFinal db ?
    duracionMin db ?
    duracionSeg db ?
    duracionStr db 6 dup(?)

;------------------------------------------------------------- tiempo

.CODE
    MOV AX, @data
    MOV DS, AX

    Main  PROC                                    ; metodo Inicio del programa
        clearConsole
        printCadena messageInit 
        printCadena messageInit1

        printCadena messageNombre
        obtenerCadena nombreJugador, 50

        Menu:
            printCadena messageMenu
            getOp op                              ; obtiene la opcion seleccionada
            CMP op, 49                            ; compara si la opcion seleccionada es 1
            JE printTablero

            CMP op, 50                            ; compara si la opcion seleccionada es 2
            JE printPuntajes

            CMP op, 51                           ; compara si la opcion seleccionada es 3 
            JE printReportes

            CMP op, 52                           ; compara si la opcion seleccionada es 4
            JE Salir

            JMP Menu

        printTablero:
            clearConsole
            inicioTiempo
            printCadena nombreJugador
            printCadena ms1
            ;printCadena tabulador
            printCadena msTiempo
            ;imprimirTiempo
            printCadena saltoLinea

            llenarTablero
            printCadena saltoLinea

            printTableroJuego            
            printCadena saltoLinea

            printCadena msPosibles
            validarRangoFila        ; posibleMovimiento
            validarRangoColumna     ; posibleMovimiento
            clearConsole

            movimientosPosibles
            printCadena saltoLinea
            printTableroJuego

            JMP pedirMov
        
        pedirMov:
            
            printCadena msMovimiento
            validar_Fila_mov
            validar_Col_mov
            LimpiarTablero          ; quita las x de los posibles movimientos

            MoverPieza
            printCadena saltoLinea
            clearConsole
            printCadena saltoLinea
            
            JMP printTablero

        printPuntajes:

        printReportes: 
            JMP Menu

        Salir:
            MOV Ax, 4C00h                     ; Termina el programa
            INT 21h

    Main ENDP

END