# simpleFTP
A simple Ftp server and client with reduced instructions implemented
Unix socket interface is used.

## Compile
	make

## Run

If you want to run the server, please enter:
	./main.out server

If you want to run the client, please enter:
	./main.out client \[ip address\] \[port\]

Notice the default port for the server is not 21 due to security considerations.
Change relevant fields in const.h and use sudo to run the server.
