//
//  main.cpp
//  2013期中考试题3
//
//  Created by 刘家硕 on 16/10/24.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;



int main()
{
    char a[100];
    int b[9];    //标准的IP地址数
    char c[100]; //需要比较的序列
    int d[9];
    cin >> a;
    
    int temp = 0;
    int k=1;
    for (int i=0;i<=10;i++) b[i]=0;
    
    while(a[temp] != '\0')
    {
        if ((a[temp] == '-')||(a[temp] == '.')) k = k+1;
        else if (a[temp]=='*') {b[k]=-1;k = k+1;b[k] = 1000000;}
        else b[k] = b[k]*10+a[temp]-48;
        temp = temp +1;
    }
    //for (int i=1;i<=k;i++) cout << b[i] <<endl;
    int m=0;
    
    cin >> m;
    
    for (int h=1;h<=m;h++)
    {
        cin >> c;
        temp = 0;
        k  = 1;
        for (int i=0;i<=10;i++) d[i]=0;
        while(c[temp] != '\0')
        {
            if ((c[temp] == '-')||(c[temp] == '.')) k = k+1;
            //else if (c[temp]=='*') {d[k]=-1;k = k+1;d[k] = 1000000;}
            else d[k] = d[k]*10+c[temp]-48;
            temp = temp +1;
        }
        if ((d[1]<b[1])||(d[1]>b[2])||(d[2]<b[3])||(d[2]>b[4])||(d[3]<b[5])||(d[3]>b[6])||(d[4]<b[7])||(d[4]>b[8])) cout << "Failed"<<endl;
        else cout << "Accepted";
    
    
    }//for_end
        
    
    
    return 0;
}
