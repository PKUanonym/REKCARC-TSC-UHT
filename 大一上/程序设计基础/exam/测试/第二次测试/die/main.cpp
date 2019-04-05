//
//  main.cpp
//  die
//
//  Created by 刘家硕 on 16/11/22.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
#include <iomanip>

using namespace std;

double A[1000]= {0.00};

void qsort(int p,int q)
{
    int mid,l,r,tmp;
    mid = A[(p+q)/2];
    l = p;r = q;
    while (1)
    {
        while (A[l]<mid) l++;
        while (A[r]>mid) r--;
        if (l <= r)
        {
            tmp = A[l];
            A[l] = A[r];
            A[r] = tmp;
            l++;
            r--;
        }  //if_end
        if (l > r)  break;
    }  //while_end
    if (p < r) qsort(p,r);
    if (q > l) qsort(l,q);
    
}


int main()
{
    int n;
    cin >> n;
    for (int i=1;i<=n;i++) cin >> A[i];
    qsort(1,n);
    if (n % 2==1) cout << fixed << setprecision(2)<<A[(n+1)/2];
    else cout << fixed << setprecision(2) << (A[n/2]+A[n/2 + 1])/2;
    
    
    
    return 0;
}