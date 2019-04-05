/*
struct sockaddr_in { 
	short    sin_family;
	u_short sin_port;
	struct   in_addr sin_addr;
	char     sin_zero[8];
};
*/
#include "sysInclude.h"
extern void tcp_DiscardPkt(char *pBuffer, int type);
extern void tcp_sendReport(int type);
extern void tcp_sendIpPkt(unsigned char *pData, UINT16 len, unsigned int   srcAddr, unsigned int dstAddr, UINT8  ttl);
extern int waitIpPacket(char *pBuffer, int timeout);
extern unsigned int getServerIpv4Address();extern unsigned int getIpv4Address();

//TCP 头结构
struct tcp_head{
	UINT16 source_port;
	UINT16 dest_port;
	UINT32 seq;
	UINT32 ack;
	UINT8 headlen;
	UINT8 flag;
	UINT16 window_size;
	UINT16 checksum;
	UINT16 urgent_pointer;
};

//TCB 结构
struct TCB{
	//int domain;
	//int type;
	//int protocol;
	int cur_state;
	int sockfd; 
	UINT16 source_port;
	UINT32 source_addr;
	UINT16 dest_port;
	UINT32 dest_addr;
	UINT32 seq;
	UINT32 ack;
	char data[2048];
	int data_len;
	//char out_data[2048];
	//int out_data_len;
	TCB* next;
};

//伪头部，计算校验和用
struct another_head{
	UINT32 saddr; //  源网络层地址
	UINT32 daddr; //  目的网络层地址
	UINT8 mbz; //赋 0
	UINT8 ptcl; //  传输层协议
	UINT16 tcpudpl; //传输层长度
};

//全局变量
int gSrcPort=2008;
int gDstPort=2009;
unsigned int gSeqNum=1;
unsigned int gAckNum=1;
int tcb_sockfd=1;
TCB *tcb_list=NULL;

//检查校验和
UINT16 checkSum(char *pBuffer,int head_len,UINT32 srcAddr,UINT32 dstAddr,UINT16 tcp_len){
	another_head unreal;
	unreal.saddr=srcAddr;
	unreal.daddr=dstAddr;
	unreal.mbz=0;
	unreal.ptcl=IPPROTO_TCP;
	unreal.tcpudpl=tcp_len;
	char* p=(char*)(&unreal);
	char* q=p;
	char* start=p;
	UINT32 sum=0;
	for(;p<start+12;p+=2){ 
		sum+=*(UINT16*)p;
	}
	p=pBuffer;
	for(;p<pBuffer+head_len;p+=2){
		sum+=*(UINT16*)p;
	}
	while((sum&0xffff0000)!=0){
		sum=(sum>>16)+(sum&0x0000ffff);
	}
	UINT16 ans=(~sum)&0x0000ffff;
	return ans;
}

int get_ack(char *pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
{
	tcp_head *head=(tcp_head*)pBuffer;
	int check_tmp;
	check_tmp=checkSum(pBuffer,len,srcAddr,dstAddr,htons(len));
	if(check_tmp!=0){
		return -1;
	}
	head->source_port=ntohs(head->source_port);
	head->dest_port=ntohs(head->dest_port);
	head->seq=ntohl(head->seq);
	head->ack=ntohl(head->ack);
	head->window_size=ntohs(head->window_size);
	head->checksum=ntohs(head->checksum);
	head->urgent_pointer=ntohs(head->urgent_pointer);
	return 0;
}

//寻找标志符对应的 TCB
TCB* find_TCB(int sock){
	TCB* p=tcb_list;
	while(p!=NULL){
	if(p->sockfd==sock)
		return p;
	p=p->next;
}
return NULL;
}

//TCP 状态
enum tcp_state{
	CLOSED, 
	SYN_SENT,
	ESTABLISHED,
	FIN_WAIT1,
	FIN_WAIT2,
	TIME_WAIT, 
};

tcp_state start_state=CLOSED;

int stud_tcp_input(char *pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
{
	//mprint(pBuffer);
	tcp_head *head=(tcp_head*)pBuffer;
	//检查校验和
	int checksum=checkSum(pBuffer,len,srcAddr,dstAddr,htons(len));
	if(checksum!=0){
		return -1;
	}
	//字节序转换
	head->source_port=ntohs(head->source_port);
	head->dest_port=ntohs(head->dest_port);
	head->seq=ntohl(head->seq);
	head->ack=ntohl(head->ack);
	head->window_size=ntohs(head->window_size);
	head->checksum=ntohs(head->checksum);
	head->urgent_pointer=ntohs(head->urgent_pointer);
	//检查序号
	unsigned char type=head->flag;
	if((type&0x04)!=0){
		start_state=CLOSED;
		return 0;
	}
	//有限状态机
	switch(start_state){
	case CLOSED:
	case SYN_SENT:
		if(type==PACKET_TYPE_SYN_ACK){
		gAckNum=head->seq+1;
		gSeqNum++;
		stud_tcp_output(NULL,0,PACKET_TYPE_ACK,head->dest_port,head->source_port,getIpv4Address(),getServerIpv4Address());
		start_state=ESTABLISHED; 
		}
		break;
	case ESTABLISHED:
	case FIN_WAIT1:
		if(type==PACKET_TYPE_ACK){
		start_state=FIN_WAIT2;
		}
		break;
	case TIME_WAIT:
	case FIN_WAIT2:
		if(type==PACKET_TYPE_FIN||type==PACKET_TYPE_FIN_ACK){
			gAckNum=head->seq+1;
			gSeqNum++;
			stud_tcp_output(NULL,0,PACKET_TYPE_ACK,head->dest_port,head->source_port,getIpv4Address(),getServerIpv4Address());
			start_state=TIME_WAIT;
		}
		break;
	}
	return 0;
}

void stud_tcp_output(char *pData, unsigned short len, unsigned char flag, unsigned short srcPort, unsigned short dstPort, unsigned int srcAddr, unsigned int dstAddr)
{
	char *tmpbuffer;
	tmpbuffer=new char[20+len];
	//构造 TCP 头
	tcp_head *p=(tcp_head*)tmpbuffer;
	p->source_port=htons(srcPort);
	p->dest_port=htons(dstPort);
	p->seq=htonl(gSeqNum);
	p->ack=htonl(gAckNum);
	p->headlen=0x50;
	p->flag=(UINT8)flag;
	p->window_size=htons(2048);
	p->checksum=htons(0);
	p->urgent_pointer=htons(0);
	//数据
	char *q=tmpbuffer+20;
	for(int i=0;i<len;i++){ 
		q[i]=pData[i];
	}
	//校验和
	UINT16 sum=checkSum(tmpbuffer,20+len,htonl(srcAddr),htonl(dstAddr),htons(len+20));
	p->checksum=sum;
	//mprint(tmpbuffer);
	tcp_sendIpPkt((unsigned char*)tmpbuffer,20+len,srcAddr,dstAddr,10);
}

int stud_tcp_socket(int domain, int type, int protocol)
{
	TCB* p=new TCB;
	p->cur_state=CLOSED;
	p->data_len=0;
	//p->out_data_len=0;
	//p->domain=domain;
	//p->type=type;
	//p->protocol=protocol;
	p->sockfd=tcb_sockfd;
	tcb_sockfd++;
	p->next=tcb_list;
	tcb_list=p;
	p->seq=1234;
	p->ack=1;
	return p->sockfd;
}

int stud_tcp_connect(int sockfd, struct sockaddr_in *addr, int addrlen)
{
	TCB* p=find_TCB(sockfd);
	if(p==NULL)
		return -1;
	p->source_port=gSrcPort;
	p->dest_port=ntohs(addr->sin_port);
	p->source_addr=getIpv4Address();
	p->dest_addr=ntohl(addr->sin_addr.s_addr);
	gAckNum=p->ack;
	gSeqNum=p->seq;
	stud_tcp_output(NULL,0,PACKET_TYPE_SYN,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	int len;
	memset(p->data,0,sizeof(p->data));
	len=waitIpPacket(p->data,1000); 
	get_ack(p->data,len,htonl(p->dest_addr),htonl(p->source_addr));
	tcp_head *head=(tcp_head*)p->data;
	p->ack=head->seq+1;
	gAckNum=p->ack;
	p->seq++;
	gSeqNum=p->seq;
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	p->cur_state=ESTABLISHED;
	return 0;
}

int stud_tcp_send(int sockfd, const unsigned char *pData, unsigned short datalen, int flags)
{
	TCB* p=find_TCB(sockfd);
	if(p==NULL){
		return -1;
	}
	if (p->cur_state!=ESTABLISHED){
		return -1;
	}
	gAckNum=p->ack;
	gSeqNum=p->seq;
	stud_tcp_output((char*)pData,datalen,flags,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	int len;
	memset(p->data,0,sizeof(p->data));
	len=waitIpPacket(p->data,1000);
	get_ack(p->data,len,htonl(p->dest_addr),htonl(p->source_addr));
	tcp_head *head=(tcp_head*)p->data;
	p->ack=head->seq+1;
	gAckNum=p->ack;
	p->seq+=datalen;
	gSeqNum=p->seq;
	return 0;
}

int stud_tcp_recv(int sockfd, unsigned char *pData, unsigned short datalen, int flags)
{ 
	TCB* p=find_TCB(sockfd);
	if(p==NULL)
		return -1;
	if (p->cur_state!=ESTABLISHED){
		return -1;
	}
	int len;
	memset(p->data,0,sizeof(p->data));
	len=waitIpPacket(p->data,1000);
	get_ack(p->data,len,htonl(p->dest_addr),htonl(p->source_addr));
	tcp_head *head=(tcp_head*)p->data;
	p->ack=head->seq+(len-20);
	gAckNum=p->ack;
	gSeqNum=p->seq;
	char* q=p->data+20;
	for(int i=0;i<len-20;i++){
	pData[i]=*(unsigned char*)(q+i);
	}
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	return 0;
}

int stud_tcp_close(int sockfd)
{
	int len;
	TCB* p=find_TCB(sockfd);
	if(p==NULL)
		return -1;
	if(p->cur_state != ESTABLISHED){
		delete p;
		return -1;
	}
	gSeqNum=p->seq;
	gAckNum=p->ack;
	stud_tcp_output(NULL,0,PACKET_TYPE_FIN_ACK,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	memset(p->data,0,sizeof(p->data)); 
	len=waitIpPacket(p->data,1000);
	get_ack(p->data,len,htonl(p->dest_addr),htonl(p->source_addr));
	stud_tcp_output(NULL,0,PACKET_TYPE_FIN,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	memset(p->data,0,sizeof(p->data));
	len=waitIpPacket(p->data,1000);
	get_ack(p->data,len,htonl(p->dest_addr),htonl(p->source_addr));
	tcp_head *head=(tcp_head*)p->data;
	p->ack=head->seq+1;
	gAckNum=p->ack;
	p->seq++;
	gSeqNum=p->seq;
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->source_port,p->dest_port,p->source_addr,p->dest_addr);
	p->cur_state=CLOSED;
	return 0;
} 
