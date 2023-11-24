.8086
.model small
.stack 100h
.data
    
    ;VARIABLES MENU

    titulo db "DOSu!",24h
    play db "Play",24h
    creditos db "Creditos",24h
    highScore db "HighScore",24h
    salir db "Salir",24h

    ;MODO DE JUEGO

    gameMode_text db "Seleccione modo de juego",24h
    mode1 db "facil",24h
    mode2 db "normal",24h
    mode3 db "dificil",24h
    mode0 db "volver",24h

    ;variable modelo que hay que se podria pasar por stack a la llamada del menu -> determina dificultad
    gameMode dw 0
    ;modos de juego:
    ;0 -> salir
    ;1 -> facil
    ;2 -> normal
    ;3 -> dificil

    ;CREDITOS

    credits db "Proyecto realizado por",24h
    name1 db "Ulises",24h
    name2 db "Nelyer",24h
    name3 db "Caro",24h
    name4 db "Paulo",24h
    name5 db "Chris",24h
    credits_exit db "click to exit",24h

    ;HIGH SCORE

    highScore_text db "Puntaje mas alto obtenido:",24h
    ;highScore db "0",24h --------------> REG 2 ASCII
    highScore_exit db "click to exit",24h

    ;VARIABLES MOUSE

    mouse_lmb_clicked db 0 ;Boton izquierdo
    mouse_lmb_hold db 0
    mouse_rmb_clicked db 0 ;Boton derecho
    mouse_rmb_hold db 0

    ;VARIABLES CLICKBOX

    ;definen area de hitbox personalizadas (no se si las voy a usar, puede ser que las reemplaze con un vector)
    ; xInicial dw 0
    ; xFinal dw 0 
    ; yInicial dw 0
    ; yFinal dw 0

    clickbox1_data dw 220,420,61,76,0
    clickbox2_data dw 220,420,85,100,0
    clickbox3_data dw 220,420,109,124,0
    clickBox4_data dw 220,420,133,148,0
    ;Xinicial, Xfinal, Yinicial, Yfinal, ClickStatus (lbm)

    ;clickBoxs del game_mode
    cb1_gm_data dw 64,214,90,110,0
    cb2_gm_data dw 242,392,90,110,0
    cb3_gm_data dw 422,572,90,110,0
    cb4_gm_data dw 242,392,155,175,0

    rhombo dw 0,0,0,0,0,0,0
    ;Xinicial, Yinicial, Xtamaño+Offset, Ytamaño+Offset, color, tamañoXoriginal, tamañoYoriginal

.code

    ;DISPLAYS MENU 
    ;DEVUELVE EN UNA VARIABLE ESPECIFICAMENTE LLAMADA "gameMode", DEVUELVE DETERMINADOS VALORES NUMERICOS
    ;SEGUN LA DIFICULTAD ELEGIDA POR EL USUARIO. SI SE DESEA PODER UTILZIAR CUALQUIER VARIABLE SE PUEDE PASAR
    ;POR STACK EL VALOR ANTES DEL LLAMADA Y LUEGO RECUPERARLO CON EL BP, ASI SE PODRIA UTILIZAR UNA VARIABLE CON CUALQUIER NOMBRE PERO
    ;SIEMPRE DE LA FORMA "variable DW 0".

    public menu_function
    menu_function proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ;MENU
        
        draw_menu:
        call gfx_draw_main_menu

        ;maneja clickboxs

        mov ax, 1 ;muestra mouse
        int 33h

        menu_loop:

        mov si, offset clickBox1_data ;BOTON JUGAR (NO IMPLEMENTADO)
        call custom_clickBox
        cmp word ptr [si+8], 1
        je play_game

        mov si, offset clickBox2_data ;BOTON CREDITOS (YA IMPLEMENTADO)
        call custom_clickBox
        cmp word ptr [si+8], 1
        je show_credits

        mov si, offset clickBox3_data ;BOTON HS (NO IMPLEMENTADO)
        call custom_clickBox
        je show_highScore
        cmp word ptr [si+8], 1
        je show_highScore

        mov si, offset clickBox4_data ;BOTON SALIR (YA IMPLEMENTADA)
        call custom_clickBox
        cmp word ptr [si+8], 1
        je exit_menu

        jmp menu_loop
        menu_loop_exit:

        ;PLAYGAME
        play_game:
        mov word ptr [si+8], 0
        call play_mode
        cmp gameMode, 0
        je draw_menu
        jmp exit_menu 

        ;CREDITS
        show_credits:
        mov word ptr [si+8], 0
        call credits_menu
        jmp draw_menu

        ;HS
        show_highScore:
        mov word ptr [si+8], 0
        call show_HS
        jmp draw_menu

        ; mov ah, 1
        ; int 21h

        exit_menu:
        mov ax, 2
        int 33h

        ; mov ah, 00h ;salir modo grafico
        ; mov al, 03h
        ; int 10h

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    menu_function endp

    ;DETECTA SI UN CLICK EN DETERMINADAS COORDENADAS
    ;MOV SI, OFFSET clickBox(N)_data
    custom_clickBox proc
        push ax
        push bx
        push cx
        push dx
        push si

        ;SI contiene el offset del clickBox_data

        ;cuando hagamos la int 33h se destruiran los registros mencionados abajo

        mov ax, 3 ;detecta status del mouse (posicion, clicks)
        int 33h
        ;usa AX, BX, CX, DX

        ;no se porque las coordenadas del mouse no son las mismas que las de pixeles
        ;NOTA: APARENTEMENTE LAS COORDENADAS DE CX EN INT 33H SE MULTIPLICAN POR DOS EN MODO GRAFICO -> MULTIPLICAR POR DOS COORDENAS EN X (SOLO INT 33H)

        ; xInicial    equ 220
        ; xFinal      equ 420
        ; yInicial   equ 133
        ; yFinal     equ 148

        ;verificar si el cursor está en el area
        cmp cx, [si]
        jb  end_clickBox_check ;si esta a la izquierda, termina
        cmp cx, [si+2]
        ja  end_clickBox_check ;si esta a la derecha, termina
        cmp dx, [si+4]
        jb  end_clickBox_check ;si esta arriba, termina
        cmp dx, [si+6]
        ja  end_clickBox_check ;si esta abajo, termina

        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je clickBox_click
        jmp clickBox_noClick ;esta parte la tengo que terminar y dependera del uso que le queramos dar a la clickBox

        clickBox_click:
        mov word ptr [si+8], 1
        jmp end_clickBox_check

        clickBox_noClick:

        end_clickBox_check:
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    custom_clickBox endp

    ;DIBUJA RECTANGULO VACIO EN COORDENADAS INDICADAS
    ;posicion de inicio en base rectOffset
    ;AL color
    ;SI largo, DI alto
    ;CX pos X
    ;DX pos y
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

    ;DIBUJA MENU PRINCIPAL
    gfx_draw_main_menu proc
        push ax
        ;push bx
        push cx
        push dx
        push si
        push di
        
        ;dibujar rectangulos
        mov al, 15
        mov cx, 110
        mov dx, 10
        mov si, 100
        mov di, 30
        call gfx_empty_rectangle

        mov al, 15
        mov cx, 110
        mov dx, 61
        mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        mov al, 15
        mov cx, 110
        mov dx, 85
        mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        mov al, 15
        mov cx, 110
        mov dx, 109
        mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        mov al, 15
        mov cx, 110
        mov dx, 133
        mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        ;dibuja string
        mov dl, 18
        mov dh, 2
        mov si, offset titulo
        call gfx_write_s

        mov dl, 18
        mov dh, 8
        mov si, offset play
        call gfx_write_s

        mov dl, 16
        mov dh, 11
        mov si, offset creditos
        call gfx_write_s
        
        mov dl, 16
        mov dh, 14
        mov si, offset highScore
        call gfx_write_s

        mov dl, 18
        mov dh, 17
        mov si, offset salir
        call gfx_write_s

        pop di
        pop si
        pop dx
        pop cx
        ;pop bx
        pop ax
        ret
    gfx_draw_main_menu endp

    ;MENU DE CREDITO
    credits_menu proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov ax, 2
        int 33h
        
        call mouse_control
        call gfx_clear_screen
    
        ;DIBUJA CREDITOS

        mov al, 15
        mov si, 280
        mov di, 180
        mov cx, 20
        mov dx, 10
        call gfx_empty_rectangle

        ;maximos 39 columns y 24 row (wtf)
        mov si, offset credits
        mov dl, 9
        mov dh, 5
        call gfx_write_s
        mov si, offset name1
        mov dl, 16
        mov dh, 8
        call gfx_write_s
        mov si, offset name2
        mov dl, 16
        mov dh, 10
        call gfx_write_s
        mov si, offset name3
        mov dl, 16
        mov dh, 12
        call gfx_write_s
        mov si, offset name4
        mov dl, 16
        mov dh, 14
        call gfx_write_s
        mov si, offset name5
        mov dl, 16
        mov dh, 16
        call gfx_write_s
        mov si, offset credits_exit
        mov dl, 13
        mov dh, 20
        call gfx_write_s

        credits_loop:   ;no se si sigue haciendo falta pero lo dejo ahi
        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je exit_credits_menu  

        inc frame_counter ; Esto para que funcione el frameskip (el frame_counter se resetea en la funcion game_restart)
        jmp credits_loop

        exit_credits_menu:

        call mouse_control

        ; mov ax, 0
        ; int 33h

        call gfx_clear_screen

        call gfx_draw_main_menu

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    credits_menu endp

    show_HS proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov ax, 2
        int 33h
        
        call mouse_control
        call gfx_clear_screen
    
        ;DIBUJA HS

        mov al, 15
        mov si, 280
        mov di, 180
        mov cx, 20
        mov dx, 10
        call gfx_empty_rectangle

        ;maximos 39 columns y 24 row (wtf)
        mov si, offset highScore_text
        mov dl, 7
        mov dh, 5
        call gfx_write_s

        ; mov si, offset highScore -------------> DESCOMENTAR CUANDO SE TENGA EL HS
        ; mov dl, 16
        ; mov dh, 11
        ; call gfx_write_s

        mov si, offset credits_exit
        mov dl, 13
        mov dh, 20
        call gfx_write_s

        HS_loop:   ;no se si sigue haciendo falta pero lo dejo ahi
        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je exit_HS_menu  
        jmp HS_loop

        exit_HS_menu:

        call mouse_control

        ; mov ax, 0
        ; int 33h

        call gfx_clear_screen

        call gfx_draw_main_menu       

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    show_HS endp

    play_mode proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov ax, 4
        mov cx, 320
        mov dx, 200
        int 33h
        
        call mouse_control
        
        call gfx_clear_screen
    
        ;DIBUJA GAMEMODE

        mov al, 15
        mov si, 280
        mov di, 180
        mov cx, 20
        mov dx, 10
        call gfx_empty_rectangle

        mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 32
        mov dx, 90
        call gfx_empty_rectangle

        mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 121
        mov dx, 90
        call gfx_empty_rectangle

        mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 211
        mov dx, 90
        call gfx_empty_rectangle

        mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 121
        mov dx, 155
        call gfx_empty_rectangle

        ;maximos 39 columns y 24 row (wtf)
        mov si, offset gameMode_text
        mov dl, 8
        mov dh, 5
        call gfx_write_s

        mov si, offset mode1
        mov dl, 6
        mov dh, 12
        call gfx_write_s

        mov si, offset mode2
        mov dl, 17
        mov dh, 12
        call gfx_write_s

        mov si, offset mode3
        mov dl, 28
        mov dh, 12
        call gfx_write_s

        mov si, offset mode0
        mov dl, 17
        mov dh, 20
        call gfx_write_s

        m_loop:

        mov si, offset cb1_gm_data
        call custom_clickBox
        cmp word ptr [si+8], 1
        je gamemode_1

        mov si, offset cb2_gm_data
        call custom_clickBox
        cmp word ptr [si+8], 1
        je gamemode_2

        mov si, offset cb3_gm_data
        call custom_clickBox
        cmp word ptr [si+8], 1
        je gamemode_3

        mov si, offset cb4_gm_data
        call custom_clickBox
        cmp word ptr [si+8], 1
        je gamemode_4

        jmp m_loop

        fin_m_loop:

        gamemode_1:
        mov word ptr [si+8], 0
        mov si, offset gameMode
        mov word ptr [si], 1
        jmp GM_loop

        gamemode_2:
        mov word ptr [si+8], 0
        mov si, offset gameMode
        mov word ptr [si], 2
        jmp GM_loop

        gamemode_3:
        mov word ptr [si+8], 0
        mov si, offset gameMode
        mov word ptr [si], 3
        jmp GM_loop

        gamemode_4:
        mov word ptr [si+8], 0
        mov si, offset gameMode
        mov word ptr [si], 0
        jmp GM_loop

        GM_loop:   ;no se si sigue haciendo falta pero lo dejo ahi
        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je exit_GM_menu  
        jmp GM_loop

        exit_GM_menu:

        call mouse_control

        mov ax, 0
        int 33h

        call gfx_clear_screen

        call gfx_draw_main_menu       

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    play_mode endp

    ;CONTROLA FLANCOS DE MOUSE (QUEDA ATRAPADO EN CICLO HASTA DEJAR DE HACER FALSO CONTACTO)
    mouse_control proc
        control_loop:

        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je control_loop
        cmp mouse_lmb_hold, 1
        je control_loop

        ret
    mouse_control endp

end





    ;Funcion que saca si el mouse colisiona con el cuadrado
    ;Si Carry = 0: Colisiona con el mouse
    ;Si Carry = 1: No colisiona con el mouse
    ; game_logic_cuadrado_colisiones proc
    ;     ;Aca la logica de las colisiones
    ;     ;Si colisiona sigue, si no tiene que saltar a game_logic_squares_next
    ;     mov ax, 3 ;Saca las posiciones del mouse (X en CX y Y en DX)
    ;     int 33h
    ;     mov ax, word ptr [si+2] ;X del cuadrado
    ;     mov bx, word ptr [si+4] ;Y del cuadrado

    ;     ;Les sumo un sesgo a todas las coordenadas (no puedo usar numeros negativos)
    ;     add ax, 320
    ;     add bx, 320

    ;     sub ax, cx ;Saca la diferencia
    ;     sub bx, dx ;Saca la diferencia

    ;     cmp ax, 312
    ;     jb game_logic_cuadrado_colisiones_NoColisiona
    ;     cmp ax, 328
    ;     ja game_logic_cuadrado_colisiones_NoColisiona
    ;     cmp bx, 312
    ;     jb game_logic_cuadrado_colisiones_NoColisiona
    ;     cmp bx, 328
    ;     ja game_logic_cuadrado_colisiones_NoColisiona

    ;     clc
    ;     ret

    ;     game_logic_cuadrado_colisiones_NoColisiona:
    ;     stc
    ;     ret

    ; game_logic_cuadrado_colisiones endp





        ; ;dibujar rectangulos
        
        ; mov al, 15
        ; mov cx, 110
        ; mov dx, 10
        ; mov si, 100
        ; mov di, 30
        ; call gfx_empty_rectangle

        ; mov al, 15
        ; mov cx, 110
        ; mov dx, 61
        ; mov si, 100
        ; mov di, 15
        ; call gfx_empty_rectangle

        ; mov al, 15
        ; mov cx, 110
        ; mov dx, 85
        ; mov si, 100
        ; mov di, 15
        ; call gfx_empty_rectangle

        ; mov al, 15
        ; mov cx, 110
        ; mov dx, 109
        ; mov si, 100
        ; mov di, 15
        ; call gfx_empty_rectangle

        ; mov al, 15
        ; mov cx, 110
        ; mov dx, 133
        ; mov si, 100
        ; mov di, 15
        ; call gfx_empty_rectangle

        ; ;dibuja string

        ; mov dl, 18
        ; mov dh, 2
        ; mov si, offset titulo
        ; call gfx_write_s

        ; mov dl, 18
        ; mov dh, 8
        ; mov si, offset play
        ; call gfx_write_s

        ; mov dl, 16
        ; mov dh, 11
        ; mov si, offset creditos
        ; call gfx_write_s
        
        ; mov dl, 16
        ; mov dh, 14
        ; mov si, offset highScore
        ; call gfx_write_s

        ; mov dl, 18
        ; mov dh, 17
        ; mov si, offset salir
        ; call gfx_write_s





        ;especifica coordenadas a partir de offset y dimensiones
        ; mov si, largo
        ; add posX2, si
        ; mov si, alto
        ; add posY2, si

        ; mov si, rectOffsetX
        ; mov di, rectOffsetY
        ; ;coreccion de posicion
        ; add largo, si
        ; add alto, di
        ; add posX, si
        ; add posY, di
        ; add posX2, si
        ; add posY2, di

        ; ;printa V
        ; mov cx, posX ;X pos inicio
        ; mov dx, posY ;Y pos inicio
        ; mov al, 15 ;color
        ; printaVLine:
        ; ; mov ah, 0ch
        ; ; int 10h
        ; call gfx_draw_pixel
        ; inc dx
        ; cmp dx, alto ;largo linea v
        ; ja endVLine
        ; jmp printaVLine  
        ; endVLine:      

        ; ;printa H
        ; mov cx, posX
        ; mov dx, posY
        ; mov al, 15
        ; printaHline:
        ; ; mov ah, 0ch
        ; ; int 10h
        ; call gfx_draw_pixel
        ; inc cx
        ; cmp cx, largo
        ; ja endHline
        ; jmp printaHline
        ; endHline:

        ; ;printa V2
        ; mov cx, posX2 ;X pos inicio
        ; mov dx, posY ;Y pos inicio
        ; mov al, 15 ;color
        ; printaV2Line:
        ; ; mov ah, 0ch
        ; ; int 10h
        ; call gfx_draw_pixel
        ; inc dx
        ; cmp dx, alto ;largo linea v
        ; ja endV2Line
        ; jmp printaV2Line  
        ; endV2Line:      

        ; ;printa H2
        ; mov cx, posX
        ; mov dx, posY2
        ; mov al, 15
        ; printaH2line:
        ; ; mov ah, 0ch
        ; ; int 10h
        ; call gfx_draw_pixel
        ; inc cx
        ; cmp cx, largo
        ; ja endH2line
        ; jmp printaH2line
        ; endH2line:





        ; mov cx, 124
        ; mov dx, 100
        ; mov al, 15
        
        ; putPixel:
        ; mov ah, 0ch
        ; int 10h

        ; inc cx
        ; cmp cx, 180
        ; ja endDrawing
        
        ; jmp putPixel
        ; endDrawing:

        ; mov ah, 2
        ; mov dl, 18      ;column18-row12 mitad de pantalla masomenos
        ; mov dh, 2       ;maximos 39 columns y 24 row (wtf)
        ; mov bh, 0
        ; int 10h ;set cursor lo vamos a usar para escribir

        ; mov ah, 9
        ; mov dx, offset titulo
        ; int 21h

        ; mov ah, 2
        ; mov dl, 18      ;column18-row12 mitad de pantalla masomenos
        ; mov dh, 8      ;maximos 39 columns y 24 row (wtf)
        ; mov bh, 0
        ; int 10h ;set cursor lo vamos a usar para escribir

        ; mov ah, 9
        ; mov dx, offset play
        ; int 21h





        ; mov si, offset clickBox1_data
        ; menu_loop_test:
        ; mov ax, 3 ;detecta status del mouse (posicion, click)
        ; int 33h
    
        ; cmp cx, word ptr [si]
        ; jb  end_clickBox_check ;si esta a la izquierda, salir
        ; cmp cx, word ptr [si+2]
        ; ja  end_clickBox_check ;si esta a la derecha, salir
        ; cmp dx, word ptr [si+4]
        ; jb  end_clickBox_check ;si esta arriba, salir
        ; cmp dx, word ptr [si+6]
        ; ja  end_clickBox_check ;si esta abajo, salir

        ; call mouse_click_handling
        ; cmp mouse_lmb_clicked, 1
        ; je clickBox_click
        ; jmp clickBox_noClick ;esta seccion dependera del uso que le queramos dar a la seccion que tenga la clickBox

        ; clickBox_click:
        ; mov [si+8], 1
        ; je fin
        ; jmp end_clickBox_check

        ; clickBox_noClick:
        ; end_clickBox_check:
        ; jmp menu_loop_test
        ;menu_loop_exit:





        ;### CLICKBOX PRE FUNCION ###
        ;MENU CLICKS

        ; mov ax, 1 ;muestra mouse
        ; int 33h

        ; game_loop:

        ; ;BX o SI v a contener el offset del clickBox

        ; mov ax, 3
        ; int 33h
        ; ;usa AX, BX, CX, DX

        ; ;no se porque las coordenadas del mouse no son las mismas que las de pixeles
        ; ;NOTA: APARENTEMENTE LAS COORDENADAS DE CX EN INT 33H SE DIVIDEN POR DOS EN MODO GRAFICO -> MULTIPLICAR POR DOS COORDENAS X
        ; ; xInicial    equ 220
        ; ; xFinal      equ 420
        ; ; yInicial   equ 133
        ; ; yFinal     equ 148

        ; ;verificar si el cursor esta en el area
        ; cmp cx, xInicial
        ; jb  next_loop ;si esta a la izquierda, salir
        ; cmp cx, xFinal
        ; ja  next_loop ;si esta a la derecha, salir
        ; cmp dx, yInicial
        ; jb  next_loop ;si esta arriba, salir
        ; cmp dx, yFinal
        ; ja  next_loop ;si esta abajo, salir

        ; ;si llega aca, el cursor esta dentro del area
        ; ; click_status:
        ; ; cmp bx, 0000000000000001b
        ; ; je fin

        ; call mouse_click_handling
        ; cmp mouse_lmb_clicked, 1
        ; je fin
        ; ; jmp fin

        ; ; dibujito:
        ; ; mov al, 15
        ; ; mov cx, 0
        ; ; mov dx, 0
        ; ; mov si, 50
        ; ; mov di, 50
        ; ; call gfx_empty_rectangle

        ; next_loop:
        ; jmp game_loop

        ;### CLICKBOX PRE FUNCION ###





        ; game_loop:

        ; mov ax, 3
        ; int 33h

        ; ;hitbox boton salir
        ; xCheck:
        ; cmp dx, 110 ;x inicial
        ; ja xArea
        ; jmp nada

        ; xArea:        
        ; cmp dx, 210 ;posicion inicial+tamaño
        ; jb yCheck
        ; jmp nada

        ; yCheck:
        ; cmp cx, 133 ;y inicial
        ; jb yArea
        ; jmp nada

        ; ;ahora necesitamos comparar si se encuentra en el area de Y
        ; yArea:
        ; cmp cx, 148
        ; ja confirmacion
        ; jmp nada

        ; confirmacion:
        ; jmp fin

        ; ; mov si, 100
        ; ; mov di, 15
        ; nada:

        ; ; mov ah, 8
        ; ; int 21h
        ; ; cmp al, 'q'
        ; ; je end_loop
        ; jmp game_loop
        ; end_loop:


        ; mov si, offset titulo
        ; mov bh, 0
        ; mov bl, 15
        ; mov cx, 1

        ; write:                    ;este codigo era para escribir
        ; mov al, [si]              ;chars con int 10h pero
        ; mov ah, 0eh               ;viendo que es la misma mierda
        ; int 10h                   ;que 21h pero peor y no te deja
        ; inc si                    ;modificar los atributos de los char
        ; cmp byte ptr [si], 24h    ;medio que se vaya a cagar la
        ; je endWriting             ;interfaz grafica pedorra de
        ; jmp write                 ;assembler, dos y 8086. Un saludo
        ; endWriting:  


        ; Wtf es esto?


        ; mov ah, 2
        ; mov dl, 18      ;column18-row12 mitad de pantalla masomenos
        ; mov dh, 2       ;maximos 39 columns y 24 row (wtf)
        ; mov bh, 0
        ; int 10h ;set cursor lo vamos a usar para escribir

        ; mov ah, 9
        ; mov dx, offset titulo
        ; int 21h