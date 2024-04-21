INCLUDE macros.asm
INCLUDE macro2.asm
INCLUDE macrosA.asm
;---------------------------------------------------------
.MODEL small
.RADIX 16

.STACK 64h

.DATA 
    filehandle dw ?
    bytesRead dw ?
    dataTXT db 1024 dup("$")
    segundos db 2 dup("$")
    Barra db "|", "$"
    horaDB db 012h dup("$")
    nombreDB db "reporte.txt", 0
    espacio db " ", "$"
    espacio11 db "            ", "$"

    enter_continuar       db   '    Presionar ENTER para continuar ','$'
    saltoLinea db 0A, 0D, "$"
    ; menu
    messageMenu   db "    +===============================+", 0A, 0D , "$"
    messageMenu1  db "    ||      MENU PRINCIPAL         ||", 0A, 0D, "$"
    messageMenu2  db "    +===============================+", 0A, 0D, "$"
    messageMenu3  db "    || 1. Nuevo Juego              ||", 0A, 0D, "$"
    messageMenu4  db "    ||                             ||", 0A, 0D, "$"
    messageMenu5  db "    || 2. Animacion                ||", 0A, 0D, "$"
    messageMenu6  db "    ||                             ||", 0A, 0D, "$"
    messageMenu7  db "    || 3. Informacion              ||", 0A, 0D, "$"
    messageMenu8  db "    ||                             ||", 0A, 0D, "$"
    messageMenu9  db "    || 4. Salir                    ||", 0A, 0D, "$"
    messageMenu10 db "    ||                             ||", 0A, 0D, "$"
    messageMenu11 db "    +===============================+", 0A, 0D, "$"
    messageMenu12 db "    Seleccione una opcion:           ", 0A, 0D, "$"
    messageMenu13 db "    >>", "$"
    op db 1 dup("$")

    ; submenu
    messageSubMenu   db "    +===============================+", 0A, 0D, "$"
    messageSubMenu1  db "    ||      MENU NUEVO JUEGO       ||", 0A, 0D, "$"
    messageSubMenu2  db "    +===============================+", 0A, 0D, "$"
    messageSubMenu3  db "    || 1. 1 vs. CPU                ||", 0A, 0D, "$"
    messageSubMenu4  db "    ||                             ||", 0A, 0D, "$"
    messageSubMenu5  db "    || 2. 1 vs. 1                  ||", 0A, 0D, "$"
    messageSubMenu6  db "    ||                             ||", 0A, 0D, "$"
    messageSubMenu7  db "    || 3. Reportes                 ||", 0A, 0D, "$"
    messageSubMenu8  db "    ||                             ||", 0A, 0D, "$"
    messageSubMenu9  db "    || 4. Regresar                 ||", 0A, 0D, "$"
    messageSubMenu10 db "    ||                             ||", 0A, 0D, "$"
    messageSubMenu12 db "    +===============================+", 0A, 0D, "$"
    messageSubMenu11 db "    Seleccione una opcion:           ", 0A, 0D, "$"
    messageSubMenu13 db "    >>  ", "$"
    subOp db 1 dup("$")

    ; informacion
    info1 db "    |\----/|\----/|\----/|\----/|\----/|\----/|\----/|\----/|   |\----/|", 0A, 0D, "$"
    info2 db "    | +--+   +---+  +---+  +--+   +--+   +--+   +--+   +--+ |   | +--+ |", 0A, 0D, "$"
    info3 db "    | |  |   |   |  |   |  |  |   |  |   |  |   |  |   |  | |   | |  | |", 0A, 0D, "$"
    info4 db "    | |P |   |R  |  |A  |  |C |   |T |   |I |   |C |   |A | |   | |4 | |", 0A, 0D, "$"
    info5 db "    | +--+   +---+  +---+  +--+   +--+   +--+   +--+   +--+ |   | +--+ |", 0A, 0D, "$"
    info6 db "    |/----\|/----\|/----\|/----\|/----\|/----\|/----\|/----/|   |/----\|", 0A, 0D, "$"
    
    info7  db "    UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0A, 0D, "$"
    info8  db "    FACULTAD DE INGENIERIA", 0A, 0D, "$"
    info9  db "    ESCUELA DE CIENCIAS Y SISTEMAS", 0A, 0D, "$"
    info10 db "    ARQUITECTURA DE COMPUTADORAS 1", 0A, 0D, "$"
    info11 db "    Primer Semestre 2024", 0A, 0D, "$"
    info12 db "    Sheila Amaya", 0A, 0D, "$"
    info13 db "    202000558", 0A, 0D, "$"
    
    ;----------------------------------------------------------
    nombreJugador3 db " IA ", "$"
    nombreJugador1 db 5 dup(32)
    nombreJugador2 db 5 dup(32)

    ;---------------------------------------------------------- totito
    ;CONTROL DEL TURNO DEL JUGADOR
    turno_jugador db 01
    ganador db 00
    is_celda_invalida db 00

    ;CORDENADAS DONDE SE COLOCARA LAS OBJETOS
    wallRead db 00
    posXRead dw 00
    posYRead dw 00
    indiceTablero db 00, '$'

    ; COORDENADAS QUE SE INGRESAN POR TEXTO
    coordenada_x db 0
    coordenada_y db 0

    ;COORDENADAS CURSOR
    coordenada_c_fila db 00
    coordenada_c_columna db 00

    coordenada_limpiar_fila db 00

    ; MENSAJES
    mensaje_ingresar_coor1 db ' >> turno jugador1:       '
    mensaje_ingresar_coor  db ' >> turno jugador2:       '
    mensaje_celda_invalida db 'La celda ingresada esta ocupada'
    mensaje_ganado_j1 db '    Ha ganado el jugador 1 jugando con X', '$'
    mensaje_ganado_j2 db '    Ha ganado el jugador 2 jugando con O', '$'

    mensaje_nombre_jugador1 db '  > Ingrese el nombre del jugador 1: ', '$'
    mensaje_nombre_jugador2 db '  > Ingrese el nombre del jugador 2: ', '$'

    ;ENTRADA DE TEXTO
    bufferEntrada db 255 dup('$')
    numRandom1 db 00
    numRandom2 db 00
;--------------------------------------------
    handler             dw ?
    filename            db "Input1.txt", 0
    salto               db  0Ah, 0Dh, "$"
    errorCode           db ?
    errorOpenFile       db " >> Ocurrio Un Error Al Abrir El Archivo - ERRCODE: ", "$"
    errorCloseFile      db " >> Ocurrio Un Error Al Cerrar El Archivo - ERRCODE: ", "$"
    errorReadFile       db " >> Ocurrio Un Error Al Leer El Archivo - ERRCODE: ", "$"
    errorSizeFile       db " >> Ocurrio Un Error Obteniendo El Size Del Archivo - ERRCODE: ", "$"
    exitOpenFileMsg     db " >> El Archivo Se Abrio Correctamente", "$"
    exitCloseFileMsg    db " >> El Archivo Se Cerro Correctamente", "$"
    exitSizeFileMsg     db " >> Se Obtuvo La Longitud Correctamente", "$"
    bufferTemporal      db 80  dup("$")
    bufferImagen1       db 900 dup("$")
    bufferImagen2       db 900 dup("$")
    bufferImagen3       db 900 dup("$")
    bufferImagen4       db 900 dup("$")
    bufferImagen5       db 900 dup("$")
    bufferImagen6       db 900 dup("$")
    bufferImagen7       db 900 dup("$")
    bufferImagen8       db 900 dup("$")
    charsPerRow1        dw ?
    cantRows1           dw ?
    charsPerRow2        dw ?
    cantRows2           dw ?
    charsPerRow3        dw ?
    cantRows3           dw ?
    charsPerRow4        dw ?
    cantRows4           dw ?
    charsPerRow5        dw ?
    cantRows5           dw ?
    charsPerRow6        dw ?
    cantRows6           dw ?
    charsPerRow7        dw ?
    cantRows7           dw ?
    charsPerRow8        dw ?
    cantRows8           dw ?
    saltoCadena         dw ?
    extensionArchivo    dw 0
    posApuntador        dw 0
    filaActual          db 0
    fila                db 0
    columna             db 5
    paginaActual        db 0

    ;----------------------------------------------------------
    R_1 db "   --------------------------------------------------", 0A, 0D, "$"
    R_2 db "  | Fecha  | Hora   | J1 | J2 | Resultados | x  | o  |", 0A, 0D, "$"
    R_3 db "  |--------|--------|----|----|------------|----|----|", 0A, 0D, "$"
    R_4 db "  |--------------------------------------------------|", 0A, 0D, "$"      
    R_5 db "  |               NO HAY REGISTROS                   |", 0A, 0D, "$"

    ;-------------------------------------------------------------

    ;PAREDES TOTITO
    empty_block db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
    wall_one    db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_two    db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_three  db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_four   db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
    wall_five   db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_six    db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_ten    db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 06, 06
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_eleven db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     06, 06, 06, 06, 06, 06, 06, 06
                db     00, 00, 00, 00, 00, 00, 00, 00
                db     00, 00, 00, 00, 00, 00, 00, 00
    wall_twelve db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     06, 06, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
                db     00, 00, 06, 06, 06, 06, 00, 00
    wall_fourteen   db     00, 00, 06, 06, 06, 06, 00, 00
                    db     00, 00, 06, 06, 06, 06, 00, 00
                    db     00, 00, 06, 06, 06, 06, 06, 06
                    db     00, 00, 06, 06, 06, 06, 06, 06
                    db     00, 00, 06, 06, 06, 06, 06, 06
                    db     00, 00, 06, 06, 06, 06, 06, 06
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00
    wall_fifteen    db     00, 00, 06, 06, 06, 06, 00, 00
                    db     00, 00, 06, 06, 06, 06, 00, 00
                    db     06, 06, 06, 06, 06, 06, 00, 00
                    db     06, 06, 06, 06, 06, 06, 00, 00
                    db     06, 06, 06, 06, 06, 06, 00, 00
                    db     06, 06, 06, 06, 06, 06, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00


    ;FIGURA X
    barrax_uno      db     0C, 0C, 00, 00, 00, 00, 00, 00
                    db     00, 0C, 0C, 00, 00, 00, 00, 00
                    db     00, 00, 0C, 0C, 00, 00, 00, 00
                    db     00, 00, 00, 0C, 0C, 00, 00, 00
                    db     00, 00, 00, 00, 0C, 0C, 00, 00
                    db     00, 00, 00, 00, 00, 0C, 0C, 00
                    db     00, 00, 00, 00, 00, 00, 0C, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C

    barrax_dos      db     00, 00, 00, 00, 00, 00, 0C, 0C
                    db     00, 00, 00, 00, 00, 0C, 0C, 00
                    db     00, 00, 00, 00, 0C, 0C, 00, 00
                    db     00, 00, 00, 0C, 0C, 00, 00, 00
                    db     00, 00, 0C, 0C, 00, 00, 00, 00
                    db     00, 0C, 0C, 00, 00, 00, 00, 00
                    db     0C, 0C, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00

    ;FIGURA O
    barrao_uno      db     00, 00, 0C, 0C, 0C, 0C, 0C, 0C
                    db     00, 0C, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00

    barrao_dos      db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     0C, 00, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     00, 0C, 00, 00, 00, 00, 00, 00
                    db     00, 00, 0C, 0C, 0C, 0C, 0C, 0C

    barrao_tres     db     0C, 0C, 0C, 0C, 0C, 0C, 00, 00
                    db     00, 00, 00, 00, 00, 00, 0C, 00
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C

    barrao_cuatro   db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 0C
                    db     00, 00, 00, 00, 00, 00, 00, 00
                    db     00, 00, 00, 00, 00, 00, 0C, 00
                    db     0C, 0C, 0C, 0C, 0C, 0C, 00, 00

    object_map db 09 dup (0)   ;3x3
    mensaje_ingresar_coor2 db ' >> turno IA:        '


.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    Main  PROC                                    ; metodo Inicio del programa
    clearConsole

    Menu:

    ;---------------------------- Imprime el menu
    printCadena saltoLinea
    PrintColor messageMenu  , 09h
    PrintColor messageMenu1 , 09h
    PrintColor messageMenu2 , 09h
    PrintColor messageMenu3 , 09h
    PrintColor messageMenu4 , 09h
    PrintColor messageMenu5 , 09h
    PrintColor messageMenu6 , 09h
    PrintColor messageMenu7 , 09h
    PrintColor messageMenu8 , 09h
    PrintColor messageMenu9 , 09h
    PrintColor messageMenu10, 09h
    PrintColor messageMenu11, 09h
    printCadena saltoLinea 
    PrintColor messageMenu12, 09h
    PrintColor messageMenu13, 09h
    ;---------------------------------------------

    getOp op

    CMP op, 31h                            ; compara si la opcion seleccionada es 1
    clearConsole
    JE NuevoJuego

    CMP op, 32h                            ; compara si la opcion seleccionada es 2
    clearConsole
    JE Animacion

    CMP op, 33h                           ; compara si la opcion seleccionada es 3  informacion
    clearConsole
    JE informacion

    CMP op, 34h                           ; compara si la opcion seleccionada es 4
    clearConsole
    JE Salir

    JMP Menu

    NuevoJuego:
        
        SubMenu:

        ;---------------------------- Imprime el submenu
        printCadena saltoLinea
        PrintColor messageSubMenu,   0Ch ; Rojo brillante
        PrintColor messageSubMenu1,  0Eh ; Amarillo brillante
        PrintColor messageSubMenu2,  0Ch
        PrintColor messageSubMenu3,  09h 
        PrintColor messageSubMenu4,  0Ch
        PrintColor messageSubMenu5,  09h
        PrintColor messageSubMenu6,  0Ch
        PrintColor messageSubMenu7,  09h
        PrintColor messageSubMenu8,  0Ch
        PrintColor messageSubMenu9,  09h ; Azul claro
        PrintColor messageSubMenu10, 0Ch
        PrintColor messageSubMenu12, 0Ch
        printCadena saltoLinea
        PrintColor messageSubMenu11, 07h 
        PrintColor messageSubMenu13, 0Fh ; Blanco
        ;-----------------------------

        getOp subOp

        CMP subOp, 31h                            ; compara si la opcion seleccionada es 1
        clearConsole
        JE UnoVsCpu

        CMP subOp, 32h                            ; compara si la opcion seleccionada es 2
        clearConsole
        JE UnoVsUno

        CMP subOp, 33h                           ; compara si la opcion seleccionada es 3
        clearConsole
        JE opcion3

        CMP subOp, 34h                           ; compara si la opcion seleccionada es 4 regresa al menu principal
        clearConsole
        JE Menu

        UnoVsCpu: ;-------------------------------------1 vs cpu
            pedirNombre_cpu:
            mTextMode
            printCadena saltoLinea
            printCadena mensaje_nombre_jugador1
            obtenerCadena nombreJugador1, 5

            printCadena enter_continuar
            ;pauseUntilEnter
            JMP iniciar_partida_cpu

            iniciar_partida_cpu:
                mVideoMode
                CALL PCLEANSCREEN
                CALL PCREARTABLERO
                inicio_turno_cpu:
                    CMP ganador, 01
                    JE imprimir_ganador_cpu
                    CMP turno_jugador, 01
                    JE mensaje_jugador1_cpu
                    CMP turno_jugador, 02
                    JE mensaje_jugador2_cpu
                mensaje_jugador1_cpu:
                    mPrintTextIntoVideo 0C, 00, mensaje_ingresar_coor1, 16, 000F
                    JMP continuar_turno_cpu
                mensaje_jugador2_cpu:
                    generateRandomNumber numRandom1
                    asignarF numRandom1
                    ; Introduce un pequeño retraso
                    mov cx, 0FFFFh
                    dL1:
                        loop dL1
                    generateRandomNumber numRandom2
                    asignarC numRandom2
                    mov cx, 0FFFFh
                    dLoop_1:
                        loop dLoop_1
                
                    mPrintTextIntoVideo 0C, 00, mensaje_ingresar_coor2, 16, 000F
                    mov cx, 0FFFFh
                    dLoop12:
                        loop dLoop12
                    JMP continuar_t2
                continuar_t2:
                    CALL PCOORDENADASOBJETOS
                    CMP turno_jugador, 01
                    JE tuno_x_cpu
                    CMP turno_jugador, 02
                    JE tuno_o_cpu               
                continuar_turno_cpu:
                    MOV coordenada_c_fila, 0C
                    MOV coordenada_c_columna, 15
                    CALL PMOVERCURSOR
                    mEnterText
                    mVerficarCoordenadas
                    CALL PCOORDENADASOBJETOS
                    CMP turno_jugador, 01
                    JE tuno_x_cpu
                    CMP turno_jugador, 02
                    JE tuno_o_cpu

                tuno_x_cpu:
                    PUSH AX
                    PUSH CX
                    PUSH DX
                    XOR AX, AX
                    MOV AL, coordenada_x
                    XOR CX, CX
                    MOV CL, coordenada_y
                    MOV DH, turno_jugador
                    CALL PPUTFIGURE
                    POP DX
                    POP CX
                    POP AX
                    CMP is_celda_invalida, 01
                    JE volver_a_intentar_cpu
                    CALL PDRAWX
                    CALL PCLEANLINECURSOR
                    MOV coordenada_limpiar_fila, 0Bh
                    CALL PCLEANANYLINE
                    CALL PCHECKPLAYERWIN
                    MOV turno_jugador, 02
                    JMP inicio_turno_cpu

                tuno_o_cpu:
                    PUSH AX
                    PUSH CX
                    PUSH DX
                    XOR AX, AX
                    MOV AL, coordenada_x
                    XOR CX, CX
                    MOV CL, coordenada_y
                    MOV DH, turno_jugador
                    CALL PPUTFIGURE
                    POP DX
                    POP CX
                    POP AX
                    CMP is_celda_invalida, 01
                    JE volver_a_intentar_cpu
                    CALL PDRAWO
                    CALL PCLEANLINECURSOR
                    MOV coordenada_limpiar_fila, 0Bh
                    CALL PCLEANANYLINE
                    CALL PCHECKPLAYERWIN
                    MOV turno_jugador, 01
                    JMP inicio_turno_cpu
                volver_a_intentar_cpu:
                    CALL PCLEANLINECURSOR
                    MOV is_celda_invalida, 00
                    JMP inicio_turno_cpu
                imprimir_ganador_cpu:

                    AbrirArchivo
                    AbrirArchivo3
                    Addtextoanterior
                    EscribirArchivo espacio
                    EscribirArchivo espacio
                    EscribirArchivo Barra
                    ImpFechaDB horaDB
                    EscribirArchivo Barra
                    EscribirArchivo nombreJugador1
                    EscribirArchivo Barra
                    EscribirArchivo nombreJugador3
                    EscribirArchivo Barra
                    EscribirArchivo espacio11
                    EscribirArchivo Barra

                    CMP turno_jugador, 01
                    JE ganador_j2_cpu
                    CMP turno_jugador, 02
                    JE ganador_j1_cpu

                ganador_j2_cpu:

                EscribirArchivo nombreJugador3
                EscribirArchivo Barra
                EscribirArchivo nombreJugador1
                EscribirArchivo Barra
                EscribirArchivo espacio
                EscribirArchivo espacio
                EscribirArchivo Salto
                CerrarArchivo

                    mTextMode
                    mPrint saltoLinea
                    PrintColor mensaje_ganado_j2, 01h
                    mPrint saltoLinea
                    JMP SubMenu
                    
                ganador_j1_cpu:

                EscribirArchivo nombreJugador1
                EscribirArchivo Barra
                EscribirArchivo nombreJugador3
                EscribirArchivo Barra
                EscribirArchivo espacio
                EscribirArchivo espacio
                EscribirArchivo Salto
                CerrarArchivo

                    mTextMode
                    mPrint saltoLinea
                    PrintColor mensaje_ganado_j1, 0Bh
                    mPrint saltoLinea
                    JMP subMenu

        JMP SubMenu ;---------------------------------------------  1 vs cpu

            UnoVsUno: ;------------------------------------------ 1 vs 1
                pedirNombres:
                mTextMode
                printCadena saltoLinea
                printCadena mensaje_nombre_jugador1
                obtenerCadena nombreJugador1, 5

                ;pauseUntilEnter

                printCadena mensaje_nombre_jugador2
                obtenerCadena nombreJugador2, 5

                ;printCadena enter_continuar
                ;pauseUntilEnter

                JMP iniciar_partida

                iniciar_partida:
                    mVideoMode
                    CALL PCLEANSCREEN
                    CALL PCREARTABLERO
                    inicio_turno:
                        CMP ganador, 01
                        JE imprimir_ganador
                        CMP turno_jugador, 01
                        JE mensaje_jugador1
                        CMP turno_jugador, 02
                        JE mensaje_jugador2

                    mensaje_jugador1:
                        mPrintTextIntoVideo 0C, 00, mensaje_ingresar_coor1, 16, 000F
                        JMP continuar_turno

                    mensaje_jugador2:
                        mPrintTextIntoVideo 0C, 00, mensaje_ingresar_coor, 16, 000F

                    continuar_turno:
                        MOV coordenada_c_fila, 0C
                        MOV coordenada_c_columna, 15
                        CALL PMOVERCURSOR
                        mEnterText
                        mVerficarCoordenadas
                        CALL PCOORDENADASOBJETOS
                        CMP turno_jugador, 01
                        JE tuno_x
                        CMP turno_jugador, 02
                        JE tuno_o

                    tuno_x:
                        PUSH AX
                        PUSH CX
                        PUSH DX
                        XOR AX, AX
                        MOV AL, coordenada_x
                        XOR CX, CX
                        MOV CL, coordenada_y
                        MOV DH, turno_jugador
                        CALL PPUTFIGURE
                        POP DX
                        POP CX
                        POP AX
                        CMP is_celda_invalida, 01
                        JE volver_a_intentar

                        CALL PDRAWX
                        CALL PCLEANLINECURSOR
                        MOV coordenada_limpiar_fila, 0Bh
                        CALL PCLEANANYLINE
                        CALL PCHECKPLAYERWIN
                        MOV turno_jugador, 02
                        JMP inicio_turno

                    tuno_o:
                        PUSH AX
                        PUSH CX
                        PUSH DX
                        XOR AX, AX
                        MOV AL, coordenada_x
                        XOR CX, CX
                        MOV CL, coordenada_y
                        MOV DH, turno_jugador
                        CALL PPUTFIGURE
                        POP DX
                        POP CX
                        POP AX
                        CMP is_celda_invalida, 01
                        JE volver_a_intentar

                        CALL PDRAWO
                        CALL PCLEANLINECURSOR
                        MOV coordenada_limpiar_fila, 0Bh
                        CALL PCLEANANYLINE
                        CALL PCHECKPLAYERWIN
                        MOV turno_jugador, 01
                        JMP inicio_turno

                    volver_a_intentar:
                        CALL PCLEANLINECURSOR
                        MOV is_celda_invalida, 00
                        JMP inicio_turno
                    imprimir_ganador:

                        AbrirArchivo
                        AbrirArchivo3
                        Addtextoanterior
                        EscribirArchivo espacio
                        EscribirArchivo espacio
                        EscribirArchivo Barra
                        ImpFechaDB horaDB
                        EscribirArchivo Barra
                        EscribirArchivo nombreJugador1
                        EscribirArchivo Barra
                        EscribirArchivo nombreJugador2
                        EscribirArchivo Barra
                        EscribirArchivo espacio11
                        EscribirArchivo Barra

                        CMP turno_jugador, 01
                        JE ganador_j2
                        CMP turno_jugador, 02
                        JE ganador_j1
                    ganador_j2:

                        EscribirArchivo nombreJugador2
                        EscribirArchivo Barra
                        EscribirArchivo nombreJugador1
                        EscribirArchivo Barra
                        EscribirArchivo espacio
                        EscribirArchivo espacio
                        EscribirArchivo Salto
                        CerrarArchivo

                        mTextMode
                        mPrint saltoLinea
                        PrintColor mensaje_ganado_j2, 0Ah
                        mPrint saltoLinea
                        JMP SubMenu

                    ganador_j1:

                        EscribirArchivo nombreJugador1
                        EscribirArchivo Barra
                        EscribirArchivo nombreJugador2
                        EscribirArchivo Barra
                        EscribirArchivo espacio
                        EscribirArchivo espacio
                        EscribirArchivo Salto
                        CerrarArchivo

                        mTextMode
                        mPrint saltoLinea
                        PrintColor mensaje_ganado_j1, 0Ah
                        mPrint saltoLinea
                        JMP subMenu


            PCHECKPLAYERWIN proc
                ; Comprueba las filas
                mov cx, 3 ; Número de filas
                mov si, offset object_map
                checkRows:
                    ; Compara cada fila
                    PUSH SI
                    mov al, [si]
                    inc si
                    cmp al, [si]
                    jne nextRow
                    inc si
                    cmp al, [si]
                    jne nextRow
                    ; Si los tres elementos de la fila son 1, hay un ganador
                    cmp al, turno_jugador
                    jne nextRow
                    ; En este punto, tenemos un ganador (jugador 1)
                    POP SI
                    mov al, 1
                    mov ganador, 01
                    ret

                nextRow:
                    POP SI
                    add si, 3 ; Avanza al inicio de la siguiente fila
                    loop checkRows ; Repite para todas las filas

                    ; Comprueba las columnas
                    mov cx, 3 ; Número de columnas
                    mov si, offset object_map
                checkColumns:
                    ; Compara cada columna
                    PUSH SI
                    mov al, [si]
                    add si, 3 ; Avanza a la siguiente columna
                    cmp al, [si]
                    jne nextColumn
                    add si, 3 ; Avanza a la siguiente columna
                    cmp al, [si]
                    jne nextColumn
                    ; Si los tres elementos de la columna son 1, hay un ganador
                    cmp al, turno_jugador
                    jne nextColumn
                    ; En este punto, tenemos un ganador (jugador 1)
                    mov al, turno_jugador
                    mov ganador, 01
                    POP SI
                    ret

                nextColumn:
                    POP SI
                    ; sub si, 8 ; Retrocede al inicio de la siguiente columna
                    INC SI
                    loop checkColumns ; Repite para todas las columnas

                    ; Comprueba las diagonales
                    mov si, offset object_map
                    ; Compara la diagonal principal (de izquierda a derecha)
                    mov al, [si]
                    add si, 4 ; Avanza a la siguiente celda de la diagonal
                    cmp al, [si]
                    jne checkSecondaryDiagonal
                    add si, 4 ; Avanza a la siguiente celda de la diagonal
                    cmp al, [si]
                    jne checkSecondaryDiagonal
                    ; Si los tres elementos de la diagonal son 1, hay un ganador
                    cmp al, turno_jugador
                    jne checkSecondaryDiagonal
                    ; En este punto, tenemos un ganador (jugador 1)
                    mov al, turno_jugador
                    mov ganador, 01
                    ret

                checkSecondaryDiagonal:
                    ; Comprueba la diagonal secundaria (de derecha a izquierda)
                    mov si, offset object_map + 2 ; Comienza en la segunda celda de la diagonal secundaria
                    mov al, [si] ; Obtiene el primer elemento de la diagonal
                    add si, 2 ; Retrocede a la siguiente celda de la diagonal
                    cmp al, [si] ; Compara con el segundo elemento de la diagonal
                    jne noWinner ; Si no son iguales, no hay ganador
                    add si, 2 ; Retrocede a la siguiente celda de la diagonal
                    cmp al, [si] ; Compara con el tercer elemento de la diagonal
                    jne noWinner ; Si no son iguales, no hay ganador
                    ; Si los tres elementos de la diagonal son 1, hay un ganador
                    cmp al, turno_jugador
                    jne noWinner ; Si no todos son iguales a 1, no hay ganador
                    ; En este punto, tenemos un ganador (jugador 1)
                    mov al, turno_jugador
                    mov ganador, 01
                    ret

                noWinner:
                    ; No hay ganador para el jugador 1
                    xor al, al
                    ret

            PCHECKPLAYERWIN endp

            PCOORDENADASOBJETOS PROC
                XOR AX, AX
                MOV AL, coordenada_x
                DEC AL
                MOV CL, 03
                MUL CL
                ADD AX, 03
                INC AX
                PUSH AX
                MOV AL, coordenada_y
                DEC AL
                MOV CL, 03
                MUL CL
                ADD AX, 03
                INC AX
                XOR CX, CX
                MOV CX, AX
                POP AX
                RET
            PCOORDENADASOBJETOS ENDP
            
            PCLEANANYLINE PROC
                XOR AX, AX      ; POS X
                XOR CX, CX      ; POS Y
                XOR SI, SI
                XOR BX, BX
                MOV CX, 28
                traverse_columns_cls1:
                    mov DI, offset empty_block
                    push AX
                    push CX
                    XOR CX, CX
                    mov CL, coordenada_limpiar_fila
                    call PDRAWFIGURE
                    pop CX
                    pop AX
                    inc AX      ; SE INCREMENTA POSICION EN X
                    loop traverse_columns_cls1
                finish_clean_screen1:
                    ret
            PCLEANANYLINE ENDP

            PCLEANLINECURSOR PROC
                XOR AX, AX      ; POS X
                XOR CX, CX      ; POS Y
                XOR SI, SI
                XOR BX, BX
                MOV CX, 28
                traverse_columns_cls2:
                    mov DI, offset empty_block
                    push AX
                    push CX
                    XOR CX, CX
                    mov CL, coordenada_c_fila
                    call PDRAWFIGURE
                    pop CX
                    pop AX
                    inc AX      ; SE INCREMENTA POSICION EN X
                    loop traverse_columns_cls2
                finish_clean_screen2:
                    ret
            PCLEANLINECURSOR ENDP

            PMOVERCURSOR PROC
                PUSH DX
                PUSH AX
                mov dh, coordenada_c_fila       ; Fila
                mov dl, coordenada_c_columna      ; Columna
                mov ah, 02h     ; Función de DOS para mover el cursor
                int 10h         ; Llama a la interrupción del BIOS para mover el cursor
                POP AX
                POP DX
                RET
            PMOVERCURSOR ENDP

            PCREARTABLERO PROC

            CALL PPAINTHORIZONTAL
            MOV AX, 00
            MOV CX, 00
            MOV DI, offset wall_one
            CALL PDRAWFIGURESCREEN
            MOV AX, 03
            MOV DI, offset wall_five
            CALL PDRAWFIGURESCREEN
            MOV AX, 06
            MOV DI, offset wall_five
            CALL PDRAWFIGURESCREEN
            MOV AX, 09
            MOV DI, offset wall_two
            CALL PDRAWFIGURESCREEN

            INC CX
            CALL PPAINTVERTICAL
            INC CX
            CALL PPAINTVERTICAL
            INC CX
            MOV AX, 00
            MOV DI, offset wall_ten
            CALL PDRAWFIGURESCREEN
            MOV AX, 03
            MOV DI, offset wall_six
            CALL PDRAWFIGURESCREEN
            MOV AX, 06
            MOV DI, offset wall_six
            CALL PDRAWFIGURESCREEN
            MOV AX, 09
            MOV DI, offset wall_twelve
            CALL PDRAWFIGURESCREEN
            CALL PPAINTHORIZONTAL

            INC CX
            CALL PPAINTVERTICAL
            INC CX
            CALL PPAINTVERTICAL
            INC CX
            MOV AX, 00
            MOV DI, offset wall_ten
            CALL PDRAWFIGURESCREEN
            MOV AX, 03
            MOV DI, offset wall_six
            CALL PDRAWFIGURESCREEN
            MOV AX, 06
            MOV DI, offset wall_six
            CALL PDRAWFIGURESCREEN
            MOV AX, 09
            MOV DI, offset wall_twelve
            CALL PDRAWFIGURESCREEN
            CALL PPAINTHORIZONTAL

            INC CX
            CALL PPAINTVERTICAL
            INC CX
            CALL PPAINTVERTICAL
            INC CX
            MOV AX, 00
            MOV DI, offset wall_fourteen
            CALL PDRAWFIGURESCREEN
            MOV AX, 03
            MOV DI, offset wall_eleven
            CALL PDRAWFIGURESCREEN
            MOV AX, 06
            MOV DI, offset wall_eleven
            CALL PDRAWFIGURESCREEN
            MOV AX, 09
            MOV DI, offset wall_fifteen
            CALL PDRAWFIGURESCREEN
            CALL PPAINTHORIZONTAL

            RET
            PCREARTABLERO ENDP

            PPAINTHORIZONTAL PROC
            MOV AX, 01
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN
            
            INC AX
            INC AX
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN

            INC AX
            INC AX
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset wall_four
            CALL PDRAWFIGURESCREEN
            RET

            PPAINTHORIZONTAL ENDP

            PPAINTVERTICAL PROC
            MOV AX, 00
            MOV DI, offset wall_three
            CALL PDRAWFIGURESCREEN
            ADD AX, 03
            MOV DI, offset wall_three
            CALL PDRAWFIGURESCREEN
            ADD AX, 03
            MOV DI, offset wall_three
            CALL PDRAWFIGURESCREEN
            ADD AX, 03
            MOV DI, offset wall_three
            CALL PDRAWFIGURESCREEN
            RET
            PPAINTVERTICAL ENDP
            
            PDRAWFIGURESCREEN PROC
                PUSH AX
                PUSH CX

                MOV BX, 0000
                MOV DL, 08
                MUL DL          ; SE MULTIPLICA AX * 8 PARA OBTENER LA COLUMNA EN LA CUAL SE UBICARA
                ADD BX, AX
                XCHG AX, CX     ; INTERCAMBIA POS X = CX y POS Y = AX
                MUL DL
                XCHG AX, CX     ; POS X = BX    POS Y = CX
                position_screen:
                    CMP CX, 0000
                    JE end_position_screen
                    ADD BX, 140     ; BX SE QUEDA CON LA POSICION FINAL DONDE SE COLOCARA EL GRAFICO
                    LOOP position_screen
                end_position_screen:
                    MOV CX, 0008
                draw_figure_row_screen:
                    PUSH CX
                    MOV CX, 0008
                draw_figure_column_screen:
                    MOV AL, [DI]

                    PUSH DS

                    mMoveToVideo
                    MOV [BX], AL
                    INC BX
                    INC DI

                    POP DS
                    LOOP draw_figure_column_screen

                    POP CX
                    SUB BX, 08      ; SE LE RESTA LOS 8 QUE SE AVANZAN EN LAS COLUMNAS
                    ADD BX, 140     ; SE LE SUMA LOS 320 PARA AVANZAR A LA SIGUIENTE FILA
                    LOOP draw_figure_row_screen
                    POP CX
                    POP AX
                    ret
            PDRAWFIGURESCREEN ENDP

            PDRAWO PROC
            PUSH AX
            PUSH CX

            PUSH AX
            PUSH CX
            MOV DI, offset barrao_uno
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset barrao_tres
            CALL PDRAWFIGURESCREEN
            POP CX
            POP AX
            
            INC CX
            MOV DI, offset barrao_dos
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset barrao_cuatro
            CALL PDRAWFIGURESCREEN

            POP CX
            POP AX  
            RET
            PDRAWO ENDP

            PDRAWX PROC
            PUSH AX
            PUSH AX
            MOV DI, offset barrax_uno
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset barrax_dos
            CALL PDRAWFIGURESCREEN
            POP AX

            INC CX
            MOV DI, offset barrax_dos
            CALL PDRAWFIGURESCREEN
            INC AX
            MOV DI, offset barrax_uno
            CALL PDRAWFIGURESCREEN
            POP AX
            RET
            PDRAWX ENDP

            PCREAROBJETO PROC
                make_wall: 
                    mov AX, [posXRead]    ; POS X DE LA PARED
                    DEC AX
                    mov CX, [posYRead]    ; POS Y DE LA PARED
                    mov DH, [wallRead]
                    call PPUTFIGURE
                    JMP end_coordinates
                end_coordinates:
                    RET
            PCREAROBJETO ENDP

            PDRAWFIGURE PROC
                MOV BX, 0000
                MOV DL, 08
                MUL DL          ; SE MULTIPLICA AX * 8 PARA OBTENER LA COLUMNA EN LA CUAL SE UBICARA
                ADD BX, AX
                XCHG AX, CX     ; INTERCAMBIA POS X = CX y POS Y = AX
                MUL DL
                XCHG AX, CX     ; POS X = BX    POS Y = CX
                position:
                    CMP CX, 0000
                    JE end_position
                    ADD BX, 140     ; BX SE QUEDA CON LA POSICION FINAL DONDE SE COLOCARA EL GRAFICO
                    LOOP position
                end_position:
                    MOV CX, 0008
                draw_figure_row:
                    PUSH CX
                    MOV CX, 0008
                draw_figure_column:
                    MOV AL, [DI]

                    PUSH DS

                    mMoveToVideo
                    MOV [BX], AL
                    INC BX
                    INC DI

                    POP DS
                    LOOP draw_figure_column

                    POP CX
                    SUB BX, 08      ; SE LE RESTA LOS 8 QUE SE AVANZAN EN LAS COLUMNAS
                    ADD BX, 140     ; SE LE SUMA LOS 320 PARA AVANZAR A LA SIGUIENTE FILA
                    LOOP draw_figure_row

                    ret
            PDRAWFIGURE ENDP

            PPUTFIGURE PROC
                PUSH AX
                PUSH CX

                MOV DI, offset object_map
                MOV DL, 03          ; 3d
                XCHG AX, CX
                MUL DL              ; POS Y * 3d
                XCHG AX, CX
                ADD DI, AX          ; Hacer row major: offset + x + y * 3d
                ADD DI, CX
                MOV AL, [DI]
                CMP AL, 00
                JNE celda_ocupada
                MOV [DI], DH        ; colocar objeto
                JMP finish_put_figure
                celda_ocupada:
                    mPrintTextIntoVideo 0Bh, 00, mensaje_celda_invalida, 1F, 0004
                    MOV is_celda_invalida, 01
                finish_put_figure:
                    POP CX
                    POP AX
                    ret
            PPUTFIGURE ENDP

            PMOVDATATOES PROC
            PUSH DX

            MOV DX, @DATA
            MOV ES, DX

            POP DX
            RET
            PMOVDATATOES ENDP

            PMOVESTOVIDEOMODE PROC
            PUSH DX

            MOV DX, 0A000h
            MOV ES, DX

            POP DX
            RET
            PMOVESTOVIDEOMODE ENDP
            
            PCLEANSCREEN PROC
                XOR AX, AX      ; POS X
                XOR CX, CX      ; POS Y
                XOR SI, SI
                XOR BX, BX
                mov CX, 19      ; 25d
                traverse_rows_cls:
                    XOR AX, AX      ; POS X
                    push CX         ; SE GUARDAN LAS FILAS
                    xchg CX, SI     ; CX = POS Y, SI = 25d
                    xchg CX, BX     ; CX = NO SIRVE EL VALOR, BX = POS Y
                    mov CX, 28      ; 40d
                traverse_columns_cls3:
                    push CX         ; SE GUARDAN LAS COLUMNAS
                    xchg CX, BX     ; CX = POS Y, BX = 40d
                    mov DI, offset empty_block
                    push AX
                    push CX
                    call PDRAWFIGURE
                    pop CX
                    pop AX
                    inc AX      ; SE INCREMENTA POSICION EN X
                    xchg CX, BX ; EL VALOR DESPUES DE DIBUJAR SE TRASLADA A CX, SE ACTUALIZA POSICION EN Y
                                ; CX = POS EN Y, BX = POS EN Y ANTES DE DIBUJAR
                    pop CX      ; SE RECUPERA EL VALOR DE LAS COLUMNAS
                    loop traverse_columns_cls3
                    xchg CX, BX ; EL VALOR DESPUES DE DIBUJAR SE TRASLADA A CX, SE ACTUALIZA POSICION EN Y
                    inc CX      ; SE INCREMENTA POSICION EN Y
                    xchg CX, SI ; CX = NO SIRVE EL VALOR, SI = POS EN Y
                    pop CX
                    loop traverse_rows_cls
                finish_clean_screen3:
                    ret
            PCLEANSCREEN ENDP

            JMP SubMenu ;--------------------------------------------- fin de uno vs uno

        opcion3: ; ---reportes
            PrintColor R_1, 0Ch  ; Rojo brillante
            PrintColor R_2, 0Ch
            PrintColor R_3, 0Ch
            AbrirArchivo2
            PrintColor dataTXT, 0Ch
            PrintColor R_4, 0Ch
            
        JMP SubMenu

    animacion: ;------------------------------------------- Animaciones menu principal
        OpenFile handler
        GetSizeFile handler
        
        MOV AH, 10h
        INT 16h

        MOV AX, 03h
        INT 10h

        CicloAnimaciones:
            MOV fila, 0
            MOV filaActual, 0
            MOV columna, 0
            
            CMP paginaActual, 0 ; * Salto A Pagina 1
            JZ EtAnimacion1Aux

            CMP paginaActual, 1 ; * Salto A Pagina 2
            JZ EtAnimacion2Aux

            CMP paginaActual, 2 ; * Salto A Pagina 3
            JZ EtAnimacion3Aux

            CMP paginaActual, 3 ; * Salto A Pagina 4
            JZ EtAnimacion4Aux

            CMP paginaActual, 4 ; * Salto A Pagina 5
            JZ EtAnimacion5Aux

            CMP paginaActual, 5; * Salto A Pagina 5
            JZ EtAnimacion6Aux

            CMP paginaActual, 6 ; * Salto A Pagina 5
            JZ EtAnimacion7Aux

            CMP paginaActual, 7 ; * Salto A Pagina 5
            JZ EtAnimacion8Aux

            JMP Salir   ; ! -> Si "paginaActual" Sobrepasa A Los Valores Definidos Que Salga Del Ciclo

            ; ? ETIQUETAS AUXILIARES PARA EVITAR ERRORES CON LA LONGITUD DE SALTOS
            EtAnimacion1Aux:    
                JMP EtAnimacion1
            EtAnimacion2Aux:
                JMP EtAnimacion2
            EtAnimacion3Aux:
                JMP EtAnimacion3
            EtAnimacion4Aux:
                JMP EtAnimacion4
            EtAnimacion5Aux:
                JMP EtAnimacion5
            EtAnimacion6Aux:
                JMP EtAnimacion6
            EtAnimacion7Aux:
                JMP EtAnimacion7
            EtAnimacion8Aux:
                JMP EtAnimacion8

            ; * Invocacion Animacion 1
            EtAnimacion1:
                Animacion1 charsPerRow1, cantRows1, bufferImagen1
                JMP CicloAnimaciones

            ; * Invocacion Animacion 2
            EtAnimacion2:
                Animacion2 charsPerRow2, cantRows2, bufferImagen2
                JMP CicloAnimaciones

            ; * Invocacion Animacion 3
            EtAnimacion3:
                Animacion3 charsPerRow3, cantRows3, bufferImagen3
                JMP CicloAnimaciones

            ; * Invocacion Animacion 4
            EtAnimacion4:
                Animacion4 charsPerRow4, cantRows4, bufferImagen4
                JMP CicloAnimaciones

            EtAnimacion5:
                Animacion1 charsPerRow5, cantRows5, bufferImagen5
                JMP CicloAnimaciones

                EtAnimacion6:
                Animacion1 charsPerRow6, cantRows6, bufferImagen6
                JMP CicloAnimaciones

                EtAnimacion7:
                Animacion1 charsPerRow7, cantRows7, bufferImagen7
                JMP CicloAnimaciones
                
                EtAnimacion8:
                Animacion1 charsPerRow8, cantRows8, bufferImagen8
                JMP CicloAnimaciones

    JMP Menu   ;--------------------------------------------- fin de animaciones

    informacion: ;--------------------------------------- informacion menu principal
        clearConsole
        printCadena saltoLinea
        PrintColor info1, 03h
        PrintColor info2, 03h
        PrintColor info3, 03h
        PrintColor info4, 03h
        PrintColor info5, 03h 
        PrintColor info6, 03h
        printCadena saltoLinea
        PrintColor info7, 03h
        PrintColor info8, 03h
        PrintColor info9, 03h
        PrintColor info10, 03h
        PrintColor info11, 03h
        PrintColor info12, 03h
        PrintColor info13, 03h

        printCadena saltoLinea
        printCadena enter_continuar
        pauseUntilEnter

        clearConsole
        JMP Menu ;--------------------------------------------- fin de informacion

    Salir:
        MOV AX, 4C00h                     ; Termina el programa
        INT 21h

    Main ENDP

END
