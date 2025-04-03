format ELF64 executable

;; equ marks a compile time constant
SYS_WRITE equ 1
SYS_EXIT equ 60
SYS_SOCKET equ 41

AF_INET equ 2
SOCK_STREAM equ 1

STDOUT equ 1
STDERR equ 2

EXIT_SUCCESS equ 0
EXIT_FAILURE equ 1

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

    write STDOUT, start, start_len
    write STDOUT, socket_trace_msg, socket_trace_msg_len
    socket AF_INET, SOCK_STREAM, 0
    cmp rax, 0 ;; compares value of rax to 0
    jl error ;; jump if its less then 0 to error
    mov dword [sockfd], eax ;; move file descriptor of socket from eax register to sockfd
    ;; dword indicates a 32-bit write to prevent overwriting
    write STDOUT, ok_msg, ok_msg_len
    exit 0

error:
    write STDERR, error_msg, error_msg_len
    exit 1

segment readable writeable
sockfd dd 0
start db "INFO: Starting Web Server!", 10
start_len = $ - start
ok_msg db "INFO: OK!", 10
ok_msg_len = $ - ok_msg
socket_trace_msg db "INFO: Creating Socket...", 10
socket_trace_msg_len = $ - socket_trace_msg
error_msg db "INFO: ERROR!", 10
error_msg_len = $ - error_msg
