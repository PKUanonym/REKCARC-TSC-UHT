//
// Created by jameshuang on 16-12-13.
//

#include "Client.h"
#include "const.h"
#include <cstdio>
#include <cstring>
#include <sstream>
#include <netinet/in.h>
#include <unistd.h>
#include <iostream>
#include <fstream>
using namespace std;

ftp::Client::Client() {
    command_socket_fd = -1;
    data_connection_fd = -1;
    data_socket_fd = -1;
    authenticated = false;
//    receiveLeft.clear();
    passive_mode = false;
}

void ftp::Client::startInteractive(const std::string &ipAddr, int port) {
    printf("Welcome to FTP client interactive console v1.0!\n");
    printf("Now connecting to localhost on port %d...\n", FTP_COMMAND_PORT);
    int ipOp[4];
    str_vec ipSplit;
    stringSplit(ipAddr, ".", &ipSplit);
    for (int i = 0; i < 4; ++i) {
        ipOp[i] = atoi(ipSplit[i].c_str());
    }

    in_addr_t rawIp = (in_addr_t) ((ipOp[0] << 24) + (ipOp[1] << 16) +
                                   (ipOp[2] << 8) + (ipOp[3]));

    sockaddr_in connectLocation;
    memset(&connectLocation, 0, sizeof(connectLocation));

    connectLocation.sin_family = AF_INET;
    connectLocation.sin_port = htons(FTP_COMMAND_PORT);
    connectLocation.sin_addr.s_addr = htonl(rawIp);

    if ((command_socket_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("Cannot create local socket.");
        exit(0);
    }

    if (connect(command_socket_fd,
                (sockaddr *) &connectLocation,
                sizeof(connectLocation)) < 0) {
        printf("Cannot connect. Verify your IP address.\n");
        return;
    }
    local_ip = connectLocation.sin_addr.s_addr;

    data_socket_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
    sockaddr_in servaddr;
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);

    local_data_port = (unsigned short) port;
    servaddr.sin_port = htons(local_data_port);

    if (bind(data_socket_fd, (sockaddr *) &servaddr, sizeof(servaddr)) < 0) {
        printf("Cannot Bind data socket.\n");
        return;
    }

    if (listen(data_socket_fd, 10) < 0) {
        printf("Cannot listen on data port.\n");
        return;
    }
    std::string msg;
    FtpResponseCode responseCode = receiveMessage(msg);
    if (responseCode == SERVICE_READY) printf("Server working normally.\n");

    while (true) {
        printf("$ ");
        std::string userCommand;
        getline(std::cin, userCommand);
        unsigned long sPos = userCommand.find_first_of(" ");
        std::string program = userCommand.substr(0, sPos);
        std::string argument;
        if (sPos != std::string::npos)
            argument = userCommand.substr(sPos + 1);

        if (!authenticated) {
            if (program == "user") processUserCommand(argument);
            else if (program == "pass") processPassCommand(argument);
            else if (program == "quit") break;
            else {
                printf("LOCAL: Not authenticated.\n");
            }
        } else {
            if (program == "help") processHelpCommand(argument);
            else if (program == "ls") processListCommand(argument);
            else if (program == "get") processRetrieveCommand(argument);
            else if (program == "put") processStoreCommand(argument);
            else if (program == "pwd") processPWDCommand(argument);
            else if (program == "cd") processCDCommand(argument);
            else if (program == "passive") {
                if (argument == "on") {
                    passive_mode = true;
                    cout << "LOCAL: Passive mode on.\n";
                } else if (argument == "off") {
                    passive_mode = false;
                    cout << "LOCAL: Passive mode off.\n";
                } else {
                    cout << "LOCAL: Unrecognized param.\n";
                }
            }
            else if (program == "help" || program == "?") processHelpCommand(argument);
            else if (program == "quit") {
                processQuitCommand(argument);
                break;
            }
            else if (program == "halt") {
                processHaltCommand(argument);
                break;
            }
        }

    }
    close(command_socket_fd);
    close(data_socket_fd);
    printf("Session Ended.\n");
}

void ftp::Client::sendCommand(const std::string &cmd) {
    std::string resp = cmd + TCP_DELIMITER;
    send(command_socket_fd, resp.c_str(), resp.size(), 0);
}

void ftp::Client::setupDataLink() {

    if (passive_mode) {
        sendCommand("PASV");
        string msg;
        FtpResponseCode code = receiveMessage(msg);

        unsigned long sPos = msg.find_first_of("(");
        unsigned long ePos = msg.find_first_of(")");

        msg = msg.substr(sPos + 1, ePos - sPos - 1);

        int portOp[6];
        str_vec msgSp;
        stringSplit(msg, ",", &msgSp);

        for (int i = 0; i < 6; ++i) {
            portOp[i] = atoi(msgSp[i].c_str());
            cout << portOp[i] << endl;
        }

        in_addr_t ipAddr = (in_addr_t) ((portOp[0] << 24) + (portOp[1] << 16) +
                                        (portOp[2] << 8) + (portOp[3]));
        in_port_t inPort = (in_port_t) ((portOp[4] << 8) + portOp[5]);

        cout << "recv = " << inPort << endl;

        sockaddr_in portLocation;

        memset(&portLocation, 0, sizeof(portLocation));

        portLocation.sin_family = AF_INET;
        portLocation.sin_port = htons(inPort);
        portLocation.sin_addr.s_addr = htonl(ipAddr);

        if ((data_passive_socket_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
            cout << "Socket create error." << endl;
        }

        if ((connect(data_passive_socket_fd, (sockaddr *) &portLocation, sizeof(portLocation))) < 0) {
            cout << "Connect error." << errno << endl;
        }
        cout << "Connection Established." << endl;

    } else {
        sockaddr_in servaddr;
        memset(&servaddr, 0, sizeof(servaddr));

        socklen_t m;
        bind(data_socket_fd, (sockaddr *) &servaddr, sizeof(servaddr));
        getsockname(data_socket_fd, (sockaddr *) &servaddr, &m);

        unsigned int localIP = local_ip;
        unsigned short localPort = local_data_port; //ntohs(servaddr.sin_port);

        std::cout << localPort << std::endl;

        std::string portStr = std::to_string(localIP & 0xFF) + "," +
                              std::to_string((localIP >> 8) & 0xFF) + "," +
                              std::to_string((localIP >> 16) & 0xFF) + "," +
                              std::to_string((localIP >> 24) & 0xFF) + "," +
                              std::to_string((localPort >> 8) & 0xFF) + "," +
                              std::to_string(localPort & 0xFF);

        sendCommand("PORT " + portStr);

        listen(data_socket_fd, 10);
        data_connection_fd = accept(data_socket_fd, (sockaddr *) NULL, NULL);
    }

}

ftp::FtpResponseCode ftp::Client::receiveMessage(std::string &msg) {

    char buffer[COMMAND_BUFFER_SIZE];
    int n = (int) recv(command_socket_fd, buffer, COMMAND_BUFFER_SIZE, 0);
    if (n < 0) {
        printf("Connection Lost.\n");
        exit(0);
    }
    buffer[n] = 0;
    msg = buffer;
    msg = receiveLeft + msg;
    unsigned long dPos = msg.find_first_of(TCP_DELIMITER);

    if (dPos + 2 < n) receiveLeft = msg.substr(dPos + 2);
    else receiveLeft = "";

    msg = msg.substr(0, dPos);
    unsigned long sPos = msg.find_first_of(" ");
    printf("%s\n", ("SERVER: " + msg).c_str());
    return convertToFtpResponseCode(atoi(msg.substr(0, sPos).c_str()));
}

void ftp::Client::processUserCommand(const std::string& arg) {
    sendCommand("USER " + arg);
    std::string msg;
    FtpResponseCode responseCode = receiveMessage(msg);
}

void ftp::Client::processPassCommand(const std::string& arg) {
    sendCommand("PASS " + arg);
    std::string msg;
    FtpResponseCode responseCode = receiveMessage(msg);
    if (responseCode == WELCOME) authenticated = true;
}

void ftp::Client::processHelpCommand(const std::string& arg) {
    sendCommand("HELP");
    std::string msg;
    FtpResponseCode responseCode = receiveMessage(msg);
}

void ftp::Client::processListCommand(const std::string& arg) {
    std::string msg;
    FtpResponseCode responseCode;

    setupDataLink();
    responseCode = receiveMessage(msg);

    sendCommand("LIST " + arg);

    std::ostringstream ostr;
    receiveViaDataConnection(ostr);

    responseCode = receiveMessage(msg);

    std::cout << ostr.str();
    tearDownDataLink();

}

void ftp::Client::processQuitCommand(const std::string& arg) {
    sendCommand("QUIT");
    std::string msg;
    receiveMessage(msg);
}

void ftp::Client::processHaltCommand(const std::string& arg) {
    sendCommand("HALT");
}

void ftp::Client::receiveViaDataConnection(std::ostream &ostream) {
    int connect_id = (passive_mode)? data_passive_socket_fd : data_connection_fd;
    fileTrunk* ft = new fileTrunk();

    unsigned int sizeToRead;
    do {
        recv(connect_id, ft, 4, 0);
        sizeToRead = ntohl(ft->size);

        unsigned int leftSizeToRead = sizeToRead;
        unsigned int payloadOffset = 0;

        while (leftSizeToRead != 0) {
            unsigned int realSizeRead = recv(connect_id,
                                             ft->payload + payloadOffset, leftSizeToRead, 0);
            leftSizeToRead -= realSizeRead;
            payloadOffset += realSizeRead;
        }

        ostream.write(ft->payload, sizeToRead);
    } while (sizeToRead == FILE_TRANSFER_BUFFER);

    delete ft;
}

void ftp::Client::tearDownDataLink() {
    if (passive_mode) close(data_passive_socket_fd);
    else close(data_connection_fd);
}

void ftp::Client::sendViaDataConnection(std::istream &istream) {

    int connect_id = (passive_mode)? data_passive_socket_fd : data_connection_fd;

    fileTrunk* ft = new fileTrunk();
    ft->size = htonl(FILE_TRANSFER_BUFFER);
    istream.seekg(0, istream.beg);

    while (true) {
        istream.read(ft->payload, FILE_TRANSFER_BUFFER);
        if (istream.eof()) {
            unsigned int sendSize = (unsigned int) istream.gcount();
            ft->size = htonl(sendSize);
            send(connect_id, ft, sendSize + 4, 0);
            break;
        }
        send(connect_id, ft, FILE_TRANSFER_BUFFER + 4, 0);
    }

    delete ft;
}

void ftp::Client::processRetrieveCommand(const std::string &arg) {
    std::string msg;
    FtpResponseCode responseCode;

    setupDataLink();
    responseCode = receiveMessage(msg);

    sendCommand("RETR " + arg);

    responseCode = receiveMessage(msg);

    if (responseCode == DATA_CONNECTION_OPEN_TRANSFER_START) {
        std::ofstream fout(arg, std::ios::binary);
        receiveViaDataConnection(fout);

        responseCode = receiveMessage(msg);
        fout.close();
    }

    tearDownDataLink();

}

void ftp::Client::processCDCommand(const std::string &arg) {
    sendCommand("CWD " + arg);
    std::string msg;
    receiveMessage(msg);
}

void ftp::Client::processPWDCommand(const std::string &arg) {
    sendCommand("PWD");
    std::string msg;
    receiveMessage(msg);
}

void ftp::Client::processStoreCommand(const std::string &arg) {


    std::ifstream fin(arg, std::ios::binary);
    if (!fin) {
        std::cout << "LOCAL: No such file or directory." << std::endl;
        return;
    }

    std::string msg;
    FtpResponseCode responseCode;

    setupDataLink();
    responseCode = receiveMessage(msg);

    sendCommand("STOR " + arg);

    responseCode = receiveMessage(msg);

    if (responseCode == DATA_CONNECTION_OPEN_TRANSFER_START) {
        sendViaDataConnection(fin);

        responseCode = receiveMessage(msg);
    }

    fin.close();
    tearDownDataLink();
}
