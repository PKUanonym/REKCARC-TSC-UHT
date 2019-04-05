#include <stdio.h>    
#include <fstream>
#include <math.h>    
using namespace std;
//寻找密钥长度    
int find_key_lenth(char*pass,int len)      
{    
    //pass密文,len 密文长度；移位统计相等的密文，取其最大的步数为d;    
    int d=0,count,MaxCount=0;    
    int step;
    for(step=1;step<10;step++)      //移动步数从1-10;    
    {    
        count=0;                            
        int j;
        for(j=0;j<len&&(j+step-2)<len;j++)    
        {    
            if(pass[j]==pass[j+step]&&pass[j+1]==pass[j+step+1])       
                count++;    
        }    
        if(count>MaxCount)    
        {    
            MaxCount=count;    
            d=step;    
        }    
    }    
    return d;    
}    
// 发现密钥并解密
void decode(char*pass,char*ming,int d,int len)    
{    
    float v[26]={0};               //V或W向量组；    
    int per_len=len/d;             //每组长度；    
    double A[26]={0.082,0.015,0.028,0.043,0.127,              //英文字母频率表A    
              0.022,0.02,0.061,0.07,0.002,0.008,    
              0.04,0.024,0.067,0.075,0.019,0.001,    
              0.06,0.063,0.091,0.028,0.01,0.023,0.001,0.02,0.001};    
                       
    double B[26]={0};              //存储W*A值    
    char*key;                      //密钥    
    //key=new char[d];      
    char temp[d];
    key = temp;
    int i;
    for(i=0;i<d;i++)    
    {    
        int j=0;    
        while(1)                     //统计每组a--z出现的频率存在V[26]中    
        {    
            if((i+d*j)>=len) break;    
            v[pass[i+d*j]-'A']+=1;    
            j++;                
        }   
        int k;            
        for(k=0;k<26;k++)          //计算W    
            v[k]=v[k]/per_len;    
   
        for(k=0;k<26;k++)              //计算B[i]=Ai*V;    
        {    
            int l;
            for(l=0;l<26;l++)          
                B[k]+=A[l]*v[(l+k)%26];         
        }    
        //找出B中的与0.065最接近的值其的下标即为密钥    
        double max=1;                        
        int c;    
        for(k=0;k<26;k++)                
        {       
            if(fabs(B[k]-0.065)<max)    
            {    
            	max=fabs(B[k]-0.065);
				c=k;           
            }    
        }    
        key[i]=c;            
        //清空B，V；    
        for(k=0;k<26;k++)    
        {    
            B[k]=0;    
            v[k]=0;    
        }    
        printf("%c",'A'+key[i]);    
    }       
    //解密并显示    
    
    printf("\n\n明文:\n");    
    for(i=0;i<len;i++)    
    {    
		int tmp;    
		tmp=pass[i]-'A';    
		ming[i]=(tmp-key[i%d]+26)%26+'a';    
		printf("%c",ming[i]); 
    }     
    printf("\n\n");   
    return ;    
}    
int main()    
{    
    char password[4635]={0}; //密文    
    char mingwen[4635]={0};  //明文 
	ifstream fin("3bin.txt");      
    int i=0,d;    
    printf("密文:\n");  
	char ch;  
    while (fin>>ch)
    {
    	password[i]=ch;
    	i++;
    }
    fin.close();
    int j;
    for(j=0;j<i;j++)    
    {    
        printf("%c",password[j]);    
    }      
    d=find_key_lenth(password,i-1);    
    printf("\n\nd==%d\n",d);    
    printf("key=");    
    decode(password,mingwen,d,i-1);      
    ofstream fout("3bout.txt");
    for (j=0;j<i;j++)
    {
    	fout<<mingwen[j]; 
    }
    fout.close();   
    return 0;    
}    
