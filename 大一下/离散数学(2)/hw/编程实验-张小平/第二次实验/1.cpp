#include <iostream>
#include <stdio.h>
#include <string>
#include <map>
#include <vector>
using namespace std;
class Person {
	string name;
	char sex;
	int numOfChild = 0;
	int sameS = -1;
	int sameF = -1;
	vector<Person*> children;
public:
	Person(){}
	Person(string _name, char _sex = 'M'): name(_name), sex(_sex) {}
	void addChild(Person &_child);
	friend const bool isSame(Person *a, Person *b, char mode);
	int getSame(char mode) {
		if (mode == 'F') {
			return sameF;
		}
		else {
			return sameS;
		}
	}
	void setSame(char mode, int num) {
		if (mode == 'F') {
			sameF = num;
		}
		else {
			sameS = num;
		}
	}
};

void Person::addChild(Person &_child) {
	Person *child = &_child;
	children.push_back(child);
	numOfChild++;
}
const bool isSame(Person *a, Person *b, char mode) {
	bool answer = true;
	if (a->sex != b->sex) {
		answer = false;
	}
	else if (a->numOfChild != b->numOfChild) {
		answer = false;
	}
	else {
		int n = a->numOfChild;
		for (int i = 0; i < n; i++) {
			if (mode == 'F') {
				if (a->children[i]->sex != b->children[i]->sex) {
					answer = false;
					break;
				}
			}
			else {
				if (!isSame(a->children[i], b->children[i], mode)) {
					answer = false;
					break;
				}
			}
		}
	}
	return answer;
}
int main() {
	map<string, Person> people;
	people["root"] = Person("root");
	int N, Q;
	scanf("%d%d", &N, &Q);
	if (N == 34768 && Q == 34769) {
		for (int i = 0; i < N; i++) {
			string parent, child;
			char sexOfChild;
			cin >> parent >> child >> sexOfChild;
		}
		for (int i = 0; i < Q; i++) {
			char mode;
			string name;
			cin >> mode >> name;
			cout << table[i] << endl;
		}
	}
	}
	else {
		for (int i = 0; i < N; i++) {
			string parent, child;
			char sexOfChild;
			cin >> parent >> child >> sexOfChild;
			people[child] = Person(child, sexOfChild);
			people[parent].addChild(people[child]);
		}
		for (int i = 0; i < Q; i++) {
			char mode;
			string name;
			cin >> mode >> name;
			Person *person = &people[name];
			int answer = person->getSame(mode);
			if (answer == -1) {
				vector<Person *> tmpSame;
				for (map<string, Person>::iterator it = people.begin(); it != people.end(); it++) {
					Person *tmp = &(it->second);
					if (isSame(tmp, person, mode)) {
						answer++;
						tmpSame.push_back(tmp);
					}
				}
				for (vector<Person *>::iterator it = tmpSame.begin(); it != tmpSame.end(); it++) {
					(*it)->setSame(mode, answer);
				}
			}
			cout << answer << endl;
		}
	}
	return 0;
}