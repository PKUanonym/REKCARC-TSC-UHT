#include "DHCryptlib.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#if defined(__cplusplus)
extern "C"
{
#endif

#define _MaxText_Length_ 1024  //最大加解密数据长度 


mh_decl void xor_block_aligned(void *r, const void *p, const void *q)
{
	rep3_u4(f_xor, UNIT_PTR(r), UNIT_PTR(p), UNIT_PTR(q), UNIT_VAL);
}
gf_decl void gf_mulx1_lb(gf_t r, const gf_t x)
{   
	gf_unit_t _tt;
	_tt = gf_tab[(UNIT_PTR(x)[3] >> 17) & MASK(0x80)];

	rep2_d4(f1_lb, UNIT_PTR(r), UNIT_PTR(x));
	UNIT_PTR(r)[0] ^= _tt;
}
void init_4k_table(const gf_t g, gf_t4k_t t)
{   
	int j, k;

	memset(t[0], 0, GF_BYTE_LEN);

	memcpy(t[128], g, GF_BYTE_LEN);
	for(j = 64; j >= 1; j >>= 1)
		gf_mulx1(mode)(t[j], t[j + j]);
	for(j = 2; j < 256; j += j)
		for(k = 1; k < j; ++k)
			xor_block_aligned(t[j + k], t[j], t[k]);
}

#define xor_4k(i,ap,t,r) gf_mulx8(mode)(r); xor_block_aligned(r, r, t[ap[GF_INDEX(i)]])

#  define ls_box(x,c)       four_tables(x,t_use(f,l),vf1,rf2,c)
#define ke4(k,i) \
{   k[4*(i)+4] = ss[0] ^= ls_box(ss[3],3) ^ t_use(r,c)[i]; \
	k[4*(i)+5] = ss[1] ^= ss[0]; \
	k[4*(i)+6] = ss[2] ^= ss[1]; \
	k[4*(i)+7] = ss[3] ^= ss[2]; \
}
#define v(n,i)  ((n) - (i) + 2 * ((i) & 3))
#define k4e(k,i) \
{   k[v(40,(4*(i))+4)] = ss[0] ^= ls_box(ss[3],3) ^ t_use(r,c)[i]; \
	k[v(40,(4*(i))+5)] = ss[1] ^= ss[0]; \
	k[v(40,(4*(i))+6)] = ss[2] ^= ss[1]; \
	k[v(40,(4*(i))+7)] = ss[3] ^= ss[2]; \
}


#define kdf4(k,i) \
{   ss[0] = ss[0] ^ ss[2] ^ ss[1] ^ ss[3]; \
	ss[1] = ss[1] ^ ss[3]; \
	ss[2] = ss[2] ^ ss[3]; \
	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ t_use(r,c)[i]; \
	ss[i % 4] ^= ss[4]; \
	ss[4] ^= k[v(40,(4*(i)))];   k[v(40,(4*(i))+4)] = ff(ss[4]); \
	ss[4] ^= k[v(40,(4*(i))+1)]; k[v(40,(4*(i))+5)] = ff(ss[4]); \
	ss[4] ^= k[v(40,(4*(i))+2)]; k[v(40,(4*(i))+6)] = ff(ss[4]); \
	ss[4] ^= k[v(40,(4*(i))+3)]; k[v(40,(4*(i))+7)] = ff(ss[4]); \
}

#define kd4(k,i) \
{   ss[4] = ls_box(ss[(i+3) % 4], 3) ^ t_use(r,c)[i]; \
	ss[i % 4] ^= ss[4]; ss[4] = ff(ss[4]); \
	k[v(40,(4*(i))+4)] = ss[4] ^= k[v(40,(4*(i)))]; \
	k[v(40,(4*(i))+5)] = ss[4] ^= k[v(40,(4*(i))+1)]; \
	k[v(40,(4*(i))+6)] = ss[4] ^= k[v(40,(4*(i))+2)]; \
	k[v(40,(4*(i))+7)] = ss[4] ^= k[v(40,(4*(i))+3)]; \
}

#define kdl4(k,i) \
{   ss[4] = ls_box(ss[(i+3) % 4], 3) ^ t_use(r,c)[i]; ss[i % 4] ^= ss[4]; \
	k[v(40,(4*(i))+4)] = (ss[0] ^= ss[1]) ^ ss[2] ^ ss[3]; \
	k[v(40,(4*(i))+5)] = ss[1] ^ ss[3]; \
	k[v(40,(4*(i))+6)] = ss[0]; \
	k[v(40,(4*(i))+7)] = ss[1]; \
}

AES_RETURN aes_encrypt_key128(const unsigned char *key, aes_encrypt_ctx cx[1])
{  
	uint_32t    ss[4];

	cx->ks[0] = ss[0] = word_in(key, 0);
	cx->ks[1] = ss[1] = word_in(key, 1);
	cx->ks[2] = ss[2] = word_in(key, 2);
	cx->ks[3] = ss[3] = word_in(key, 3);

	ke4(cx->ks, 0);  ke4(cx->ks, 1);
	ke4(cx->ks, 2);  ke4(cx->ks, 3);
	ke4(cx->ks, 4);  ke4(cx->ks, 5);
	ke4(cx->ks, 6);  ke4(cx->ks, 7);
	ke4(cx->ks, 8);

	ke4(cx->ks, 9);
	cx->inf.l = 0;
	cx->inf.b[0] = 10 * 16;


	cx->inf.b[1] = 0xff;

	return EXIT_SUCCESS;
}
//初始化key
AES_RETURN aes_encrypt_key(const unsigned char *key, int key_len, aes_encrypt_ctx cx[1])
{   
	if(key_len!=16&&key_len!=128)
		return EXIT_FAILURE;
    return aes_encrypt_key128(key, cx);
}
#  define s(x,c) x[c]
#define si(y,x,k,c) (s(y,c) = word_in(x, c) ^ (k)[c])
#define so(y,x,c)   word_out(y, c, s(x,c))
#define locals(y,x)     x[4],y[4]
#define l_copy(y, x)    s(y,0) = s(x,0); s(y,1) = s(x,1); \
	s(y,2) = s(x,2); s(y,3) = s(x,3);
#define state_in(y,x,k) si(y,x,k,0); si(y,x,k,1); si(y,x,k,2); si(y,x,k,3)
#define state_out(y,x)  so(y,x,0); so(y,x,1); so(y,x,2); so(y,x,3)
#define round(rm,y,x,k) rm(y,x,k,0); rm(y,x,k,1); rm(y,x,k,2); rm(y,x,k,3)
#define fwd_var(x,r,c)\
	( r == 0 ? ( c == 0 ? s(x,0) : c == 1 ? s(x,1) : c == 2 ? s(x,2) : s(x,3))\
	: r == 1 ? ( c == 0 ? s(x,1) : c == 1 ? s(x,2) : c == 2 ? s(x,3) : s(x,0))\
	: r == 2 ? ( c == 0 ? s(x,2) : c == 1 ? s(x,3) : c == 2 ? s(x,0) : s(x,1))\
	:          ( c == 0 ? s(x,3) : c == 1 ? s(x,0) : c == 2 ? s(x,1) : s(x,2)))
#define fwd_rnd(y,x,k,c)    (s(y,c) = (k)[c] ^ four_tables(x,t_use(f,n),fwd_var,rf1,c))
#define fwd_lrnd(y,x,k,c)   (s(y,c) = (k)[c] ^ four_tables(x,t_use(f,l),fwd_var,rf1,c))

AES_RETURN aes_encrypt(const unsigned char *in, unsigned char *out, const aes_encrypt_ctx cx[1])
{   
	uint_32t         locals(b0, b1);
    const uint_32t   *kp;


if( cx->inf.b[0] != 10 * 16 && cx->inf.b[0] != 12 * 16 && cx->inf.b[0] != 14 * 16 )
	return EXIT_FAILURE;

kp = cx->ks;
state_in(b0, in, kp);

switch(cx->inf.b[0])
{
case 14 * 16:
	round(fwd_rnd,  b1, b0, kp + 1 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 2 * N_COLS);
	kp += 2 * N_COLS;
case 12 * 16:
	round(fwd_rnd,  b1, b0, kp + 1 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 2 * N_COLS);
	kp += 2 * N_COLS;
case 10 * 16:
	round(fwd_rnd,  b1, b0, kp + 1 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 2 * N_COLS);
	round(fwd_rnd,  b1, b0, kp + 3 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 4 * N_COLS);
	round(fwd_rnd,  b1, b0, kp + 5 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 6 * N_COLS);
	round(fwd_rnd,  b1, b0, kp + 7 * N_COLS);
	round(fwd_rnd,  b0, b1, kp + 8 * N_COLS);
	round(fwd_rnd,  b1, b0, kp + 9 * N_COLS);
	round(fwd_lrnd, b0, b1, kp +10 * N_COLS);
}
state_out(out, b0);
return EXIT_SUCCESS;
}


#define inc_ctr(x)  \
{   int i = BLOCK_SIZE; while(i-- > CTR_POS && !++(UI8_PTR(x)[i])) ; }

ret_type gcm_init_and_key(          /* initialise mode and set key  */
	const unsigned char key[],      /* the key value                */
	unsigned long key_len,          /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{
	memset(ctx->ghash_h, 0, sizeof(ctx->ghash_h));

	/* set the AES key                          */
	aes_encrypt_key(key, key_len, ctx->aes);

	/* compute E(0) (for the hash function)     */
	aes_encrypt(UI8_PTR(ctx->ghash_h), UI8_PTR(ctx->ghash_h), ctx->aes);

#if defined( TABLES_4K )
	init_4k_table(ctx->ghash_h, ctx->gf_t4k);
#endif
	return RETURN_GOOD;
}
mh_decl void copy_block_aligned(void *p, const void *q)
{
	 rep2_u4(f_copy,UNIT_PTR(p),UNIT_PTR(q));
}
gf_decl void gf_mulx8_lb(gf_t x)
{   gf_unit_t _tt;

   _tt = gf_tab[UNIT_PTR(x)[3] >> 24];

   rep2_d4(f8_lb, UNIT_PTR(x), UNIT_PTR(x));
   UNIT_PTR(x)[0] ^= _tt;
}

#define xor_4k(i,ap,t,r) gf_mulx8(mode)(r); xor_block_aligned(r, r, t[ap[GF_INDEX(i)]])
void gf_mul_4k(gf_t a, const gf_t4k_t t, gf_t r)
{   
	uint_8t *ap = (uint_8t*)a;
	memset(r, 0, GF_BYTE_LEN);
	xor_4k(15, ap, t, r); xor_4k(14, ap, t, r);
	xor_4k(13, ap, t, r); xor_4k(12, ap, t, r);
	xor_4k(11, ap, t, r); xor_4k(10, ap, t, r);
	xor_4k( 9, ap, t, r); xor_4k( 8, ap, t, r);
	xor_4k( 7, ap, t, r); xor_4k( 6, ap, t, r);
	xor_4k( 5, ap, t, r); xor_4k( 4, ap, t, r);
	xor_4k( 3, ap, t, r); xor_4k( 2, ap, t, r);
	xor_4k( 1, ap, t, r); xor_4k( 0, ap, t, r);
	copy_block_aligned(a, r);
}
void gf_mul_hh(gf_t a, gcm_ctx ctx[1])
{
	gf_t    scr;
	gf_mul_4k(a, ctx->gf_t4k, scr);
}
ret_type gcm_init_message(                  /* initialise a new message     */
	const unsigned char iv[],       /* the initialisation vector    */
	unsigned long iv_len,           /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{   
	uint_32t i, n_pos = 0;
	uint_8t *p;

	memset(ctx->ctr_val, 0, BLOCK_SIZE);
	if(iv_len == CTR_POS)
	{
		memcpy(ctx->ctr_val, iv, CTR_POS); UI8_PTR(ctx->ctr_val)[15] = 0x01;
	}
	else
	{   n_pos = iv_len;
	while(n_pos >= BLOCK_SIZE)
	{
		xor_block_aligned(ctx->ctr_val, ctx->ctr_val, iv);
		n_pos -= BLOCK_SIZE;
		iv += BLOCK_SIZE;
		gf_mul_hh(ctx->ctr_val, ctx);
	}

	if(n_pos)
	{
		p = UI8_PTR(ctx->ctr_val);
		while(n_pos-- > 0)
			*p++ ^= *iv++;
		gf_mul_hh(ctx->ctr_val, ctx);
	}
	n_pos = (iv_len << 3);
	for(i = BLOCK_SIZE - 1; n_pos; --i, n_pos >>= 8)
		UI8_PTR(ctx->ctr_val)[i] ^= (unsigned char)n_pos;
	gf_mul_hh(ctx->ctr_val, ctx);
	}

	ctx->y0_val = *UI32_PTR(UI8_PTR(ctx->ctr_val) + CTR_POS);
	memset(ctx->hdr_ghv, 0, BLOCK_SIZE);
	memset(ctx->txt_ghv, 0, BLOCK_SIZE);
	ctx->hdr_cnt = 0;
	ctx->txt_ccnt = ctx->txt_acnt = 0;
	return RETURN_GOOD;
}
mh_decl void xor_block(void *r, const void* p, const void* q)
{
	rep3_u16(f_xor, UI8_PTR(r), UI8_PTR(p), UI8_PTR(q), UI8_VAL);
}

ret_type gcm_auth_header(                   /* authenticate the header      */
	const unsigned char hdr[],      /* the header buffer            */
	unsigned long hdr_len,          /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{  
	uint_32t cnt = 0, b_pos = (uint_32t)ctx->hdr_cnt & BLK_ADR_MASK;

	if(!hdr_len)
		return RETURN_GOOD;

	if(ctx->hdr_cnt && b_pos == 0)
		gf_mul_hh(ctx->hdr_ghv, ctx);

	if(!((hdr - (UI8_PTR(ctx->hdr_ghv) + b_pos)) & BUF_ADRMASK))
	{
		while(cnt < hdr_len && (b_pos & BUF_ADRMASK))
			UI8_PTR(ctx->hdr_ghv)[b_pos++] ^= hdr[cnt++];

		while(cnt + BUF_INC <= hdr_len && b_pos <= BLOCK_SIZE - BUF_INC)
		{
			*UNIT_PTR(UI8_PTR(ctx->hdr_ghv) + b_pos) ^= *UNIT_PTR(hdr + cnt);
			cnt += BUF_INC; b_pos += BUF_INC;
		}

		while(cnt + BLOCK_SIZE <= hdr_len)
		{
			gf_mul_hh(ctx->hdr_ghv, ctx);
			xor_block_aligned(ctx->hdr_ghv, ctx->hdr_ghv, hdr + cnt);
			cnt += BLOCK_SIZE;
		}
	}
	else
	{
		while(cnt < hdr_len && b_pos < BLOCK_SIZE)
			UI8_PTR(ctx->hdr_ghv)[b_pos++] ^= hdr[cnt++];

		while(cnt + BLOCK_SIZE <= hdr_len)
		{
			gf_mul_hh(ctx->hdr_ghv, ctx);
			xor_block(ctx->hdr_ghv, ctx->hdr_ghv, hdr + cnt);
			cnt += BLOCK_SIZE;
		}
	}

	while(cnt < hdr_len)
	{
		if(b_pos == BLOCK_SIZE)
		{
			gf_mul_hh(ctx->hdr_ghv, ctx);
			b_pos = 0;
		}
		UI8_PTR(ctx->hdr_ghv)[b_pos++] ^= hdr[cnt++];
	}

	ctx->hdr_cnt += cnt;
	return RETURN_GOOD;
}

//////////////////////////////////////////////////////////////////////////

ret_type gcm_crypt_data(                    /* encrypt or decrypt data      */
	unsigned char data[],           /* the data buffer              */
	unsigned long data_len,         /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{   
	uint_32t cnt = 0, b_pos = (uint_32t)ctx->txt_ccnt & BLK_ADR_MASK;

	if(!data_len)
		return RETURN_GOOD;

	if(!((data - (UI8_PTR(ctx->enc_ctr) + b_pos)) & BUF_ADRMASK))
	{
		if(b_pos)
		{
			while(cnt < data_len && (b_pos & BUF_ADRMASK))
				data[cnt++] ^= UI8_PTR(ctx->enc_ctr)[b_pos++];

			while(cnt + BUF_INC <= data_len && b_pos <= BLOCK_SIZE - BUF_INC)
			{
				*UNIT_PTR(data + cnt) ^= *UNIT_PTR(UI8_PTR(ctx->enc_ctr) + b_pos);
				cnt += BUF_INC; b_pos += BUF_INC;
			}
		}

		while(cnt + BLOCK_SIZE <= data_len)
		{
			inc_ctr(ctx->ctr_val);
			aes_encrypt(UI8_PTR(ctx->ctr_val), UI8_PTR(ctx->enc_ctr), ctx->aes);
			xor_block_aligned(data + cnt, data + cnt, ctx->enc_ctr);
			cnt += BLOCK_SIZE;
		}
	}
	else
	{
		if(b_pos)
			while(cnt < data_len && b_pos < BLOCK_SIZE)
				data[cnt++] ^= UI8_PTR(ctx->enc_ctr)[b_pos++];

		while(cnt + BLOCK_SIZE <= data_len)
		{
			inc_ctr(ctx->ctr_val);
			aes_encrypt(UI8_PTR(ctx->ctr_val), UI8_PTR(ctx->enc_ctr), ctx->aes);
			xor_block(data + cnt, data + cnt, ctx->enc_ctr);
			cnt += BLOCK_SIZE;
		}
	}

	while(cnt < data_len)
	{
		if(b_pos == BLOCK_SIZE || !b_pos)
		{
			inc_ctr(ctx->ctr_val);
			aes_encrypt(UI8_PTR(ctx->ctr_val), UI8_PTR(ctx->enc_ctr), ctx->aes);
			b_pos = 0;
		}
		data[cnt++] ^= UI8_PTR(ctx->enc_ctr)[b_pos++];
	}

	ctx->txt_ccnt += cnt;
	return RETURN_GOOD;
}

ret_type gcm_auth_data(                     /* authenticate ciphertext data */
	const unsigned char data[],     /* the data buffer              */
	unsigned long data_len,         /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{   
	uint_32t cnt = 0, b_pos = (uint_32t)ctx->txt_acnt & BLK_ADR_MASK;

	if(!data_len)
		return RETURN_GOOD;

	if(ctx->txt_acnt && b_pos == 0)
		gf_mul_hh(ctx->txt_ghv, ctx);

	if(!((data - (UI8_PTR(ctx->txt_ghv) + b_pos)) & BUF_ADRMASK))
	{
		while(cnt < data_len && (b_pos & BUF_ADRMASK))
			UI8_PTR(ctx->txt_ghv)[b_pos++] ^= data[cnt++];

		while(cnt + BUF_INC <= data_len && b_pos <= BLOCK_SIZE - BUF_INC)
		{
			*UNIT_PTR(UI8_PTR(ctx->txt_ghv) + b_pos) ^= *UNIT_PTR(data + cnt);
			cnt += BUF_INC; b_pos += BUF_INC;
		}

		while(cnt + BLOCK_SIZE <= data_len)
		{
			gf_mul_hh(ctx->txt_ghv, ctx);
			xor_block_aligned(ctx->txt_ghv, ctx->txt_ghv, data + cnt);
			cnt += BLOCK_SIZE;
		}
	}
	else
	{
		while(cnt < data_len && b_pos < BLOCK_SIZE)
			UI8_PTR(ctx->txt_ghv)[b_pos++] ^= data[cnt++];

		while(cnt + BLOCK_SIZE <= data_len)
		{
			gf_mul_hh(ctx->txt_ghv, ctx);
			xor_block(ctx->txt_ghv, ctx->txt_ghv, data + cnt);
			cnt += BLOCK_SIZE;
		}
	}

	while(cnt < data_len)
	{
		if(b_pos == BLOCK_SIZE)
		{
			gf_mul_hh(ctx->txt_ghv, ctx);
			b_pos = 0;
		}
		UI8_PTR(ctx->txt_ghv)[b_pos++] ^= data[cnt++];
	}

	ctx->txt_acnt += cnt;
	return RETURN_GOOD;
}

ret_type gcm_encrypt(                       /* encrypt & authenticate data  */
	unsigned char data[],           /* the data buffer              */
	unsigned long data_len,         /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{
	gcm_crypt_data(data, data_len, ctx);
	gcm_auth_data(data, data_len, ctx);
	return RETURN_GOOD;
}


/* A slow field multiplier */

void gf_mul(gf_t a, const gf_t b)
{   
	gf_t p[8];
	uint_8t *q, ch;
	int i;

	copy_block_aligned(p[0], a);
	for(i = 0; i < 7; ++i)
		gf_mulx1(mode)(p[i + 1], p[i]);

	q = (uint_8t*)(a == b ? p[0] : b);
	memset(a, 0, GF_BYTE_LEN);
	for(i = 15 ;  ; )
	{
		ch = q[GF_INDEX(i)];
		if(ch & X_0)
			xor_block_aligned(a, a, p[0]);
		if(ch & X_1)
			xor_block_aligned(a, a, p[1]);
		if(ch & X_2)
			xor_block_aligned(a, a, p[2]);
		if(ch & X_3)
			xor_block_aligned(a, a, p[3]);
		if(ch & X_4)
			xor_block_aligned(a, a, p[4]);
		if(ch & X_5)
			xor_block_aligned(a, a, p[5]);
		if(ch & X_6)
			xor_block_aligned(a, a, p[6]);
		if(ch & X_7)
			xor_block_aligned(a, a, p[7]);
		if(!i--)
			break;
		gf_mulx8(mode)(a);
	}
}

ret_type gcm_compute_tag(                   /* compute authentication tag   */
	unsigned char tag[],            /* the buffer for the tag       */
	unsigned long tag_len,          /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{  
	uint_32t i, ln;
	gf_t tbuf;

	if(ctx->txt_acnt != ctx->txt_ccnt && ctx->txt_ccnt > 0)
		return RETURN_ERROR;

	gf_mul_hh(ctx->hdr_ghv, ctx);
	gf_mul_hh(ctx->txt_ghv, ctx);

	if(ctx->hdr_cnt)
	{
		ln = (uint_32t)((ctx->txt_acnt + BLOCK_SIZE - 1) / BLOCK_SIZE);
		if(ln)
		{
			/* alternative versions of the exponentiation operation */
			memcpy(tbuf, ctx->ghash_h, BLOCK_SIZE);

			for( ; ; )
			{
				if(ln & 1)
				{
					gf_mul(ctx->hdr_ghv, tbuf);
				}
				if(!(ln >>= 1))
					break;
				gf_mul(tbuf, tbuf);
			}
		}
	}

	i = BLOCK_SIZE; 

	{   uint_64t tm = ((uint_64t)ctx->txt_acnt) << 3;
	while(i-- > 0)
	{
		UI8_PTR(ctx->hdr_ghv)[i] ^= UI8_PTR(ctx->txt_ghv)[i] ^ (unsigned char)tm;
		tm = (i == 8 ? (((uint_64t)ctx->hdr_cnt) << 3) : tm >> 8);
	}
	}


	gf_mul_hh(ctx->hdr_ghv, ctx);

	memcpy(ctx->enc_ctr, ctx->ctr_val, BLOCK_SIZE);
	*UI32_PTR(UI8_PTR(ctx->enc_ctr) + CTR_POS) = ctx->y0_val;
	aes_encrypt(UI8_PTR(ctx->enc_ctr), UI8_PTR(ctx->enc_ctr), ctx->aes);
	for(i = 0; i < (unsigned int)tag_len; ++i)
		tag[i] = (unsigned char)(UI8_PTR(ctx->hdr_ghv)[i] ^ UI8_PTR(ctx->enc_ctr)[i]);

	return (ctx->txt_ccnt == ctx->txt_acnt ? RETURN_GOOD : RETURN_WARN);
}

ret_type gcm_end(                           /* clean up and end operation   */
	gcm_ctx ctx[1])                 /* the mode context             */
{
	memset(ctx, 0, sizeof(gcm_ctx));
	return RETURN_GOOD;
}

ret_type gcm_decrypt(                       /* authenticate & decrypt data  */
	unsigned char data[],           /* the data buffer              */
	unsigned long data_len,         /* and its length in bytes      */
	gcm_ctx ctx[1])                 /* the mode context             */
{
	gcm_auth_data(data, data_len, ctx);
	gcm_crypt_data(data, data_len, ctx);
	return RETURN_GOOD;
}

AES_RETURN aes_decrypt_key128(const unsigned char *key, aes_decrypt_ctx cx[1])
{   
	uint_32t    ss[5];
	cx->ks[v(40,(0))] = ss[0] = word_in(key, 0);
	cx->ks[v(40,(1))] = ss[1] = word_in(key, 1);
	cx->ks[v(40,(2))] = ss[2] = word_in(key, 2);
	cx->ks[v(40,(3))] = ss[3] = word_in(key, 3);
	kdf4(cx->ks, 0); kd4(cx->ks, 1);
	kd4(cx->ks, 2);  kd4(cx->ks, 3);
	kd4(cx->ks, 4);  kd4(cx->ks, 5);
	kd4(cx->ks, 6);  kd4(cx->ks, 7);
	kd4(cx->ks, 8);  kdl4(cx->ks, 9);
	cx->inf.l = 0;
	cx->inf.b[0] = 10 * 16;
	cx->inf.b[1] = 0xff;
	return EXIT_SUCCESS;
}
#define key_ofs     0
#define rnd_key(n)  (kp + n * N_COLS)
#define inv_var(x,r,c)\
	( r == 0 ? ( c == 0 ? s(x,0) : c == 1 ? s(x,1) : c == 2 ? s(x,2) : s(x,3))\
	: r == 1 ? ( c == 0 ? s(x,3) : c == 1 ? s(x,0) : c == 2 ? s(x,1) : s(x,2))\
	: r == 2 ? ( c == 0 ? s(x,2) : c == 1 ? s(x,3) : c == 2 ? s(x,0) : s(x,1))\
	:          ( c == 0 ? s(x,1) : c == 1 ? s(x,2) : c == 2 ? s(x,3) : s(x,0)))
#define inv_rnd(y,x,k,c)    (s(y,c) = (k)[c] ^ four_tables(x,t_use(i,n),inv_var,rf1,c))
#define inv_lrnd(y,x,k,c)   (s(y,c) = (k)[c] ^ four_tables(x,t_use(i,l),inv_var,rf1,c))
AES_RETURN aes_decrypt(const unsigned char *in, unsigned char *out, const aes_decrypt_ctx cx[1])
{
	uint_32t        locals(b0, b1);
	const uint_32t *kp;

	if( cx->inf.b[0] != 10 * 16 && cx->inf.b[0] != 12 * 16 && cx->inf.b[0] != 14 * 16 )
		return EXIT_FAILURE;

	kp = cx->ks + (key_ofs ? (cx->inf.b[0] >> 2) : 0);
	
	state_in(b0, in, kp);
	kp = cx->ks + (key_ofs ? 0 : (cx->inf.b[0] >> 2));
	switch(cx->inf.b[0])
	{
	case 14 * 16:
		round(inv_rnd,  b1, b0, rnd_key(-13));
		round(inv_rnd,  b0, b1, rnd_key(-12));
	case 12 * 16:
		round(inv_rnd,  b1, b0, rnd_key(-11));
		round(inv_rnd,  b0, b1, rnd_key(-10));
	case 10 * 16:
		round(inv_rnd,  b1, b0, rnd_key(-9));
		round(inv_rnd,  b0, b1, rnd_key(-8));
		round(inv_rnd,  b1, b0, rnd_key(-7));
		round(inv_rnd,  b0, b1, rnd_key(-6));
		round(inv_rnd,  b1, b0, rnd_key(-5));
		round(inv_rnd,  b0, b1, rnd_key(-4));
		round(inv_rnd,  b1, b0, rnd_key(-3));
		round(inv_rnd,  b0, b1, rnd_key(-2));
		round(inv_rnd,  b1, b0, rnd_key(-1));
		round(inv_lrnd, b0, b1, rnd_key( 0));
	}
	state_out(out, b0);
	return EXIT_SUCCESS;
}

AES_RETURN aes_decrypt_key(const unsigned char *key, int key_len, aes_decrypt_ctx cx[1])
{
	switch(key_len)
	{
	case 16: case 128: return aes_decrypt_key128(key, cx);
	default: return EXIT_FAILURE;
	}
}

void GetBCDFrom16Xchar(char *fromText,unsigned char *toData,int toDatalen)
{
	unsigned char data = 0,pos;
	memset(toData,0,toDatalen);
	for(int i=strlen(fromText)-1;i>=0;i--)
	{
		data = 0;
		if(*(fromText+i)>='0' && *(fromText+i)<='9')
			data = (*(fromText+i)-'0');
		else if(*(fromText+i)>='a' && *(fromText+i)<='f')
			data = (*(fromText+i)-'a'+10);
		else if(*(fromText+i)>='A' && *(fromText+i)<='F')
			data = (*(fromText+i)-'A'+10);
		if( (int)((strlen(fromText)-i-1)/2) > (toDatalen-1)) break;
		pos = strlen(fromText)-i-1;
		if(pos%2==0)
			*(toData+pos/2) = *(toData+pos/2)+data;
		else
			*(toData+pos/2) = *(toData+pos/2)+0x10*data;
	}
}
//将CString 中数据导入到 Byte * 中
//如果字节数不为偶数，在缺数位前补0
//如果CString长度 < BYTE *指定长度，在BYTE*高位补AA
int CopyCharToByte(char* pfrom,unsigned char* todata,int datalen)
{	
	memset(todata,0X00,datalen);
	int nlen=strlen(pfrom);
	if(nlen<1||nlen%2!=0)return -1;
	char temChar[3]="";
	int nDataLen=datalen;
	if(nDataLen>(nlen+1)/2)
		nDataLen = (nlen+1)/2;
	for(int i=0;i<nDataLen;i++)
	{
		if(i<nDataLen)
		{
			temChar[0] =  pfrom[i*2]; // pfrom[nlen-2-i*2];
		    temChar[1]  = pfrom[i*2+1];
		}
		else
			continue;
		unsigned char bbtmp;
		GetBCDFrom16Xchar(temChar,&bbtmp,1);
		memcpy(todata+i,&bbtmp,1);
	}
	return 1;
}
int Encrypt_ByteData(unsigned char* pKey/*密钥*/,int nKeyLen,unsigned char* pIV/*初始化向量*/,int nIVLen,unsigned char* pHDR,int nHdrLen,unsigned char* pPlaintext/*明文*/,int nPtextLen,unsigned char* pOutCiphertext/*密文*/,unsigned char* pOutTag/*认证识别码*/)
{
	unsigned char   key[16], iv[16], hdr[_MaxText_Length_], ptx[_MaxText_Length_], tbuf[16];
	int             key_len, iv_len, hdr_len, ptx_len, ctx_len, tag_len;

	//密钥长度固定为16字节
	key_len=nKeyLen;
	if(key_len!=16)return -1;
	memcpy(key,pKey,key_len);
	//初始化向量固定为12字节
	iv_len=nIVLen;
	if(iv_len!=12)return -1;
	memcpy(iv,pIV,iv_len);

	if(nHdrLen>=_MaxText_Length_)return -1;
	hdr_len=nHdrLen;
	if(nHdrLen>0)
	   memcpy(hdr,pHDR,nHdrLen);

	//明文
	ptx_len=0;
	memset(ptx,0,_MaxText_Length_);
	if(nPtextLen>=_MaxText_Length_)return -1;
	ptx_len=nPtextLen;
	if(ptx_len>0)
	   memcpy(ptx,pPlaintext,ptx_len);
	
	ctx_len=ptx_len;
	pOutTag[0]=0;

	//加密开始
	gcm_ctx contx[1];
	//////////////////////////////////////////////////////////////////////////
	gcm_init_and_key(key, key_len,contx);
	gcm_init_message(iv, iv_len, contx);

	gcm_auth_header(hdr, hdr_len, contx);

	memcpy(pOutCiphertext, ptx, ptx_len);
	gcm_encrypt(pOutCiphertext, ptx_len, contx);

	//拷贝Tag
	tag_len=16;
	gcm_compute_tag(tbuf, tag_len,contx);
	memcpy(pOutTag,tbuf, tag_len);

	gcm_end(contx);

	return 1;
}
int Encrypt_StringData(char* pKey/*密钥*/,char* pIV/*初始化向量*/,char* pHDR,char* pPlaintext/*明文*/,char* pOutCiphertext/*密文*/,char* pOutTag/*认证识别码*/)
{
	unsigned char   key[16], iv[16], hdr[_MaxText_Length_], ptx[_MaxText_Length_], ctx[_MaxText_Length_],tag[16];
	int             key_len, iv_len, hdr_len, ptx_len, ctx_len, tag_len, i;
	//Tag长度为12字节
	tag_len=16;
	//密钥长度固定为16字节
	key_len=strlen(pKey)/2;
	if(key_len!=16)return -1;
	CopyCharToByte(pKey,key,key_len);
	/*printf("key:\n");
	for (int i = 0; i < 16; i++)
	{
	    printf("%02x", key[i]);
	} */   

	//初始化向量固定为12字节
	iv_len=strlen(pIV)/2;
	if(iv_len!=12)return -1;
	CopyCharToByte(pIV,iv,iv_len);

	hdr_len=strlen(pHDR)/2;
	if(hdr_len>=_MaxText_Length_)return -1;
	if(hdr_len>0)
	{
		
		CopyCharToByte(pHDR,hdr,hdr_len);
	}
	else
	{
		hdr_len=0;
		hdr[0]=0;
	}

	//明文
	ptx_len=strlen(pPlaintext)/2;
	if(ptx_len>=_MaxText_Length_)return -1;
	if(ptx_len>0)
	{
		CopyCharToByte(pPlaintext,ptx,ptx_len);
	}
	else
	{
		ptx_len=0;
	}
	int nRet= Encrypt_ByteData(key,key_len,iv,iv_len,hdr,hdr_len,ptx,ptx_len,ctx,tag);
	if(nRet==1)
	{//拷贝密文
		pOutCiphertext[0]=0;
		char temp[10]="";
		for (i=0;i<ptx_len;i++)
		{
			sprintf(temp,"%02X",ctx[i]);
			strcat(pOutCiphertext,temp);
		}
		//拷贝Tag
		pOutTag[0]=0;
		for (i=0;i<tag_len;i++)
		{
			sprintf(temp,"%02x",tag[i]);
			strcat(pOutTag,temp);
		}
	}
	return nRet;
}
int Decrypt_ByteData(unsigned char* pKey/*密钥*/,unsigned char* pIV /*初始化向量*/,unsigned char* pHDR/*头-附加数据*/,int nHdrLen,unsigned char* pCiphertext /*密文*/,int *nCtextLen,unsigned char* pTag /*认证识别码*/,unsigned char* pOutPlaintext/*明文*/)
{//返回 -1：传入参数错误、0：解密错误 1：解密正确
	unsigned char   key[16], iv[12], hdr[_MaxText_Length_],  ctx[_MaxText_Length_], tbuf[16];
	int             key_len, iv_len, hdr_len, ctx_len, tag_len, i;
	//密钥长度固定为16字节
	key_len=16;
	memcpy(key,pKey,key_len);
	//初始化向量固定为12字节
	iv_len=12;
	memcpy(iv,pIV,iv_len);

	hdr_len=nHdrLen;
	if(hdr_len>=100)return -1;
	if(hdr_len>0)
		memcpy(hdr,pHDR,nHdrLen);

	//密文
	if(*nCtextLen>=_MaxText_Length_)return -1;
	ctx_len=*nCtextLen;
	if(ctx_len>0)
		memcpy(ctx,pCiphertext,ctx_len);

// 	ctx_len=0;
// 	pTag[0]=0;

	//解密开始
	gcm_ctx contx[1];
	//buf[0]=0;
	gcm_init_and_key(key, key_len,(gcm_ctx*) contx);
	gcm_init_message(iv, iv_len,(gcm_ctx*) contx);

	gcm_auth_header(hdr, hdr_len,(gcm_ctx*) contx);

	memcpy(pOutPlaintext, ctx, ctx_len);
	gcm_decrypt(pOutPlaintext, ctx_len,(gcm_ctx*) contx);
	//memcpy(pOutPlaintext,buf, ctx_len);
	char temp[10]="";
	//Tag长度为12字节
	int nOKFlag=1;
	if(pTag)
	{
		tag_len=12;
		gcm_compute_tag(tbuf, tag_len,(gcm_ctx*) contx);
		for (i=0;i<tag_len;i++)
		{
			if(pTag[i]!=tbuf[i])
			{
				nOKFlag=0;
				break;
			}
		}
	}
	gcm_end((gcm_ctx*)contx);
	return nOKFlag;
}
int Decrypt_StringData(char* pKey/*密钥*/,char* pIV/*初始化向量*/,char* pHDR,char* pCiphertext/*密文*/,char* pTag/*认证识别码*/,char* pOutPlaintext/*明文*/)
{
	unsigned char   key[16], iv[12], hdr[_MaxText_Length_],  ctx[_MaxText_Length_], buf[_MaxText_Length_], tbuf[16];
	int             key_len, iv_len, hdr_len, ptx_len, ctx_len, tag_len, i;

	//密钥长度固定为16字节
	key_len=strlen(pKey)/2;
	if(key_len!=16) return -1;
	CopyCharToByte(pKey,key,key_len);
	
	//初始化向量固定为12字节
	iv_len=strlen(pIV)/2;
	if(iv_len!=12) return -1;
	CopyCharToByte(pIV,iv,iv_len);

	hdr_len=strlen(pHDR)/2;
	if(hdr_len>100)return -1;
	if(hdr_len>0)
	{
		CopyCharToByte(pHDR,hdr,hdr_len);
	}
	else
	{
		hdr_len=0;
		hdr[0]=0;
	}
	//密文
	if(strlen(pCiphertext)>0)
	{
		CopyCharToByte(pCiphertext,ctx,strlen(pCiphertext));
		ctx_len=strlen(pCiphertext)/2;
	}
	else
	{
		ctx_len=0;
	}
	ptx_len=0;
	tag_len=12;
	pTag[0]=0;

	//解密开始
	gcm_ctx contx[1];
	buf[0]=0;
	gcm_init_and_key(key, key_len,(gcm_ctx*) contx);
	gcm_init_message(iv, iv_len,(gcm_ctx*) contx);

	gcm_auth_header(hdr, hdr_len,(gcm_ctx*) contx);

	memcpy(buf, ctx, ctx_len);
	gcm_decrypt(buf, ctx_len,(gcm_ctx*) contx);
	char temp[5]="";
	for (i=0;i<ctx_len;i++)
	{
		sprintf(temp,"%02x",buf[i]);
		strcat(pOutPlaintext,temp);
	}

	gcm_compute_tag(tbuf, tag_len,(gcm_ctx*) contx);
	for (i=0;i<tag_len;i++)
	{
		sprintf(temp,"%02x",tbuf[i]);
		strcat(pTag,temp);
	}
	gcm_end((gcm_ctx*)contx);
	return 1;
}

int aes_wrap(const unsigned char *kek, int n, const unsigned char *plain, unsigned char *cipher,aes_encrypt_ctx aes[1])
{
	unsigned char *a, *r, b[16];
	int i, j;


	a = cipher;
	r = cipher + 8;

	/* 1) Initialize variables. */
	memset(a, 0xa6, 8);
	memcpy(r, plain, 8 * n);


	/* set the AES key                          */
	aes_encrypt_key(kek, 16, aes);

	for (j = 0; j <= 5; j++) {
		r = cipher + 8;
		for (i = 1; i <= n; i++) {
			memcpy(b, a, 8);
			memcpy(b + 8, r, 8);
			/* compute E(0) (for the hash function)     */
			aes_encrypt(b, b, aes);
			memcpy(a, b, 8);
			a[7] ^= n * j + i;
			memcpy(r, b + 8, 8);
			r += 8;
		}
	}
	memset(aes, 0, sizeof(aes_encrypt_ctx));

	return 0;
}

int aes_wrap_String(char* pKey,char* pPlain,char* pCipher)
{
	aes_encrypt_ctx contx[1];
	unsigned char kek[16];
	memset(&kek,0,16);
	int nKeyLen=16;//strlen(pKey)/2;
	unsigned char Plaintext[50];
	int nPlainLen=16;//strlen(pPlain)/2;
	memset(&Plaintext,0,50);
	CopyCharToByte(pKey,kek,nKeyLen);
	CopyCharToByte(pPlain,Plaintext,nPlainLen);
	unsigned char Cipher[50];
	memset(&Cipher,0,50);
	
	int nRet=aes_wrap(kek,2,Plaintext,Cipher,contx);

	pCipher[0]=0;
	char temp[10]="";
	for (int i=0;i<24;i++)
	{
		sprintf(temp,"%02X",Cipher[i]);
		strcat(pCipher,temp);
	}
	return nRet;
}
int aes_wrap_byte(unsigned char* pKey,unsigned char* pPlain,unsigned char* pCipher)
{
	aes_encrypt_ctx contx[1];
	int nRet=aes_wrap(pKey,2,pPlain,pCipher,contx);
	return nRet;
}

int aes_unwrap(const unsigned char *kek, int n, const unsigned char *cipher, unsigned char *plain,aes_decrypt_ctx aes[1])
{
	unsigned char a[8], *r, b[16];
	int i, j;

	/* 1) Initialize variables. */
	memcpy(a, cipher, 8);
	r = plain;
	memcpy(r, cipher + 8, 8 * n);

	aes_decrypt_key(kek, 16,aes);
	if (aes == NULL)
		return -1;

	for (j = 5; j >= 0; j--) {
		r = plain + (n - 1) * 8;
		for (i = n; i >= 1; i--) {
			memcpy(b, a, 8);
			b[7] ^= n * j + i;

		    memcpy(b + 8, r, 8);
			aes_decrypt(b, b, aes);
		//	aes_decrypt(ctx, b, b);
			memcpy(a, b, 8);
			memcpy(r, b + 8, 8);
			r -= 8;
		}
	}
	memset(aes, 0, sizeof(aes_decrypt_ctx));

	for (i = 0; i < 8; i++) {
		if (a[i] != 0xa6)
			return -1;
	}

	return 0;
}
int aes_unwrap_string(char* pKey,char* pCipher,char* pPlain)
{
	aes_decrypt_ctx contx[1];
	int n=2;
	int nCipherLen=24;
	int nPlainLen=16;
	unsigned char kek[16];
	memset(&kek,0,16);
	CopyCharToByte(pKey,kek,16);
	unsigned char Plaintext[50];
	memset(&Plaintext,0,50);
	unsigned char Cipher[50];
	memset(&Cipher,0,50);
	CopyCharToByte(pCipher,Cipher,24);
	pPlain[0]=0;
	int nRet=aes_unwrap(kek,2,Cipher,Plaintext,contx);
	char temp[5]="";
	for (int i=0;i<16;i++)
	{
		sprintf(temp,"%02X",Plaintext[i]);
		strcat(pPlain,temp);
	}
	return nRet;
}
int aes_unwrap_byte(unsigned char* pKey,unsigned char* pCipher,unsigned char* pPlain)
{
	aes_decrypt_ctx contx[1];
	return aes_unwrap(pKey,2,pCipher,pPlain,contx);
}

#if defined(__cplusplus)
}
#endif

