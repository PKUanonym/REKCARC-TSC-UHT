//
//  main.cpp
//  4
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <cmath>
using namespace std;

int main()
{
    int a1,a2,a3,b1,b2,b3,n;
    int sum = 0;
    cin >> n;
    cin >> a1 >> a2 >> a3;
    cin >> b1 >> b2 >> b3;
    for (int i=1;i<=n;i++)
        for (int j=1;j<=n;j++)
            for (int h=1;h<=n;h++)
            {
                if ((((abs(i-a1)<3)||(i-a1+n<3)||(abs(i-a1-n)<3))&&((abs(j-a2)<3)||(j-a2+n<3)||(abs(j-a2-n)<3))&&((abs(h-a3)<3)||(h-a3+n<3)||(abs(h-a3-n)<3)))
                    ||   (((abs(i-b1)<3)||(i-b1+n<3)||(abs(i-b1-n)<3))&&((abs(j-b2)<3)||(j-b2+n<3)||(abs(j-b2-n)<3))&&((abs(h-b3)<3)||(h-b3+n<3)||(abs(h-b3-n)<3))))
                sum++;

            }
    
    
    cout << sum;
    
    return 0;
}