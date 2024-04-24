
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