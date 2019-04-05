//
//  main.cpp
//  5
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;

int a[1001][1001] = {0};
int d[1001][1001] = {0};
//int sum = 0;
//int mmax = 0;
int n;

int max(int,int);


int main()
{
    //mmax = -1;
    cin >> n;
    for (int i=1;i<=n;i++)
        for (int j=1;j<=i;j++)
            cin >> a[i][j];
    
    for (int i = 1 ;i <= n; i++) d[n][i] = a[n][i];
    for (int i=n-1;i>=1;i--)
        for (int j=1;j<=i;j++)
            d[i][j] = max(d[i+1][j],d[i+1][j+1]) + a[i][j];
    cout << d[1][1];
        
    
    return 0;
}


int max(int x,int y)
{
    if (x > y) return x;
    else return y;
}



