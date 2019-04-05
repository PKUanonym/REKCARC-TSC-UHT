//
//  main.cpp
//  6++
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;

int mmax(int,int,int);

int main()
{
    int n;
    int a[1001][1001] = { 0 },b[1001][1001] = {0};
    cin >> n;
    for (int i=1;i<=n;i++)
        for (int j=1;j<=i;j++)
            cin >> a[i][j];
    b[1][1] = a[1][1];
    b[2][1] = a[1][1]+b[2][1];
    b[2][2] = a[1][1]+a[2][2];
    for (int i=3;i<=n;i++)
        for (int j=1;j<=i;j++)
        {
            
          
            if (j==1) b[i][j] = b[i-1][j] + a[i][j];
            else if (j==i) b[i][j] = b[i-1][j-1] + a[i][j];
                 else b[i][j] = mmax(b[i-1][j],b[i-1][j-1],-1) + a[i][j];
            
        }
    int max = -1;
    for (int i=1;i<=n;i++)
        if (b[n][i] > max) max = b[n][i];
    cout << max;
    
    
    return 0;
}

int mmax(int x,int y,int z)
{
    if (x>=y&&x>=z) return x;
    else if (y>=x && y>=z) return y;
    else return z;
}