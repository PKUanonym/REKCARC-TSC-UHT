#include <iostream>
#include <string>
using namespace std;

int main()
{
	
	string str;
	cin>>str;
	for (int i=1;i<=25;i++)
	{
		for (int j=0;j<str.length();j++)
		{
			if (str[j]+i>90)
				cout<<(char)(str[j]+i-26+32);
			else
				cout<<(char)(str[j]+i+32);
		}
		cout<<endl;
	} 
	return 0;
}
