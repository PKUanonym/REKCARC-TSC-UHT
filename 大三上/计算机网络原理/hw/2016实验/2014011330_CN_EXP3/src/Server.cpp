//
// Created by jameshuang on 16-12-13.
//

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <glog/logging.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <sstream>
#include <fstream>
#include <thread>
#include "Server.h"
#include "const.h"
using namespace std;

using std::memset;

int ftp::Server::command_socket_fd;

void ftp::Server::startService(short port) {

    google::InitGoogleLogging("Ftp_Server");
    google::SetStderrLogging(google::INFO);

    // Initialize Socket.
    if ((command_socket_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP)) == -1) {
        LOG(FATAL) << "Socket init error.";
        exit(0);
    }

    sockaddr_in servaddr;
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons((uint16_t) port);

    if (bind(command_socket_fd, (sockaddr *) &servaddr, sizeof(servaddr)) == -1) {
        LOG(FATAL) << "Socket bind error.";
        exit(0);
    }

    if (listen(command_socket_fd, 10) == -1) {
        LOG(FATAL) << "Listen error.";
        exit(0);
    }

    vector<thread*> instanceThreads;
    vector<ServerInstance*> instancePool;

    int inst_cur_id = 0;

    LOG(INFO) << "Init Complete. Waiting for connections";
    while (true) {
        int command_connection_fd;

        if ((command_connection_fd = accept(command_socket_fd, (sockaddr *) NULL, NULL)) == -1) {
            LOG(INFO) << "An incoming request accept error. Denying.";
            continue;
        }

        ServerInstance* instance = new ServerInstance(command_connection_fd, inst_cur_id ++);
        thread* t = new thread(&ServerInstance::startService, instance);

        instanceThreads.push_back(t);
        instancePool.push_back(instance);

        if (inst_cur_id == 100) break;
    }

    close(command_socket_fd);
    google::ShutdownGoogleLogging();
}

int ftp::ServerInstance::executeCommand(const std::string &cmd) {
    std::vector<std::string> splitResult;
    stringSplit(cmd, " ", &splitResult);

    FtpCommand ftpCommand = convertToFtpCommand(splitResult[0]);

    if (ftpCommand != USER && ftpCommand != PASS && !current_user_authorized) {
        issueCommandResponse(PERMISSION_DENIED, "Permission denied");
        return -1;
    }

    switch (ftpCommand) {
        case RESERVED:
            issueCommandResponse(COMMAND_NOT_IMPLEMENTED, "Command not implemented.");
            break;
        case STRU:
        case NOOP:
        case MODE:
            issueCommandResponse(COMMAND_OK, "Command OK.");
        case USER:
            processUserCommand(splitResult);
            break;
        case PASS:
            processPasswordCommand(splitResult);
            break;
        case LIST:
            processListCommand(splitResult);
            break;
        case PASV:
            processPassiveCommand(splitResult);
            break;
        case PORT:
            processPortCommand(splitResult);
            break;
        case RETRIEVE: {
            thread t(&ServerInstance::processRetrieveCommand, this, splitResult);
            t.detach();
            break;
        }
        case STORE: {
            thread t(&ServerInstance::processStoreCommand, this, splitResult);
            t.detach();
            break;
        }
        case PWD:
            processPWDCommand(splitResult);
            break;
        case CWD:
            processCWDCommand(splitResult);
            break;
        case HELP:
            processHelpCommand(splitResult);
            break;
        case SYST:
            issueCommandResponse(NAME_SYS_TYPE, "UNIX Type: L8");
            break;
        case TYPE:
            issueCommandResponse(COMMAND_OK, "Type set to: Binary.");
            break;
        case QUIT:
            issueCommandResponse(SERVICE_CLOSE, "goodbye!");
            return -1;
        case HALT:
            return 1;
        default:
            return -1;
    }

    return 0;
}

void ftp::ServerInstance::issueCommandResponse(ftp::FtpResponseCode code,
                                       const std::string &info) {
    std::string buffer = std::to_string((int) code) + " " + info + TCP_DELIMITER;
    LOG(INFO) << "SEND " << buffer << "to instance " << instance_id;
    send(command_connection_fd, buffer.c_str(), buffer.size(), 0);
}

bool ftp::ServerInstance::processRetrieveCommand(const ftp::str_vec &info) {
    std::ifstream fin(FTP_BASE_DIR + working_dir + '/' + info[1], std::ios::binary);
    if (fin) {
        issueCommandResponse(DATA_CONNECTION_OPEN_TRANSFER_START, "Data connection already open. Transfer starting.");
        sendViaDataConnection(fin);
        fin.close();
        issueCommandResponse(TRANSFER_COMPLETE, "Transfer complete.");
        closeDataConnection();
    } else {
        issueCommandResponse(FILE_UNAVAILABLE, "No such file or directory.");
        closeDataConnection();
    }

    return true;
}

bool ftp::ServerInstance::processStoreCommand(const ftp::str_vec &info) {
    std::ofstream fout(FTP_BASE_DIR + working_dir + '/' + info[1], std::ios::binary);
    issueCommandResponse(DATA_CONNECTION_OPEN_TRANSFER_START, "Data connection already open. Transfer starting.");
    receiveViaDataConnection(fout);
    issueCommandResponse(TRANSFER_COMPLETE, "Transfer complete.");
    return true;
}

bool ftp::ServerInstance::processPWDCommand(const ftp::str_vec &info) {
    issueCommandResponse(PATHNAME_CREATED, "'" + working_dir + "' is the current directory.");
    return true;
}

bool ftp::ServerInstance::processCWDCommand(const ftp::str_vec &info) {
    std::string req = info[1];
    LOG(INFO) << info[1];
    LOG(INFO) << working_dir;
    if (req[0] == '/') working_dir = req;
    else {
        if (req.at(req.size() - 1) != '/') req = req + '/';

        while (req.size() != 0) {
            if (req.size() >= 2 && req[0] == '.' && req[1] == '.') {
                DirUtil::getParent(working_dir, req);
            } else if (req[0] == '.') {
                DirUtil::getCurrent(working_dir, req);
            } else {
                DirUtil::getInto(working_dir, req);
            }
        }

    }
    issueCommandResponse(FILE_COMMAND_OK, "'" + working_dir + "' is the current directory.");
    return true;
}

bool ftp::ServerInstance::processListCommand(const ftp::str_vec &info) {
    std::string lsOp = FTP_BASE_DIR + working_dir;
    if (info.size() != 1) lsOp += info[1];
    std::string lsRes = unixOperation("ls " + lsOp + " -l");
    std::istringstream lsStream(lsRes);
    sendViaDataConnection(lsStream);
    // via command connection
    issueCommandResponse(TRANSFER_COMPLETE, "Transfer complete.");
    closeDataConnection();
    return true;
}

bool ftp::ServerInstance::processPortCommand(const ftp::str_vec &info) {
    passive_mode = false;
    int portOp[6];
    str_vec portSplit;
    stringSplit(info[1], ",", &portSplit);

    for (int i = 0; i < 6; ++i) {
        portOp[i] = atoi(portSplit[i].c_str());
    }

    in_addr_t ipAddr = (in_addr_t) ((portOp[0] << 24) + (portOp[1] << 16) +
                                    (portOp[2] << 8) + (portOp[3]));
    in_port_t inPort = (in_port_t) ((portOp[4] << 8) + portOp[5]);

    sockaddr_in portLocation;

    memset(&portLocation, 0, sizeof(portLocation));

    portLocation.sin_family = AF_INET;
    portLocation.sin_port = htons(inPort);
    portLocation.sin_addr.s_addr = htonl(ipAddr);
    openDataConnection(portLocation);

    issueCommandResponse(COMMAND_OK, "Active data connection established.");

    return true;
}

ftp::ServerInstance::ServerInstance(int ccf, int id) {
    command_connection_fd = ccf;
    data_socket_fd = -1;
    instance_id = id;

    current_user_authorized = false;
    current_user_ok = false;
    working_dir = "/";

    passive_mode = false;
}

void ftp::ServerInstance::openDataConnection(const sockaddr_in &sock_addr) {

    if ((data_socket_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        LOG(FATAL) << "Create data socket error!";
        exit(0);
    }

    if (connect(data_socket_fd, (sockaddr *) &sock_addr, sizeof(sock_addr)) < 0) {
        LOG(WARNING) << "Failed to connect to client via data link.";
        return;
    }

}

void ftp::ServerInstance::closeDataConnection() {
    if (data_socket_fd == -1) return;
    close(data_socket_fd);
    if (passive_mode) {
        close(data_passive_socket_fd);
        close(data_connection_fd);
    }
}

std::string ftp::ServerInstance::unixOperation(const std::string& command) {
    FILE *fstream = popen(command.c_str(), "r");
    char buff[UNIX_OPERATION_BUFFER];
    memset(buff, 0, sizeof(char) * UNIX_OPERATION_BUFFER);
    fread(buff, UNIX_OPERATION_BUFFER, 1, fstream);
    pclose(fstream);
    return std::string(buff);
}

bool ftp::ServerInstance::processUserCommand(const ftp::str_vec &info) {
    if (info[1] == ADMIN_NAME) {
        issueCommandResponse(USER_NAME_OK_NEED_PASS, "Username ok, send password.");
        current_user_ok = true;
        return true;
    } else {
        issueCommandResponse(PERMISSION_DENIED, "No such user.");
    }
    return false;
}

bool ftp::ServerInstance::processPasswordCommand(const ftp::str_vec &info) {
    if (!current_user_ok) return false;
    if (info[1] == ADMIN_PASS) {
        issueCommandResponse(WELCOME, "welcome, admin!");
        current_user_authorized = true;
        return true;
    }
    issueCommandResponse(PERMISSION_DENIED, "Permission denied");
    return false;
}

void ftp::ServerInstance::sendViaDataConnection(std::istream &istream) {

    int real_fd = passive_mode ? data_connection_fd : data_socket_fd;

    LOG(INFO) << "Start transferring data";

    fileTrunk* ft = new fileTrunk();
    ft->size = htonl(FILE_TRANSFER_BUFFER);
    istream.seekg(0, istream.beg);

    while (true) {
        istream.read(ft->payload, FILE_TRANSFER_BUFFER);
        if (istream.eof()) {
            unsigned int sendSize = (unsigned int) istream.gcount();
            LOG(INFO) << sendSize;
            ft->size = htonl(sendSize);
            send(real_fd, ft, sendSize + 4, 0);
            break;
        }
        send(real_fd, ft, FILE_TRANSFER_BUFFER + 4, 0);
    }

    delete ft;

    LOG(INFO) << "Data transfer complete.";

}

void ftp::ServerInstance::receiveViaDataConnection(std::ostream &ostream) {

    int real_fd = passive_mode ? data_connection_fd : data_socket_fd;

    fileTrunk* ft = new fileTrunk();

    unsigned int sizeToRead;
    do {
        recv(real_fd, ft, 4, 0);
        sizeToRead = ntohl(ft->size);

        unsigned int leftSizeToRead = sizeToRead;
        unsigned int payloadOffset = 0;

        while (leftSizeToRead != 0) {
            unsigned int realSizeRead = recv(real_fd,
                                             ft->payload + payloadOffset, leftSizeToRead, 0);
            leftSizeToRead -= realSizeRead;
            payloadOffset += realSizeRead;
        }

        ostream.write(ft->payload, sizeToRead);
    } while (sizeToRead == FILE_TRANSFER_BUFFER);

    delete ft;
}

bool ftp::ServerInstance::processHelpCommand(const ftp::str_vec &info) {
    issueCommandResponse(HELP_MESSAGE, FTP_HELP_MSG);
    return false;
}

void ftp::ServerInstance::startService() {
    issueCommandResponse(SERVICE_READY, SERVER_NAME + " ready.");

    bool isStopServer = false;
    current_user_authorized = false;
    current_user_ok = false;
    std::string buffer_left;

    while (true) {
        int n;
        char buffer[COMMAND_BUFFER_SIZE];
        n = (int) recv(command_connection_fd, buffer, COMMAND_BUFFER_SIZE, 0);
        buffer[n] = 0;
        buffer_left = buffer_left + buffer;
        bool outer_break = false;

        while (true) {
            unsigned long sp_pos = buffer_left.find_first_of(TCP_DELIMITER);
            if (sp_pos == std::string::npos) break;

            std::string cmd = buffer_left.substr(0, sp_pos);
            buffer_left = buffer_left.substr(sp_pos + 2);

            LOG(INFO) << cmd << " Received on thread No:" << instance_id;
            int returnAction = executeCommand(cmd);

            if (returnAction == 1) isStopServer = true;

            if (returnAction != 0) {
                close(command_connection_fd);
                outer_break = true;
                break;
            }

        }

        if (outer_break) break;

    }

    if (isStopServer) {
        close(Server::command_socket_fd);
        exit(0);
    }
}

bool ftp::ServerInstance::processPassiveCommand(const ftp::str_vec &info) {
    passive_mode = true;

    data_passive_socket_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);

    sockaddr_in passiveInSoc;
    memset(&passiveInSoc, 0, sizeof(passiveInSoc));

    passiveInSoc.sin_family = AF_INET;
    passiveInSoc.sin_addr.s_addr = htonl(INADDR_ANY);

    unsigned short sessionPort;

    while (true) {
        sessionPort = getRandomPassiveServerPort();
        passiveInSoc.sin_port = htons((uint16_t) sessionPort);
        if (bind(data_passive_socket_fd, (sockaddr *) &passiveInSoc, sizeof(passiveInSoc)) >= 0)
            break;
        else
            LOG(INFO) << "Bind port on random " << sessionPort << " Failed";
    }

    LOG(INFO) << "Binded " << sessionPort;

    std::string portStr = FTP_NAT_IP + "," +
                          std::to_string((sessionPort >> 8) & 0xFF) + "," +
                          std::to_string(sessionPort & 0xFF);

    issueCommandResponse(PASSIVE_MODE_ON, "Entering passive mode (" + portStr + ")");

    listen(data_passive_socket_fd, 10);
    data_connection_fd = accept(data_passive_socket_fd, (sockaddr *) NULL, NULL);

    issueCommandResponse(COMMAND_OK, "Active data connection established.");
    return true;
}
