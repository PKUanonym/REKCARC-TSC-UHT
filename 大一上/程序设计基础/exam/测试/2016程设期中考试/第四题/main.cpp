//
//  main.cpp
//  第四题
//
//  Created by 刘家硕 on 16/10/25.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;

int main()
{
    int a[20]={0};
    int n=0;
    cin >> n;
    a[0] = 0;
    a[1] = 0;
    a[2] = 1;
    for (int i=3;i<=n;i++)
        a[i] = (i-1)*(a[i-1]+a[i-2]);
    cout << a[n];
    
    
    return 0;
}