/*
* THIS FILE IS FOR IPv6 TEST
*/
// system support
#include "sysinclude.h"

extern void ipv6_DiscardPkt(char* pBuffer,int type);

extern void ipv6_SendtoLower(char*pBuffer,int length);

extern void ipv6_SendtoUp(char *pBuffer,int length);

extern void getIpv6Address(ipv6_addr *paddr);

// implemented by students

int stud_ipv6_recv(char *pBuffer, unsigned short length)//接收接口函数
{
	int Version = (*(int*)pBuffer)>>4;  
	unsigned int PayloadLen = ntohl(*(short unsigned int*)(pBuffer+4));  
	unsigned int HopLimit = ntohs((unsigned int)pBuffer[7]);
	ipv6_addr *DstAddr = (ipv6_addr*)( pBuffer+24);
	if(Version != 6)//判断版本号合法性
	{
		ipv6_DiscardPkt(pBuffer, STUD_IPV6_TEST_VERSION_ERROR);
		return -1;
	}
	if(HopLimit <= 0)//HL小于等于1则丢弃分组
	{
		ipv6_DiscardPkt(pBuffer, STUD_IPV6_TEST_HOPLIMIT_ERROR);
		return -1;
	}
	ipv6_addr *Paddr=new ipv6_addr();
	getIpv6Address(Paddr);//得到本机ip地址
	for(int i=0; i<4; i++)//比对地址
	{
		if(Paddr->dwAddr[i] != DstAddr->dwAddr[i])
		{
			ipv6_DiscardPkt(pBuffer, STUD_IPV6_TEST_DESTINATION_ERROR);
			return -1;
		}
	}
	ipv6_SendtoUp(pBuffer, length);
	return 0;
}

int stud_ipv6_Upsend(char *pData, unsigned short len, 
					 ipv6_addr *srcAddr, ipv6_addr *dstAddr, 
					 char hoplimit, char nexthead)
{
	char SendPacket[len+40];//待封装的ipv6
	short int sendPacketLen = htons(len);
	SendPacket[0] = 0x60;
	memcpy(SendPacket+4, &sendPacketLen, sizeof(short int));
	memcpy(SendPacket+6, &nexthead, sizeof(char));
	memcpy(SendPacket+7, &hoplimit, sizeof(char));
	memcpy(SendPacket+8, srcAddr, sizeof(ipv6_addr));
	memcpy(SendPacket+24, dstAddr, sizeof(ipv6_addr));
	memcpy(SendPacket+40, pData, len);
	ipv6_SendtoLower(SendPacket, len+40);//发送
	return 0;
}
