#include <iostream>
#include <string>
using namespace std;

int main()
{
	
	string str;
	cin>>str;
	for (int j=0;j<31;j++)
	{
		if (j%8==0)
		{
			cout<<str[j+1]<<str[j+3]<<str[j+5]<<str[j]<<str[j+7]<<str[j+2]<<str[j+4]<<str[j+6];
		}
	}
	return 0;
}
