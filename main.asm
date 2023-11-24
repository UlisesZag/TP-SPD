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

    ;variable modelo que hay que se podria pasar por stack a la llamada del menu -> determina dificultad
    gameMode dw 0
    ;modos de juego:
    ;0 -> salir
    ;1 -> facil
    ;2 -> normal
    ;3 -> dificil

    ;Variables de dificultad
    dificultad dw 2
    SKILL_ARRAY_PROPS equ 10
    skill_array dw 160, 75, 2, 120, 12 ;Facil
                dw 128, 60, 2, 90, 5 ;Medio
                dw 100, 45, 2, 70, 3 ;Dificil

    frame_generador_cuadrado_start dw 128
    frame_generador_cuadrado_minimo dw 40
    frame_generador_cuadrado_acelerar dw 2
    timeout_cuadrados dw 75
    divisor_score dw 5


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
    str_vidas db "00000", 24h
    str_puntaje db "00000", 24h
    str_highscore db "00000", 24h

    ;Variables del menu

    clickbox1_data dw 110,210,61,76,0
    clickbox2_data dw 110,210,85,100,0
    clickbox3_data dw 110,210,109,124,0
    clickBox4_data dw 110,210,133,148,0
    ;Xinicial, Xfinal, Yinicial, Yfinal, ClickStatus (lbm)

    ;clickBoxs del game_mode
    cb1_gm_data dw 32,107,90,110,0
    cb2_gm_data dw 121,196,90,110,0
    cb3_gm_data dw 211,296,90,110,0
    cb4_gm_data dw 121,196,155,175,0

    ;//////////////////////////////STRINGS////////////////////////////////////////////
    txt_welcome_to_dosu db "                                Welcome to DOSu!                                ", 0Dh, 0Ah
                        db "                             - Click the Squares -                              ", 0Dh, 0Ah, 24h

    txt_gui_vidas db "Vidas: ", 24h
    txt_gui_puntaje db "Puntaje: ", 24h
    txt_gui_highscore db "High: ", 24h
    txt_gui_dificultad_facil db "FACIL", 24h
    txt_gui_dificultad_normal db "NORMAL", 24h
    txt_gui_dificultad_dificil db "DIFICIL", 24h

    txt_prepare_thyself db "Preparados...", 24h

    txt_creditos db "----------------- Gracias por jugar Osu del chino -----------------", 0Dh, 0Ah
                 db "Integrantes del grupo 2:", 0Dh, 0Ah
                 db "Carolina Villalba", 0Dh, 0Ah
                 db "Nelyer Narvaez", 0Dh, 0Ah
                 db "Paulo Gaston Meira Strazzolini", 0Dh, 0Ah
                 db "Ulises Zagare", 0Dh, 0Ah
                 db "-------------------------------------------------------------------", 0Dh, 0Ah, 24h
    
    txt_mensajeGO db "GAME OVER!",0dh, 0ah, 24h ; j u e g o   s o b r e
    txt_gameover_puntaje db "Puntaje: ", 24h
    txt_ResetGo db "Pulse 'espacio' para reintentar.",0dh, 0ah, 24h
    txt_msgQ db "Pulse 'q' para volver al menu.",0dh, 0ah, 24h 
    txt_highscore db "Nuevo Highscore Obtenido !!", 24h
    txt_highscore_anterior db "Highscore: ", 24h

    ;Menu
    txt_menu_titulo db "DOSu!",24h
    txt_menu_play db "Play",24h
    txt_menu_creditos db "Creditos",24h
    txt_menu_highScore db "HighScore",24h
    txt_menu_salir db "Salir",24h

    txt_menu_gameMode_text db "Seleccione modo de juego",24h
    txt_menu_mode1 db "facil",24h
    txt_menu_mode2 db "normal",24h
    txt_menu_mode3 db "dificil",24h
    txt_menu_mode0 db "volver",24h

    txt_menu_credits db "Proyecto realizado por",24h
    txt_menu_name1 db "Ulises",24h
    txt_menu_name2 db "Nelyer",24h
    txt_menu_name3 db "Caro",24h
    txt_menu_name4 db "Paulo",24h
    txt_menu_name5 db "Chris",24h
    txt_menu_credits_exit db "click to exit",24h

    txt_menu_highScore_text db "Puntaje mas alto obtenido:",24h
    str_menu_highScore db 5 dup (24h),24h
    txt_menu_highScore_exit db "click to exit",24h

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
    extrn gfx_empty_rectangle:proc
    extrn gfx_write_s:proc
    extrn wait_new_vr:proc

    extrn strings_word2ascii:proc

    extrn random_genero_seed:proc
    extrn random_numero:proc
    extrn random_numero_anterior:proc

    extrn play:proc
    extrn play_snd_hit:proc
    extrn play_snd_miss:proc
    extrn play_snd_bounce:proc
    extrn play_snd_select:proc
    extrn play_snd_welcome_to_dosu:proc

    extrn savefile_load:proc
    extrn savefile_save:proc

    main proc
        mov ax, @data
        mov ds, ax

        mov ah, 9
        mov dx, OFFSET txt_welcome_to_dosu
        int 21h
        call play_snd_welcome_to_dosu

        call gfx_init
        call game_setup

        ;Carga el puntaje alto
        call savefile_load
        mov highscore, si

    game_menu:
        call menu_function
    
    game_set:
        call random_genero_seed
        call game_reset

        ;Pone el mouse en el centro
        mov ax, 4
        mov cx, 160
        mov dx, 100
        int 33h

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
        je game_menu
        cmp al, "Q"
        je game_menu

        mainloop_end:
        inc frame_counter ;Incrementa el contador de frames
        jmp mainloop

    gameover:
        int 3h
        call game_over_proc
        cmp ax, 0 ;Si ax = 0: reinicia la partida
        je game_set ;Si ax = 1: menu
        jmp game_menu
        
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
        push si

        mov ax, gameMode
        dec ax ; (gameMode = dificultad + 1, 0 es volver al menu)
        mov bx, SKILL_ARRAY_PROPS
        mul bx
        mov si, ax

        mov bx, OFFSET skill_array
        mov ax, word ptr[bx+si]
        mov frame_generador_cuadrado_start, ax
        mov ax, word ptr[bx+si+2]
        mov frame_generador_cuadrado_minimo, ax
        mov ax, word ptr[bx+si+4]
        mov frame_generador_cuadrado_acelerar, ax
        mov ax, word ptr[bx+si+6]
        mov timeout_cuadrados, ax
        mov ax, word ptr[bx+si+8]
        mov divisor_score, ax
        
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

        pop si
        ret
    game_reset endp

    game_logic proc
        push si

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
        
        pop si
        ret 
    game_logic endp

    ;Funcion que maneja el movimiento de los cuadrados
    game_logic_movimiento_cuadrado proc

        cmp word ptr[si+8],1
        je game_logic_movimiento_cuadrado_izquierda
        cmp word ptr[si+8],2
        je game_logic_movimiento_cuadrado_derecha
        cmp word ptr[si+8],3
        je game_logic_movimiento_cuadrado_arriba
        cmp word ptr[si+8],4
        je game_logic_movimiento_cuadrado_abajo
        jmp game_logic_movimiento_cuadrado_end

        game_logic_movimiento_cuadrado_izquierda:
        dec word ptr[si+2]
        cmp word ptr[si+2], 320
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+2], 0
        mov word ptr[si+8], 2
        call play_snd_bounce
        jmp game_logic_movimiento_cuadrado_end
        
        game_logic_movimiento_cuadrado_derecha:
        inc word ptr[si+2]
        cmp word ptr[si+2], 320
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+2], 320
        mov word ptr[si+8], 1
        call play_snd_bounce
        jmp game_logic_movimiento_cuadrado_end

        game_logic_movimiento_cuadrado_arriba:
        dec word ptr[si+4]
        cmp word ptr[si+4], 200
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+4], 0
        mov word ptr[si+8], 4
        call play_snd_bounce
        jmp game_logic_movimiento_cuadrado_end
        
        game_logic_movimiento_cuadrado_abajo:
        inc word ptr[si+4]
        cmp word ptr[si+4], 200
        jbe game_logic_movimiento_cuadrado_end
        mov word ptr[si+4], 200
        mov word ptr[si+8], 3
        call play_snd_bounce
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
        mov di, divisor_score
        div di
        inc ax ;A veces suma 0
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
        mov di, divisor_score
        div di
        inc ax ;A veces suma 0
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
        push ax
        push bx
        push cx
        push dx

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

        pop dx
        pop cx
        pop bx
        pop ax

        ret

        game_logic_cuadrado_colisiones_NoColisiona:
        stc

        pop dx
        pop cx
        pop bx
        pop ax
        ret

    game_logic_cuadrado_colisiones endp

    ;Funcion de instanciado de objetos.
    ;Busca una entrada tipo 0 en el array y pone lo demas luego
    ;ax: Tipo
    ;bx: Contador
    ;cx: Posicion en X
    ;dx: Posicion en Y
    ;di: Movimiento
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

    ;Destruye un objeto (pone todo en 0)
    game_destroy_obj proc
        push bx
        push cx

        mov cx, OBJECT_PROPS_BYTES
        mov bx, 0
        _destroy_obj_loop:
            mov word ptr[bx+si], 0
            add bx, 2
            cmp bx, cx
            je _destroy_obj_end
            jmp _destroy_obj_loop
        _destroy_obj_end:

        pop cx
        pop bx
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

        mov dl, 11
        mov dh, 0
        call set_cursor_position

        mov ah, 9
        mov dx, OFFSET txt_gui_puntaje
        int 21h

        mov ax, puntaje
        mov si, OFFSET str_puntaje
        call strings_word2ascii

        mov ah, 9
        mov dx, OFFSET str_puntaje
        int 21h

        ;Highscore
        mov dl, 26
        mov dh, 0
        call set_cursor_position

        mov ah, 9
        mov dx, OFFSET txt_gui_highscore
        int 21h

        mov ax, highscore
        mov si, OFFSET str_highscore
        call strings_word2ascii

        mov ah, 9
        mov dx, OFFSET str_highscore
        int 21h

        ;Dificultad
        mov dl, 0
        mov dh, 24
        call set_cursor_position

        cmp gameMode, 1
        je draw_gui_dificultad_facil
        cmp gameMode, 2
        je draw_gui_dificultad_normal
        cmp gameMode, 3
        je draw_gui_dificultad_dificil

        draw_gui_dificultad_facil:
        mov ah, 9
        mov dx, OFFSET txt_gui_dificultad_facil
        int 21h
        jmp draw_gui_end

        draw_gui_dificultad_normal:
        mov ah, 9
        mov dx, OFFSET txt_gui_dificultad_normal
        int 21h
        jmp draw_gui_end

        draw_gui_dificultad_dificil:
        mov ah, 9
        mov dx, OFFSET txt_gui_dificultad_dificil
        int 21h
        jmp draw_gui_end

        draw_gui_end:
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

    ;Pantalla de game over
    ; Devuelve por ax la opcion seleccionada
    ;  ax = 0: Reintentar
    ;  ax = 1: Volver al menu
    game_over_proc proc
        
        push cx
        push si
        ;Calcula el high score
        mov ax, puntaje
        cmp highscore, ax
        jae gameover_screen;Si highscore es mayor o igual que puntaje salta esta parte

        mov highscore, ax
        mov highscore_achieved, 1

        ;Guarda el savefile
        mov si, highscore
        call savefile_save

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
        mov ax, 1
        jmp game_over_proc_end

        gameover_restart:
        mov ax, 0

        game_over_proc_end:
        pop si
        pop cx
        
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
        mov dl,5
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

    ; ============================= MENU =======================================

    menu_function proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ;MENU

        ;Pone el mouse en el centro
        mov ax, 4
        mov cx, 160
        mov dx, 100
        int 33h

        menu_loop:
        call gfx_draw_main_menu

        ;maneja clickboxs
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
        je menu_function_close_game

        inc frame_counter ;Esto para que funcione el frameskip (frame_counter es reseteado con la funcion game_reset)

        jmp menu_loop
        menu_loop_exit:

        ;PLAYGAME
        play_game:
        mov word ptr [si+8], 0
        call play_snd_select
        call play_mode
        cmp gameMode, 0
        je menu_loop
        jmp exit_menu 

        ;CREDITS
        show_credits:
        mov word ptr [si+8], 0
        call play_snd_select
        call credits_menu
        jmp menu_loop

        ;HS
        show_highScore:
        mov word ptr [si+8], 0
        call play_snd_select
        call show_HS
        jmp menu_loop

        menu_function_close_game:
        call play_snd_select
        call game_close ;Cierra el juego

        exit_menu:

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

    ;DIBUJA MENU PRINCIPAL
    gfx_draw_main_menu proc
        push ax
        ;push bx
        push cx
        push dx
        push si
        push di

        call wait_new_vr

        ;Frameskip
        mov ax, frame_counter
        mov cx, frameskip_exponent
        gfx_draw_main_menu_frameskip_loop:
            shr ax, 1
            jc gfx_draw_main_menu_end
            loop gfx_draw_main_menu_frameskip_loop

        call gfx_clear_screen
        
        ;dibujar rectangulos
        mov al, 15
        mov cx, 110
        mov dx, 10
        mov si, 100
        mov di, 30
        call gfx_empty_rectangle

        ;mov al, 15
        ;mov cx, 110
        mov dx, 61
        ;mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        ;mov al, 15
        ;mov cx, 110
        mov dx, 85
        ;mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        ;mov al, 15
        ;mov cx, 110
        mov dx, 109
        ;mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        ;mov al, 15
        ;mov cx, 110
        mov dx, 133
        ;mov si, 100
        mov di, 15
        call gfx_empty_rectangle

        ;dibuja string
        mov dl, 18
        mov dh, 2
        mov si, offset txt_menu_titulo
        call gfx_write_s

        mov dl, 18
        mov dh, 8
        mov si, offset txt_menu_play
        call gfx_write_s

        mov dl, 16
        mov dh, 11
        mov si, offset txt_menu_creditos
        call gfx_write_s
        
        mov dl, 16
        mov dh, 14
        mov si, offset txt_menu_highScore
        call gfx_write_s

        mov dl, 18
        mov dh, 17
        mov si, offset txt_menu_salir
        call gfx_write_s

        call draw_cursor

        gfx_draw_main_menu_end:
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
        mov si, offset txt_menu_credits
        mov dl, 9
        mov dh, 5
        call gfx_write_s
        mov si, offset txt_menu_name1
        mov dl, 16
        mov dh, 8
        call gfx_write_s
        mov si, offset txt_menu_name2
        mov dl, 16
        mov dh, 10
        call gfx_write_s
        mov si, offset txt_menu_name3
        mov dl, 16
        mov dh, 12
        call gfx_write_s
        mov si, offset txt_menu_name4
        mov dl, 16
        mov dh, 14
        call gfx_write_s
        mov si, offset txt_menu_name5
        mov dl, 16
        mov dh, 16
        call gfx_write_s
        mov si, offset txt_menu_credits_exit
        mov dl, 13
        mov dh, 20
        call gfx_write_s

        credits_loop:   ;no se si sigue haciendo falta pero lo dejo ahi
        call mouse_click_handling
        cmp mouse_lmb_clicked, 1
        je exit_credits_menu  
        jmp credits_loop

        exit_credits_menu:
        call mouse_control
        call play_snd_select

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
        mov si, offset txt_menu_highScore_text
        mov dl, 7
        mov dh, 5
        call gfx_write_s

        mov ax, highscore
        mov si, OFFSET str_menu_highScore
        call strings_word2ascii
        
        mov si, offset str_menu_highScore
        mov dl, 18
        mov dh, 11
        call gfx_write_s

        mov si, offset txt_menu_highScore_exit
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
        call play_snd_select

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
        mov cx, 160
        mov dx, 80
        int 33h
        
        draw_play_mode_menu:
        call wait_new_vr

        ;Frameskip
        mov ax, frame_counter
        mov cx, frameskip_exponent
        play_mode_frameskip_loop:
            shr ax, 1
            jc logic_play_mode_menu
            loop play_mode_frameskip_loop

        call gfx_clear_screen
    
        ;DIBUJA GAMEMODE
        mov al, 15
        mov si, 280
        mov di, 180
        mov cx, 20
        mov dx, 10
        call gfx_empty_rectangle

        ;mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 32
        mov dx, 90
        call gfx_empty_rectangle

        ;mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 121
        ;mov dx, 90
        call gfx_empty_rectangle

        ;mov al, 15
        mov si, 75
        mov di, 20
        mov cx, 211
        ;mov dx, 90
        call gfx_empty_rectangle

        ;mov al, 15
        mov si, 75
        ;mov di, 20
        mov cx, 121
        mov dx, 155
        call gfx_empty_rectangle

        ;maximos 39 columns y 24 row (wtf)
        mov si, offset txt_menu_gameMode_text
        mov dl, 8
        mov dh, 5
        call gfx_write_s

        mov si, offset txt_menu_mode1
        mov dl, 6
        mov dh, 12
        call gfx_write_s

        mov si, offset txt_menu_mode2
        mov dl, 17
        mov dh, 12
        call gfx_write_s

        mov si, offset txt_menu_mode3
        mov dl, 28
        mov dh, 12
        call gfx_write_s

        mov si, offset txt_menu_mode0
        mov dl, 17
        mov dh, 20
        call gfx_write_s

        call draw_cursor

        ;Parte de la logica (colisiones y asignar)
        ;call mouse_control

        logic_play_mode_menu:
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

        inc frame_counter ;Esto para que funcione el frameskip (frame_counter es reseteado con la funcion game_reset)

        jmp draw_play_mode_menu

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
        call play_snd_select

        ;call mouse_control
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

end