format ELF64 executable

print:
    mov     r9, -3689348814741910323
    sub     rsp, 40
    mov     BYTE [rsp+31], 10
    lea     rcx, [rsp+30]
.L2:
    mov     rax, rdi
    lea     r8, [rsp+32]
    mul     r9
    mov     rax, rdi
    sub     r8, rcx
    shr     rdx, 3
    lea     rsi, [rdx+rdx*4]
    add     rsi, rsi
    sub     rax, rsi
    add     eax, 48
    mov     BYTE [rcx], al
    mov     rax, rdi
    mov     rdi, rdx
    mov     rdx, rcx
    sub     rcx, 1
    cmp     rax, 9
    ja      .L2
    lea     rax, [rsp+32]
    mov     edi, 1
    sub     rdx, rax
    xor     eax, eax
    lea     rsi, [rsp+32+rdx]
    mov     rdx, r8
    mov     rax, 1
    syscall
    add     rsp, 40
    ret

entry main
main:
    mov rdi, 69
    call print
;;    ;; int3 sets entry point for debugging
;;    mov r15, 10
;; .again:
;;    cmp r15, 0
;;    jle .over ;; jump when less or equal to 0
;;        mov rax, 1
;;        mov rdi, 1
;;        mov rsi, my_msg
;;        mov rdx, my_msg_len
;;        syscall
;;        dec r15
;;    jmp .again
;;
;; .over:
   mov rax, 60
   mov rdi, 0
   syscall

msg db "Hello World!", 10
msg_len = $ - msg

my_msg: file "./message.txt"
my_msg_len = $ - my_msg
