%include "./pc_io.inc"

section .data
    msg: db 'Ingrese dos digitos: (0-9)',0
    len: equ $-msg
    multip: db '--------------- Multiplicación',0
    divi: db '--------------- División',0
    cont: db '--------------- Contador 2 en 2',0

section .bss
    num resb 1
    num2 resb 1
    cad resb 12
    res resb 10

global _start
    section .text

_start:

    call salto

    ;------------------------------------------ Imprime para pedir los digitos

    mov edx, msg
    call puts

    call salto

    ;------------------------------------------ Captura el primer digito

    call getch
    sub al, 48
    call salto
    mov esi, cad
    call printHex

    ;------------------------------------------ Guarda el primer digito

    mov ebx, num
    mov [ebx],al

    ;------------------------------------------ Muestra el digito

    call putchar
    call salto

    ;------------------------------------------ Captura el segundo digito

    call getch
    sub al, 48
    call salto
    mov esi, cad
    call printHex

    call putchar
    call salto

    ; ------------------------------ ebx --> numero 1
    ; ------------------------------ eax --> numero 2
    call salto
    mov edx, multip
    call puts
    call salto

    mov cx, [ebx]
    mov byte [ebx], 0  ; inicializar resultado en 0

    multi:
        add [ebx], al
        call salto
        mov esi, res
        call printHex
    loop multi

    call salto
    call salto
    mov dl, al
    mov al, [ebx]
    mov esi, res
    call printHex
    mov al, dl
    call salto

    call salto
    mov edx, divi
    call puts
    call salto

    div:
      sub [ebx], al
      call salto
      mov dl, al
      mov al, [ebx]
      mov esi, res
      call printHex
      mov al, dl
      add ecx, 1
      cmp byte [ebx], 0
      je fin
    jmp div

  fin:
    call salto
    call salto
    mov al, cl
    mov esi, res
    call printHex
    call salto
    call salto

  mov edx, cont
  call puts
  call salto
  call salto

  mov ecx, 0
    contador2_2:
      add ecx, 2
      mov al, cl
      mov esi, res
      call printHex
      call salto
      cmp ecx, 100
      je termina
    jmp contador2_2

    termina:
      mov eax, 1         ; sys_exit syscall
      mov ebx, 0         ; return 0 (todo correcto)
      int 80h

    ; sys_exit(return_code)
    mov eax, 1         ; sys_exit syscall
    mov ebx, 0         ; return 0 (todo correcto)
    int 80h

salto:
    pushad
    mov al, 13
    call putchar
    mov al, 10
    call putchar 
    popad  
    ret

printHex:
  pushad
  mov edx, eax
  mov ebx, 0fh
  mov cl, 28
.nxt: shr eax,cl
.msk: and eax,ebx
  cmp al, 9
  jbe .menor
  add al,7
.menor:add al,'0'
  mov byte [esi],al
  inc esi
  mov eax, edx
  cmp cl, 0
  je .print
  sub cl, 4
  cmp cl, 0
  ja .nxt
  je .msk
.print: mov eax, 4
  mov ebx, 1
  sub esi, 8
  mov ecx, esi
  mov edx, 8
  int 80h
  popad
  ret