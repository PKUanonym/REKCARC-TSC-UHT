//
//  main.cpp
//  第三题
//
//  Created by 刘家硕 on 16/10/25.
//  Copyright © 2016年 刘家硕. All rights reserved.
//

#include <iostream>
using namespace std;

int main()
{
    int sum;
    int h[4][3];
    cin >> sum;  //说假话的人数
    int i,j;
    for (i=1;i<4;i++)
        for (j=1;j<3;j++) cin >>h[i][j];
    int a,b,c;
    int s1,s2,s3;
    for (a=0;a<2;a++)
        for (b=0;b<2;b++)
            for (c=0;c<2;c++)
            {
                
       if ((h[1][1]==1)&&(h[1][2]==a)) s1 = 1;
        else if ((h[2][1]==1)&&(h[2][2]==a)) s1 = 1;
        else if ((h[3][1]==1)&&(h[3][2]==a)) s1 = 1; else s1=0;
    
      if ((h[1][1]==2)&&(h[1][2]==b)) s2 = 1;
    else if ((h[2][1]==2)&&(h[2][2]==b)) s2 = 1;
    else if ((h[3][1]==2)&&(h[3][2]==b)) s2 = 1;else s2=0;
    
    if ((h[1][1]==3)&&(h[1][2]==c)) s3 = 1;
    else if ((h[2][1]==3)&&(h[2][2]==c)) s3 = 1;
    else if ((h[3][1]==3)&&(h[3][2]==c)) s3 = 1;else s3=0;
                if (s1+s2+s3==3-sum){
                    if (a==1) cout <<'1';
                    else if (b==1) cout <<'2';
                    else if (c==1) cout <<'3';
                    return 0;
                }
            }
    return 0;
}