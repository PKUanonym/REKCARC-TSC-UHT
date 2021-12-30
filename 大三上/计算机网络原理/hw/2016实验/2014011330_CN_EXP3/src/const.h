//
// Created by jameshuang on 16-12-12.
//

#pragma once

#include <vector>
#include <cstring>
#include <cstdlib>
//#define FTP_PASSIVE_MODE

namespace ftp {

    typedef std::vector<std::string> str_vec;
    static const int FTP_COMMAND_PORT = 2000;
    static const int FTP_CLIENT_DATA_PORT = 4499;
    static const int COMMAND_BUFFER_SIZE = 4096;
    static const int UNIX_OPERATION_BUFFER = 4096;

    // 4 MB buffer.
    static const int FILE_TRANSFER_BUFFER = 0x400000;

    struct fileTrunk {
        unsigned int size;
        char payload[FILE_TRANSFER_BUFFER];
        fileTrunk() { memset(payload, 0, sizeof(char) * FILE_TRANSFER_BUFFER); size = 0; }
    };

    static const std::string SERVER_NAME = "THUCS-FTP 1.0";

    static const std::string FTP_BASE_DIR = "/home/jameshuang/FTP_ROOT";

    static const std::string TCP_DELIMITER = "\r\n";

    static const std::string ADMIN_NAME = "admin";
    static const std::string ADMIN_PASS = "admin";

    static const std::string FTP_HELP_MSG = "Available commands are: list, pwd, cd, get, put, quit, halt";

    static const std::string FTP_NAT_IP = "127,0,0,1";

    inline void stringSplit(const std::string &s,
                     const std::string &delim,
                     std::vector<std::string> *ret) {
        size_t last = 0;
        size_t index = s.find_first_of(delim, last);
        while (index != std::string::npos) {
            ret->push_back(s.substr(last, index - last));
            last = index + 1;
            index = s.find_first_of(delim, last);
        }
        if (index - last > 0) {
            ret->push_back(s.substr(last, index - last));
        }
    }

    enum FtpCommand {
        USER, PASS, PORT, LIST, PWD, CWD, RETRIEVE, STORE, RESERVED, HALT, QUIT, HELP, PASV, SYST, TYPE, MODE, STRU, NOOP
    };

    inline FtpCommand convertToFtpCommand(const std::string& cmd) {
        if (cmd == "USER") return USER;
        if (cmd == "PASS") return PASS;
        if (cmd == "PORT") return PORT;
        if (cmd == "LIST") return LIST;
        if (cmd == "PWD") return PWD;
        if (cmd == "CWD") return CWD;
        if (cmd == "RETR") return RETRIEVE;
        if (cmd == "STOR") return STORE;
        if (cmd == "HALT") return HALT;
        if (cmd == "HELP") return HELP;
        if (cmd == "SYST") return SYST;
        if (cmd == "QUIT") return QUIT;
        if (cmd == "PASV") return PASV;
        if (cmd == "TYPE") return TYPE;
        if (cmd == "MODE") return MODE;
        if (cmd == "STRU") return STRU;
        if (cmd == "NOOP") return NOOP;
        return RESERVED;
    }

    enum FtpResponseCode {
        DATA_CONNECTION_OPEN_TRANSFER_START = 125,

        HELP_MESSAGE = 214,
        NAME_SYS_TYPE = 215,

        SERVICE_READY = 220,
        SERVICE_CLOSE = 221,

        WELCOME = 230,

        TRANSFER_COMPLETE = 226,

        COMMAND_OK = 200,

        PASSIVE_MODE_ON = 227,

        USER_NAME_OK_NEED_PASS = 331,

        FILE_COMMAND_OK = 250,

        PATHNAME_CREATED = 257,

        PERMISSION_DENIED = 500,

        COMMAND_NOT_IMPLEMENTED = 502,

        FILE_UNAVAILABLE = 550,

        RESERVED_CODE = 999

    };

    static const FtpResponseCode supportedResponseCodes[] = {DATA_CONNECTION_OPEN_TRANSFER_START,
                                                             SERVICE_READY, SERVICE_CLOSE, PATHNAME_CREATED,
                                                             PERMISSION_DENIED, HELP_MESSAGE, PASSIVE_MODE_ON,
            WELCOME, TRANSFER_COMPLETE, COMMAND_OK, USER_NAME_OK_NEED_PASS, FILE_COMMAND_OK, FILE_UNAVAILABLE};

    inline FtpResponseCode convertToFtpResponseCode(int code) {
        for (int i = 0; i < sizeof(supportedResponseCodes) / sizeof(FtpResponseCode); ++ i) {
            if (code == (int) supportedResponseCodes[i]) return (FtpResponseCode) code;
        }
        return RESERVED_CODE;
    }

    struct DirUtil {
        static void getParent(std::string& wd, std::string &req) {
            req = req.substr(3);
            if (wd.size() == 1) return;
            wd = wd.substr(0, wd.size() - 1);
            wd = wd.substr(0, wd.find_last_of("/") + 1);
        }
        static void getCurrent(std::string& wd, std::string &req) {
            req = req.substr(2);
        }
        static void getInto(std::string& wd, std::string &req) {
            wd = wd + req;
            req = "";
        }
    };

    inline unsigned short getRandomPassiveServerPort() {
        return (unsigned short) (rand() % 600 + 5000);
    }

}

