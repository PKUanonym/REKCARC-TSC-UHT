#include "ChatSession.h"

void ChatSession::addUser(ChatUser *user)
{
    users.push_back(user);
    std::cout<<"Add user: "<<user->getName()<<std::endl;
}

void ChatSession::removeUser(ChatUser *user)
{
    if(user == nullptr)return;
    int index = -1;
    for(int i = 0; i< users.size(); ++i){
        if(users[i]->getName() == user->getName()){
            index = i;
            break;
        }
    }
    if(index == -1){
        std::cout<<user->getName()<<" not in chat"<<std::endl;
    }else{
        users.erase(users.begin() + index);
        std::cout<<"Remove user: "<<user->getName()<<std::endl;
    }
}

ChatUser *ChatSession::getUserByName(std::string name)
{
    for(auto u: users){
        if(u->getName() == name){
            return u;
        }
    }
    std::cout<<name<<" not in chat"<<std::endl;
    return nullptr;
}
