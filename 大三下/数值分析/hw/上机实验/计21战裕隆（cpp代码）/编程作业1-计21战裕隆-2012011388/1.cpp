#include<iostream>
#include<cmath>

using namespace std;
float ln2=0.693147180560;
float wucha=0.0000005;
float a[99999999];

bool panduan(float x)
{ 
	float t=x-ln2;
	if(abs(t)<wucha)
	return true;
	else
	return false;
}

int main()
{
	a[0]=0.0;
	//double sum=0.0;
	for(float i=1.0;;i=i+1.0)
	{
		float mid=1/i;
		if((int(i)-1)%2==0)
		{
			a[int(i)]=a[int(i)-1]+mid;
		}
		else
		{
			a[int(i)]=a[int(i)-1]-mid;
		}
		if(panduan(a[int(i)])==true)
		{
			cout<<i<<endl;
			break;
		}
	}
	system("pause");
	return 0;
}
