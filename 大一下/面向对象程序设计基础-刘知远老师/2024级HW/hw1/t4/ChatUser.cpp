#include "ChatUser.h"

void ChatUser::addFriend(ChatUser *user)
{
    if(user == nullptr)return;
    for(auto f: friends){
        if(user->getName() == f->getName()){
            std::cout<<name<<" and "<<user->getName()<<" are already friends"<<std::endl;
            return;
        }
    }
    friends.push_back(user);
    std::cout<<name<<" -> add friend -> "<<user->getName()<<std::endl;
}

void ChatUser::removeFriend(ChatUser *user)
{
    if(user == nullptr)return;
    int index = -1;
    for(int i = 0; i< friends.size(); ++i){
        if(friends[i]->getName() == user->getName()){
            index = i;
            break;
        }
    }
    if(index == -1){
        std::cout<<name<<" and "<<user->getName()<<" are not yet friends"<<std::endl;
    }else{
        friends.erase(friends.begin() + index);
        std::cout<<name<<" -> remove friend -> "<<user->getName()<<std::endl;
    }
}

void ChatUser::sendMessage(ChatUser *user, std::string message)
{
    if(user == nullptr)return;
    std::cout<<name<<" -> send message -> "<<user->getName()<<" : "<<message<<std::endl;
    user->receiveMessage(this, message);
}

void ChatUser::receiveMessage(ChatUser *user, std::string message)
{   
    if(user == nullptr)return;
    std::cout<<name<<" -> receive message -> "<<user->getName()<<" : "<<message<<std::endl;
    
    bool isfound = false;
    for(auto &p: messageQueue){
        if(p.first->getName() == user->getName()){
            p.second.push_back(message);
            isfound = true;
            return;
        }
    }
    if(isfound == false){
        std::vector<std::string> messageList;
        messageList.push_back(message);
        std::pair<ChatUser*, std::vector<std::string>> p1 = std::make_pair(user, messageList);
        messageQueue.push_back(p1);
    }
}

void ChatUser::showMessage()
{
    std::cout<<"Chat "<<name<<":"<<std::endl;
    for(auto &p: messageQueue){
        std::cout<<">> From "<<p.first->getName()<<":"<<std::endl;
        for(std::string s: p.second){
            std::cout<<">> "<<s<<std::endl;
        }
    }
}

void ChatUser::showFriends()
{
    std::cout<<name<<"'s friend:";
    for(auto& f: friends){
        std::cout<<" "<<f->getName();
    }
    std::cout<<std::endl;
}
