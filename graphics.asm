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

    ;VARIABLES RECTANGULOS GFX

    ;ahora con solo cambiar el offset podemos decidir en que coordenada
    ;iniciara el rectangulo y que tamaño tendra con solo modificar 
    ;el largo y el alto, tambien va a ser mas facil convertirlo en una funcion

    ;define coordenadas inicio rect y corrige el resto
    rectOffsetX dw 0                         
    rectOffsetY dw 0                           
                                                
    ;define tamaño rect                         
    largo dw 0                              
    alto dw 0

    ;coordenadas start (+offsetX, +offsetY)
    posX dw 0
    posY dw 0
    ;coordenadas end (las del largo+offsetX y alto+offsetY)
    posX2 dw 0
    posY2 dw 0

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

    ;Funcion que espera a que la pantalla dibuje un nuevo frame
    ;Para reemplazar el wait_next_tick por tiempo del sistema
    public wait_new_vr
    wait_new_vr proc 
        push ax
        push dx

        waitForNewVR:
        mov dx, 3dah

        ;Wait for bit 3 to be zero (not in VR).
        ;We want to detect a 0->1 transition.
        _waitForEnd:
        in al, dx
        test al, 08h
        jnz _waitForEnd

        ;Wait for bit 3 to be one (in VR)
        _waitForNew:
        in al, dx
        test al, 08h
        jz _waitForNew

        pop dx
        pop ax

        ret

    wait_new_vr endp

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
                cmp dx, 199
                ja gfx_draw_square_end
                jmp gfx_draw_square_dibujarCuadrado
        
        gfx_draw_square_end:

        pop bp
        ret 10
    gfx_draw_square endp

    ;DIBUJA RECTANGULO VACIO EN COORDENADAS INDICADAS
    ;posicion de inicio en base rectOffset
    ;AL color
    ;SI largo, DI alto
    ;CX pos X
    ;DX pos y
    public gfx_empty_rectangle
    gfx_empty_rectangle proc
        push ax
        push cx
        push dx
        push si
        push di

        mov posX, 0
        mov posY, 0
        mov posX2, 0
        mov posY2, 0

        mov largo, si
        mov alto, di
        mov rectOffsetX, cx
        mov rectOffsetY, dx

        ;especifica coordenadas a partir de offset(posicion) y dimensiones
        mov si, largo
        add posX2, si
        mov si, alto
        add posY2, si

        mov si, rectOffsetX
        mov di, rectOffsetY
        ;coreccion de posicion
        add largo, si
        add alto, di
        add posX, si
        add posY, di
        add posX2, si
        add posY2, di

        ;printa V
        mov cx, posX ;X pos inicio
        mov dx, posY ;Y pos inicio
        ; mov al, 15 ;color
        printaVLine:
        ; mov ah, 0ch
        ; int 10h
        call gfx_draw_pixel
        inc dx
        cmp dx, alto ;largo linea v
        ja endVLine
        jmp printaVLine  
        endVLine:      

        ;printa H
        mov cx, posX
        mov dx, posY
        ; mov al, 15
        printaHline:
        ; mov ah, 0ch
        ; int 10h
        call gfx_draw_pixel
        inc cx
        cmp cx, largo
        ja endHline
        jmp printaHline
        endHline:

        ;printa V2
        mov cx, posX2 ;X pos inicio
        mov dx, posY ;Y pos inicio
        ; mov al, 15 ;color
        printaV2Line:
        ; mov ah, 0ch
        ; int 10h
        call gfx_draw_pixel
        inc dx
        cmp dx, alto ;largo linea v
        ja endV2Line
        jmp printaV2Line  
        endV2Line:      

        ;printa H2
        mov cx, posX
        mov dx, posY2
        ; mov al, 15
        printaH2line:
        ; mov ah, 0ch
        ; int 10h
        call gfx_draw_pixel
        inc cx
        cmp cx, largo
        ja endH2line
        jmp printaH2line
        endH2line:

        pop di
        pop si
        pop dx
        pop cx
        pop ax
        ret
    gfx_empty_rectangle endp

    ;ESCRIBE STRING EN COORDENADAS INDICADAS
    ;DL column, DH row
    ;page number is 0 (bh)
    ;SI contains string offset
    public gfx_write_s
    gfx_write_s proc
        push ax
        push bx
        push dx
        push si

        xor bx, bx
        mov ah, 2
        int 10h

        mov ah, 9
        mov dx, si
        int 21h

        pop si
        pop dx
        pop bx
        pop ax
        ret
    gfx_write_s endp
end