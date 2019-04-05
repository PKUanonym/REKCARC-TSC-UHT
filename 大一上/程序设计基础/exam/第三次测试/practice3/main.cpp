//
//  main.cpp
//  practice3
//
//  Created by 刘家硕 on 2016/12/20.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;


int main()
{
    int k;
    cin >> k;
    
    int sum = 0;
    int ti = 3;
    
    while (k >= (ti+1)*ti /2)
    {
        if (2*k % (ti) == 0)
        {
            int temp = 2 * k / ti;
            for (int i = 1;i < temp/2;i++)
                {
                    if ((temp - 2*i) % (ti - 1)==0  && (temp - 2*i >0)) sum++;
                }
            

        }
        ti++;
    }
    
    cout << sum;
    return 0;
}