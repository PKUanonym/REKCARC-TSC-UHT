#pragma once
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <algorithm>

class ChatUser {
private:
    std::string name;
    std::vector<ChatUser*> friends;
    std::vector<std::pair<ChatUser*, std::vector<std::string> > > messageQueue;

public:
    ChatUser(std::string _name): name(_name) {}
    std::string getName() {
        return name;
    }
    void addFriend(ChatUser* user);
    void removeFriend(ChatUser* user);
    void sendMessage(ChatUser* user, std::string message);
    void receiveMessage(ChatUser* user, std::string message);
    void showMessage();
    void showFriends();
};
