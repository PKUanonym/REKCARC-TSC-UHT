#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include "ChatUser.h"

class ChatSession {
private:
    std::vector<ChatUser*> users;
public:
    void addUser(ChatUser *user);
    void removeUser(ChatUser *user);
    ChatUser* getUserByName(std::string name);
};
