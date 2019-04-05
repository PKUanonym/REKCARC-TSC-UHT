#include "sysInclude.h"  //这是Rivernet2000 系统软件提供的库函数
extern void ip_DiscardPkt(char* pBuffer,int type); //丢弃包
extern void ip_SendtoLower(char*pBuffer,int length); //交给下层
extern void ip_SendtoUp(char *pBuffer,int length); //交给上层
extern unsigned int getIpv4Address(); 
// implemented by students 
int stud_ip_recv(char *pBuffer,unsigned short length)  //自己实现的本机Ipv4数据包接收函数
{ 
	//获取ip头信息 
	int version = pBuffer[0] >> 4; 
	int headlength = pBuffer[0] & 0xf; 
	int timetolive = (int)pBuffer[8]; 
	int headerChecksum = ntohs(*(short unsigned int*)(pBuffer+10)); 
	int destinationAddress = ntohl(*(unsigned int*)(pBuffer+16)); 
	if (version != 4) //检查version 
	{ 
	ip_DiscardPkt(pBuffer,STUD_IP_TEST_VERSION_ERROR); 
	return 1; 
	}
	if (headlength < 5) //检查IHL 
	{ 
	ip_DiscardPkt(pBuffer,STUD_IP_TEST_HEADLEN_ERROR); 
	return 1; 
	} 
	if (timetolive == 0) //检查TTL 
	{ 
	ip_DiscardPkt(pBuffer,STUD_IP_TEST_TTL_ERROR); 
	return 1; 
	} 
	//检查目的地址和本机地址是否相同 
	if (destinationAddress != getIpv4Address() && destinationAddress != 0xffffff) 
	{ 
	ip_DiscardPkt(pBuffer,STUD_IP_TEST_DESTINATION_ERROR); 
	return 1; 
	} 
	int sum = 0; 
	unsigned short int localCheckSum = 0; 
	unsigned short int field; 
	int offset; 
	for(int i = 1;i <= headlength*2; i++) //计算校验和 
	{ 
	offset = (i-1)*2; 
	if(i != 6) 
	{ 
	field = (pBuffer[offset])<<8; 
	field += pBuffer[offset+1]; 
	sum += field; 
	sum %= 65535; 
	} 
	} 
	localCheckSum = 0xffff - (unsigned short int)sum; 
	if(localCheckSum != headerChecksum) //检验校验和 
	{ 
	ip_DiscardPkt(pBuffer,STUD_IP_TEST_CHECKSUM_ERROR); 
	return 1; 
	} 

	ip_SendtoUp(pBuffer,length); 
	return 0; 
} 
int stud_ip_Upsend(char *pBuffer,unsigned short len,unsigned int srcAddr, 
unsigned int dstAddr,byte protocol,byte ttl) 
{ 
	char *sendBuffer = new char(len + 20); 
	memset(sendBuffer, 0, len+20); 
	//填入各种IP头信息 
	sendBuffer[0] = 0x45; 
	unsigned short int totallen = htons(len + 20); 
	memcpy(sendBuffer + 2, &totallen, sizeof(unsigned short int)); 
	sendBuffer[8] = ttl; 
	sendBuffer[9] = protocol; 
	unsigned int src = htonl(srcAddr); 
	unsigned int dis = htonl(dstAddr); 
	memcpy(sendBuffer + 12, &src, sizeof(unsigned int)); 
	memcpy(sendBuffer + 16, &dis, sizeof(unsigned int)); 

	int sum = 0; 
	unsigned short int localCheckSum = 0; 
	for(int i = 0;i < 10;i ++) 
	{ 
	sum = sum + (sendBuffer[i*2]<<8) + (sendBuffer[i*2+1]); 
	sum %= 65535; 
	} 
	localCheckSum = htons(0xffff - (unsigned short int)sum); 

	memcpy(sendBuffer + 10, &localCheckSum, sizeof(unsigned short int)); 
	memcpy(sendBuffer + 20, pBuffer, len); 
	//发送 
	ip_SendtoLower(sendBuffer,len+20); 
	return 0;
}
