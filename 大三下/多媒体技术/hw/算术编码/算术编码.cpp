#include <iostream>
#include <cstring>
#include <cstdlib>
#include <iomanip>
using namespace std;
int main()
{
	cout.setf(ios::fixed);

	string str = "11011111"; // 要处理的字符串
	string diff = "01"; // 可能出现的字符 从大到小排序
	double p[10] = {0.125 , 0.875}; // 可能出现的字符对应的概率 从大到小排序
	int code[50];  // 编码结果
	// 算数编码
	double C = 0.0;
	double A = 1.0;
	for(int i = 0;i < str.length();i++)
	{
		if(str[i] == diff[0])
		{
			C = C;
			A = A * p[0];
		}
		else if(str[i] == diff[1])
		{
			C = C + A * p[0];
			A = A * p[1];
		}
	}
	cout << setprecision(12) << "C: " << C << " A: " << A << " C+A: " << C + A << endl;
	
	// 取C A中点 并转化为2进制 进行编码 
	double middle = C + 0.5 * A;
	cout << "将区间中点 " << middle << "转化为2进制" << endl;
	cout << "编码结果为：0.";
	for(int j=0;j < 50;j++)
	{
		middle = middle * 2;
		if(middle > 1.0)
		{
		    middle = middle - 1;
		    code[j]=1;
		}
		else
		    code[j]=0;

		cout << code[j];
	}
	cout << endl;
	
	// 解码
	middle = C + 0.5 * A;
	A = 1.0;
	double qe = p[0];
	int count = 0;
	cout << "解码结果为：";
	while(count < str.length())
	{
		if(middle > 0 && middle <= qe * A)
		{
			middle = middle;
			A = qe * A;
			cout << diff[0];
		}
		else if(middle < 1 && middle > qe * A)
		{
			middle = middle - qe * A;
			A = A * (1 - qe);
			cout << diff[1];
		}
		count++;
	}
	cout << endl;

	system("pause");
	return 0;
}
