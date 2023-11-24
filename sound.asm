
; ------------------------------------------------------------------
; http://muruganad.com/8086/8086-assembly-language-program-to-play-sound-using-pc-speaker.html
; os_play_sound -- Play a single tone using the pc speaker
; IN: CX = tone, BX = duration

;EN EL MAIN

;mov cx, 9121
;mov bx, 25
;call play

  ; sii dw 2415  
  ; la  dw 2711  
  ; sol dw 3043  
  ; fa  dw 3416  
  ; mi  dw 3619  
  ; re  dw 4061  
  ; do  dw 4560  
  
  ; F_low dw 6833
  ; Fsh_low dw 6449
  ; Gsh_low dw 5746
  ; Ash_low dw 5119

  ; C dw 4560
  ; Csh dw 4304
  ; D dw 4063
  ; Dsh dw 3834
  ; E dw 3619
  ; F dw 3416
  ; Fsh dw 3224
  ; G dw 3043
  ; Gsh dw 2873
    

.8086
.model small
.stack 100h
.data

.code

public play
play proc
    play:
    push ax
    push cx
    push bx
    mov     ax, cx

    out     42h, al
    mov     al, ah
    out     42h, al
    in      al, 61h

    or      al, 00000011b
    out     61h, al

    pause1:
        mov cx, 65535

    pause2:
        dec cx
        jne pause2
        dec bx
        jne pause1

        in  al, 61h
        and al, 11111100b
        out 61h, al
        
    pop bx
    pop cx
    pop ax

    ret
play endp

public play_snd_hit
play_snd_hit proc
    xor cx,cx
    mov cx, 1200       
    mov bx, 30
    call play

    xor cx,cx
    xor bx, bx
    mov cx, 1560      
    mov bx, 25
    call play

    ret 
play_snd_hit endp

public play_snd_miss
play_snd_miss proc
    xor cx,cx
    xor bx,bx
    mov cx, 9340
    mov bx, 35
    call play

    xor cx,cx
    xor bx,bx
    mov cx, 8450
    mov bx, 25
    call play

    ret
play_snd_miss endp

public play_snd_bounce
play_snd_bounce proc
    xor cx,cx
    xor bx,bx
    mov cx, 8000
    mov bx, 20
    call play

    ret
play_snd_bounce endp

end