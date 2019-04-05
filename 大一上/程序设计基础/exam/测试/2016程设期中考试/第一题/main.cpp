//
//  main.cpp
//  diyiti
//
//  Created by 刘家硕 on 16/10/25.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;

int main()
{
    char a[16][16];
    int n=0;
    cin >> n;
    int i,j;
    for (i=1;i<=n;i++)
        for (j=1;j<=i;j++)
            a[i][j] = '*';
    for (i=1;i<=n;i++)
    {
        for (j=1;j<=n-i;j++) cout << ' ';
        for (j=1;j<=i;j++) cout << a[i][j] <<' ';
        cout << endl;
    }
    
    return 0;
}