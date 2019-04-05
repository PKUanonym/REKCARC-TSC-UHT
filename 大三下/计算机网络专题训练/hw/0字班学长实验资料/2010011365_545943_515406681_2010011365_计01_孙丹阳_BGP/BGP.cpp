#include "sysinclude.h"

#define BGP_ERR_CEASE 6
#define BGP_ERR_FM 5
#define BGP_ERR_HOLD 4
#define BGP_ERR_UPDATE 3
#define BGP_ERR_OPEN 2
#define BGP_ERR_HEADER 1

struct BGPOpenPacket{
	UINT32 header_marker[4];
	UINT16 header_length;
	UINT8 header_type;
	UINT8 version;
	UINT16 myas;
	UINT16 holdtime;
	UINT32 bgp_idf;
	UINT8 opl;
};

struct BGPKeepAlivePacket{
	UINT32 header_marker[4];
	UINT16 header_length;
	UINT8 header_type;
};

struct BGPNotifyPacket{
	UINT32 header_marker[4];
	UINT16 header_length;
	UINT8 header_type;
	UINT8 errorcode;
	UINT8 errsubcode;
};

extern void bgp_FsmTryToConnectPeer();
extern void bgp_FsmSendTcpData(char *pBuf,DWORD dwLen);

void send_notification(UINT8 error_code){
	BGPNotifyPacket * send = new BGPNotifyPacket();
	for(int i = 0; i < 4; i++)
		send->header_marker[i] = 0xffffffff;
	send->header_length = htons(sizeof(BGPNotifyPacket));
	send->header_type = BGP_NOTIFY;
	send->errorcode = error_code;
	bgp_FsmSendTcpData( (char*)send , sizeof(BGPNotifyPacket));
	delete send;
	return;
}

void send_keepalive(){
	BGPKeepAlivePacket * send = new BGPKeepAlivePacket();
	for(int i = 0; i < 4; i++)
		send->header_marker[i] = 0xffffffff;
	send->header_length = htons(sizeof(BGPKeepAlivePacket));
	send->header_type = BGP_KEEPALIVE;
	bgp_FsmSendTcpData( (char*)send , sizeof(BGPKeepAlivePacket));
	delete send;
	return;
}

void send_open(BgpPeer *pPeer){
	BGPOpenPacket * send = new BGPOpenPacket();
	for(int i = 0; i < 4; i++)
		send->header_marker[i] = 0xffffffff;
	send->header_length = htons(sizeof(BGPOpenPacket));
	send->header_type = BGP_OPEN;
	send->version = pPeer->bVersion;
	send->myas = htons( pPeer->bgp_wMyAS );
	send->holdtime = htons( (UINT16) pPeer->bgp_dwCfgHoldtime );
	send->bgp_idf = htonl( pPeer->bgp_dwMyRouterID );
	send->opl = 0;
	bgp_FsmSendTcpData( (char*)send , sizeof(BGPOpenPacket));
	delete send;
	return;
}

BYTE stud_bgp_FsmEventOpen(BgpPeer *pPeer,BYTE *pBuf,unsigned int len){
	BGPOpenPacket * packet = (BGPOpenPacket *) pBuf;
	
	switch(pPeer->bgp_byState){
	case BGP_STATE_OPENCONFIRM:
	case BGP_STATE_ESTABLISHED:
		send_notification(BGP_ERR_FM);
	case BGP_STATE_IDLE:
	case BGP_STATE_CONNECT:
	case BGP_STATE_ACTIVE:
		pPeer->bgp_byState = BGP_STATE_IDLE;
		break;
	case BGP_STATE_OPENSENT:
		if(packet->header_type != BGP_OPEN){
			send_notification(BGP_ERR_HEADER);
			pPeer->bgp_byState = BGP_STATE_IDLE;
			return 0;
		}else if(packet->version != 4){
			send_notification(BGP_ERR_OPEN);
			pPeer->bgp_byState = BGP_STATE_IDLE;
			return 0;
		}
		send_keepalive();
		pPeer->bgp_byState = BGP_STATE_OPENCONFIRM;
		break;
	default: break;
	}
}

BYTE stud_bgp_FsmEventKeepAlive(BgpPeer *pPeer,BYTE *pBuf,unsigned int len){
	switch(pPeer->bgp_byState){
	case BGP_STATE_OPENCONFIRM:
		pPeer->bgp_byState = BGP_STATE_ESTABLISHED;
		break;
	case BGP_STATE_IDLE:
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

BYTE stud_bgp_FsmEventNotification(BgpPeer *pPeer,BYTE *pBuf,unsigned int len){
	pPeer->bgp_byState = BGP_STATE_IDLE;
	return 0;
}

BYTE stud_bgp_FsmEventUpdate(BgpPeer *pPeer,BYTE *pBuf,unsigned int len){
	switch(pPeer->bgp_byState){
	case BGP_STATE_IDLE:
	case BGP_STATE_ACTIVE:
	case BGP_STATE_CONNECT:
	case BGP_STATE_OPENSENT:
	case BGP_STATE_OPENCONFIRM:
		pPeer->bgp_byState = BGP_STATE_IDLE;
		break;
	default: break;
	}
	return 0;
}

BYTE stud_bgp_FsmEventTcpException(BgpPeer *pPeer,BYTE msgType){
	if ( msgType == 1 ){
		switch(pPeer->bgp_byState){
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_notification(BGP_ERR_FM);
		case BGP_STATE_IDLE:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_ACTIVE;
			break;
		default: break;
		}
	}
	else if ( msgType == 2 ){
		switch(pPeer->bgp_byState){
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_notification(BGP_ERR_FM);
		case BGP_STATE_IDLE:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: break;
		}
	}
	else if ( msgType == 3 ){
		switch(pPeer->bgp_byState){
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_notification(5);
		case BGP_STATE_IDLE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		case BGP_STATE_ACTIVE:
		case BGP_STATE_CONNECT:
			pPeer->bgp_byState = BGP_STATE_ACTIVE;
			break;
		default: break;
		}
	}
	return 0;
}

BYTE stud_bgp_FsmEventTimerProcess(BgpPeer *pPeer,BYTE msgType){
	if ( msgType == BGP_CONNECTRETRY_TIMEOUT ) {
		switch(pPeer->bgp_byState){
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
			pPeer->bgp_byState = BGP_STATE_CONNECT;
			break;
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_notification(BGP_ERR_FM);
		case BGP_STATE_IDLE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: break;
		}
	}
	else if ( msgType == BGP_HOLD_TIMEOUT ){
		switch(pPeer->bgp_byState){
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_notification(BGP_ERR_HOLD);
		case BGP_STATE_IDLE:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
		case BGP_STATE_OPENSENT:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		default: break;
		}
	}
	else if ( msgType == BGP_KEEPALIVE_TIMEOUT ){
		switch(pPeer->bgp_byState){
		case BGP_STATE_IDLE:
		case BGP_STATE_OPENSENT:
		case BGP_STATE_CONNECT:
		case BGP_STATE_ACTIVE:
			pPeer->bgp_byState = BGP_STATE_IDLE;
			break;
		case BGP_STATE_OPENCONFIRM:
		case BGP_STATE_ESTABLISHED:
			send_keepalive();
			break;
		default: break;
		}
	}
	return 0;
}

BYTE stud_bgp_FsmEventStart(BgpPeer *pPeer){
	if( pPeer->bgp_byState == BGP_STATE_IDLE ){
		bgp_FsmTryToConnectPeer();
		pPeer->bgp_byState = BGP_STATE_CONNECT;
	}
	return 0;
}

BYTE stud_bgp_FsmEventStop(BgpPeer *pPeer){
	switch(pPeer->bgp_byState){
	case BGP_STATE_OPENCONFIRM:
	case BGP_STATE_ESTABLISHED:
		send_notification(BGP_ERR_CEASE);
	case BGP_STATE_IDLE:
	case BGP_STATE_CONNECT:
	case BGP_STATE_ACTIVE:
	case BGP_STATE_OPENSENT:
		pPeer->bgp_byState = BGP_STATE_IDLE;
		break;
	default: break;
	}
	return 0;
}

BYTE stud_bgp_FsmEventConnect(BgpPeer *pPeer){
	switch(pPeer->bgp_byState){
	case BGP_STATE_IDLE:
	case BGP_STATE_OPENSENT:
		pPeer->bgp_byState = BGP_STATE_IDLE;
		break;
	case BGP_STATE_CONNECT:
	case BGP_STATE_ACTIVE:
		send_open( pPeer );
		pPeer->bgp_byState = BGP_STATE_OPENSENT;
		break;
	case BGP_STATE_OPENCONFIRM:
	case BGP_STATE_ESTABLISHED:
		send_notification(BGP_ERR_FM);
		pPeer->bgp_byState = BGP_STATE_IDLE;
		break;
	default: break;
	}
	return 0;
}

