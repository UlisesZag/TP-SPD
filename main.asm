.8086
.model small
.stack 100h
.data
    puntaje dw 0
    vidas dw 5

    game_over dw 0    

    highscore dw 0
    highscore_achieved dw 0

    ;Variables que chequean si el mouse esta cliqueado o no
    mouse_lmb_clicked db 0 ;Boton izquierdo
    mouse_lmb_hold db 0
    mouse_rmb_clicked db 0 ;Boton derecho
    mouse_rmb_hold db 0

    frame_counter dw 0 ;Contador de frame 
    frame_counter_generator dw 0 ;Contador de frame para el generador

    ;Variables para el generador de cuadrados aleatorio
    generador_cuadrados_activado db 0
    FRAME_GENERADOR_CUADRADO dw 128 ;Frame cuando cada tanto se spawnea un cuadrado
    coordenada_cuadrado_x dw 0
    coordenada_cuadrado_y dw 0
    randomColorCuadrado dw 0

    ;Variables de dificultad
    frame_generador_cuadrado_start dw 128
    frame_generador_cuadrado_minimo dw 50
    frame_generador_cuadrado_acelerar dw 2
    timeout_cuadrados dw 75


    frameskip_exponent dw 1 ;Frameskip. Para que ande mejor en 3000 hz y coso

    ;El array donde se almacentaran todos los cuadrados
    ;El formato sera el siguiente:
    ;0: Tipo del cuadrado (si es 0 el cuadrado no existe y el loop pasa al siguiente cuadrado.)
    ;1: Posicion en X del cuadrado
    ;2: Posicion en Y del cuadrado
    ;3: Temporizador del cuadrado

    OBJECT_PROPS_BYTES EQU 10 ;Esta constante es la que suman los bucles para contar las propiedades de los objetos
                             ;SI AGREGAN PARAMETROS: CAMBIEN EL VALOR A CANTIDAD DE PARAMETROS * 2

    ;Tipo 0: No existe objeto
    ;Tipo 1: Cuadrado Azul
    ;Tipo 2: Cuadrado Verde
    ;Tipo 3: Cuadrado Rojo
    ;Tipo 128: Explosion
    ;Tipo 129: Explosion (falla)
    ;Tipo 130: Cuenta regresiva
    instances_array dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 0,0,0,0,0
                    dw 65535

    str_puntaje db "00000", 24h
    str_vidas db "00000", 24h

    ;//////////////////////////////STRINGS////////////////////////////////////////////
    txt_gui_vidas db "Vidas: ", 24h
    txt_gui_puntaje db "    Puntaje: ", 24h

    txt_prepare_thyself db "Preparados...", 24h

    txt_creditos db "----------------- Gracias por jugar Osu del chino -----------------", 0Dh, 0Ah
                 db "Integrantes del grupo 2:", 0Dh, 0Ah
                 db "Carolina Villalba", 0Dh, 0Ah
                 db "Christian Cavero", 0Dh, 0Ah    
                 db "Nelyer Narvaez", 0Dh, 0Ah
                 db "Paulo Gaston Meira Strazzolini", 0Dh, 0Ah
                 db "Ulises Zagare", 0Dh, 0Ah
                 db "-------------------------------------------------------------------", 0Dh, 0Ah, 24h
    
    txt_mensajeGO db "GAME OVER!",0dh, 0ah, 24h ; j u e g o   s o b r e
    txt_gameover_puntaje db "Puntaje: ", 24h
    txt_ResetGo db "Pulse 'espacio' para reintentar.",0dh, 0ah, 24h
    txt_msgQ db "Para salir pulse 'q'.",0dh, 0ah, 24h 
    txt_highscore db "Nuevo Highscore Obtenido !!", 24h
    txt_highscore_anterior db "Highscore: ", 24h

    ;/////////////////////////////SPRITES/////////////////////////////////////////////
    spr_cursor dw 8,8,4,4
               db 00,00,00,15,15,00,00,00
               db 00,00,00,15,15,00,00,00
               db 00,00,00,15,15,00,00,00
               db 15,15,15,15,15,15,15,15
               db 15,15,15,15,15,15,15,15
               db 00,00,00,15,15,00,00,00
               db 00,00,00,15,15,00,00,00
               db 00,00,00,15,15,00,00,00
    
    
    spr_cuadrado_verde dw 16,16,8,8
                       db 256 dup (11)

    spr_cuadrado_azul  dw 16,16,8,8
                       db 256 dup (10)
    
    spr_cuadrado_rojo  dw 16,16,8,8
                       db 256 dup (13)
    
    spr_cuadrado_borde dw 16,16,8,8
                       db 16 dup (15)
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 15, 14 dup (0), 15
                       db 16 dup (15) 

    
               
.code
    extrn gfx_init:proc
    extrn gfx_clear_screen:proc
    extrn gfx_draw_pixel:proc
    extrn gfx_draw_sprite:proc
    extrn gfx_draw_square:proc

    extrn strings_word2ascii:proc

    extrn random_genero_seed:proc
    extrn random_numero:proc
    extrn random_numero_anterior:proc

    extrn play:proc
    extrn play_snd_hit:proc
    extrn play_snd_miss:proc

    main proc
        mov ax, @data
        mov ds, ax

        call gfx_init
        call game_setup
    
    game_set:
        call random_genero_seed
        call game_reset

        ;Genero la cuenta regresiva
        mov ax, 130
        mov bx, 180
        mov cx, 160
        mov dx, 100
        call game_instance_obj

    mainloop:
        cmp game_over, 0
        jne gameover

        call game_logic
        call game_draw

        ;Ve si la tecla Q esta presionada (rapido por medio de llamadas a la BIOS, no para la cosa final)
        mov ah, 01h
        int 16h
        jz mainloop_end
        mov ah, 00h
        int 16h
        cmp al, "q"
        je cerrar_juego
        cmp al, "Q"
        je cerrar_juego

        mainloop_end:
        inc frame_counter ;Incrementa el contador de frames
        jmp mainloop

    gameover:
        call game_over_proc
        jmp game_set
        
    cerrar_juego:
        call game_close
    main endp

    game_setup proc
        push ax
        push cx
        push dx

        ;Setup mouse
        mov ax, 0
        int 33h

        ;Configura la resolucion del mouse
        mov ax, 7 ;Ancho
        mov cx,0
        mov dx,320
        int 33h
        mov ax, 8 ;Alto
        mov cx,0
        mov dx,199
        int 33h

        ;Configura el timer 0 para que de 30 frames por segundo
        mov al, 36h
        out 43h, al    ;tell the PIT which channel we're setting

        mov ax, 39772
        out 40h, al    ;send low byte
        mov al, ah
        out 40h, al    ;send high byte


        pop dx
        pop cx
        pop ax
        ret
    game_setup endp 

    ;Funcion que prepara las variables de juego
    game_reset proc
        mov game_over, 0
        mov highscore_achieved, 0
        mov vidas, 5
        mov puntaje, 0
        mov frame_counter, 0
        mov ax, frame_generador_cuadrado_start
        mov FRAME_GENERADOR_CUADRADO, ax
        mov generador_cuadrados_activado, 0

        mov si, 0
        game_reset_cleaninstances_loop:
            cmp instances_array[si], 65535
            je game_reset_cleaninstances_end
            mov instances_array[si], 0
            add si, object_props_bytes
            jmp game_reset_cleaninstances_loop
        game_reset_cleaninstances_end:

        ret
    game_reset endp

    game_logic proc
        call mouse_click_handling ;Para sacar que botones estan clickeados del mouse

        call game_check_gameover

        call game_generador_cuadrado_aleatorio

        ;Bucle que parsea el array de objetos para dibujarlos
        mov si, OFFSET instances_array
        game_logic_squares_loop:
            cmp word ptr[si], 65535 ;Si el tipo es 65535 significa FIN DEL ARRAY. Termina
            je game_logic_squares_end
            cmp word ptr[si], 0     ;Si el tipo es 0 el cuadrado no existe. Va al proximo.
            je game_logic_squares_next

            ;De que tipo es el cuadrado??
            cmp word ptr[si],1
            je LogicaCuadradoAzul
            cmp word ptr[si],2
            je LogicaCuadradoVerde
            cmp word ptr[si],3
            je LogicaCuadradoRojo
            cmp word ptr[si],128
            je LogicaExplosion
            cmp word ptr[si],129
            je LogicaExplosionFail
            cmp word ptr[si], 130
            je LogicaCuentaRegresiva

            LogicaCuadradoVerde:
            call game_logic_cuadrado_verde
            jmp game_logic_squares_next

            LogicaCuadradoAzul:
            call game_logic_cuadrado_azul
            jmp game_logic_squares_next

            LogicaCuadradoRojo:
            call game_logic_cuadrado_rojo
            jmp game_logic_squares_next

            LogicaExplosion:
            call game_logic_timeout_object
            jmp game_logic_squares_next

            LogicaExplosionFail:
            call game_logic_timeout_object
            jmp game_logic_squares_next

            LogicaCuentaRegresiva:
            call game_logic_cuenta_regresiva
            jmp game_logic_squares_next

            game_logic_squares_next:
            add si, OBJECT_PROPS_BYTES ;Pasa al siguiente cuadrado (cantidad de propiedades * 2 porque son words y no bytes)
            jmp game_logic_squares_loop
        game_logic_squares_end:
        
        ret 
    game_logic endp

    ;Funcion que maneja el movimiento de los cuadrados
    game_logic_movimiento_cuadrado proc
        ;Switch.
        cmp word ptr[si+8],0
        je game_logic_movimiento_cuadrado_end
        cmp word ptr[si+8],1
        je game_logic_movimiento_cuadrado_izquierda
        cmp word ptr[si+8],2
        je game_logic_movimiento_cuadrado_derecha
        cmp word ptr[si+8],3
        je game_logic_movimiento_cuadrado_arriba
        cmp word ptr[si+8],4
        je game_logic_movimiento_cuadrado_abajo

        game_logic_movimiento_cuadrado_izquierda:
        dec word ptr[si+2]
        cmp word ptr[si+2], 320
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+2], 0
        mov word ptr[si+8], 2
        jmp game_logic_movimiento_cuadrado_end
        
        game_logic_movimiento_cuadrado_derecha:
        inc word ptr[si+2]
        cmp word ptr[si+2], 320
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+2], 320
        mov word ptr[si+8], 1
        jmp game_logic_movimiento_cuadrado_end

        game_logic_movimiento_cuadrado_arriba:
        dec word ptr[si+4]
        cmp word ptr[si+4], 200
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+4], 0
        mov word ptr[si+8], 4
        jmp game_logic_movimiento_cuadrado_end
        
        game_logic_movimiento_cuadrado_abajo:
        inc word ptr[si+4]
        cmp word ptr[si+4], 200
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+4], 200
        mov word ptr[si+8], 3
        jmp game_logic_movimiento_cuadrado_end

        game_logic_movimiento_cuadrado_end:
        ret
    game_logic_movimiento_cuadrado endp

    game_logic_cuadrado_azul proc
        ;Decrementa el contador
        dec word ptr[si+6]
        cmp word ptr[si+6],0
        je _game_logic_cuadrado_azul_timeout

        call game_logic_movimiento_cuadrado ;Movimiento del cuadrado

        call game_logic_cuadrado_colisiones ;Chequea las colisiones
        jc _game_logic_cuadrado_azul_end ;Si no colisiona end


        ;Se fija si el mouse esta clickeado
        cmp mouse_lmb_clicked, 1
        jne _game_logic_cuadrado_azul_end

        ;Añade el score (contador dividido 5)
        mov dx, 0
        mov ax, word ptr[si+6]
        mov di, 5
        div di
        add puntaje, ax

        ;Spawnea una explosion si la toca
        mov ax, 128
        mov bx, 10
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call game_instance_obj
        ;Destruye el cuadrado (el indice ya esta en si)

        call play_snd_hit

        call game_destroy_obj
        jmp _game_logic_cuadrado_azul_end

        _game_logic_cuadrado_azul_timeout:
        dec vidas
        ;Spawnea una explosion fail

        mov ax, 129
        mov bx, 20
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call game_instance_obj

        call play_snd_miss

        call game_destroy_obj

        _game_logic_cuadrado_azul_end:
        ret
    game_logic_cuadrado_azul endp

    game_logic_cuadrado_verde proc
        ;Decrementa el contador
        dec word ptr[si+6]
        cmp word ptr[si+6],0
        je _game_logic_cuadrado_verde_timeout

        call game_logic_movimiento_cuadrado ;Movimiento del cuadrado

        call game_logic_cuadrado_colisiones ;Chequea las colisiones
        jc _game_logic_cuadrado_verde_end ;Si no colisiona end
        
        ;Se fija si el mouse esta clickeado
        cmp mouse_rmb_clicked, 1
        jne _game_logic_cuadrado_verde_end
        
        ;Añade el score (contador dividido 5)
        mov dx, 0
        mov ax, word ptr[si+6]
        mov di, 5
        div di
        add puntaje, ax
        ;Spawnea una explosion si la toca
        mov ax, 128
        mov bx, 10
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call game_instance_obj
        ;Destruye el cuadrado (el indice ya esta en si)

        call play_snd_hit

        call game_destroy_obj
        jmp _game_logic_cuadrado_verde_end

        _game_logic_cuadrado_verde_timeout:
        dec vidas
        ;Spawnea una explosion fail
        ;poner sonido wuaa wuaaa
        mov ax, 129
        mov bx, 20
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call game_instance_obj

        call play_snd_miss

        call game_destroy_obj

        _game_logic_cuadrado_verde_end:
        ret
    game_logic_cuadrado_verde endp

    game_logic_cuadrado_rojo proc
         ;Decrementa el contador
        dec word ptr[si+6]
        cmp word ptr[si+6],0
        je _game_logic_cuadrado_rojo_timeout

        call game_logic_movimiento_cuadrado ;Movimiento del cuadrado

        call game_logic_cuadrado_colisiones ;Chequea las colisiones
        jc _game_logic_cuadrado_rojo_end ;Si no colisiona end

        mov ax, 0
        add al, mouse_lmb_clicked
        add al, mouse_rmb_clicked
        cmp al, 0
        je _game_logic_cuadrado_rojo_end
        dec vidas

        call play_snd_miss

        ;Destruye el cuadrado (el indice ya esta en si)
        ;Spawnea una explosion fail
        mov ax, 129
        mov bx, 20
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call game_instance_obj
        call game_destroy_obj
        jmp _game_logic_cuadrado_rojo_end

        _game_logic_cuadrado_rojo_timeout:
        ;Spawnea una explosion si la toca
        ;poner sonido wuaa wuaaa
        mov ax, 128
        mov bx, 10
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]

        call game_instance_obj

        call play_snd_hit

        call game_destroy_obj
        _game_logic_cuadrado_rojo_end:
        ret
    game_logic_cuadrado_rojo endp

    game_logic_timeout_object proc
        ;Decrementa el contador
        dec word ptr[si+6]
        cmp word ptr[si+6],0
        je _game_logic_explosion_timeout

        jmp _game_logic_explosion_end

        _game_logic_explosion_timeout:
        call game_destroy_obj

        _game_logic_explosion_end:
        ret
    game_logic_timeout_object endp

    game_logic_cuenta_regresiva proc
        ;Decrementa el contador
        dec word ptr[si+6]
        cmp word ptr[si+6],0
        je _game_logic_cuenta_regresiva_timeout

        jmp _game_logic_cuenta_regresiva_end

        _game_logic_cuenta_regresiva_timeout:
        mov generador_cuadrados_activado, 1
        call game_destroy_obj

        _game_logic_cuenta_regresiva_end:
        ret
    game_logic_cuenta_regresiva endp

    ;Funcion que saca si el mouse colisiona con el cuadrado
    ;Si Carry = 0: Colisiona con el mouse
    ;Si Carry = 1: No colisiona con el mouse
    game_logic_cuadrado_colisiones proc
        ;Aca la logica de las colisiones
        ;Si colisiona sigue, si no tiene que saltar a game_logic_squares_next
        mov ax, 3 ;Saca las posiciones del mouse (X en CX y Y en DX)
        int 33h
        mov ax, word ptr [si+2] ;X del cuadrado
        mov bx, word ptr [si+4] ;Y del cuadrado

        ;Les sumo un sesgo a todas las coordenadas (no puedo usar numeros negativos)
        add ax, 320
        add bx, 320

        sub ax, cx ;Saca la diferencia
        sub bx, dx ;Saca la diferencia

        cmp ax, 312
        jb game_logic_cuadrado_colisiones_NoColisiona
        cmp ax, 328
        ja game_logic_cuadrado_colisiones_NoColisiona
        cmp bx, 312
        jb game_logic_cuadrado_colisiones_NoColisiona
        cmp bx, 328
        ja game_logic_cuadrado_colisiones_NoColisiona

        clc
        ret

        game_logic_cuadrado_colisiones_NoColisiona:
        stc
        ret

    game_logic_cuadrado_colisiones endp

    ;Funcion de instanciado de objetos.
    ;Busca una entrada tipo 0 en el array y pone lo demas luego
    game_instance_obj proc
        push si

        mov si, OFFSET instances_array
        game_instance_loop:
            cmp word ptr[si], 65535 ;Si no hay mas espacio en el array de objetos no instancia
            je game_instance_failed
            cmp word ptr[si], 0 ;Si no es 0 no pone nada
            jne game_instance_next

            mov word ptr[si], ax ;Tipo
            mov word ptr[si+2], cx ;Eje X
            mov word ptr[si+4], dx ;Eje Y
            mov word ptr[si+6], bx ;Contador
            mov word ptr[si+8], di ;Tipo de movimiento

            jmp game_instance_end
        game_instance_next:
            add si, OBJECT_PROPS_BYTES
            jmp game_instance_loop

        game_instance_failed:
            stc ;Carry = 1: Error de instanciado

        game_instance_end:

        pop si
        ret
    game_instance_obj endp

    game_destroy_obj proc
        mov cx, OBJECT_PROPS_BYTES
        mov bx, 0
        _destroy_obj_loop:
            mov word ptr[bx+si], 0
            add bx, 2
            cmp bx, cx
            je _destroy_obj_end
            jmp _destroy_obj_loop
        _destroy_obj_end:

        ret
    game_destroy_obj endp

    game_generador_cuadrado_aleatorio proc
        ;Esta funcion no recibe ningun parametro, solo se llama y genera los cuadrados con caracteristicas random
        ;como las coordenas y,x y el tipo de cuadrado, luego lo printea y ya
        ;dato los primeros bytes en hexa siempre son 0 ej (XX00)
        
        push ax
        push bx
        push cx
        push dx
        push si

        ;Esta activado?
        cmp generador_cuadrados_activado, 1
        jne game_generador_cuadrado_aleatorio_end

        mov ax, frame_counter_generator
        mov dx, 0 
        mov cx, FRAME_GENERADOR_CUADRADO
        div cx
        cmp dx, 0; si el resto es 0 llamo o hago lo que necesitaba hacer cada x frames 
        jne game_generador_cuadrado_aleatorio_end

        mov frame_counter_generator, 0;Resetea el contador del generador

        ;Coordenada X
        call random_numero
        mov bx, 280
        mov dx, 0
        div bx
        add dx, 20 ;en DX queda el resto
        mov coordenada_cuadrado_x,dx
        
        ;Coordenada Y
        call random_numero
        mov bx, 160
        mov dx, 0
        div bx
        add dx, 20
        mov coordenada_cuadrado_y,dx

        call random_numero

        ;Por como funciona la intr81 el dato a dividir ya esta en ax
        mov cx,3
        mov dx,0
        div cx
        inc dx
        mov randomColorCuadrado, dx

        mov cx, 5
        mov dx, 0
        div cx
        mov di, dx

        mov ax, randomColorCuadrado
        mov cx, coordenada_cuadrado_x
        mov dx, coordenada_cuadrado_y
        mov bx, timeout_cuadrados
        call game_instance_obj;Crea el cuadrado

        ;Se fija si el frame_counter es al menos 60
        mov ax, frame_generador_cuadrado_minimo
        cmp FRAME_GENERADOR_CUADRADO, ax
        jbe game_generador_cuadrado_aleatorio_end

        mov ax, frame_generador_cuadrado_acelerar
        sub FRAME_GENERADOR_CUADRADO, ax
        
        game_generador_cuadrado_aleatorio_end:
        inc frame_counter_generator

        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    ret
    game_generador_cuadrado_aleatorio endp

    ;Si las vidas son 0: gameover = 1 y pasa a pantalla de game over
    game_check_gameover proc
        cmp vidas, 0
        jne game_check_gameover_end
        mov game_over, 1
        game_check_gameover_end:
        ret
    game_check_gameover endp

    game_draw proc
        ;Espera a que el monitor dibuje un nuevo frame (sirve para los tick tambien)
        call wait_new_vr

        ;Frameskip
        mov ax, frame_counter
        mov cx, frameskip_exponent
        frameskip_loop:
            shr ax, 1
            jc game_draw_end
            loop frameskip_loop

        call gfx_clear_screen ;Limpia la pantalla
        call draw_gui ;GUI

        call draw_instances ;Cuadrados

        call draw_cursor ;Dibuja el cursor

        game_draw_end:
        ret
    game_draw endp 

    draw_instances proc
        push bx
        push cx
        push dx
        push si

        ;Bucle que parsea el array de objetos para dibujarlos
        mov si, OFFSET instances_array
        draw_squares_loop:
            cmp word ptr[si], 65535 ;Si el tipo es 65535 significa FIN DEL ARRAY. Termina
            je draw_squares_end
            cmp word ptr[si], 0     ;Si el tipo es 0 el cuadrado no existe. Va al proximo.
            je draw_squares_next

            ;De que tipo es el cuadrado??
            cmp word ptr[si],1
            je DibujaCuadradoVerde
            cmp word ptr[si],2
            je DibujaCuadradoAzul
            cmp word ptr[si],3
            je DibujaCuadradoRojo
            cmp word ptr[si],128
            je DibujaExplosion
            cmp word ptr[si],129
            je DibujaExplosionFail
            cmp word ptr[si],130
            je DibujaCuentaRegresiva
            jmp draw_squares_next ;Si no es ningun otro ya fue

            DibujaCuadradoVerde:
            call draw_instances_CuadradoVerde
            jmp draw_squares_next

            DibujaCuadradoAzul:
            call draw_instances_CuadradoAzul
            jmp draw_squares_next

            DibujaCuadradoRojo:
            call draw_instances_CuadradoRojo
            jmp draw_squares_next

            DibujaExplosion:
            call draw_instances_Explosion
            jmp draw_squares_next

            DibujaExplosionFail:
            call draw_instances_ExplosionFail
            jmp draw_squares_next

            DibujaCuentaRegresiva:
            call draw_instances_CuentaRegresiva
            jmp draw_squares_next

            draw_squares_next:
            add si, OBJECT_PROPS_BYTES ;Pasa al siguiente cuadrado (cantidad de propiedades * 2 porque son words y no bytes)
            jmp draw_squares_loop
        draw_squares_end:

        pop si
        pop dx
        pop cx
        pop bx

        ret
    draw_instances endp

    draw_instances_CuadradoAzul proc
        mov bx, OFFSET spr_cuadrado_azul
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call gfx_draw_sprite

        call draw_instances_cuadrado_borde
        
        ret

    draw_instances_CuadradoAzul endp

    draw_instances_CuadradoVerde proc
        mov bx, OFFSET spr_cuadrado_verde
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call gfx_draw_sprite

        call draw_instances_cuadrado_borde

        ret
    draw_instances_CuadradoVerde endp

    draw_instances_CuadradoRojo proc
        mov bx, OFFSET spr_cuadrado_rojo
        mov cx, word ptr[si+2]
        mov dx, word ptr[si+4]
        call gfx_draw_sprite

        call draw_instances_cuadrado_borde

        ret
    draw_instances_CuadradoRojo endp

    draw_instances_Explosion proc
        ;Barra vertical
        mov ax, word ptr[si+2];X inicial
        sub ax, word ptr[si+6]
        push ax
        mov ax, 0;Y inicial
        push ax
        mov ax, word ptr[si+2];X final
        add ax, word ptr[si+6]
        push ax
        mov ax, 200;Y final
        push ax
        mov ax, 15
        push ax
        call gfx_draw_square

        ret
    draw_instances_Explosion endp

    draw_instances_ExplosionFail proc
        ;Barra vertical
        mov ax, word ptr[si+2];X inicial
        sub ax, word ptr[si+6]
        push ax
        mov ax, 0;Y inicial
        push ax
        mov ax, word ptr[si+2];X final
        add ax, word ptr[si+6]
        push ax
        mov ax, 200;Y final
        push ax
        mov ax, 13
        push ax
        call gfx_draw_square

        ;Barra horizontal
        mov ax, 0;X inicial
        push ax
        mov ax, word ptr[si+4];Y inicial
        sub ax, word ptr[si+6]
        push ax
        mov ax, 320;X final
        push ax
        mov ax, word ptr[si+4];Y final
        add ax, word ptr[si+6]
        push ax
        
        mov ax, 13
        push ax
        call gfx_draw_square

        ret
    draw_instances_ExplosionFail endp

    draw_instances_CuentaRegresiva proc
        mov dl, 14
        mov dh, 9
        call set_cursor_position

        mov ah, 9
        mov dx, OFFSET txt_prepare_thyself
        int 21h

        mov dl, 20
        mov dh, 11
        call set_cursor_position

        cmp word ptr[si+6], 120
        ja draw_instances_CuentaRegresiva_PrintThree
        cmp word ptr[si+6], 60
        ja draw_instances_CuentaRegresiva_PrintTwo
        jmp draw_instances_CuentaRegresiva_PrintOne

        draw_instances_CuentaRegresiva_PrintThree:
        mov ah, 2
        mov dl, "3"
        int 21h
        jmp draw_instances_CuentaRegresiva_end

        draw_instances_CuentaRegresiva_PrintTwo:
        mov ah, 2
        mov dl, "2"
        int 21h
        jmp draw_instances_CuentaRegresiva_end

        draw_instances_CuentaRegresiva_PrintOne:
        mov ah, 2
        mov dl, "1"
        int 21h
        jmp draw_instances_CuentaRegresiva_end

        draw_instances_CuentaRegresiva_end:
        ret
    draw_instances_CuentaRegresiva endp

    draw_instances_cuadrado_borde proc
        ;Dibuja el borde
        ;Primero se fija el temporizador
        mov ax, word ptr[si+6]
        cmp ax, 30
        jb draw_instances_CuadradoRojo_BordeTitila

        draw_instances_CuadradoRojo_BordeNoTitila:
        mov bx, OFFSET spr_cuadrado_borde
        call gfx_draw_sprite
        jmp draw_instances_cuadrado_borde_end

        draw_instances_CuadradoRojo_BordeTitila:
        mov bx, 3
        div bl
        cmp ah, 0
        jne draw_instances_cuadrado_borde_end
        mov bx, OFFSET spr_cuadrado_borde
        call gfx_draw_sprite

        draw_instances_cuadrado_borde_end:
        ret
    draw_instances_cuadrado_borde endp

    ;Funcion que setea mouse_lmb_clicked y mouse_rmb_clicked si esta clickeado o no
    mouse_click_handling proc
        push ax
        push bx
        push cx
        push dx

        ;Left Mouse Button
        mouse_click_handling_CheckLeft:
        mov ax, 03h
        int 33h
        and bx, 0000000000000001b
        jz mouse_click_handling_NoLeft
        mov mouse_lmb_clicked, 1
        mov mouse_lmb_hold, 1
        jmp mouse_click_handling_CheckRight

        mouse_click_handling_NoLeft:
        mov mouse_lmb_clicked, 0
        mov mouse_lmb_hold, 0

        mouse_click_handling_CheckRight:
        mov ax, 03h
        int 33h
        and bx, 0000000000000010b
        jz mouse_click_handling_NoRight
        mov mouse_rmb_clicked, 1
        mov mouse_rmb_hold, 1
        jmp mouse_click_handling_end

        mouse_click_handling_NoRight:
        mov mouse_rmb_clicked, 0
        mov mouse_rmb_hold, 0

        mouse_click_handling_end:

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    mouse_click_handling endp

    ;Funcion que espera a que la pantalla dibuje un nuevo frame
    ;Para reemplazar el wait_next_tick por tiempo del sistema
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

    ;Funcion que mueve el cursor de texto a una posicion en especifico
    ;INPUT : DL=X, DH=Y.
    set_cursor_position proc
        push ax
        push bx

        mov  ah, 2
        mov  bh, 0
        int  10h

        pop bx
        pop ax

        RET
    set_cursor_position endp

    draw_gui proc
        push ax
        push dx
        push si

        mov dl, 0
        mov dh, 0
        call set_cursor_position

        mov ah, 9
        mov dx, OFFSET txt_gui_vidas
        int 21h

        mov ax, vidas
        mov si, OFFSET str_vidas
        call strings_word2ascii

        mov ah, 9
        mov dx, OFFSET str_vidas
        int 21h

        mov ah, 9
        mov dx, OFFSET txt_gui_puntaje
        int 21h

        mov ax, puntaje
        mov si, OFFSET str_puntaje
        call strings_word2ascii

        mov ah, 9
        mov dx, OFFSET str_puntaje
        int 21h

        pop si
        pop dx
        pop ax

        ret
    draw_gui endp

    draw_cursor proc
        push ax
        push bx

        ;Va dibujando en la posicion del mouse
        mov ax,03
        int 33h

        mov bx, OFFSET spr_cursor
        call gfx_draw_sprite
        
        pop bx
        pop ax
        ret
    draw_cursor endp

    game_over_proc proc
        ;Calcula el high score
        mov ax, puntaje
        cmp highscore, ax
        jae gameover_screen;Si highscore es mayor o igual que puntaje salta esta parte

        mov highscore, ax
        mov highscore_achieved, 1

        gameover_screen:
        call wait_new_vr

        ;Frameskip
        mov ax, frame_counter
        mov cx, frameskip_exponent
        gameover_frameskip_loop:
            shr ax, 1
            jc gameover_screen_end
            loop gameover_frameskip_loop

        call gfx_clear_screen

        call game_over_draw
        
        ;Dibuja el cursor
        call draw_cursor

        ;Hay una tecla presionada o no??
        mov ah, 01h
        int 16h
        jz gameover_screen_end
        ;Obtiene la tecla presionada por AL
        mov ah, 00h
        int 16h
        ;Tecla espacio presionada?
        cmp al, 20h
        je gameover_restart
        ;Tecla Q/q presionada?
        cmp al, "q"
        je gameover_game_close
        cmp al, "Q"
        je gameover_game_close

        gameover_screen_end:
        inc frame_counter
        jmp gameover_screen

        gameover_game_close:
        call game_close

        gameover_restart:
        ret
    game_over_proc endp

    game_over_draw proc
        ;Mensaje de Game Over
        mov dl,15
        mov dh,7
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_mensajeGO
        int 21h

        ;Mensaje de Puntaje Final
        mov dl,14
        mov dh,12
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_gameover_puntaje
        int 21h

        mov ax, puntaje
        mov si, OFFSET str_puntaje
        call strings_word2ascii

        mov ah, 9
        mov dx, offset str_puntaje
        int 21h

        ;Mensaje de Reset
        mov dl,4
        mov dh,17
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_ResetGo
        int 21h

        ;Mensaje de salir
        mov dl,11
        mov dh,18
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_msgQ
        int 21h

        ;Highscore?
        cmp highscore_achieved, 1 ;Yeeeeee highscoreeee
        jne gameover_no_highscore

        mov dl,7
        mov dh,14
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_highscore
        int 21h

        je gameover_end

        gameover_no_highscore: ;No highscore :(
        mov dl,12
        mov dh,14
        call set_cursor_position

        mov ah, 9
        mov dx, offset txt_highscore_anterior
        int 21h

        mov ax, highscore
        mov si, OFFSET str_puntaje
        call strings_word2ascii

        mov ah, 9
        mov dx, offset str_puntaje
        int 21h
        
        gameover_end:
        ret
    game_over_draw endp

    ;Funcion que cierra el juego
    game_close proc
        mov ax, 3h  ;Sale del modo grafico
        int 10h

        mov ah, 9   ;Mensaje de fin
        mov dx, OFFSET txt_creditos
        int 21h

        mov ax, 4C00h ;Fin del programa
        int 21h
        ret
    game_close endp 

end