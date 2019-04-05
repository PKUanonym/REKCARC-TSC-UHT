//
//  main.cpp
//  3
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <cmath>

using namespace std;

int main()
{
    int n;
    cin >> n;
    int num[20000];
    num[1] = 2;
    num[2] = 3;
    int k=2;
    for (int i=5;i<100000;i++)
    {
        bool flag = true;
        for (int j=2;j<=sqrt(i);j++)
            if (i % j == 0)
            {
                flag = false;
                break;
            }
        if (flag)
        {
            k++;
            num[k] = i;
        }
    }
    for (int i=1;i<=k;i++)
         for (int j=1;j<=i;j++)
         {
             if (num[i] - num[j] == n)
             {
                 cout << num[i] << " " << num[j];
                 return 0;
             }
         }
    
    
    return 0;
}