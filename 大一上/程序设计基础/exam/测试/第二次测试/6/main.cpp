//
//  main.cpp
//  6
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;

int main()
{
    int n;
    int a[1001][1001] = {0},sum[1001][1001] = {0};
    
    cin >> n;
    for (int i=1;i<=n;i++)
        for (int j=1;j<=i;j++)
        {
            cin  >> a[i][j];
        }
    for (int i=1;i<=n;i++) sum[n][i] = a[n][i];
    
    for (int i=n-1;i>=1;i--)
        for (int j=1;j<=i;j++)
        {
            if (sum[i+1][j] > sum[i+1][j+1]) sum[i][j] = sum[i+1][j] + a[i][j];
            else sum[i][j] = sum[i+1][j+1] + a[i][j];
        }
    cout << sum[1][1];
    
    
    return 0;
}