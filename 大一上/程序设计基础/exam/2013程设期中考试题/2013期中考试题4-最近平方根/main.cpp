//
//  main.cpp
//  2013期中考试题4-最近平方根
//
//  Created by 刘家硕 on 16/10/24.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <cmath>
using namespace std;

const int maxn=5001;
int a[maxn]={0};

int main()
{
    int n=0,temp;
    int m=0,num,judge;
    cin >> n;
    for (int i=1;i<=n;i++) cin >> a[i];
    for (int i=1;i<n;i++)
        for (int j=1;j<=n-i;j++)
        {
            if (a[i]>a[i+1]) {
                temp = a[i];
                a[i] = a[i+1];
                a[i+1] = temp;
            }
        }
    cin >> m;
    for (int i=1;i<=m;i++)
    {
        cin >> num >> judge;
        num = sqrt(num);
        int k=0;
        if (judge==0)
        {
            for (int j=n;j>=1;j--) if (a[j]<=num) { cout << a[j] << endl;k++;break;};
            if (k==0) cout << "-1"<< endl;
        }
        else
        {
            for (int j=1;j<=n;j++) if (a[j]>num) { cout << a[j] << endl;k++;break;};
            if (k==0) cout << "-1" << endl;
        }
    }
    
    
    return 0;
}