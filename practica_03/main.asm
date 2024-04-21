INCLUDE macros.asm

;---------------------------------------------------------
.MODEL small

.STACK 64h

.DATA 
    ; mensajes de inicio
    messageInit db 10, 13, " UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10, 13, " FACULTAD DE INGENIERIA", 10, 13, " ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13," ARQUITECTURA DE COMPUTADORAS 1", 10, 13, "$"
    messageInit1 db " SECCION A", 10, 13, " Primer Semestre 2024", 10, 13, " Sheila Amaya", 10, 13, " 202000558", 10, 13, " Practica 3", 10, 13, "$"
    
    msContinuar db 10, 13, "¿Desea volver al menu? (s/n): ", "$"
    opcion db 1 dup("$")                                ; variable para almacenar la opcion seleccionada del menu

    ErrorMessageF db "    -> Error: fila fuera de rango", "$"
    ErrorMessageC db "    -> Error: columna fuera de rango", "$"

    nombreJugador db 8 dup(32)
    espacio db 1 dup("$")
    messageNombre db 10, 13, " Bienvenido ,Ingrese su nombre: ", "$"
    nombreIA db "IA", "$"
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

    row_IA db 1 dup(32)                                  ; variable para almacenar la fila
    col_IA db 1 dup(32)                                  ; variable para almacenar la columna

    newRow db 1 dup(32)                                 ; variable para almacenar la nueva fila
    newCol db 1 dup(32)                                 ; variable para almacenar la nueva columna

    piezas db 112, 116, 99, 97, 114, 35
    piezaAleatoria DB ?
    piezaActual DB ?

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

    horaHTML db 20 dup("$")

    encabezadoPuntaje db " Nombre Jugador - Tiempo", "$"

    handlerArchivo dw ?
    handlerArchivo2 dw ?
    nombreArchivo db "reporte.txt", 0
    errorCrearArchivo db "Error al crear el archivo", "$"
    ErrorAbrirArchivo db "Error al abrir el archivo", "$"
    errorCerrarArchivo db "Error al cerrar el archivo", "$"
    ErrorEscribirArchivo db "Error al escribir en el archivo", "$"
    ErrorLeerArchivo db "Error al leer el archivo", "$"
    bufferArchivo db 100 dup("$")

    ;---------------------------------------------------------txt
    contenidoArchivo  db "Reporte de partidas", 10, 13, "Nombre Jugador - Tiempo", 10, 13, "-------------------------", 10, 13, "$"


    ;--------------------------------------------------------- html
    nombreArchivoHtml db "reporte.html ", 0

    contenidoArchivo2 db "<!DOCTYPE html>", 10, 13, "<html>", 10, 13, "<head>", 10, 13, "<title>Reporte</title>", 10, 13, "<meta charset='UTF-8'>", 10, 13, "<style>", 10, 13, "table {", 10, 13, "width: 50%;", 10, 13, "border-collapse: collapse;", 10, 13, "margin-top: 20px;", 10, 13, "}", 10, 13, "th, td {", 10, 13, "border: 1px solid black;"
    contenidoArchivo3 db 10, 13, "padding: 8px;", 10, 13, "text-align: left;", 10, 13, "}", 10, 13, "th {", 10, 13, "background-color: #f2f2f2;", 10, 13, "}", 10, 13, "</style>", 10, 13, "</head>", 10, 13, "<body>", 10, 13, "<h1>REPORTE</h1>", 10, 13
    contenidoArchivo4 db "<p>Nombre del curso: Arquitectura de computadores y ensambladores 1</p>", 10, 13, "<p>Sección: A</p>", 10, 13, "<p>Nombre del estudiante: Sheila Elizabeth Amaya Rodriguez</p>", 10, 13, "<p>Carne: 202000558</p>", 10, 13, "<p>Fecha Actual: "
    contenidoArchivo5 db "</p>", 10, 13, "<h2>Puntajes de jugadores</h2>", 10, 13
    contenidoArchivo6 db "<table>", 10, 13, "<tr>", 10, 13, "<th>Jugador  -  Tiempo </th>", 10, 13, "</tr>", 10, 13, "<tr>", 10, 13, "<td><pre> "
    contenidoArchivo7 db "</td>",  10, 13, "</tr>", 10, 13, "</table>", 10, 13, "</body>", 10, 13, "</html>"

;------------------------------------------------------------- 
    contTxt db 256 dup("$")
    bytesRead dw ?

.CODE
    MOV AX, @data
    MOV DS, AX

    Main  PROC                                    ; metodo Inicio del programa
        clearConsole
        printCadena messageInit 
        printCadena messageInit1

        printCadena messageNombre
        obtenerCadena nombreJugador, 15

        Menu:
            clearConsole
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
            ;printCadena tabulador
            llenarTablero
            ; mueve la pieza de la IA

            JMP pedirMov
        
        pedirMov:
            clearConsole
            inicioTiempo
            printCadena nombreJugador
            printCadena ms1
            printCadena msTiempo
            imprimirTiempo
            printCadena tabulador
            printCadena TurnoJugador
            printCadena nombreJugador
            printCadena saltoLinea
            printCadena saltoLinea
            
            printTableroJuego            
            printCadena saltoLinea

            printCadena msPosibles
            validarRangoFila        ; posibleMovimiento
            validarRangoColumna     ; posibleMovimiento
            clearConsole

            movimientosPosibles

            printCadena nombreJugador
            printCadena ms1
            printCadena msTiempo
            imprimirTiempo
            printCadena tabulador
            printCadena TurnoJugador
            printCadena nombreJugador

            printCadena saltoLinea
            printTableroJuego
            
            printCadena msMovimiento
            validar_Fila_mov
            validar_Col_mov
            LimpiarTablero          ; quita las x de los posibles movimientos

            
            printTableroJuego
            MoverPieza
            
            printCadena saltoLinea
            clearConsole
            printCadena saltoLinea

            printCadena msContinuar
            getInput 
            CMP opcion, 115         ; si la opcion es s
            finTiempo
            clearConsole
            JE Menu
            
            clearConsole
            JMP pedirMov

        printPuntajes:

            printCadena saltoLinea
            puntajeJuego 


        printReportes: 
            MOV op, 0

            ;CrearArchivo nombreArchivo, handlerArchivo
            CrearArchivo nombreArchivoHtml, handlerArchivo2
            CMP op, 13
            JE Salir

            EscribirArchivo contenidoArchivo, handlerArchivo
            EscribirArchivo2 contenidoArchivo2, handlerArchivo2
            
            EscribirArchivo4 contenidoArchivo2
            EscribirArchivo4 contenidoArchivo3
            EscribirArchivo4 contenidoArchivo4
            ImpFechaHTML horaHTML
            EscribirArchivo4 contenidoArchivo5
            EscribirArchivo4 contenidoArchivo6

            macroTexto2
            EscribirArchivo4 contenidoArchivo7
            CMP op, 13
            JE Salir

            cerrarArchivo handlerArchivo
            cerrarArchivo handlerArchivo2
            CMP op, 13
            JE Salir

            getOp op
            JMP Menu

        Salir:
            MOV AX, 4C00h                     ; Termina el programa
            INT 21h

    Main ENDP

END