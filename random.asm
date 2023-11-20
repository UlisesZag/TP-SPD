.8086
.model small
.stack 100h
.data
    seed db 1
    nr_random dw 3
    random_secuencia dw 4
.code
    ;Funcion que genera la seed
    public random_genero_seed
    random_genero_seed proc
        push ax
        push dx
        mov ah, 2ch
        int 21h;genera en dl un numero del time de la maquina
        mov dh,0;limpio dh por si acaso
        mov seed,dl; en dl pasa un numero que usa como semilla
        pop dx
        pop ax
        ret
    random_genero_seed endp

    ;Funcion que genera un numero random desde 0 a 65535
    ;genero_random = random_numero
    public random_numero
    random_numero proc
        ;Esta funcion lo que tiene es que si o si te devuelve en ax un numero random muy grande
        ;Osea daña la profilaxis si o si en ax --OJO--
        push dx
        push si

        mov ah, 2ch
        int 21h
        
        mov dh,0
        mov seed,dl; en dl pasa un numero que usa como semilla
        mov ah,0
        mov al, seed
        mov si, random_secuencia
        mov di, nr_random 
        int 81h; llamo la intr y me genera los datos 
        
        mov nr_random, ax
        mov random_secuencia,si
        pop si
        pop dx
    ret
    random_numero endp

    ;Funcion que devuelve el numero random anterior por di
    public random_numero_anterior
    random_numero_anterior proc
        mov di, nr_random
        ret
    random_numero_anterior endp
end
