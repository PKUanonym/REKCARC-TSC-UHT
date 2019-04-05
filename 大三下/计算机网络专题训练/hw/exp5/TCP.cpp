/*
* THIS FILE IS FOR TCP TEST
*/

/*
struct sockaddr_in {
        short   sin_family;
        u_short sin_port;
        struct  in_addr sin_addr;
        char    sin_zero[8];
};
*/

#include "sysInclude.h"

extern void tcp_DiscardPkt(char *pBuffer, int type);

extern void tcp_sendReport(int type);

extern void tcp_sendIpPkt(unsigned char *pData, UINT16 len, unsigned int  srcAddr, unsigned int dstAddr, UINT8	ttl);

extern int waitIpPacket(char *pBuffer, int timeout);

extern unsigned int getIpv4Address();

extern unsigned int getServerIpv4Address();

struct tcp_head//TCP 头结构
{
    UINT16 Source_Port;
	UINT16 Destination_Port;
	UINT32 Sequence;
	UINT32 Ack;
	UINT8 Header_Length;
	UINT8 Flag;
	UINT16 Window_Size;
	UINT16 Checksum;
	UINT16 Urgent_Pointer;
};

//TCB 结构
struct TCB{
	int cur_state;
	int sockfd; 
	UINT16 Source_Port;
	UINT32 source_addr;
	UINT16 Destination_Port;
	UINT32 dest_addr;
	UINT32 Sequence;
	UINT32 Ack;
	char Data[1024];
	int data_len;
	TCB* next;
};

struct psd_header{//伪头部，计算校验和用
	UINT32 saddr; //  源网络层地址
	UINT32 daddr; //  目的网络层地址
	UINT8 mbz; //赋 0
	UINT8 ptcl; //  传输层协议
	UINT16 tcpudpl; //传输层长度
};

//TCP 状态
enum tcp_state{
	CLOSED, 
	SYN_SENT,
	ESTABLISHED,
	FIN_WAIT1,
	FIN_WAIT2,
	TIME_WAIT, 
};

//全局变量
int gSrcPort=2008;
int gDstPort=2009;
int gSeqNum=1234;
int gAckNum=1;
int socknum=1;
TCB *tcb_list=NULL;
tcp_state start_state=CLOSED;

//检查校验和，为0
UINT16 getchecksum(char *pBuffer,int head_len,UINT32 srcAddr,UINT32 dstAddr,UINT16 tcp_len){
	psd_header unreal;
	unreal.saddr=srcAddr;
	unreal.daddr=dstAddr;
	unreal.mbz=0;
	unreal.ptcl=IPPROTO_TCP;
	unreal.tcpudpl=tcp_len;
	char* p=(char*)(&unreal);
	char* q=p;
	char* start=p;
	UINT32 sum=0;
	for(;p<start+12;p+=2){ //ipv4伪头为12byte
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

//寻找标志符对应的TCB
TCB* find_TCB(int sock){
	TCB* p=tcb_list;
	while(p!=NULL){
        if(p->sockfd==sock)
            return p;
        p=p->next;
    }
    return NULL;
}

int stud_tcp_input(char *pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
{
    tcp_head *head=(tcp_head*)pBuffer;
	//检查校验和
	int Checksum=getchecksum(pBuffer,len,srcAddr,dstAddr,htons(len));
	if(Checksum!=0){
		return -1;
	}
	//字节序转换
	head->Source_Port=ntohs(head->Source_Port);
	head->Destination_Port=ntohs(head->Destination_Port);
	head->Sequence=ntohl(head->Sequence);
	head->Ack=ntohl(head->Ack);
	head->Window_Size=ntohs(head->Window_Size);
	head->Checksum=ntohs(head->Checksum);
	head->Urgent_Pointer=ntohs(head->Urgent_Pointer);
	//有限状态机
    unsigned char type=head->Flag;
	switch(start_state){
        case CLOSED:
        case SYN_SENT:
            if(type==PACKET_TYPE_SYN_ACK){
            gAckNum=head->Sequence+1;
            gSeqNum++;
            stud_tcp_output(NULL,0,PACKET_TYPE_ACK,head->Destination_Port,head->Source_Port,getIpv4Address(),getServerIpv4Address());
            start_state=ESTABLISHED; 
            }
            break;
        case ESTABLISHED:
        case FIN_WAIT1:
            if(type==PACKET_TYPE_ACK){
            start_state=FIN_WAIT2;
            }
            break;
        case FIN_WAIT2:
        case TIME_WAIT:
            if(type==PACKET_TYPE_FIN||type==PACKET_TYPE_FIN_ACK){
                gAckNum=head->Sequence+1;
                gSeqNum++;
                stud_tcp_output(NULL,0,PACKET_TYPE_ACK,head->Destination_Port,head->Source_Port,getIpv4Address(),getServerIpv4Address());
                start_state=TIME_WAIT;
            }
            break;
	}
	return 0;
}

void stud_tcp_output(char *pData, unsigned short len, unsigned char Flag, unsigned short srcPort, unsigned short dstPort, unsigned int srcAddr, unsigned int dstAddr)
{
    char *tmpbuffer;
	tmpbuffer=new char[20+len];
	//构造 TCP 头
	tcp_head *p=(tcp_head*)tmpbuffer;
	p->Source_Port=htons(srcPort);
	p->Destination_Port=htons(dstPort);
	p->Sequence=htonl(gSeqNum);
	p->Ack=htonl(gAckNum);
	p->Header_Length=0x50;
	p->Flag=(UINT8)Flag;
	p->Window_Size=htons(2048);
	p->Checksum=htons(0);
	p->Urgent_Pointer=htons(0);
	//数据
	char *q=tmpbuffer+20;
	for(int i=0;i<len;i++){ 
		q[i]=pData[i];
	}
	//校验和
	UINT16 sum=getchecksum(tmpbuffer,20+len,htonl(srcAddr),htonl(dstAddr),htons(len+20));
	p->Checksum=sum;
	tcp_sendIpPkt((unsigned char*)tmpbuffer,20+len,srcAddr,dstAddr,10);
}

int stud_tcp_socket(int domain, int type, int protocol)
{
    if(domain!=AF_INET || type!= SOCK_STREAM || protocol!=IPPROTO_TCP)//不符合规格
        return -1;
    TCB* p=new TCB;
	p->cur_state=CLOSED;
	p->data_len=0;
	p->sockfd=socknum++;
	p->next=tcb_list;
	tcb_list=p;
	p->Sequence=gSeqNum++;
	p->Ack=gAckNum;
	return p->sockfd;
}

int stud_tcp_connect(int sockfd, struct sockaddr_in *addr, int addrlen)
{
    TCB* p=find_TCB(sockfd);
	if(p==NULL)
		return -1;
    //初始化TCB结构
	p->Source_Port=gSrcPort;
	p->Destination_Port=ntohs(addr->sin_port);
	p->source_addr=getIpv4Address();
	p->dest_addr=ntohl(addr->sin_addr.s_addr);
	gAckNum=p->Ack;
	gSeqNum=p->Sequence;
    //发送SYN段，等待应答，若收到SYN+ACK，以ACK应答,状态变为ESTABLISHED
	stud_tcp_output(NULL,0,PACKET_TYPE_SYN,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);
    //发送SYN段
	memset(p->Data,0,sizeof(p->Data));
	int len=waitIpPacket(p->Data,4000); //接收
    int check_tmp=getchecksum(p->Data,len,htonl(p->dest_addr),htonl(p->source_addr),htons(len));
	if(check_tmp!=0){
		return -1;
	}
	
	tcp_head *head=(tcp_head*)p->Data;
    head->Source_Port=ntohs(head->Source_Port);
	head->Destination_Port=ntohs(head->Destination_Port);
	head->Sequence=ntohl(head->Sequence);
	head->Ack=ntohl(head->Ack);
	head->Window_Size=ntohs(head->Window_Size);
	head->Checksum=ntohs(head->Checksum);
	head->Urgent_Pointer=ntohs(head->Urgent_Pointer);
	p->Ack=head->Sequence+1;
	gAckNum=p->Ack;
	p->Sequence++;
	gSeqNum=p->Sequence;
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);//发送ACK段
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
	gAckNum=p->Ack;
	gSeqNum=p->Sequence;
	stud_tcp_output((char*)pData,datalen,flags,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);

	memset(p->Data,0,sizeof(p->Data));
	int len=waitIpPacket(p->Data,4000);
	int check_tmp=getchecksum(p->Data,len,htonl(p->dest_addr),htonl(p->source_addr),htons(len));
	if(check_tmp!=0){
		return -1;
	}
    
	tcp_head *head=(tcp_head*)p->Data;
    head->Source_Port=ntohs(head->Source_Port);
	head->Destination_Port=ntohs(head->Destination_Port);
	head->Sequence=ntohl(head->Sequence);
	head->Ack=ntohl(head->Ack);
	head->Window_Size=ntohs(head->Window_Size);
	head->Checksum=ntohs(head->Checksum);
	head->Urgent_Pointer=ntohs(head->Urgent_Pointer);
	p->Ack=head->Sequence+1;
	gAckNum=p->Ack;
	p->Sequence+=datalen;
	gSeqNum=p->Sequence;//应答
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

	memset(p->Data,0,sizeof(p->Data));
	int len=waitIpPacket(p->Data,4000);//从TCB缓冲区读出数据
	int check_tmp=getchecksum(p->Data,len,htonl(p->dest_addr),htonl(p->source_addr),htons(len));
	if(check_tmp!=0){
		return -1;
	}
	tcp_head *head=(tcp_head*)p->Data;
    head->Source_Port=ntohs(head->Source_Port);
	head->Destination_Port=ntohs(head->Destination_Port);
	head->Sequence=ntohl(head->Sequence);
	head->Ack=ntohl(head->Ack);
	head->Window_Size=ntohs(head->Window_Size);
	head->Checksum=ntohs(head->Checksum);
	head->Urgent_Pointer=ntohs(head->Urgent_Pointer);
	p->Ack=head->Sequence+(len-20);
	gAckNum=p->Ack;
	gSeqNum=p->Sequence;
	char* q=p->Data+20;
	for(int i=0;i<len-20;i++){
        pData[i]=*(unsigned char*)(q+i);
	}
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);//将数据交给应用层协议
	return 0;
}

int stud_tcp_close(int sockfd)
{
    int len;
    TCB* p=tcb_list;
    TCB* prep;
	while(p!=NULL){
        if(p->sockfd==sockfd)
            break;
        prep=p;
        p=p->next;
    }
	if(p==NULL)
		return -1;
	if(p->cur_state != ESTABLISHED)//非正常情况下直接删除TCB结构后退出
    {
        if (p!=prep)
        {
            prep->next=p->next;
            delete p;
        }
		else
            delete p;
        p=NULL;
		return -1;
	}
	gSeqNum=p->Sequence;
	gAckNum=p->Ack;
	stud_tcp_output(NULL,0,PACKET_TYPE_FIN_ACK,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);//发送ACK段
	memset(p->Data,0,sizeof(p->Data)); 
	len=waitIpPacket(p->Data,4000);//接收
	int check_tmp=getchecksum(p->Data,len,htonl(p->dest_addr),htonl(p->source_addr),htons(len));
	if(check_tmp!=0){
		return -1;
	}
	stud_tcp_output(NULL,0,PACKET_TYPE_FIN,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);//发送FIN段
	memset(p->Data,0,sizeof(p->Data));
	len=waitIpPacket(p->Data,4000);//接收
	check_tmp=getchecksum(p->Data,len,htonl(p->dest_addr),htonl(p->source_addr),htons(len));
	if(check_tmp!=0){
		return -1;
	}
	tcp_head *head=(tcp_head*)p->Data;
    head->Source_Port=ntohs(head->Source_Port);
	head->Destination_Port=ntohs(head->Destination_Port);
	head->Sequence=ntohl(head->Sequence);
	head->Ack=ntohl(head->Ack);
	head->Window_Size=ntohs(head->Window_Size);
	head->Checksum=ntohs(head->Checksum);
	head->Urgent_Pointer=ntohs(head->Urgent_Pointer);
	p->Ack=head->Sequence+1;
	gAckNum=p->Ack;
	p->Sequence++;
	gSeqNum=p->Sequence;
	stud_tcp_output(NULL,0,PACKET_TYPE_ACK,p->Source_Port,p->Destination_Port,p->source_addr,p->dest_addr);//发送ACK段
	p->cur_state=CLOSED;
	return 0;
}

