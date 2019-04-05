//
//  main.cpp
//  第二题
//
//  Created by 刘家硕 on 16/10/25.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;

int main()
{
    int a,b,c,d;
    for (a=1;a<10;a++)
        for (b=0;b<10;b++)
            for (c=0;c<10;c++)
                for (d=1;d<10;d++)
                    if (3999*a+390*b==996*d+60*c) cout << a<<b<<c<<d;
    
    
    
    return 0;
}