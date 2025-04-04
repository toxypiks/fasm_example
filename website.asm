format ELF64 executable

;; equ marks a compile time constant
SYS_WRITE equ 1
SYS_EXIT equ 60
SYS_SOCKET equ 41
SYS_ACCEPT equ 43
SYS_BIND equ 49
SYS_LISTEN equ 50
SYS_CLOSE equ 3

AF_INET equ 2
SOCK_STREAM equ 1
INADDR_ANY equ 0

STDOUT equ 1
STDERR equ 2

EXIT_SUCCESS equ 0
EXIT_FAILURE equ 1

MAX_CONN equ 5

macro syscall1 number, a
{
    mov rax, number
    mov rdi, a
    syscall
}

macro syscall2 number, a, b
{
    mov rax, number
    mov rdi, a
    mov rsi, b
    syscall
}

macro syscall3 number, a, b, c
{
    mov rax, number
    mov rdi, a
    mov rsi, b
    mov rdx, c
    syscall
}

macro write fd, buf, count
{
    mov rax, SYS_WRITE
    mov rdi, fd
    mov rsi, buf
    mov rdx, count
    syscall
}

macro close fd
{
    syscall1 SYS_CLOSE, fd
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

macro bind sockfd, addr, addrlen
{
    syscall3 SYS_BIND, sockfd, addr, addrlen
}

macro listen sockfd, backlog
{
    syscall2 SYS_LISTEN, sockfd, backlog
}

macro accept sockfd, addr, addrlen
{
    syscall3 SYS_ACCEPT, sockfd, addr, addrlen
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

    write STDOUT, start, start_len
    write STDOUT, socket_trace_msg, socket_trace_msg_len
    socket AF_INET, SOCK_STREAM, 0
    cmp rax, 0 ;; compares value of rax to 0
    jl error ;; jump if its less then 0 to error
    mov qword [sockfd], rax ;; move file descriptor of socket from eax register to sockfd
    ;; dword indicates a 32-bit write to prevent overwriting

    write STDOUT, bind_trace_msg, bind_trace_msg_len
    mov word [servaddr.sin_family], AF_INET ;;word = 16 bit write
    mov word [servaddr.sin_port], 14619
    mov dword [servaddr.sin_addr], INADDR_ANY
    bind [sockfd], servaddr.sin_family, servaddr.size
    cmp rax, 0
    jl error

    write STDOUT, listen_trace_msg, listen_trace_msg_len
    listen[sockfd], MAX_CONN
    cmp rax, 0
    jl error

    write STDOUT, accept_trace_msg, accept_trace_msg_len
    accept [sockfd], cliaddr.sin_family, cliaddr.size
    cmp rax, 0
    jl error

    write STDOUT, ok_msg, ok_msg_len
    close [sockfd]
    exit 0

error:
    write STDERR, error_msg, error_msg_len
    exit 1

;; db - 1 byte
;; dw - 2 byte
;; dd - 4 bytes
;; dq - 8 bytes

segment readable writeable

struc servaddr_in
{
    .sin_family dw 0
    .sin_port   dw 0
    .sin_addr   dd 0
    .sin_zero   dq 0
    .size = $ - .sin_family
}
sockfd dq 0
servaddr servaddr_in
cliaddr servaddr_in

start db "INFO: Starting Web Server!", 10
start_len = $ - start
ok_msg db "INFO: OK!", 10
ok_msg_len = $ - ok_msg
socket_trace_msg db "INFO: Creating Socket...", 10
socket_trace_msg_len = $ - socket_trace_msg
bind_trace_msg db "INFO: Binding the Socket...", 10
bind_trace_msg_len = $ - bind_trace_msg
listen_trace_msg db "INFO: Listening to the Socket...", 10
listen_trace_msg_len = $ - listen_trace_msg
accept_trace_msg db "INFO: Waiting for client connections...", 10
accept_trace_msg_len = $ - accept_trace_msg
error_msg db "INFO: ERROR!", 10
error_msg_len = $ - error_msg
