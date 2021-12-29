//
// Created by jameshuang on 16-12-13.
//

#ifndef FTP_SERVER_CLIENT_H
#define FTP_SERVER_CLIENT_H

#include <string>
#include "const.h"

namespace ftp {

class Client {

    std::string receiveLeft;

    int command_socket_fd;
    int data_socket_fd;

    int data_connection_fd;

    int data_passive_socket_fd;

    unsigned short local_data_port;

    unsigned int local_ip;

    bool passive_mode;

    bool authenticated;

    FtpResponseCode receiveMessage(std::string& msg);

    void sendCommand(const std::string& cmd);

    void setupDataLink();
    void tearDownDataLink();

    void processUserCommand(const std::string& arg);
    void processPassCommand(const std::string& arg);
    void processHelpCommand(const std::string& arg);
    void processListCommand(const std::string& arg);
    void processQuitCommand(const std::string& arg);
    void processRetrieveCommand(const std::string& arg);
    void processStoreCommand(const std::string& arg);
    void processHaltCommand(const std::string& arg);
    void processCDCommand(const std::string& arg);
    void processPWDCommand(const std::string& arg);

    void sendViaDataConnection(std::istream& istream);
    void receiveViaDataConnection(std::ostream& ostream);

public:
    Client();
    void startInteractive(const std::string& ipAddr, int localDataPort = FTP_CLIENT_DATA_PORT);
};

}


#endif //FTP_SERVER_CLIENT_H
