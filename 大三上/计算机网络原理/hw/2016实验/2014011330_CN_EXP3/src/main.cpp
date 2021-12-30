#include "Server.h"
#include "Client.h"
#include <cstdio>
#include <cstdlib>

int main(int argc, char** argv) {
    if (argc == 1) {
        printf("Usage: ftp.out server | ftp.out client SERVER_IP\n");
        return 0;
    }
    if (argv[1][0] == 's' || argv[1][0] == 'S') {
        ftp::Server ftpServer;
        if (argc == 3)
            ftpServer.startService((short) atoi(argv[2]));
        else
            ftpServer.startService();
    } else {
        ftp::Client ftpClient;
        if (argc == 4)
            ftpClient.startInteractive(argv[2], atoi(argv[3]));
        else
            ftpClient.startInteractive(argv[2]);
    }
    return 0;
}