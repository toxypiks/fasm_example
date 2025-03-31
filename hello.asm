format ELF64 executable

segment readable executable
entry main
main:
    ; 1 = number of syscall write
    ; rax register syscall, rdi, rsi and rdx register for parameters
    mov rax, 1
    ; standard output 1
    mov rdi, 1
    ; message to write
    mov rsi, msg
    ; size of the buffer 13 character plus new line = 14
    mov rdx, 14
    syscall

    ; second syscall to exit
    mov rax, 60
    ; mov rdi register for exit code (0)
    mov rdi, 0
    syscall

segment readable writeable
msg db "Hello, World!", 10
