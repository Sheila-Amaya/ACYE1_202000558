
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

pauseUntilEnter macro
    LOCAL until_press_enter
    PUSH AX

    until_press_enter:
        MOV AH,08h
        INT 21h
        CMP AL, 000DH
        JNE until_press_enter
    POP AX
endm

obtenerCadena MACRO inputString, maxLength
    LOCAL obtener_loop, end_obtener

    LEA DI, inputString
    MOV CX, maxLength

    obtener_loop:
        MOV AH, 1
        INT 21h
        CMP AL, 13 ; Carácter de retorno de carro
        JE end_obtener
        STOSB
        LOOP obtener_loop

    end_obtener:
        MOV AL, 0
        STOSB
ENDM

compareStrings MACRO inputString, compareString, label
    LOCAL compare_loop, end_compare

    LEA SI, inputString
    LEA DI, compareString

    compare_loop:
        MOV AL, [SI]
        MOV BL, [DI]
        CMP AL, BL
        JNE end_compare
        INC SI
        INC DI
        CMP AL, 0
        JNE compare_loop

    JMP label

    end_compare:
ENDM

limpiarCadena MACRO inputString
    LOCAL limpiar_loop, end_limpiar

    LEA SI, inputString

    limpiar_loop:
        MOV AL, [SI]
        CMP AL, 0
        JE end_limpiar
        MOV [SI], 0
        INC SI
        JMP limpiar_loop

    end_limpiar:
ENDM

mostrarInfo MACRO
        printCadena saltoLinea
        PrintColor info0, 9
        PrintColor info1, 9
        PrintColor info2, 9
        PrintColor info3, 9
        PrintColor info4, 9
        PrintColor info5, 9
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
    mov [salidaSTR + 7], dl     ; Guardar unidades año
    
    div bl
    add ah, 30h
    mov [salidaSTR + 6], ah     ; Guardar decenas año
    xor ah,ah

    mov [salidaSTR + 8], "|"

    mov ah, 2Ch       ; Servicio para obtener la hora actual
    int 21h           ; Llamar a la interrupción DOS

    mov bl, 0ah
    xor ax, ax
    mov al, ch        ; Hora actual
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 9], al ; Guardar hora
    mov [salidaSTR + 10], ah

    mov [salidaSTR + 11], 58 ; Caracter ':'

    xor ax, ax
    mov al, cl        ; Minutos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 12], al ; Guardar minutos
    mov [salidaSTR + 13], ah 

    mov [salidaSTR + 14], 58 ; Caracter ':'

    xor ax, ax
    mov al, dh        ; Segundos actuales
    div bl
    add al, 30h
    add ah, 30h
    mov [salidaSTR + 15], al ; Guardar segundos
    mov [salidaSTR + 16], ah
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
    ImprimirCadenasColor REPORTE5, colorAmarilloTexto
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