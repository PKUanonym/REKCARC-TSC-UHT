//
//  main.cpp
//  FHGFH
//
//  Created by 刘家硕 on 2016/12/20.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;
char a[201];

void operate1();
void operate2();
void operate3();
void operate4();
void operate5();


int main()
{
    
    int m;
    cin >> m;
    cin >> a;
    if (m==1) operate1();
    if (m==2) operate2();
    if (m==3) operate3();
    if (m==4) operate4();
    if (m==5) operate5();
    
    return 0;
}


void operate1()
{
    int i=0;
    while (a[i] != '\0')
    {
        if (int(a[i])>=97) a[i] = a[i] -'a'+'A';
        i = i+1;
    }
    for (int j=0;j<i;j++) cout << a[j];
}

void operate2()
{
    int i=0;
    while (a[i] != '\0')
    {
        if (int(a[i])<97) a[i] = a[i] +'a'-'A';
        i = i+1;
    }
    for (int j=0;j<i;j++) cout << a[j];
}

void operate3()
{
    int i=0;
    while (a[i]!='\0') i++;
    for (int j=i-1;j>=0;j--) cout << a[j];
}

void operate4()
{
    int i=0;
    while (a[i] != '\0')
    {
        if (int(a[i])<97) a[i] = a[i] +'a'-'A';
        else a[i] = a[i]-'a'+'A';
        i = i+1;
    }
    for (int j=0;j<i;j++) cout << a[j];
}

void operate5()
{
    int i=0;
    
    while (a[i] != '\0')
    {
        if (int(a[i])<97) a[i] = a[i] +'a'-'A';
        i ++;
    }
    int length=i;
    length--;
    
    int judge[300]={0};
    for (int i=1;i<=length;i++)
    {
        if (a[i]-a[i-1]==1) judge[i]=1;
    }
    for (int i=0;i<=length;i++)
    {
        if (!judge[i]) cout << a[i];
        else if ((judge[i])&&(!judge[i+1]))
        {
            if (judge[i-1]) cout << "-" << a[i];
            else cout <<a[i];
            
        }
    }
    
}









