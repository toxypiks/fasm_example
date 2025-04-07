format ELF64 executable

entry main
main:
   ;; int3 sets entry point for debugging
   mov r15, 10
.again:
   cmp r15, 0
   jle .over ;; jump when less or equal to 0
       mov rax, 1
       mov rdi, 1
       mov rsi, my_msg
       mov rdx, my_msg_len
       syscall
       dec r15
   jmp .again

.over:
   mov rax, 60
   mov rdi, 0
   syscall

msg db "Hello World!", 10
msg_len = $ - msg

my_msg: file "./message.txt"
my_msg_len = $ - my_msg
