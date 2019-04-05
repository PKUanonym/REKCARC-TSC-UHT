//
//  main.cpp
//  practice2
//
//  Created by 刘家硕 on 2016/12/20.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <cmath>

using namespace std;


int ans[10000000] = { 0 };
int jud[10000000] = { 0 };
int data[1000000] = { 0 };
int num = 1;


bool judge(int);  //判断回文数
bool judge2(int);

int main()
{
    int a,b;
    
    cin >> a >> b;
  
        for (int i = 2;i<=sqrt(b);i++)
        {
            if (!jud[i])
            {
                for (int j = 2;j <= sqrt(b)/i;j++)
                    jud[i*j] = 1;
                
                data[num] = i;
                num++;
            }
        }
    
    
    int ki  = 1;
    
    for (int i = a;i<=b;i++)
        {
            if ( !judge(i)) continue;
            if (judge2(i))
            {
                ans[ki] = i;
                ki++;
            }
                
        }

        for (int i = 1;i < ki;i++)
            cout << ans[i] << endl;
    
    
    
    
    return 0;
}



bool judge(int x)
{
    int a[20] = { 0 };
    int k = 1;
    while (x != 0)
    {
        a[k] = x % 10;
        x = x / 10;
        k++;
    }
    
    
    bool flag = true;
    for (int i = 1;i <= k;i++)
    {
        if (a[i] != a[k-i]) flag = false;
    }
    
    return flag;
        
    
    
}

bool judge2(int x)
{
    if (x == 1) return false;
    bool flag = true;
    for (int i = 2;i < num && data[i] <= sqrt(x);i++)
        if (x % data[i] == 0) flag = false;
    return flag;
}








