format ELF64 executable

SYS_WRITE = 1
SYS_EXIT = 60
SYS_SOCKET = 41

AF_INET = 2
SOCK_STREAM = 1

macro write fd, buf, count
{
    mov rax, SYS_WRITE
    mov rdi, fd
    mov rsi, buf
    mov rdx, count
    syscall
}

;; int socket(int domain, int type, int protocol)
macro socket domain, type, protocol
{
    mov rax, SYS_SOCKET
    mov rdi, domain
    mov rsi, type
    mov rdx, protocol
    syscall
}

macro exit code
{
    mov rax, SYS_EXIT
    mov rdi, code
    syscall
}

segment readable executable
entry main
main:

    write 1, start, start_len
    socket AF_INET, SOCK_STREAM, 0
    mov dword [sockfd], eax ;; move file descriptor of socket from eax register to sockfd
    ;; dword indicates a 32-bit write
    exit 0

segment readable writeable
sockfd dd 0
start db "Hello Web Server!", 10
start_len = $ - start
