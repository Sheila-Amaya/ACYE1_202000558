INCLUDE macro.asm
;---------------------------------------------------------
.MODEL small

.STACK 64h

.DATA
        l1 db  "                                .                          ",10,13, "$"                       
        l2 db  "                              .###                         ",10,13, "$"                       
        l3 db  "                       ####  ##  ##  ####                  ",10,13, "$"                       
        l4 db  "                        # #  #    #  # #                   ",10,13, "$"                       
        l5 db  "                        #  ##########+ #                   ",10,13, "$"                       
        l6 db  "                  ####.  #-          +#   ####             ",10,13, "$"                       
        l7 db  "                    #     #+         #     #               ",10,13, "$"                       
        l8 db  "                     ###### -####### ######                ",10,13, "$"                       
        l9 db  "                     #  #      ##      #  #                ",10,13, "$"                       
        l10 db "                   #####+##- #    # .########              ",10,13, "$"                       
        l11 db "                    ###- #####    ##### .###-              ",10,13, "$"                       
        l12 db "                        #    # ## #    #                   ",10,13, "$"                       
        l13 db "                        #   ##    ##   #                   ",10,13, "$"                       
        l14 db "                       ###    #  #    ###                  ",10,13, "$"                       
        l15 db "                               ##                          ",10,13, "$"                       
        l16 db "                                                           ",10,13, "$"                       
        l17 db "                                                           ",10,13, "$"                       
        l18 db "       ##  #  ## #####  ##   ##### #####   ##    ##   ##   ",10,13, "$"                       
        l19 db "       .# ### ## #   ## ##   ##    ## ##  # -#   #.# ###   ",10,13, "$"                       
        l20 db "        ### ###  #.  ## #-   ##    ## #  ###### -# ### ##  ",10,13, "$"                       
        l21 db "        ##   ##   ###   #### ##    ## ##.#    ###   #  ##  ",10,13, "$"

        info0 db  "    ARQUITECTURA DE COMPUTADORES 1",10,13, "$"
        info1 db "    Y ENSAMBLADORES 1 - A",10,13, "$"
        info2 db "    PRIMER SEMESTRE 2024",10,13, "$"
        info3 db "    sheila Amaya",10,13, "$"
        info4 db "    202000558",10,13, "$"
        info5 db "    Proyecto 2 Assembler",10,13, "$"

        enter_continuar  db  '       Presionar ENTER para continuar ','$'
        saltoLinea db 10, 13, "$"
        msj0 db " >> Ingrese un comando: ", "$"

        inputString db 16 dup(0)
        promedioString      db 'prom', 0
        medianaString       db 'med', 0
        modaString          db 'moda', 0
        maximoString        db 'max', 0
        minimoString        db 'min', 0
        contadorString      db 'contador', 0
        barra_aString       db 'graf_barra_asc', 0
        barra_dString       db 'graf_barra_desc', 0
        grafico_lString     db 'graf_line', 0
        abrir_archivoString db 'abrir', 0
        limpiarString       db 'limpiar', 0
        reporteString       db 'reporte', 0
        infoString          db 'info', 0
        salirString         db 'salir', 0

        
        msj1 db "desde prom", "$"
        msj2 db "desde mediana", "$"
        msj3 db "desde moda", "$"
        msj4 db "desde maximo", "$"
        msj5 db "desde minimo", "$"
        msj6 db "desde contador", "$"
        msj7 db "desde barra_a", "$"
        msj8 db "desde barra_d", "$"
        msj9 db "desde grafico_l", "$"
        msj10 db "desde abrir_archivo", "$"
        msj11 db "desde limpiar", "$"
        msj12 db "desde reporte", "$"
        msj13 db "desde info", "$"
        msj db " >> Comando no reconocido", "$"



.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    Main  PROC                                    ; metodo Inicio del programa
    clearConsole

    PrintColor l1, 7
    PrintColor l2, 7
    PrintColor l3, 7
    PrintColor l4, 7
    PrintColor l5, 7
    PrintColor l6, 7
    PrintColor l7, 7
    PrintColor l8, 7
    PrintColor l9, 7
    PrintColor l10, 7
    PrintColor l11, 7
    PrintColor l12, 7
    PrintColor l13, 7
    PrintColor l14, 7
    PrintColor l15, 7
    PrintColor l16, 7
    PrintColor l18, 4
    PrintColor l19, 4
    PrintColor l20, 4
    PrintColor l21, 4
    printCadena saltoLinea

    PrintColor enter_continuar, 6
    pauseUntilEnter
    clearConsole

    ;---------------- ingreso de comandos por consola
    Menu:
        printCadena saltoLinea

        printCadena msj0
        limpiarCadena inputString
        obtenerCadena inputString, 16
        
        compareStrings inputString, promedioString, promedio
        JMP no_es_promedio

        promedio:
            PrintColor msj1, 2 ; verde
            limpiarCadena inputString
            JMP Menu
        
        no_es_promedio:
            compareStrings inputString, medianaString, mediana
            JMP no_es_mediana

        mediana:
            PrintColor msj2, 3 ; azul
            limpiarCadena inputString
            JMP Menu
        
        no_es_mediana:
            compareStrings inputString, modaString, moda
            JMP no_es_moda

        moda:
            PrintColor msj3, 1 ; rojo
            limpiarCadena inputString
            JMP Menu

        no_es_moda:
            compareStrings inputString, maximoString, maximo
            JMP no_es_maximo

        maximo:
            PrintColor msj4, 5 ; morado
            limpiarCadena inputString
            JMP Menu

        no_es_maximo:
            compareStrings inputString, minimoString, minimo
            JMP no_es_minimo

        minimo:
            PrintColor msj5, 8 ; gris
            limpiarCadena inputString
            JMP Menu

        no_es_minimo:
            compareStrings inputString, contadorString, contador
            JMP no_es_contador

        contador:
            PrintColor msj6, 9 ; azul claro
            limpiarCadena inputString
            JMP Menu

        no_es_contador:
            compareStrings inputString, barra_aString, barra_a
            JMP no_es_barra_a

        barra_a:
            PrintColor msj7, 1
            limpiarCadena inputString 
            JMP Menu

        no_es_barra_a:
            compareStrings inputString, barra_dString, barra_d
            JMP no_es_barra_d

        barra_d:
            PrintColor msj8, 11 ; verde claro
            limpiarCadena inputString
            JMP Menu

        no_es_barra_d:
            compareStrings inputString, grafico_lString, grafico_l
            JMP no_es_grafico_l

        grafico_l:
            PrintColor msj9, 12 ; verde claro
            limpiarCadena inputString
            JMP Menu

        no_es_grafico_l:
            compareStrings inputString, abrir_archivoString, abrir_archivo
            JMP no_es_abrir_archivo

        abrir_archivo:
            PrintColor msj10, 6 ; rojo
            limpiarCadena inputString
            JMP Menu

        no_es_abrir_archivo:
            compareStrings inputString, limpiarString, limpiar
            JMP no_es_limpiar

        limpiar:
            PrintColor msj11, 8 ; rojo
            limpiarCadena inputString
            JMP Menu

        no_es_limpiar:
            compareStrings inputString, reporteString, reporte
            JMP no_es_reporte

        reporte:
            PrintColor msj12, 9 ; rojo
            limpiarCadena inputString
            JMP Menu

        no_es_reporte:
            compareStrings inputString, infoString, info
            JMP no_es_info

        info:
            limpiarCadena inputString

            printCadena saltoLinea
            PrintColor info0, 9
            PrintColor info1, 9
            PrintColor info2, 9
            PrintColor info3, 9
            PrintColor info4, 9
            PrintColor info5, 9

            JMP Menu

        no_es_info:
            compareStrings inputString, salirString, salir
            JMP no_es_salir

        salir:
            MOV AX, 4C00h                     ; Termina el programa
            INT 21h

        no_es_salir:
            PrintColor msj, 4
            limpiarCadena inputString
            JMP Main

    Main ENDP
END