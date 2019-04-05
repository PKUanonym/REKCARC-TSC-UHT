#include <iostream>
#include <string>
#include <fstream>
using namespace std;

int jiemi[26]={'v'-97,'x'-97,'e'-97,'b'-97,'i'-97,
			   'w'-97,'a'-97,'f'-97,'d'-97,'c'-97,
			   's'-97,'y'-97,'m'-97,'l'-97,'n'-97,
			   'u'-97,'j'-97,'k'-97,'o'-97,'z'-97,
			   't'-97,'q'-97,'g'-97,'p'-97,'r'-97,
			   'h'-97};

int main()
{
	int str[26];
	int ebefore[26];
	int eafter[26];
	for (int i=0;i<26;i++)
	{
		str[i]=ebefore[i]=eafter[i]=0;
	}
	ifstream fin("3ain.txt");
	string ss;
	fin>>ss;
	fin.close();
	int counts=0;
	ofstream fout1("3aout.txt"); 
	for (int i=0;i<ss.length();i++)
	{
		str[ss[i]-65]++;
		/*if (ss[i]=='C')//此处为统计C(e)的部分代码 
		{
			fout1<<ss[i-2]<<ss[i-1]<<ss[i]<<" ";
			ebefore[ss[i-2]-65]++;
			//eafter[ss[i-1]-65]++;
		} */ 
		fout1<<(char)(jiemi[ss[i]-65]+97);//输出结果 
	}
	fout1.close();
	
	ofstream fout("3acount.txt");//统计信息 
	fout<<"cipin:"<<endl;
	for (int i=0;i<26;i++)
	{
		fout<<(char)(i+65)<<":"<<str[i]<<" ";
	}
	fout<<endl<<"ebefore:"<<endl;
	for (int i=0;i<26;i++)
	{
		fout<<(char)(i+65)<<":"<<ebefore[i]<<" ";
	}
	fout<<endl<<"eafter:"<<endl;
	for (int i=0;i<26;i++)
	{
		fout<<(char)(i+65)<<":"<<eafter[i]<<" ";
	}
	fout.close();
	return 0;
}
