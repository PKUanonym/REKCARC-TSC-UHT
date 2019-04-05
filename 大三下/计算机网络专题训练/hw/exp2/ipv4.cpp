/*
* THIS FILE IS FOR IP FORWARD TEST
*/
#include "sysInclude.h"

// system support
extern void fwd_LocalRcv(char *pBuffer, int length);

extern void fwd_SendtoLower(char *pBuffer, int length, unsigned int nexthop);

extern void fwd_DiscardPkt(char *pBuffer, int type);

extern unsigned int getIpv4Address( );

// implemented by students

struct Router_table//定义链表节点
{
	unsigned int dest;
	unsigned int masklen;
	unsigned int next_hop;
	Router_table *next;
	Router_table()
	{
		next=NULL;
	}
};

Router_table *head;//首节点
Router_table *p;

void stud_Route_Init()//初始化链表
{
	head=new Router_table();
	return;
}

void stud_route_add(stud_route_msg *proute)//添加路由
{
	Router_table *temp=new Router_table();
	temp->dest=ntohl(proute->dest)&((1<<31)>>(ntohl(proute->masklen)-1));
	temp->masklen=proute->masklen;
	temp->next_hop=ntohl(proute->nexthop);
	p=head;
	while (p->next!=NULL)
	{
		p=p->next;
	}
	p->next=temp;//添加路由到链表末尾
	return;
}


int stud_fwd_deal(char *pBuffer, int length)//转发处理
{
	int IHL=pBuffer[0]&0xf;
	int TTL=(int)pBuffer[8];
	int Header_checksum=ntohs(*(unsigned short*)(pBuffer+10));
	int Destination_address = ntohl(*(unsigned int*)(pBuffer+16));
	if (Destination_address==getIpv4Address())//判断是否为本机接受的路由
	{
		fwd_LocalRcv(pBuffer,length);
		return 0;
	}
	if (TTL<=0)//TTL小于等于0则丢弃
	{
		fwd_DiscardPkt(pBuffer,STUD_FORWARD_TEST_TTLERROR);
		return 1;
	}
	p=head->next;
	unsigned int max=0;
	bool match=0;
	Router_table *max_table;
	while (p!=NULL)
	{
		if (p->dest==Destination_address&&max < p->masklen)//查找路由表向相应接口进行转发
		{
			match=1;
			max_table=p;
		}
		p=p->next;
	}
	if (match)
	{
		char *buffer=new char[length];
		memcpy(buffer,pBuffer,length);
		buffer[8]--;//TTL减1
		unsigned short sum=0;
		for (int i=0;i<2*IHL;i++)
		{
			if (i==5)
				continue;
			sum+=(buffer[i*2]<<8)+(buffer[i*2+1]);
			sum%=65535;
		}//重新计算校验和
		sum=htons(0xffff-(unsigned short)sum);
		memcpy(buffer+10,&sum,2);
		fwd_SendtoLower(buffer,length,max_table->next_hop);
		return 0;
	}
	fwd_DiscardPkt(pBuffer,STUD_FORWARD_TEST_NOROUTE);//丢弃找不到路由的分组
	return 1;
}

