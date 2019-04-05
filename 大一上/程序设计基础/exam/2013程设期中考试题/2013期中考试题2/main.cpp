//
//  main.cpp
//  2013期中考试题2
//
//  Created by 刘家硕 on 16/10/24.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>

using namespace std;

int main()
{
    int sum=0,truth=0;
    char X;
    cin >> sum >> X >> truth;
    int a,b,c,d,e,x;
    int k=0;
    for (a=0;a<2;a++)
        for (b=0;b<2;b++)
            for (c=0;c<2;c++)
                for (d=0;d<2;d++)
                    for (e=0;e<2;e++)
                {
                    if (X=='A') x = a;
                    if (X=='B') x = b;
                    if (X=='C') x = c;
                    if (X=='D') x = d;
                    if (X=='E') x = e;
                    int ans1 = (a&&(!x))||(!a&&x);
                    int ans2 = (c||e);
                    int ans3 = (c||d||a);
                    int ans4 = (!b&&!c);
                    int ans5 = (!e);
                    if ((ans1+ans2+ans3+ans4+ans5==truth)&&(a+b+c+d+e==sum))
                    {
                        k = k+1;
                        if (a>0) cout << 'A';
                        if (b>0) cout << 'B';
                        if (c>0) cout << 'C';
                        if (d>0) cout << 'D';
                        if (e>0) cout << 'E';
                        cout <<endl;
                        
                    }
                    
                }
    if (k==0) cout << '0';
    return 0;
}