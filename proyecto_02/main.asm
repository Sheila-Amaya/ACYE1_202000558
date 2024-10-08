INCLUDE macro.asm
INCLUDE macro2.asm
;---------------------------------------------------------
.MODEL small
.STACK 100h
.DATA
        l1 db  "                                       .                           ",10,13, "$"                       
        l2 db  "                                     .###                          ",10,13, "$"                       
        l3 db  "                               ####  ##  ##  ####                  ",10,13, "$"                       
        l4 db  "                                # #  #    #  # #                   ",10,13, "$"                       
        l5 db  "                                #  ##########+ #                   ",10,13, "$"                       
        l6 db  "                          ####.  #-          +#   ####             ",10,13, "$"                       
        l7 db  "                            #     #+         #     #               ",10,13, "$"                       
        l8 db  "                             ###### -####### ######                ",10,13, "$"                       
        l9 db  "                             #  #      ##      #  #                ",10,13, "$"                       
        l10 db "                           #####+##- #    # .########              ",10,13, "$"                       
        l11 db "                            ###- #####    ##### .###-              ",10,13, "$"                       
        l12 db "                                #    # ## #    #                   ",10,13, "$"                       
        l13 db "                                #   ##    ##   #                   ",10,13, "$"                       
        l14 db "                               ###    #  #    ###                  ",10,13, "$"                       
        l15 db "                                       ##                          ",10,13, "$"                       
        l16 db "                                                                   ",10,13, "$"                       
        l17 db "                                                                   ",10,13, "$"                       
        l18 db "                ##  #  ## #####  ##   ##### #####   ##    ##   ##   ",10,13, "$"                       
        l19 db "               .# ### ## #   ## ##   ##    ## ##  # -#   #.# ###   ",10,13, "$"                       
        l20 db "                ### ###  #.  ## #    ##=   ## #  ###### -# ### ##  ",10,13, "$"                       
        l21 db "                ##   ##   ###   #### ##    ## ##.#    ###   #  ##  ",10,13, "$"

        info0 db "    ARQUITECTURA DE COMPUTADORES 1",10,13, "$"
        info1 db "    Y ENSAMBLADORES 1 - A",10,13, "$"
        info2 db "    PRIMER SEMESTRE 2024",10,13, "$"
        info3 db "    sheila Amaya",10,13, "$"
        info4 db "    202000558",10,13, "$"
        info5 db "    Proyecto 2 Assembler",10,13, "$"

        enter_continuar  db  '       Presionar ENTER para continuar ','$'
        enter_continuar2  db  ' ... ','$'
        saltoLinea db 10, 13, "$"
        msj0 db " >> ", "$"

        ;------------------ op 
        handlerFile         dw ?
        filename            db 30 dup(32)
        bufferDatos         db 1200 dup (?)
        errorCode           db ?
        errorOpenFile       db "    Ocurrio Un Error al Abrir El Archivo - ERRCODE: ", "$"
        errorCloseFile      db "    Ocurrio Un Error al Cerrar El Archivo - ERRCODE: ", "$"
        errorReadFile       db "    Ocurrio Un Error al Leer El CSV - ERRCODE: ", "$"
        errorSizeFile       db "    Ocurrio Un Error Obteniendo El Size Del Archivo - ERRCODE: ", "$"
        exitOpenFileMsg     db "    El Archivo Se Abrio Correctamente", "$"
        exitCloseFileMsg    db "    El Archivo Se Cerro Correctamente", "$"
        exitSizeFileMsg     db "    Se Obtuvo La Longitud Correctamente", "$"
        msgToRequestFile    db "  > ", "$"
        msgPromedio         db "    ", "$"
        msgMaximo           db "    ", "$"
        msgMinimo           db "    ", "$"
        msgMediana          db "    ", "$"
        msgContadorDatos    db "    ", "$"
        msgModa1            db "    Moda      : ", "$"
        msgModa2            db "    Frecuencia: ", "$"
        msgEncabezadoTabla  db "    |    V    |    Fr   |", "$"
        msgEncabezadoTabla2 db "    +-------------------+", "$"
        salto               db 10, 13, "$"
        salto2               db 10, "$"
        formatoTabla        db "|", "$"   
        espacios            db 32, 32, "$"
        numCSV              db 3 dup(?)
        cadenaResult        db 6 dup("$")
        tablaFrecuencias    db 100 dup(?)
        numEntradas         db 1
        indexDatos          dw 0
        extensionArchivo    dw 0
        posApuntador        dw 0
        numDatos            dw 0
        base                dw 10000
        entero              dw ?
        decimal             dw ?
        cantDecimal         db 0

        ;------------------ datos2
        tablaF              db 400 dup(?)
        numE                db 1
        entero2              dw ?


        nombreDB db "202000558.txt", 0
        filehandle dw ?
        bytesRead dw ?
        dataTXT db 1024 dup("$")
        segundos db 2 dup("$")
        Barra db "|", "$"
        horaDB db 10 dup(32)
        fechaDB db 10 dup(32)
        espacio db "    ", "$"
        espacio11 db "            ", "$"


        ;------------------ comandos
        inputString db 16 dup(0)
        promedioString      db 'prom', 0
        medianaString       db 'med' , 0
        modaString          db 'moda', 0
        maximoString        db 'max' , 0
        minimoString        db 'min' , 0
        contadorString      db 'contador', 0
        barra_aString       db 'graf_barra_asc', 0
        barra_dString       db 'graf_barra_desc', 0
        grafico_lString     db 'graf_line', 0
        abrir_archivoString db 'abrir', 0
        limpiarString       db 'limpiar', 0
        reporteString       db 'reporte', 0
        infoString          db 'info', 0
        salirString         db 'salir', 0

        
        msj1 db " Promedio     : ", "$"
        msj2 db " Mediana      : ", "$"
        msj3 db " Moda         : ", "$"
        msj4 db " Frecuencia   : ", "$"
        msj5 db " Maximo       : ", "$"
        msj6 db " Minimo       : ", "$"
        msj7 db " Contador     : ", "$"
        msj13 db "    Archivo creado ...", "$"

        msj db " >> Err", "$"

        nombre   db "Nombre : Sheila Amaya", "$"
        id       db "Carnet : 202000558", "$"
        fechaStr db "Fecha  : ", "$"
        horaStr  db "Hora   : ", "$"

        ;------------------
        msgDosPuntosEspacio db ': ', 0
        msgLineaHorizontal db '-', 0

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

        printCadena msj0    ; >>
        limpiarCadena inputString
        obtenerCadena inputString, 16
        
        compareStrings inputString, promedioString, promedio1
        JMP no_es_promedio

        promedio1:                          ;---------------------- promedio
            Promedio
            MOV base, 10000
            
            limpiarCadena inputString
            JMP Menu                       ; ------------------- fin promedio
        
        no_es_promedio:
            compareStrings inputString, medianaString, mediana1
            JMP no_es_mediana

        mediana1:                          ;---------------------- mediana

            Mediana
            MOV base, 10000

            limpiarCadena inputString
            JMP Menu                      ; ------------------- fin mediana
        
        no_es_mediana:
            compareStrings inputString, modaString, moda1
            JMP no_es_moda

        moda1:                             ;---------------------- moda

            BuildTablaFrecuencias
            OrderFrecuencies
            MOV base, 10000
            ;PrintTablaFrecuencias
            ;printCadena msgEncabezadoTabla2

            Moda
            MOV base, 10000
            JMP Menu                       ; ------------------- fin moda

        no_es_moda:
            compareStrings inputString, maximoString, maximo1
            JMP no_es_maximo

        maximo1:                           ;---------------------- maximo

            Maximo
            MOV base, 10000

            limpiarCadena inputString
            JMP Menu                       ; ------------------- fin maximo

        no_es_maximo:
            compareStrings inputString, minimoString, minimo1
            JMP no_es_minimo

        minimo1:                          ;---------------------- minimo

            Minimo
            MOV base, 10000

            limpiarCadena inputString
            JMP Menu                     ; ------------------- fin minimo

        no_es_minimo:
            compareStrings inputString, contadorString, contador1
            JMP no_es_contador

        contador1:                       ;---------------------- contador

            ContadorDatos
            MOV base, 10000

            limpiarCadena inputString
            JMP Menu                    ; ------------------- fin contador

        no_es_contador:
            compareStrings inputString, barra_aString, barra_a1
            JMP no_es_barra_a

        barra_a1:                       ;---------------------- barra_ascendente
            CambiarModoVideo
            DibujarLineas

            PrintColor enter_continuar2, 11
            pauseUntilEnter

            CambiarModoTexto
            limpiarCadena inputString 
            JMP Menu                    ; ------------------- fin barra_ascendente

        no_es_barra_a:  
            compareStrings inputString, barra_dString, barra_d1
            JMP no_es_barra_d

        barra_d1:                       ;---------------------- barra_descendente
            CambiarModoVideo


            PrintColor enter_continuar2, 11
            pauseUntilEnter

            CambiarModoTexto
            limpiarCadena inputString
            JMP Menu                    ; ------------------- fin barra_descendente

        no_es_barra_d:
            compareStrings inputString, grafico_lString, grafico_l1
            JMP no_es_grafico_l

        grafico_l1:                     ;---------------------- grafico_lineal
            CambiarModoVideo


            PrintColor enter_continuar2, 11
            pauseUntilEnter

            CambiarModoTexto
            limpiarCadena inputString
            JMP Menu                   ; ------------------- fin grafico_lineal

        no_es_grafico_l:
            compareStrings inputString, abrir_archivoString, abrir_archivo1
            JMP no_es_abrir_archivo

        abrir_archivo1:                 ;-------------------- abrir archivo
            
            Clean ; limpia las variables
            PrintColor msgToRequestFile, 7 
            PedirCadena filename

            OpenFile
            GetSizeFile handlerFile
            ReadCSV handlerFile, numCSV
            CloseFile handlerFile

            OrderData

            limpiarCadena inputString
            JMP Menu                    ; ------------------- fin abrir archivo

        no_es_abrir_archivo:
            compareStrings inputString, limpiarString, limpiar1
            JMP no_es_limpiar

        limpiar1:                       ;---------------------- limpiar consola
            clearConsole
            limpiarCadena inputString
            JMP Menu                    ; ------------------- fin limpiar consola

        no_es_limpiar:
            compareStrings inputString, reporteString, reporte1
            JMP no_es_reporte

        reporte1:                       ;---------------------- reporte
            
            AbrirArchivo
            AbrirArchivo3

            Promedio2
            MOV base, 10000
            EscribirArchivo salto2

            Mediana2
            MOV base, 10000
            EscribirArchivo salto2

            Minimo2 
            MOV base, 10000
            EscribirArchivo salto2

            Maximo2
            MOV base, 10000
            EscribirArchivo salto2

            ContadorDatos2
            MOV base, 10000
            EscribirArchivo salto2

            BuildTablaFrecuencias2
            OrderFrecuencies2
            MOV base, 10000

            Moda2
            MOV base, 10000

            PrintTablaFrecuencias2
            EscribirArchivo msgEncabezadoTabla2
            EscribirArchivo salto

            EscribirArchivo  fechaStr
            ImpFecha fechaDB
            EscribirArchivo  salto2
            EscribirArchivo  horaStr
            ImpHora horaDB
            EscribirArchivo  salto2
            EscribirArchivo  nombre
            EscribirArchivo  salto2
            EscribirArchivo  id
            EscribirArchivo  salto2

            PrintColor msj13, 9
            limpiarCadena inputString
            CerrarArchivo
            JMP Menu                    ; ------------------- fin reporte

        no_es_reporte:
            compareStrings inputString, infoString, info
            JMP no_es_info

        info:                           ;---------------------- info
            limpiarCadena inputString
            mostrarInfo                 ; macro muestra la info
            JMP Menu                    ; ------------------- fin info

        no_es_info:
            compareStrings inputString, salirString, salir
            JMP no_es_salir

        salir:
            MOV AX, 4C00h                     ; Termina el programa
            INT 21h

        no_es_salir:
            PrintColor msj, 4
            limpiarCadena inputString
            JMP Menu

    Main ENDP
END