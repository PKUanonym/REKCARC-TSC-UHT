#include <iostream>
#include <cstdlib>
#include "Array.h"
#include "Node.h"
using namespace std;

void outputArray(Array& a, int len)
{
	for(int i = 0; i < len; i++){
		cout << a[i] << " ";
	}
	cout << endl;
}
void readArray(Array& a, int len)
{
	int tval;
	for(int i = 0; i < len; i++){
		cin >> a[i];//普通构造*len
	}
}

void test()
{
	int reference_ans;
	cin >> reference_ans; //read 1st line, unused
	
	int len, xpos, xval, ypos, yval;
	cin >> len >> xpos >> xval >> ypos >> yval; //read 2nd line
	
	Array a(len);//普通构造3
	Node x(xval);//普通构造4
	
	//set
	readArray(a, len);  //read 3rd line 
	a[xpos] = x;
	a[ypos] = Node(yval);//普通构造5，移动赋值1
	outputArray(a, len);  //output 1st line
	
	//write after copy
	cin >> x;  //read 4th line
	outputArray(a, len);  //output 2nd line
	
	//copy constructor
	Array b = a;	//拷贝构造123
	outputArray(b, len);  //output 3rd line
	
	//write after copy
	readArray(a, len); //read 5th line 
	outputArray(a, len);  //output 4th line
	outputArray(b, len);  //output 5th line
	
	//assignment
	b = a;	
	readArray(a, len);  //read 6th line 
	outputArray(a, len);  //output 6th line
	outputArray(b, len);  //output 7th line
	
	//move constructor && move assignment
	Array tmp = std::move(a); //普通构造9 10 11
	a = std::move(b);	//移动赋值234
	b = std::move(tmp);//移动赋值567
	outputArray(a, len);  //output 8th line
	outputArray(b, len);  //output 9th line
}

int main()
{
	test();
	Node::outputResult();  //output 10th line
	return 0;
}
