format ELF64 executable

SYS_WRITE = 1
SYS_EXIT = 60
X = 1

macro write fd, buf, count
{
    ; 1 = number of syscall write
    ; rax register syscall, rdi, rsi and rdx register for parameters
    mov rax, SYS_WRITE
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
    mov rax, SYS_EXIT
    ; mov rdi register for exit code (0)
    mov rdi, code
    syscall
}

X = X + 2

segment readable executable
entry main
main:
repeat X
    write 1, msg, msg_len
end repeat
    exit 0

segment readable writeable
msg db "Hello World!", 10
; 10 = ASCII value for LINEFEED
msg_len = $ - msg
