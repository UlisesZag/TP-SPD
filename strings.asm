.8086
.model small
.stack 100h
.data

.code
    ;===================== WORD2ASCII =====================
    ; ARGUMENTOS:
    ; ax: variable numerica word
    ; si: OFFSET del string a rellenar con el numero
    ;   el formato del string deberia ser de la forma:
    ;     str_numero db 6 dup (24h), 24h
    public strings_word2ascii
    strings_word2ascii proc
        push ax
        push bx
        push cx
        push dx 
        ;Primero vacia el string
        mov cx,5
        mov bx,0
        _word2ascii_borrarstring:
            mov byte ptr[si+bx], 24h
            inc bx
            loop _word2ascii_borrarstring

        mov cx, 5
            
        ;divide AX por 10
        _word2ascii_word_to_string:
            mov bx, 10  ;Esto porque necesito un word (BX) para dividir otro word (AX)
            mov dx, 0 ;Resetea DX
            div bx ;Divide AX por BX. El resto queda en DX
            add dx, 30h ;Le suma 30 a DX, para que coincida con el codigo de caracter

            mov bx, cx; Pasa a BX el valor de CX (va de 5 a 0)
            mov byte ptr[si+bx-1], dl ;Pasa la parte baja de DL como caracter

            cmp ax, 0 ;Si AX es 0 se acabo el numero.
            je _word2ascii_fin_word_to_string

            loop _word2ascii_word_to_string
        _word2ascii_fin_word_to_string:


        ;Mueve el string para la izquierda
        _word2ascii_move_string:
            cmp byte ptr[si], 24h
            jne _word2ascii_fin_move_string

            mov bx, 0
            mov cx, 5
            ;Va moviendo los caracteres hacia la izquierda.
            _word2ascii_mover_caracteres:
                mov al, [si+bx+1]
                mov [si+bx], al
                inc bx
                loop _word2ascii_mover_caracteres

            jmp _word2ascii_move_string
        _word2ascii_fin_move_string:

        pop dx
        pop cx
        pop bx
        pop ax

        ret
    strings_word2ascii endp
end