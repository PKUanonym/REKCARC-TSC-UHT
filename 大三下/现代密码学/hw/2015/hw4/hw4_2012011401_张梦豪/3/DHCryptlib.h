

#include "AESHead.h"

#if defined(__cplusplus)
extern "C"
{
#endif


#ifndef RET_TYPE_DEFINED
typedef int  ret_type;
#endif

#ifndef RETURN_GOOD
# define RETURN_WARN      1
# define RETURN_GOOD      0
# define RETURN_ERROR    -1
#endif


UNIT_TYPEDEF(gcm_unit_t, UNIT_BITS);
BUFR_TYPEDEF(gcm_buf_t, UNIT_BITS, AES_BLOCK_SIZE);

UNIT_TYPEDEF(gf_unit_t, UNIT_BITS);
BUFR_TYPEDEF(gf_t, UNIT_BITS, GF_BYTE_LEN);

typedef gf_t    gf_t4k_a[256];
typedef gf_t    (*gf_t4k_t);



/* The GCM-AES  context  */
#  define TABLES_4K
typedef struct
{

#if defined( TABLES_4K )
	gf_t4k_a        gf_t4k;
#endif

	gcm_buf_t       ctr_val;                /* CTR counter value            */
	gcm_buf_t       enc_ctr;                /* encrypted CTR block          */
	gcm_buf_t       hdr_ghv;                /* ghash buffer (header)        */
	gcm_buf_t       txt_ghv;                /* ghash buffer (ciphertext)    */
	gf_t            ghash_h;                /* ghash H value                */
	aes_encrypt_ctx aes[1];                 /* AES encryption context       */
	uint_32t        y0_val;                 /* initial counter value        */
	uint_32t        hdr_cnt;                /* header bytes so far          */
	uint_32t        txt_ccnt;               /* text bytes so far (encrypt)  */
	uint_32t        txt_acnt;               /* text bytes so far (auth)     */
} gcm_ctx;


/* The following calls handle mode initialisation, keying and completion    */

ret_type gcm_init_and_key(                  /* initialise mode and set key  */
            const unsigned char key[],      /* the key value                */
            unsigned long key_len,          /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

ret_type gcm_end(                           /* clean up and end operation   */
            gcm_ctx ctx[1]);                /* the mode context             */

/* The following calls handle complete messages in memory as one operation  */

ret_type gcm_encrypt_message(               /* encrypt an entire message    */
            const unsigned char iv[],       /* the initialisation vector    */
            unsigned long iv_len,           /* and its length in bytes      */
            const unsigned char hdr[],      /* the header buffer            */
            unsigned long hdr_len,          /* and its length in bytes      */
            unsigned char msg[],            /* the message buffer           */
            unsigned long msg_len,          /* and its length in bytes      */
            unsigned char tag[],            /* the buffer for the tag       */
            unsigned long tag_len,          /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

                                /* RETURN_GOOD is returned if the input tag */
                                /* matches that for the decrypted message   */
ret_type gcm_decrypt_message(               /* decrypt an entire message    */
            const unsigned char iv[],       /* the initialisation vector    */
            unsigned long iv_len,           /* and its length in bytes      */
            const unsigned char hdr[],      /* the header buffer            */
            unsigned long hdr_len,          /* and its length in bytes      */
            unsigned char msg[],            /* the message buffer           */
            unsigned long msg_len,          /* and its length in bytes      */
            const unsigned char tag[],      /* the buffer for the tag       */
            unsigned long tag_len,          /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

/* The following calls handle messages in a sequence of operations followed */
/* by tag computation after the sequence has been completed. In these calls */
/* the user is responsible for verfiying the computed tag on decryption     */

ret_type gcm_init_message(                  /* initialise a new message     */
            const unsigned char iv[],       /* the initialisation vector    */
            unsigned long iv_len,           /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

ret_type gcm_auth_header(                   /* authenticate the header      */
            const unsigned char hdr[],      /* the header buffer            */
            unsigned long hdr_len,          /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

ret_type gcm_encrypt(                       /* encrypt & authenticate data  */
            unsigned char data[],           /* the data buffer              */
            unsigned long data_len,         /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

ret_type gcm_decrypt(                       /* authenticate & decrypt data  */
            unsigned char data[],           /* the data buffer              */
            unsigned long data_len,         /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

ret_type gcm_compute_tag(                   /* compute authentication tag   */
            unsigned char tag[],            /* the buffer for the tag       */
            unsigned long tag_len,          /* and its length in bytes      */
            gcm_ctx ctx[1]);                /* the mode context             */

 ret_type gcm_auth_data(                     /* authenticate ciphertext data */
             const unsigned char data[],     /* the data buffer              */
             unsigned long data_len,         /* and its length in bytes      */
             gcm_ctx ctx[1]);                /* the mode context             */

 ret_type gcm_crypt_data(                    /* encrypt or decrypt data      */
             unsigned char data[],           /* the data buffer              */
             unsigned long data_len,         /* and its length in bytes      */
             gcm_ctx ctx[1]);                /* the mode context             */

//加解密对外接口函数
int Decrypt_StringData(
	        char* pKey,                     /*密钥*/
			char* pIV,                      /*初始化向量*/
			char* pHDR,
			char* pCiphertext,              /*密文*/
			char* pTag,                     /*认证识别码*/
			char* pOutPlaintext);           /*明文*/
int Decrypt_ByteData(
	        unsigned char* pKey,            /*密钥*/
			unsigned char* pIV ,            /*初始化向量*/
			unsigned char* pHDR,            /*头-附加数据*/
			int nHdrLen,
			unsigned char* pCiphertext,     /*密文*/
			int *nCtextLen,
			unsigned char* pTag,            /*认证识别码*/
			unsigned char* pOutPlaintext);  /*明文*/
int Encrypt_StringData(
	        char* pKey,                     /*密钥*/
			char* pIV,                      /*初始化向量*/
			char* pHDR,
			char* pPlaintext,               /*明文*/
			char* pOutCiphertext,           /*密文*/
			char* pOutTag);                 /*认证识别码*/
int Encrypt_ByteData(
	        unsigned char* pKey,            /*密钥*/
			int nKeyLen,
			unsigned char* pIV,             /*初始化向量*/
			int nIVLen,
			unsigned char* pHDR,
			int nHdrLen,
			unsigned char* pPlaintext,     /*明文*/
			int nPtextLen,
			unsigned char* pOutCiphertext, /*密文*/
			unsigned char* pOutTag);       /*认证识别码*/
//字符串转16进制处理函数
void GetBCDFrom16Xchar(char *fromText,unsigned char *toData,int toDatalen);
int CopyCharToByte(char* pfrom,unsigned char* todata,int datalen);

//密钥加密函数
int aes_wrap_String(char* pKey,char* pPlain,char* pCipher);
int aes_wrap_byte(unsigned char* pKey,unsigned char* pPlain,unsigned char* pCipher);
//密钥解密函数
int aes_unwrap_string(char* pKey,char* pCipher,char* pPlain);
int aes_unwrap_byte(unsigned char* pKey,unsigned char* pCipher,unsigned char* pPlain);
//////////////////////////////////////////////////////////////////////////


#if defined(__cplusplus)
}
#endif
