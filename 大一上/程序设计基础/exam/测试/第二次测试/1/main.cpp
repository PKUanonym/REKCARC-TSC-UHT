//
//  main.cpp
//  第一题
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <cstring>
#include <cstdlib>


using namespace std;


int main()
{
    char a[7],b[7];
    cin >> a >> b;
    int sum1 = 1,sum2 = 1;
    int length1 = strlen(a);
    int length2 = strlen(b);
    for (int i=0;i<length1;i++)
    {
        sum1 = sum1*int(a[i]-'A'+1);
        
        //cout << "**" << int(a[i] - 64);
        sum1 = sum1 % 47;
    }
    for (int i=0;i<length2;i++)
    {
        sum2 = sum2*int(b[i]-'A'+1);
        sum2 = sum2 % 47;
    }
    if (sum1 == sum2) cout << "GO";
    else cout << "STAY";
    
    return 0;
}