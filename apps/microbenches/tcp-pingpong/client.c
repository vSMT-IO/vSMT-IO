/* 
 * tcpclient.c - A simple TCP client
 * usage: tcpclient <host> <port>
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 

#define BUFSIZE 1024

/* 
 * error - wrapper for perror
 */
void error(char *msg) {
    perror(msg);
    exit(0);
}

int main(int argc, char **argv) {
    int sockfd, portno, n;
    struct sockaddr_in serveraddr;
    struct hostent *server;
    char *hostname;
    char buf[BUFSIZE];

    /* check command line arguments */
    if (argc != 3) {
       fprintf(stderr,"usage: %s <hostname> <port>\n", argv[0]);
       exit(0);
    }
    hostname = argv[1];
    portno = atoi(argv[2]);

    /* socket: create the socket */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");

    /* gethostbyname: get the server's DNS entry */
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host as %s\n", hostname);
        exit(0);
    }

    /* build the server's Internet address */
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
	  (char *)&serveraddr.sin_addr.s_addr, server->h_length);
    serveraddr.sin_port = htons(portno);
	struct timeval tv_start, tv_end;
    gettimeofday(&tv_start, 0);
    /* connect: create a connection with the server */
    if (connect(sockfd, &serveraddr, sizeof(serveraddr)) < 0) 
      error("ERROR connecting");
    gettimeofday(&tv_end, 0);
    long gap = (tv_end.tv_sec - tv_start.tv_sec)*1000000 + (tv_end.tv_usec - tv_start.tv_usec);
     printf("connect time %ld\n", gap);
    /* get message line from the user */
//    printf("Please enter msg: ");
    bzero(buf, BUFSIZE);
    strcpy(buf, "message\n");
    //fgets(buf, BUFSIZE, stdin);
    long total = 0;	
    for (int i = 0;i < 10000;i++){
    /* send the message line to the server */
	    gettimeofday(&tv_start, 0);
	    n = write(sockfd, buf, strlen(buf));
	    if (n < 0) 
	      error("ERROR writing to socket");

	    /* print the server's reply */
	    bzero(buf, BUFSIZE);
	    n = read(sockfd, buf, BUFSIZE);
	    gettimeofday(&tv_end, 0);
	    if (n < 0){ 
	      error("ERROR reading from socket");
	    } else if (n == 0) {
		printf("empty response\n");
	    }
	    total += (tv_end.tv_sec - tv_start.tv_sec)*1000000 + (tv_end.tv_usec - tv_start.tv_usec);
     }
    //printf("Echo from server: %s", buf);
    printf("average time: %ld\n", total/10000);
    close(sockfd);
    return 0;
}
