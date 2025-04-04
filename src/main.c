#include <stdio.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void)
{
    printf("AF_INET = %d\n", AF_INET);
    printf("SOCK_STREAM = %d\n", SOCK_STREAM);
    printf("INADDR_ANY = %d\n", INADDR_ANY);
    return 0;
}
