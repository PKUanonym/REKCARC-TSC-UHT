#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "ChatUser.h"
#include "ChatSession.h"
using namespace std;

int main() {
	freopen("test.in", "r", stdin);
	freopen("test.out", "w", stdout);
	ChatSession session;
	int n;
	cin >> n;
	vector<ChatUser*> users;
	for (int i = 0; i < n; ++i) {
		string name;
		cin >> name;
		users.push_back(new ChatUser(name));
		session.addUser(users[i]);
	}
	int m;
	cin >> m;
	for (int i = 0; i < m; ++i) {
		static int op;
		cin >> op;
		switch (op) {
			case 0: {
				// 添加好友
				string myself;
				cin >> myself;
				string name;
				cin >> name;
				if (ChatUser* me = session.getUserByName(myself))
					me->addFriend(session.getUserByName(name));
				break;
			}
			case 1:{
				// 删除好友
				string myself;
				cin >> myself;
				string name;
				cin >> name;
				if (ChatUser* me = session.getUserByName(myself))
					me->removeFriend(session.getUserByName(name));
				break;
			}
			case 2: {
				// 发送消息
				string myself;
				cin >> myself;
				string name;
				cin >> name;
				string message;
				getline(cin, message);
				message.erase(message.begin());
				if (ChatUser* me = session.getUserByName(myself))
					me->sendMessage(session.getUserByName(name), message);
				break;
			}
			case 3: {
				// 查看消息
				string myself;
				cin >> myself;
				if (ChatUser* me = session.getUserByName(myself))
					me->showMessage();
				break;
			}
			case 4: {
				// 从群聊中移除成员
				string name;
				cin >> name;
				session.removeUser(session.getUserByName(name));
				break;
			}
			case 5: {
				// 展示好友列表
				string name;
				cin >> name;
				if (ChatUser* me = session.getUserByName(name))
					me->showFriends();
				break;
			}
			default:
				break;
		}
	}
	return 0;
}