format ELF64 executable

macro write fd, buf, count
{
    ; 1 = number of syscall write
    ; rax register syscall, rdi, rsi and rdx register for parameters
    mov rax, 1
    ; standard output 1
    mov rdi, fd
    ; message to write
    mov rsi, buf
    ; size of the buffer 13 character plus new line = 14
    mov rdx, count
    syscall
}

macro exit code
{
    ; second syscall to exit
    mov rax, 60
    ; mov rdi register for exit code (0)
    mov rdi, code
    syscall
}

segment readable executable
entry main
main:
    write 1, msg, msg_len
    exit 0

segment readable writeable
msg db "Hello, World!", 10
msg_len = $ - msg
