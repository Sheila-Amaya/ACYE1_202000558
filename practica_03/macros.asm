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

getInput MACRO
    MOV AH, 01h
    INT 21h
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


;-------------------------------------------------------------
validar_Fila_mov MACRO
    ; Solicitar y validar row
    printCadena PosibleFila
    getOp row

    CMP row, 49        ; Compara con 49 (el código ASCII de '1')
    JL _ErrorfilaMov      ; Si es menor que 0, salta a la etiqueta de error

    CMP row, 56        ; Compara con 56 (el código ASCII de '8')
    JG _ErrorfilaMov      ; Si es mayor que 8, salta a la etiqueta de error

    CMP row, 32        ; Compara con 32 (el código ASCII de ' ')
    JE _Errorfila      ; Si es igual a 32, salta a la etiqueta de errorfila
    JMP _ContinueFilaMov 

_ErrorfilaMov:
    Errorfila
_ContinueFilaMov:
ENDM

validar_Col_mov MACRO
    ; Solicita y validar col
    printCadena PosibleColumna
    getOp col

    CMP col, 65             ; Compara con 65 (el código ASCII de 'A')
    JL _ErrorColumnaMov        ; Si es menor que 0, salta a la etiqueta de error

    CMP col, 72             ; Compara con 72 (el código ASCII de 'H')
    JG _ErrorColumna        ; Si es mayor que 8, salta a la etiqueta de error
    JMP _ContinueColumnaMov

    CMP col, 32             ; Compara con 32 (el código ASCII de ' ')
    JE _ErrorColumna        ; Si es igual a 32, salta a la etiqueta de errorcolumna
    JMP _ContinueColumnaMov

_ErrorColumnaMov: 
    errorColumna
_ContinueColumnaMov:
ENDM

;------------------------------------------------------------- 

validarRangoFila MACRO
    LOCAL fin
    ; Solicitar y validar p_row
    printCadena PosibleFila
    getOp p_row

    CMP p_row, 119     ; Compara con 119 (el código ASCII de 'w')
    JE fin

    CMP p_row, 49      ; Compara con 49 (el código ASCII de '1')
    JL _Errorfila      ; Si es menor que 0, salta a la etiqueta de error

    CMP p_row, 56      ; Compara con 56 (el código ASCII de '8')
    JG _Errorfila      ; Si es mayor que 8, salta a la etiqueta de error

    CMP p_row, 32      ; Compara con 32 (el código ASCII de ' ')
    JE _Errorfila      ; Si es igual a 32, salta a la etiqueta de errorfila
    JMP _ContinueFila 

_Errorfila:
    Errorfila

fin:
    EndGame
    JMP pedirMov

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

EndGame MACRO params
LOCAL inicio, valido, fin

    AbrirArchivo3
    AbrirArchivo4
    CrearArchivo nombreArchivo, handlerArchivo
    macroTexto
    ;EscribirArchivo5 contTxt
    EscribirArchivo5 saltoLinea
    EscribirArchivo5 nombreJugador
    EscribirArchivo5 duracionStr
    cerrarArchivo handlerArchivo

ENDM

macroTexto MACRO
    LOCAL inicio, fin
        xor si, si
        xor bx, bx

        mov si, 00h
        mov bl, "$"

    inicio:
        cmp si, 100h
        je fin
        mov bh, contTxt[si]
        cmp bh, bl
        je fin
        inc si
        jmp inicio

    fin:
        EscribirArchivo6 contTxt
ENDM

macroTexto2 MACRO
    LOCAL inicio, fin
        xor si, si
        xor bx, bx

        mov si, 00h
        mov bl, "$"

    inicio:
        cmp si, 100h
        je fin
        mov bh, contTxt[si]
        cmp bh, bl
        je fin
        inc si
        jmp inicio

    fin:
        EscribirArchivo7 contTxt
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
    MOV AH, 2Ch
    INT 21h
    MOV horaInicial, CH
    MOV minutoInicial, CL
    MOV segundoInicial, DH
ENDM

finTiempo MACRO
    ; Guardar la hora final
    mov ah, 2Ch
    INT 21h
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
    MOV AH, 0
    MOV AL, duracionMin
    MOV BL, 10
    DIV BL
    ADD AH, '0'
    MOV duracionStr[0], AH
    ADD AL, '0'
    MOV duracionStr[1], AL
    MOV AL, ':'
    MOV duracionStr[2], AL
    MOV AH, 0
    MOV AL, duracionSeg
    MOV BL, 10
    DIV BL
    ADD AH, '0'
    MOV duracionStr[3], AH
    ADD AL, '0'
    MOV duracionStr[4], AL
    MOV AL, '$'
    MOV duracionStr[5], AL

    ; Imprimir la duración
    MOV AH, 09h
    LEA DX, duracionStr
    INT 21h
ENDM

convertirTiempoACadena MACRO
    ; Convertir la duración a una cadena
    MOV AH, 0
    MOV AL, duracionMin
    MOV BL, 10
    DIV BL
    ADD AH, '0'
    MOV duracionStr[0], AH
    ADD AL, '0'
    MOV duracionStr[1], AL
    MOV AL, ':'
    MOV duracionStr[2], AL
    MOV AH, 0
    MOV AL, duracionSeg
    MOV BL, 10
    DIV BL
    ADD AH, '0'
    MOV duracionStr[3], AH
    ADD AL, '0'
    MOV duracionStr[4], AL
    MOV AL, '$'
    MOV duracionStr[5], AL
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
;--------------------------------------------------------------

LimpiarTablero MACRO
    LOCAL Recorrido, Reemplazo

    MOV SI, 0

Recorrido:
    MOV DL, tablero[SI] 
    CMP DL, 120
    JE Reemplazo
    JNE Siguiente

Reemplazo:
    MOV tablero[SI], 32 

Siguiente:
    INC SI 
    CMP SI, 64 
    JB Recorrido 
ENDM
;------------------------------------------------------------- movimientos posibles

movimientosPosibles MACRO
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49          ; convierte la fila a numero
    SUB BL, 65          ; ingresa mayusculas
    MOV DH, BL          ; almacena la columna en DH
    MOV BH, 8
    MUL BH

    ADD AL, BL         
    MOV DL, AL         ; guarda el valor de la casilla, rowmajor 
    MOV SI, AX         ; mueve la posicion al registro SI

    MOV CH, 84
    CMP tablero[SI], CH     ; Torre ASCCI T
    JE _Torre

    MOV CH, 67
    CMP tablero[SI], CH     ; Caballo ASCCI C
    JE _Caballo

    MOV CH, 65
    CMP tablero[SI], CH     ; Alfil ASCCI A
    JE _Alfil

    MOV CH, 82
    CMP tablero[SI], CH     ; Rey ASCCI R
    JE _Rey

    MOV CH, 42
    CMP tablero[SI], CH     ; Reina ASCCI *          
    JE _Reina

    MOV CH, 80
    CMP tablero[SI], CH     ; Peon ASCCI P
    JE _Peon

_Fin:
    JMP printTablero

_Torre:
    posibleMovTorre
    JMP _FinMovimientos

_Caballo:
    posibleMovCaballo
    JMP _FinMovimientos

_Alfil:
    posibleMovAlfil
    JMP _FinMovimientos

_Rey:
    posibleMovRey
    JMP _FinMovimientos

_Reina:
    posibleMovReina
    JMP _FinMovimientos

_Peon:
    posibleMovPeon
    JMP _FinMovimientos

_FinMovimientos:

ENDM


posibleMovTorre MACRO

ENDM


posibleMovCaballo MACRO

ENDM

posibleMovAlfil MACRO
    ; Diagonalmente hacia arriba a la derecha
    moverDerechaArriba:
    MOV AL, DL
    MOV BL, DH
    SUB AL, 7           ; resta 7 a la fila
    ADD BL, 1           ; suma 1 a la columna
    CMP BL, 7           ; compara si la columna es mayor a 7
    JG moverIzquierdaArriba
    MOV SI, AX
    CMP tablero[SI], 32
    JE _moverDAbajo
    JMP _continue

    ; mover diagonal hacia arriba a la izquierda
    moverIzquierdaArriba:
    MOV AL, DL
    MOV BL, DH
    SUB AL, 9           ; resta 9 a la fila
    SUB BL, 1           ; resta 1 a la columna
    CMP BL, 0           ; compara si la columna es menor a 0
    JL moverDerechaAbajo
    MOV SI, AX
    CMP tablero[SI], 32
    JE _moverIArriba
    JMP _continue

    ; mover diagonal hacia abajo a la derecha
    moverDerechaAbajo:
    MOV AL, DL
    MOV BL, DH
    ADD AL, 9           ; suma 9 a la fila
    ADD BL, 1           ; suma 1 a la columna
    CMP BL, 7           ; compara si la columna es mayor a 7
    JG moverIzquierdaAbajo
    MOV SI, AX
    CMP tablero[SI], 32
    JE _moverDAbajo
    JMP _continue

    ; mover diagonal hacia abajo a la izquierda
    moverIzquierdaAbajo:
    MOV AL, DL
    MOV BL, DH
    ADD AL, 7           ; suma 7 a la fila
    SUB BL, 1           ; resta 1 a la columna
    CMP BL, 0           ; compara si la columna es menor a 0
    JL moverDerechaAbajo
    MOV SI, AX
    CMP tablero[SI], 32
    JE _moverIAbajo
    JMP _continue

_moverDArriba:
    MOV tablero[SI], 120    ; coloca una x en la casilla
    JMP moverDerechaArriba

_moverDAbajo:
    MOV tablero[SI], 120    ; coloca una x en la casilla
    JMP moverIzquierdaArriba

_moverIAbajo:
    MOV tablero[SI], 120    ; coloca una x en la casilla
    JMP moverDerechaAbajo

_moverIArriba:
    MOV tablero[SI], 120    ; coloca una x en la casilla
    JMP moverIzquierdaAbajo

_continue:

ENDM 


posibleMovRey MACRO 
    
ENDM

posibleMovReina MACRO

ENDM

posibleMovPeon MACRO    
    SUB AL, 16                  ; mueve el peon hacia arriba
    MOV SI, AX
    CMP tablero[SI], 32         ; compara si la casilla esta vacia
    JE _moverPeonBlanco

    MOV AL, DL 
    SUB AL, 8 
    MOV SI, AX
    CMP tablero[SI], 32
    JE _moverPeonBlanco

_moverPeonBlanco:
    MOV tablero[SI], 120    ; coloca una x en la casilla
    MOV AL, DL              
    SUB AL, 8
    MOV SI, AX
    MOV tablero[SI], 120    ; coloca una x en la casilla

ENDM


;-------------------------------------------------------------- mover pieza
MoverPieza MACRO 
    ; Calcular la posición original y la nueva en el tablero
    MOV AL, row
    MOV BL, col
    SUB AL, 49
    SUB BL, 65  
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV DL, AL
    MOV SI, AX

    CMP CH, 80
    JE _MoverPeon

    CMP CH, 84
    JE _MoverTorre

    CMP CH, 67
    JE _MoverCaballo

    CMP CH, 65
    JE _MoverAlfil

    CMP CH, 82
    JE _MoverRey

    CMP CH, 42
    JE _MoverReina

_MoverPeon:
    MOV tablero[SI], 80
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32


_MoverTorre:
    MOV tablero[SI], 84
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32


_MoverCaballo:
    MOV tablero[SI], 67
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32


_MoverAlfil:
    MOV tablero[SI], 65
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32


_MoverRey:  
    MOV tablero[SI], 82
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32


_MoverReina:    
    MOV tablero[SI], 42
    MOV AL, p_row
    MOV BL, p_col
    SUB AL, 49
    SUB BL, 65
    MOV BH, 8
    MUL BH
    ADD AL, BL
    MOV SI, AX
    MOV tablero[SI], 32

ENDM

;------------------------------------------------------------- mov aleatorios



;-------------------------------------------------------------
CrearArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinCrearArchivo
    MOV BL,0

    ; Crear el archivo
    MOV AH, 3Ch
    MOV CX, 00h
    LEA DX, nombreArchivo
    INT 21h

    ; Verificar si se creó el archivo
    MOV handler, AX
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCrearArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorCrearArchivo
        getOp op

    FinCrearArchivo:

ENDM

AbrirArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinAbrirArchivo
    MOV BL,0

    ; Abrir el archivo
    MOV AH, 3Dh
    MOV AL, 00h
    LEA DX, nombreArchivo
    INT 21h

    ; Verificar si se abrió el archivo
    MOV handler, AX
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinAbrirArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorAbrirArchivo
        getOp op

    FinAbrirArchivo:
ENDM

CerrarArchivo MACRO handler
    LOCAL ManejarError, FinCerrarArchivo


    ; Cerrar el archivo
    MOV AH, 3Eh
    MOV BX, handler
    INT 21h

    ; Verificar si se cerró el archivo
    MOV BL, 0
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCerrarArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorCerrarArchivo
        getOp op

    FinCerrarArchivo:
ENDM

LeerArchivo MACRO buffer, handler
    LOCAL ManejarError, FinLeerArchivo

    ; Leer el archivo
    MOV AH, 3Fh
    MOV BX, handler
    MOV CX, 100
    LEA DX, buffer
    INT 21h

    ; Verificar si se leyó el archivo
    MOV BL, 0
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinLeerArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorLeerArchivo
        getOps op

    FinLeerArchivo:
ENDM

EscribirArchivo MACRO cadena, handler
    LOCAL ManejarError, FinEscribirArchivo

    ; Escribir en el archivo
    MOV AH, 40h
    MOV BX, handler
    MOV CX, 70             ; tamanio de la cadena
    LEA DX, cadena
    INT 21h

    ; Verificar si se escribió en el archivo
    MOV BL, 1
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinEscribirArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorEscribirArchivo
        getOp  op

    FinEscribirArchivo:
ENDM

EscribirArchivo2 MACRO cadena, handler
    LOCAL ManejarError, FinEscribirArchivo

    ; Escribir en el archivo
    MOV AH, 40h
    MOV BX, handler
    MOV CX, 718             ; tamanio de la cadena
    LEA DX, cadena
    INT 21h

    ; Verificar si se escribió en el archivo
    MOV BL, 1
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinEscribirArchivo

    ManejarError:
        printCadena saltoLinea
        printCadena ErrorEscribirArchivo
        getOp  op

    FinEscribirArchivo:
ENDM

;------------------------------------------------------------- puntajes

puntajeJuego MACRO 
    LOCAL imprimirPuntaje

    imprimirPuntaje:
        printCadena saltoLinea
        printcadena encabezadoPuntaje
        AbrirArchivo3 
        printCadena saltoLinea
        printCadena contTxt

ENDM

;-------------------------------------------------------------
EscribirArchivo4 MACRO params 
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, handlerArchivo2  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, lengthof params  ; Número de bytes a escribir
    dec cx       ; Excluir el carácter de fin de cadena
    int 21h      ; Llamar a DOS
ENDM


EscribirArchivo5 MACRO params 
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, handlerArchivo  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, lengthof params  ; Número de bytes a escribir
    dec cx       ; Excluir el carácter de fin de cadena
    int 21h      ; Llamar a DOS
ENDM

EscribirArchivo6 MACRO params 
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, handlerArchivo  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, si  ; Número de bytes a escribir
    dec cx       ; Excluir el carácter de fin de cadena
    int 21h      ; Llamar a DOS
ENDM

EscribirArchivo7 MACRO params 
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, handlerArchivo2  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, si  ; Número de bytes a escribir
    dec cx       ; Excluir el carácter de fin de cadena
    int 21h      ; Llamar a DOS
ENDM

ImpFechaHTML MACRO salidaSTR
    ; Obtener la fecha actual
    mov ah, 2Ah                 ; Servicio para obtener la fecha actual
    int 21h                     ; Llamar a la interrupción DOS

    xor ax, ax
    mov bl, 0ah

    mov al, dl
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR], al         ; Guardar decena día
    mov [salidaSTR + 1], ah     ; Guardar unidad día
    mov [salidaSTR + 2], 47

    xor ax, ax

    mov al, dh
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 3], al     ; Guardar decena mes
    mov [salidaSTR + 4], ah     ; Guardar unidad mes
    mov [salidaSTR + 5], 47

    mov ax, cx 
    mov dx, 0h
    div bx
    add dl, 30h
    mov [salidaSTR + 9], dl     ; Guardar unidades año
    
    div bl
    add ah, 30h
    mov [salidaSTR + 8], ah     ; Guardar decenas año
    xor ah,ah

    div bl
    add ah, 30h
    mov [salidaSTR + 7], ah     ; Guardar centenas año
    xor ah,ah

    div bl
    add ah, 30h
    mov [salidaSTR + 6], ah     ; Guardar millares año
    xor ah,ah

    mov [salidaSTR + 10], 32

    mov ah, 2Ch       ; Servicio para obtener la hora actual
    int 21h           ; Llamar a la interrupción DOS

    mov bl, 0ah
    xor ax, ax
    mov al, ch        ; Hora actual
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 11], al ; Guardar hora
    mov [salidaSTR + 12], ah

    mov [salidaSTR + 13], 58 ; Caracter ':'

    xor ax, ax
    mov al, cl        ; Minutos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 14], al ; Guardar minutos
    mov [salidaSTR + 15], ah 

    mov [salidaSTR + 16], 58 ; Caracter ':'

    xor ax, ax
    mov al, dh        ; Segundos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 17], al ; Guardar segundos
    mov [salidaSTR + 18], ah
    ;mov [segundos], dh ; Guardar minutos



    EscribirArchivo4 salidaSTR
ENDM

AbrirArchivo3 MACRO 
LOCAL file_not_found, read_file , fin
    mov ah, 3Dh  ; Función 3Dh: Abrir archivo existente
    mov al, 0    ; Modo de acceso: lectura
    lea dx, nombreArchivo  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    jc file_not_found  ; Saltar si el archivo no se encuentra

    ; El archivo existe, leer su contenido
    mov handlerArchivo, ax  ; Guardar manejador de archivo
    jmp read_file

file_not_found:
    ; Crear el archivo si no existe
    mov ah, 3Ch  ; Función 3Ch: Crear archivo
    xor cx, cx   ; Atributos de archivo: normal
    lea dx, nombreArchivo  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    mov handlerArchivo, ax  ; Guardar manejador de archivo
    JMP fin

read_file:
    ; Leer el contenido del archivo en el buffer
    mov ah, 3Fh  ; Función 3Fh: Leer de archivo
    mov bx, handlerArchivo  ; Manejador de archivo
    lea dx, contTxt       ; Buffer para leer el contenido
    mov cx, sizeof contTxt   ; Tamaño del buffer
    int 21h      ; Llamar a DOS
    mov bytesRead, ax  ; Guardar el número de bytes leídos

fin:

ENDM

AbrirArchivo4 MACRO 
    mov ah, 3Ch  ; Función 3Ch: Crear archivo
    xor cx, cx   ; Atributos de archivo: normal
    lea dx, nombreArchivo  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    mov handlerArchivo, ax  ; Guardar manejador de archivo
ENDM

;-------------------------------------------------------------