#include <iostream>
#include "Test.h" 
#include "func.h" 

using namespace std;

int main()
{
	cout << "------entering main------" << endl;
	Test a;
	Test b;
	
	cout << "------before call f1------" << endl;
	
	cout << "f1():" << endl;
	Test A = f1(a);
	
	cout << "------after f1 return------" << endl;
	
	cout << "------before call f2------" << endl;
	
	cout << "f2():" << endl;
	Test& B = f2(b);
	
	cout << "------after f2 return------" << endl;
	
	cout << "------before call f3------" << endl;
	
	cout << "f3():" << endl;
	f3(a, b);
	
	cout << "------after f3 return------" << endl;
	
	cout << "------exiting main------" << endl;
	
	return 0;
}

