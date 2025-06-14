#pragma once

#include <iostream>

using namespace std;

class Test {
	int *buf;
public:
	Test() {
		buf = new int(0);
		cout << "Test(): this->buf @ " << hex << buf << endl;
	}
	Test(int val) {
		buf = new int(val);
		cout << "Test(int): this->buf @ " << hex << buf << endl;
	}
	~Test() {
		cout << "~Test(): this->buf @ " << hex << buf << endl;
		if (buf) delete buf;
	}
	Test(const Test& t) : buf(new int(*t.buf)) {
		cout << "Test(const Test&) called. this->buf @ "
			<< hex << buf << endl;
	}
	Test(Test&& t) : buf(t.buf) {
		cout << "Test(Test&&) called. this->buf @ "
			<< hex << buf << endl;
		t.buf = nullptr;
	}
	Test& operator= (const Test& right) {
		if (this != &right){
			if(buf) delete buf;
			buf = new int(*right.buf);
		}
		return *this;
	}
	Test& operator= (Test&& right) {
		if (this != &right){
			if(buf) delete buf;
			this->buf = right.buf;
			right.buf = nullptr;
		}
		return *this;
	}
	void print(const char *name) {
		cout << name << ".buf @ " << hex << buf << endl;
	}
};
