.8086
.model small
.stack 100h
.data
    gfx_x_to_draw dw 0
    gfx_y_to_draw dw 0
    gfx_starting_x dw 0
    gfx_starting_y dw 0
    gfx_sprite_width dw 0
    gfx_sprite_height dw 0
    gfx_sprite_offset_x dw 0
    gfx_sprite_offset_y dw 0

.code
    public gfx_init
    public gfx_clear_screen
    public gfx_draw_pixel
    public gfx_draw_sprite

    ;Funcion que inicializa los graficos
    gfx_init proc
        mov ax, 13h  
        int 10h

        mov ax,0A000h
        mov es,ax

        ret
    gfx_init endp

    ;Funcion que limpia la pantalla
    ;Rellena todo el segmento extra con pixeles de color negro.
    gfx_clear_screen proc
        push cx
        push dx
        push di

        mov cx, 64000
        mov di, 0
        mov dl, 0
        _gfx_cls_loop:
            mov es:[di],dl
            inc di
            loop _gfx_cls_loop

        pop di
        pop dx
        pop cx

        ret
    gfx_clear_screen endp

    ;Funcion que dibuja un pixel en pantalla
    ;CX: Posicion en X del pixel
    ;DX: Posicion en Y del pixel
    ;AL: Color del pixel
    gfx_draw_pixel proc
        push ax
        push cx
        push dx
        push di

        push ax
        mov ax,dx ; Y coord to AX
        mov dx,320

        mul dx ; multiply AX by 320
        add ax,cx ; add X coord
        ; (Now cursor position is in AX, lets draw the pixel there)
        mov di,ax
        pop ax

        mov es:[di],al ; and we have the pixel drawn

        pop di
        pop dx
        pop cx
        pop ax
        ret
    gfx_draw_pixel endp 

    ;Funcion que dibuja un sprite en pantalla
    ;bx: OFFSET del sprite a dibujar
    ;cx: Eje X
    ;dx: Eje Y
    gfx_draw_sprite proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ;Datos del sprite
        mov ax, word ptr[bx] ;Ancho del sprite
        mov gfx_sprite_width, ax
        add bx, 2
        mov ax, word ptr[bx] ;Alto del sprite
        mov gfx_sprite_height, ax
        add bx, 2
        mov ax, word ptr[bx] ;OFFSET X del sprite
        mov gfx_sprite_offset_x, ax
        add bx, 2
        mov ax, word ptr[bx] ;OFFSET Y del sprite
        mov gfx_sprite_offset_y, ax
        add bx, 2

        ;Offsetea el sprite
        sub cx, gfx_sprite_offset_x
        sub dx, gfx_sprite_offset_y

        mov gfx_x_to_draw, cx
        mov gfx_y_to_draw, dx
        mov gfx_starting_x, cx
        mov gfx_starting_y, dx

        _dibujar_fila:
            _dibujar_pixel:
                mov cx, gfx_x_to_draw ;Eje X
                mov dx, gfx_y_to_draw ;Eje Y

                mov al, byte ptr[bx]  ;Color

                ;Si usamos el 0 como transparencia:
                ;Saltea el pixel si el color es 0
                cmp al, 0
                je _proximo_pixel

                ;Si se sale de la pantalla en X
                cmp cx, 319
                ja _proximo_pixel

                ;En Y
                cmp dx, 199
                ja _proximo_pixel

                call gfx_draw_pixel
                
                _proximo_pixel:
                    inc bx ;Proximo pixel en memoria
                    inc gfx_x_to_draw
                    
                    ;Calcula si ya llego al limite del sprite
                    mov ax, gfx_x_to_draw
                    sub ax, gfx_starting_x
                    mov si, gfx_sprite_width
                    cmp ax, si ;Si no es igual sigue con el proximo pixel
                    jne _dibujar_pixel
            mov si, gfx_starting_x
            mov gfx_x_to_draw, si;Resetea X
            inc gfx_y_to_draw ;Proxima fila
            
            ;Calcula si ya llego al limite del sprite (y)
            mov ax, gfx_y_to_draw
            sub ax, gfx_starting_y
            mov si, gfx_sprite_height
            cmp ax, si;Si no es igual, proxima fila
            jne _dibujar_fila
        _fin_dibujar_sprite:

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    gfx_draw_sprite endp

    public gfx_draw_square
    gfx_draw_square proc
        push bp
        mov bp, sp
        ;[bp+12]: X inicial
        ;[bp+10]: Y inicial
        ;[bp+8]: X final
        ;[bp+6]: Y final
        ;[bp+4]: Color

        mov ax, ss:[bp+4]
        mov cx, ss:[bp+12]
        mov dx, ss:[bp+10]
        gfx_draw_square_dibujarCuadrado:
            gfx_draw_square_dibujarFila:
                cmp cx, ss:[bp+8]
                je gfx_draw_square_ProximaFila
                cmp cx, 319
                ja gfx_draw_square_proximoPixel
                ;cx esta, dx esta. al tambien.
                call gfx_draw_pixel
                gfx_draw_square_proximoPixel:
                inc cx
                jmp gfx_draw_square_dibujarFila
            
            gfx_draw_square_ProximaFila:
                inc dx
                mov cx, ss:[bp+12]
                cmp dx, ss:[bp+6]
                je gfx_draw_square_end
                jmp gfx_draw_square_dibujarCuadrado
        
        gfx_draw_square_end:

        pop bp
        ret 10
    gfx_draw_square endp
end