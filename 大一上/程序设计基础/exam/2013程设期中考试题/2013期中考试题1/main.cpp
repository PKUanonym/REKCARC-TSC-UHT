//
//  main.cpp
//  2013期中考试题1
//
//  Created by 刘家硕 on 16/10/24.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;
const int maxn=51;
char a[maxn][maxn];


void solve(int,int);

int main()
{
    int n=0;
    cin >> n;
    for (int i=1;i<=n;i++)
        for (int j=1;j<=n;j++) a[i][j] = ' ';
    solve(1,n);
    for (int i=1;i<=n;i++)
    {
        for (int j=1;j<=n;j++) cout << a[i][j];
        cout <<endl;
 
    }
    
    return 0;
}




void solve(int be,int length)
{
    if ((length==0)||(length<0)) return;
    for (int i=be;i<=be+length-1;i++) a[be][i] = '*';
    for (int i=be;i<=be+length-1;i++) a[i][be] = '*';
    for (int i=be;i<=be+length-1;i++) a[be+length-1][i] = '*';
    for (int i=be;i<=be+length-1;i++) a[i][be+length-1] = '*';
    solve(be+2,length-4);
}