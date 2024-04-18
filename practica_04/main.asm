INCLUDE macros.asm

;---------------------------------------------------------
.MODEL small

.STACK 64h

.DATA 
    saltoLinea db 10, 13, "$"
    ; menu
    messageMenu   db "    +===============================+", 10, 13 , "$"
    messageMenu1  db "    ||      MENU PRINCIPAL         ||", 10, 13, "$"
    messageMenu2  db "    +===============================+", 10, 13, "$"
    messageMenu3  db "    || 1. Nuevo Juego              ||", 10, 13, "$"
    messageMenu4  db "    ||                             ||", 10, 13, "$"
    messageMenu5  db "    || 2. Animacion                ||", 10, 13, "$"
    messageMenu6  db "    ||                             ||", 10, 13, "$"
    messageMenu7  db "    || 3. Informacion              ||", 10, 13, "$"
    messageMenu8  db "    ||                             ||", 10, 13, "$"
    messageMenu9  db "    || 4. Salir                    ||", 10, 13, "$"
    messageMenu10 db "    ||                             ||", 10, 13, "$"
    messageMenu11 db "    ||   Seleccione una opcion:    ||", 10, 13, "$"
    messageMenu12 db "    +===============================+", 10, 13, "$"
    messageMenu13 db "    >>", "$"
    op db 1 dup("$")

    ; submenu
    messageSubMenu   db "    +===============================+", 10, 13, "$"
    messageSubMenu1  db "    ||      MENU NUEVO JUEGO       ||", 10, 13, "$"
    messageSubMenu2  db "    +===============================+", 10, 13, "$"
    messageSubMenu3  db "    || 1. 1 vs. CPU                ||", 10, 13, "$"
    messageSubMenu4  db "    ||                             ||", 10, 13, "$"
    messageSubMenu5  db "    || 2. 1 vs. 1                  ||", 10, 13, "$"
    messageSubMenu6  db "    ||                             ||", 10, 13, "$"
    messageSubMenu7  db "    || 3. Reportes                 ||", 10, 13, "$"
    messageSubMenu8  db "    ||                             ||", 10, 13, "$"
    messageSubMenu9  db "    || 4. Volver al menu principal ||", 10, 13, "$"
    messageSubMenu10 db "    ||                             ||", 10, 13, "$"
    messageSubMenu11 db "    ||   Seleccione una opcion:    ||", 10, 13, "$"
    messageSubMenu12 db "    +==============================+", 10, 13, "$"
    messageSubMenu13 db "    >>  ", "$"
    subOp db 1 dup("$")

    ; informacion
    info1 db "    |\----/|\----/|\----/|\----/|\----/|\----/|\----/|\----/|   |\----/|", 10, 13, "$"
    info2 db "    | +--+   +---+  +---+  +--+   +--+   +--+   +--+   +--+ |   | +--+ |", 10, 13, "$"
    info3 db "    | |  |   |   |  |   |  |  |   |  |   |  |   |  |   |  | |   | |  | |", 10, 13, "$"
    info4 db "    | |P |   |R  |  |A  |  |C |   |T |   |I |   |C |   |A | |   | |4 | |", 10, 13, "$"
    info5 db "    | +--+   +---+  +---+  +--+   +--+   +--+   +--+   +--+ |   | +--+ |", 10, 13, "$"
    info6 db "    |/----\|/----\|/----\|/----\|/----\|/----\|/----\|/----/|   |/----\|", 10, 13, "$"
    
    info7  db "    UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 10, 13 , "$"
    info8  db "    FACULTAD DE INGENIERIA", 10, 13, "$"
    info9  db "    ESCUELA DE CIENCIAS Y SISTEMAS", 10, 13, "$"
    info10 db "    ARQUITECTURA DE COMPUTADORAS 1",10,13, "$"
    info11 db "    Primer Semestre 2024", 10, 13, "$"
    info12 db "    Sheila Amaya", 10, 13, "$"
    info13 db "    202000558", 10, 13, "$"
    
    ;----------------------------------------------------------

    nombreJugador1 db 8 dup(32)
    nombreJugador2 db 8 dup(32)


.CODE
    MOV AX, @data
    MOV DS, AX

    Main  PROC                                    ; metodo Inicio del programa
    clearConsole

    Menu:

    ;---------------------------- Imprime el menu
    printCadena saltoLinea
    printCadena messageMenu
    printCadena messageMenu1
    printCadena messageMenu2
    printCadena messageMenu3
    printCadena messageMenu4
    printCadena messageMenu5
    printCadena messageMenu6
    printCadena messageMenu7
    printCadena messageMenu8
    printCadena messageMenu9
    printCadena messageMenu10
    printCadena messageMenu11
    printCadena messageMenu12
    printCadena messageMenu13
    ;---------------------------------------------

    getOp op

    CMP op, 49                            ; compara si la opcion seleccionada es 1
    clearConsole
    JE NuevoJuego

    CMP op, 50                            ; compara si la opcion seleccionada es 2
    clearConsole
    JE Animacion

    CMP op, 51                           ; compara si la opcion seleccionada es 3  informacion
    clearConsole
    JE informacion

    CMP op, 52                           ; compara si la opcion seleccionada es 4
    clearConsole
    JE Salir

    JMP Menu

    NuevoJuego:
        
        SubMenu:

        ;---------------------------- Imprime el submenu
        printCadena saltoLinea
        PrintColor messageSubMenu,   0Ch ; Rojo brillante
        PrintColor messageSubMenu1,  0Eh ; Amarillo brillante
        PrintColor messageSubMenu2,  02h ; Verde
        PrintColor messageSubMenu3,  03h ; Cian
        PrintColor messageSubMenu4,  01h ; Azul
        PrintColor messageSubMenu5,  05h ; Magenta
        PrintColor messageSubMenu6,  06h ; Marrón
        PrintColor messageSubMenu7,  07h ; Gris claro
        PrintColor messageSubMenu8,  08h ; Gris oscuro
        PrintColor messageSubMenu9,  09h ; Azul claro
        PrintColor messageSubMenu10, 0Ah ; Verde claro
        PrintColor messageSubMenu11, 0Bh ; Cian claro
        PrintColor messageSubMenu12, 0Dh ; Magenta claro
        PrintColor messageSubMenu13, 0Fh ; Blanco
        
        ;-----------------------------

        getOp subOp

        CMP subOp, 49                            ; compara si la opcion seleccionada es 1
        clearConsole
        JE Opcion1

        CMP subOp, 50                            ; compara si la opcion seleccionada es 2
        clearConsole
        JE Opcion2

        CMP subOp, 51                           ; compara si la opcion seleccionada es 3
        clearConsole
        JE opcion3

        CMP subOp, 52                           ; compara si la opcion seleccionada es 4 regresa al menu principal
        clearConsole
        JE Menu

        Opcion1: ; 1 vs cpu
        JMP SubMenu

        Opcion2: ; 1 vs 1
        JMP SubMenu

        opcion3: ; reportes
        JMP SubMenu

    animacion:
    JMP Menu

    informacion:
        clearConsole
        printCadena saltoLinea
        PrintColor info1, 0Dh
        PrintColor info2, 0Dh
        PrintColor info3, 0Dh
        PrintColor info4, 0Dh
        PrintColor info5, 0Dh 
        PrintColor info6, 0Dh
        printCadena saltoLinea
        PrintColor info7, 0Dh
        PrintColor info8, 0Dh
        PrintColor info9, 0Dh
        PrintColor info10, 0Dh
        PrintColor info11, 0Dh
        PrintColor info12, 0Dh
        PrintColor info13, 0Dh

        getOp op
        clearConsole
        JMP Menu

    Salir:
        MOV AX, 4C00h                     ; Termina el programa
        INT 21h

    Main ENDP

END
