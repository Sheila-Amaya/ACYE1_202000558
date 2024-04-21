INCLUDE macrosA.asm

.MODEL small

.STACK 100h

.DATA
    handler             dw ?
    filename            db "Input1.txt", 0
    salto               db 10, 13, "$"
    errorCode           db ?
    errorOpenFile       db "Ocurrio Un Error Al Abrir El Archivo - ERRCODE: ", "$"
    errorCloseFile      db "Ocurrio Un Error Al Cerrar El Archivo - ERRCODE: ", "$"
    errorReadFile       db "Ocurrio Un Error Al Leer El Archivo - ERRCODE: ", "$"
    errorSizeFile       db "Ocurrio Un Error Obteniendo El Size Del Archivo - ERRCODE: ", "$"
    exitOpenFileMsg     db " ", "$"
    exitCloseFileMsg    db " ", "$"
    exitSizeFileMsg     db " ", "$"
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
.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    Main PROC

        CargarFile

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
                Animacion5 charsPerRow5, cantRows5, bufferImagen5
                JMP CicloAnimaciones

                EtAnimacion6:
                Animacion6 charsPerRow6, cantRows6, bufferImagen6
                JMP CicloAnimaciones

                EtAnimacion7:
                Animacion7 charsPerRow7, cantRows7, bufferImagen7
                JMP CicloAnimaciones
                
                EtAnimacion8:
                Animacion8 charsPerRow8, cantRows8, bufferImagen8
                JMP CicloAnimaciones
        Salir:
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END
