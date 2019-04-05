#include "sysinclude.h"

#define BGP_ERR_HEADER 1
#define BGP_ERR_OPEN 2
#define BGP_ERR_UPDATE 3
#define BGP_ERR_HOLD 4
#define BGP_ERR_FM 5
#define BGP_ERR_EXIT 6

#define BGP_STATE_IDLE			1	
#define BGP_STATE_CONNECT		2	
#define BGP_STATE_ACTIVE		3	
#define BGP_STATE_OPENSENT		4	 
#define BGP_STATE_OPENCONFIRM	5	
#define BGP_STATE_ESTABLISHED	6	

// BGP PACKET types
#define BGP_OPEN		    1		
#define BGP_UPDATE		    2		
#define BGP_NOTIFY		    3		
#define BGP_KEEPALIVE	    4		   

//BGP timeout message type
#define BGP_CONNECTRETRY_TIMEOUT        1      
#define BGP_HOLD_TIMEOUT                2      
#define BGP_KEEPALIVE_TIMEOUT           3     

//BGP tcp Exception message type
#define BGP_TCP_CLOSE   1
#define BGP_TCP_FATAL_ERROR 2 
#define BGP_TCP_RETRANSMISSION_TIMEOUT      3 

extern void bgp_FsmTryToConnectPeer();
extern void bgp_FsmSendTcpData(char *pBuf,DWORD dwLen);

struct BGPOPEN
{
	int Marker[4];
	short Length;
	char Type;
	char Version;
	short MyAS;
	short HoldTime;
	int BGPId;
	char OP;
};

struct BGPKEEPALIVE
{
	int Marker[4];
	short Length;
	char Type;
};

struct BGPNOTIFICATION
{
	int Marker[4];
	short Length;
	char Type;
	char ErrorCode;
	char Errsubcode;
};

void Send_notification(char error_code){//发送Notification消息
	BGPNOTIFICATION * send = new BGPNOTIFICATION();
	for(int i = 0; i < 4; i++)
		send->Marker[i] = 0xffffffff;
	send->Length = htons(sizeof(BGPNOTIFICATION));
	send->Type = BGP_NOTIFY;
	send->ErrorCode = error_code;
	bgp_FsmSendTcpData((char*)send , sizeof(BGPNOTIFICATION));
	delete send;
	return;
}

void Send_keepalive(){//发送KeepAlive消息
	BGPKEEPALIVE * send = new BGPKEEPALIVE();
	for(int i = 0; i < 4; i++)
		send->Marker[i] = 0xffffffff;
	send->Length = htons(sizeof(BGPKEEPALIVE));
	send->Type = BGP_KEEPALIVE;
	bgp_FsmSendTcpData( (char*)send , sizeof(BGPKEEPALIVE));
	delete send;
	return;
}

void Send_open(BgpPeer *pPeer){//发送Open消息
	BGPOPEN * send = new BGPOPEN();
	for(int i = 0; i < 4; i++)
		send->Marker[i] = 0xffffffff;
	send->Length = htons(sizeof(BGPOPEN));
	send->Type = BGP_OPEN;
	send->Version = pPeer->bVersion;
	send->MyAS = htons( pPeer->bgp_wMyAS );
	send->HoldTime = htons(pPeer->bgp_dwCfgHoldtime);
	send->BGPId = htonl( pPeer->bgp_dwMyRouterID );
	send->OP = 0;
	bgp_FsmSendTcpData( (char*)send , sizeof(BGPOPEN));
	delete send;
	return;
}

BYTE stud_bgp_FsmEventOpen(BgpPeer *pPeer,BYTE *pBuf,unsigned int len) //IE10
{
	BGPOPEN *packet = (BGPOPEN*)pBuf;
	switch (pPeer->bgp_byState)
	{
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		case BGP_STATE_OPENSENT:
			if(packet->Type != BGP_OPEN)
			{
				Send_notification(BGP_ERR_HEADER);
				pPeer->bgp_byState = BGP_STATE_IDLE;
				return -1;
			}
			else if(packet->Version != 4)
			{
				Send_notification(BGP_ERR_OPEN);
				pPeer->bgp_byState = BGP_STATE_IDLE;
				return -1;
			}
			Send_keepalive();
			pPeer->bgp_byState = BGP_STATE_OPENCONFIRM;
			break;
		default: 
			break;
	}
	return 0;
}

BYTE stud_bgp_FsmEventKeepAlive(BgpPeer *pPeer,BYTE *pBuf,unsigned int len) //IE11  
{
	switch(pPeer->bgp_byState)
	{
		case BGP_STATE_OPENCONFIRM:
			pPeer->bgp_byState = BGP_STATE_ESTABLISHED;
			break;
		case BGP_STATE_ACTIVE:
		case BGP_STATE_OPENSENT:
		case BGP_STATE_CONNECT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default:
			break;
	}
	return 0;
}

BYTE stud_bgp_FsmEventNotification(BgpPeer *pPeer,BYTE *pBuf,unsigned int len) //IE13
{
	pPeer->bgp_byState = BGP_STATE_IDLE;
	return 0;
}

BYTE stud_bgp_FsmEventUpdate(BgpPeer *pPeer,BYTE *pBuf,unsigned int len)//IE12
{
	switch(pPeer->bgp_byState)
	{
		case BGP_STATE_ACTIVE:
		case BGP_STATE_CONNECT:
		case BGP_STATE_OPENSENT:
		case BGP_STATE_OPENCONFIRM:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: 
			break;
	}
	return 0;
}
        
BYTE stud_bgp_FsmEventTcpException(BgpPeer *pPeer,BYTE msgType)      
{
	if ( msgType == BGP_TCP_CLOSE )//IE4
	{
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
			case BGP_STATE_IDLE:
			case BGP_STATE_CONNECT:
			case BGP_STATE_ACTIVE:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			case BGP_STATE_OPENSENT:
				pPeer->bgp_byState = BGP_STATE_ACTIVE;
				break;
			default: 
				break;
		}
	}
	else if ( msgType == BGP_TCP_FATAL_ERROR )//IE
	{
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
			case BGP_STATE_IDLE:
			case BGP_STATE_CONNECT:
			case BGP_STATE_ACTIVE:
			case BGP_STATE_OPENSENT:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			default: 
				break;
		}
	}
	else if ( msgType == BGP_TCP_RETRANSMISSION_TIMEOUT)//IE5
	{
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
			case BGP_STATE_IDLE:
			case BGP_STATE_OPENSENT:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			case BGP_STATE_ACTIVE:
			case BGP_STATE_CONNECT:
				pPeer->bgp_byState = BGP_STATE_ACTIVE;
				break;
			default: 
				break;
		}
	}
	return 0;
}
	
BYTE stud_bgp_FsmEventTimerProcess(BgpPeer *pPeer,BYTE msgType)
{
	if ( msgType == BGP_CONNECTRETRY_TIMEOUT ) //IE7
	{
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_CONNECT:
			case BGP_STATE_ACTIVE:
				pPeer->bgp_byState = BGP_STATE_CONNECT;
				break;
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
			case BGP_STATE_IDLE:
			case BGP_STATE_OPENSENT:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			default: 
				break;
		}
	}
	else if ( msgType == BGP_HOLD_TIMEOUT )//IE
    {
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
			case BGP_STATE_IDLE:
			case BGP_STATE_CONNECT:
			case BGP_STATE_ACTIVE:
			case BGP_STATE_OPENSENT:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			default: 
				break;
		}
	}
	else if ( msgType == BGP_KEEPALIVE_TIMEOUT )//IE9
	{
		switch(pPeer->bgp_byState)
		{
			case BGP_STATE_IDLE:
			case BGP_STATE_OPENSENT:
			case BGP_STATE_CONNECT:
			case BGP_STATE_ACTIVE:
				pPeer->bgp_byState = BGP_STATE_IDLE;
				break;
			case BGP_STATE_OPENCONFIRM:
			case BGP_STATE_ESTABLISHED:
				Send_keepalive();
				break;
			default: 
				break;
		}
	}
	return 0;
}
        
BYTE stud_bgp_FsmEventStart(BgpPeer *pPeer) 
{
	switch (pPeer->bgp_byState)
	{
		case BGP_STATE_IDLE:
			bgp_FsmTryToConnectPeer();
			pPeer->bgp_byState = BGP_STATE_CONNECT;
			break;
		default:
			break;
	}
	return 0;
}
       
BYTE stud_bgp_FsmEventStop(BgpPeer *pPeer) //IE2  
{
	switch(pPeer->bgp_byState)
	{
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
		case BGP_STATE_IDLE:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: 
			break;
	}
	return 0;
}
       
BYTE stud_bgp_FsmEventConnect(BgpPeer *pPeer) //IE3
{
	switch(pPeer->bgp_byState)
	{
		case BGP_STATE_IDLE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
			Send_open( pPeer );
			pPeer->bgp_byState = BGP_STATE_OPENSENT;
			break;
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			Send_notification(BGP_ERR_FM);
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: 
			break;
	}
	return 0;
}

