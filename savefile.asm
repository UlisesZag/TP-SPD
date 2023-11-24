.8086
.model small
.stack 100h
.data
    savefile_ruta db "savefile.dat",0
    savefile_handle dw 0

    empty_buffer db 0,0
    file_buffer db 0,0
.code
    
    ;Carga el puntaje alto
    ;si: OFFSET de la variable a cargar
    public savefile_load
    savefile_load proc
        push ax
        push bx
        push cx
        push dx

        ;Intenta abrir el archivo
        mov ah, 3Dh
        mov al, 1000000b
        mov dx, OFFSET savefile_ruta
        int 21h
        jc savefile_load_LoadFailed ;Si falla (no existe) intenta crearlo.

        mov savefile_handle, ax

        ;Carga 2 bytes en el archivo
        mov ah, 3Fh
        mov bx, savefile_handle
        mov cx, 2
        mov dx, OFFSET file_buffer
        int 21h

        ;Pone el numero en ax (big endian)
        mov ah, file_buffer[0]
        mov al, file_buffer[1]
        mov si, ax

        jmp savefile_load_close

        savefile_load_LoadFailed:
        ;Si no existe el archivo lo crea
        mov ah, 3Ch
        mov cx, 00h
        mov dx, OFFSET savefile_ruta
        int 21h
        jc savefile_load_end ;Si no puede ni crearlo finaliza la funcion 

        mov savefile_handle, ax ;Mueve el handle a savefile_handle

        ;Lo llena con un word 0
        mov ah, 40h
        mov bx, savefile_handle
        mov cx, 2
        mov dx, OFFSET empty_buffer
        int 21h 

        ;si = 0
        mov si, 0

        jmp savefile_load_close

        savefile_load_close:
        mov ah, 3Eh ;Cierra el archivo
        mov bx, savefile_handle
        int 21h

        savefile_load_end:
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    savefile_load endp

    ;Guarda el puntaje alto al archivo guardado
    ;si: Valor del puntaje alto
    ;Aca sacrificamos la limpieza con pushes porque surgio una cosa rarisima que se freezeaba el programa cuando el IP llegaba a 0E60h  
    public savefile_save
    savefile_save proc
        push ax
        push bx
        push cx
        push dx

        ;Intenta abrir el archivo
        mov ah, 3Dh
        mov al, 1000001b
        mov dx, OFFSET savefile_ruta
        int 21h
        jc savefile_save_OpenFailed ;Si falla (no existe) intenta crearlo.

        mov savefile_handle, ax

        ;Pone el numero en ax (big endian)
        mov ax, si
        mov file_buffer[0], ah
        mov file_buffer[1], al

        ;Guarda 2 bytes en el archivo
        mov ah, 40h
        mov bx, savefile_handle
        mov cx, 2
        mov dx, OFFSET file_buffer
        int 21h

        jmp savefile_save_close

        savefile_save_OpenFailed:
        ;Si no existe el archivo lo crea
        mov ah, 3Ch
        mov cx, 00h
        mov dx, OFFSET savefile_ruta
        int 21h
        jc savefile_save_end ;Si no puede ni crearlo finaliza la funcion 

        mov savefile_handle, ax ;Mueve el handle a savefile_handle

        ;Pone el numero en ax (big endian)
        mov ax, si
        mov file_buffer[0], ah
        mov file_buffer[1], al

        ;Guarda 2 bytes en el archivo
        mov ah, 40h
        mov bx, savefile_handle
        mov cx, 2
        mov dx, OFFSET file_buffer
        int 21h

        jmp savefile_save_close

        savefile_save_close:
        mov ah, 3Eh ;Cierra el archivo
        mov bx, savefile_handle
        int 21h

        savefile_save_end:

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    savefile_save endp
end