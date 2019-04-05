#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "AESGCM.cpp"

using namespace std;

int main()
{
    char Key[100],IV[50],HDR[500],PlainText[512],Cliper[512],Tag[50];
    
    sprintf(Key,"30303030303030303030303030303030");//0µÄasciiµÄ0x30 
    sprintf(IV,"303030303030303030303030");
    sprintf(HDR,"");
    
    string a = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    for (int i = 0; i < 62; i++)
    {
        int high = a[i] >> 4;
        if (high < 10)
                PlainText[2*i] = high+48;
        else
                PlainText[2*i] = high+87;
        
        int low = a[i] & 0xf;
        if (low < 10)
                PlainText[2*i+1] = low+48;
        else
                PlainText[2*i+1] = low+87;
    }    
  	
  	cout<<"PlainText:"<<endl;
  	cout<<hex<<PlainText<<endl;
    
    Encrypt_StringData(Key,IV,HDR,PlainText,Cliper,Tag);
    cout<<"Cipher:"<<endl;
	cout<<Cliper<<endl;
	cout<<"Tag:"<<endl;
	cout<<Tag<<endl;
    
    return 0;
}    
