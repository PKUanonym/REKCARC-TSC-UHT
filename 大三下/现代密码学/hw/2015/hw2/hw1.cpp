#include <iostream>
#include <string>
using namespace std;

int main()
{
	
	string str;
	cin>>str;
	int i=11;
	//for (int i=1;i<=25;i++)
	{
		for (int j=0;j<str.length();j++)
		{
			if (str[j]-i<65)
				cout<<(char)(str[j]-i+26);
			else
				cout<<(char)(str[j]-i);
		}
		cout<<endl;
	} 
	return 0;
}
