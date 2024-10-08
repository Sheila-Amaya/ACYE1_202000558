
;----------------------------------------------
clearConsole MACRO 
    MOV AX, 03H
    INT 10H
ENDM


getOp MACRO registrOp
    MOV AH, 01h
    INT 21h
    MOV registrOp, AL
ENDM

;---------------------------------------------- imprimir en pantalla color
PrintColor MACRO rPrint, color
    MOV AH, 09h     
    MOV AL, ' '     
    MOV BH, 0       
    MOV BL, color   
    MOV CX, lengthof rPrint       
    INT 10h         ; Interrupción de video

    MOV AH, 09h     
    LEA DX, rPrint ; Carga la dirección de la cadena en DX
    INT 21h         
ENDM

printCadena MACRO registrop 
    MOV AH, 09h 
    LEA DX, registrop
    INT 21h
ENDM


;---------------------------------------------- guardar player
obtenerCadena MACRO regBuffer, maxLength
    LOCAL leer_caracter_bucle, fin_lectura
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

;---------------------------------------------- 
ImpFechaDB MACRO salidaSTR
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
    mov [salidaSTR + 01h], ah     ; Guardar unidad día
    mov [salidaSTR + 02h], 2Fh

    xor ax, ax

    mov al, dh
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 03h], al     ; Guardar decena mes
    mov [salidaSTR + 04h], ah     ; Guardar unidad mes
    mov [salidaSTR + 05h], 2Fh

    mov ax, cx 
    mov dx, 0h
    div bx
    add dl, 30h
    mov [salidaSTR + 07h], dl     ; Guardar unidades año
    
    div bl
    add ah, 30h
    mov [salidaSTR + 06h], ah     ; Guardar decenas año
    xor ah,ah

    mov [salidaSTR + 08h], "|"

    mov ah, 2Ch       ; Servicio para obtener la hora actual
    int 21h           ; Llamar a la interrupción DOS

    mov bl, 0ah
    xor ax, ax
    mov al, ch        ; Hora actual
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 09h], al ; Guardar hora
    mov [salidaSTR + 0Ah], ah

    mov [salidaSTR + 0Bh], 3Ah ; Caracter ':'

    xor ax, ax
    mov al, cl        ; Minutos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 0Ch], al ; Guardar minutos
    mov [salidaSTR + 0Dh], ah 

    mov [salidaSTR + 0Eh], 3Ah ; Caracter ':'

    xor ax, ax
    mov al, dh        ; Segundos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 0Fh], al ; Guardar segundos
    mov [salidaSTR + 010h], ah
    mov [segundos], dh ; Guardar minutos

    EscribirArchivo salidaSTR
ENDM

CerrarArchivo MACRO
    mov ah, 3Eh  ; Función 3Eh: Cerrar archivo
    mov bx, filehandle  ; Manejador de archivo
    int 21h      ; Llamar a DOS
ENDM

EscribirArchivo MACRO params
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, filehandle  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, lengthof params  ; Número de bytes a escribir
    dec cx       ; Excluir el carácter de fin de cadena
    int 21h      ; Llamar a DOS
ENDM

Addtextoanterior MACRO
LOCAL inicio, fin
    xor si, si
    xor bx, bx

    mov si, 00h
    mov bl, "$"

inicio:
    cmp si, 400h
    je fin
    mov bh, dataTXT[si]
    cmp bh, bl
    je fin
    inc si
    jmp inicio

fin:
    EscribirArchivo2 dataTXT, si
ENDM

EscribirArchivo2 MACRO params, params2
    mov ah, 40h  ; Función 40h: Escribir en archivo
    mov bx, filehandle  ; Manejador de archivo
    lea dx, params     ; Mensaje a escribir
    mov cx, params2 ; Número de bytes a escribir
    int 21h      ; Llamar a DOS
ENDM

AbrirArchivo3 MACRO 
    mov ah, 3Ch  ; Función 3Ch: Crear archivo
    xor cx, cx   ; Atributos de archivo: normal
    lea dx, nombreDB  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    mov filehandle, ax  ; Guardar manejador de archivo
ENDM

AbrirArchivo MACRO 
LOCAL file_not_found, read_file
    mov ah, 3Dh  ; Función 3Dh: Abrir archivo existente
    mov al, 0    ; Modo de acceso: lectura
    lea dx, nombreDB  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    jc file_not_found  ; Saltar si el archivo no se encuentra

    ; El archivo existe, leer su contenido
    mov filehandle, ax  ; Guardar manejador de archivo
    jmp read_file

file_not_found:
    ; Crear el archivo si no existe
    mov ah, 3Ch  ; Función 3Ch: Crear archivo
    xor cx, cx   ; Atributos de archivo: normal
    lea dx, nombreDB  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    mov filehandle, ax  ; Guardar manejador de archivo

read_file:
    ; Leer el contenido del archivo en el buffer
    mov ah, 3Fh  ; Función 3Fh: Leer de archivo
    mov bx, filehandle  ; Manejador de archivo
    lea dx, dataTXT      ; Buffer para leer el contenido
    mov cx, sizeof dataTXT  ; Tamaño del buffer
    int 21h      ; Llamar a DOS
    mov bytesRead, ax  ; Guardar el número de bytes leídos
ENDM

AbrirArchivo2 MACRO 
LOCAL file_not_found, read_file, fin
    mov ah, 3Dh  ; Función 3Dh: Abrir archivo existente
    mov al, 0    ; Modo de acceso: lectura
    lea dx, nombreDB  ; Nombre del archivo
    int 21h      ; Llamar a DOS
    jc file_not_found  ; Saltar si el archivo no se encuentra

    ; El archivo existe, leer su contenido
    mov filehandle, ax  ; Guardar manejador de archivo
    jmp read_file

file_not_found:
    PrintColor R_5, 0Ch
    jmp fin

read_file:
    ; Leer el contenido del archivo en el buffer
    mov ah, 3Fh  ; Función 3Fh: Leer de archivo
    mov bx, filehandle  ; Manejador de archivo
    lea dx, dataTXT      ; Buffer para leer el contenido
    mov cx, sizeof dataTXT  ; Tamaño del buffer
    int 21h      ; Llamar a DOS
    mov bytesRead, ax  ; Guardar el número de bytes leídos
fin:
ENDM