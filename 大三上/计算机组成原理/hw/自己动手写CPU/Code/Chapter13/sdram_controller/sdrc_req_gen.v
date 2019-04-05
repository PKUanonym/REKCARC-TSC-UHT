/*********************************************************************
                                                              
  SDRAM Controller Request Generation                                  
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: SDRAM Controller Reguest Generation

  Address Generation Based on cfg_colbits
     cfg_colbits= 2'b00
            Address[7:0]    - Column Address
            Address[9:8]    - Bank Address
            Address[22:10]  - Row Address
     cfg_colbits= 2'b01
            Address[8:0]    - Column Address
            Address[10:9]   - Bank Address
            Address[23:11]  - Row Address
     cfg_colbits= 2'b10
            Address[9:0]    - Column Address
            Address[11:10]   - Bank Address
            Address[24:12]  - Row Address
     cfg_colbits= 2'b11
            Address[10:0]    - Column Address
            Address[12:11]   - Bank Address
            Address[25:13]  - Row Address

  The SDRAMs are operated in 4 beat burst mode.

  If Wrap = 0; 
      If the current burst cross the page boundary, then this block split the request 
      into two coressponding change in address and request length

  if the current burst cross the page boundar.
  This module takes requests from the memory controller, 
  chops them to page boundaries if wrap=0, 
  and passes the request to bank_ctl

  Note: With Wrap = 0, each request from Application layer will be splited into two request, 
	if the current burst cross the page boundary. 

  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesha@opencores.org                 
  Version  : 0.0 - 8th Jan 2012
             0.1 - 5th Feb 2012, column/row/bank address are register to improve the timing issue in FPGA synthesis
                                                              

                                                             
 Copyright (C) 2000 Authors and OPENCORES.ORG                
                                                             
 This source file may be used and distributed without         
 restriction provided that this copyright statement is not    
 removed from the file and that any derivative work contains  
 the original copyright notice and the associated disclaimer. 
                                                              
 This source file is free software; you can redistribute it   
 and/or modify it under the terms of the GNU Lesser General   
 Public License as published by the Free Software Foundation; 
 either version 2.1 of the License, or (at your option) any   
later version.                                               
                                                              
 This source is distributed in the hope that it will be       
 useful, but WITHOUT ANY WARRANTY; without even the implied   
 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
 PURPOSE.  See the GNU Lesser General Public License for more 
 details.                                                     
                                                              
 You should have received a copy of the GNU Lesser General    
 Public License along with this source; if not, download it   
 from http://www.opencores.org/lgpl.shtml                     
                                                              
*******************************************************************/

`include "sdrc_define.v"

module sdrc_req_gen (clk,
		    reset_n,
		    cfg_colbits,
		    sdr_width,

		    /* Request from app */
		    req,	        // Transfer Request
		    req_id,	        // ID for this transfer
		    req_addr,	        // SDRAM Address
		    req_len,	        // Burst Length (in 32 bit words)
		    req_wrap,	        // Wrap mode request (xfr_len = 4)
		    req_wr_n,	        // 0 => Write request, 1 => read req
		    req_ack,	        // Request has been accepted
		    
		    /* Req to xfr_ctl */
		    r2x_idle,

		    /* Req to bank_ctl */
		    r2b_req,	        // request
		    r2b_req_id,	        // ID
		    r2b_start,	        // First chunk of burst
		    r2b_last,	        // Last chunk of burst
		    r2b_wrap,	        // Wrap Mode
		    r2b_ba,	        // bank address
		    r2b_raddr,	        // row address
		    r2b_caddr,	        // col address
		    r2b_len,	        // length
		    r2b_write,	        // write request
		    b2r_ack,
		    b2r_arb_ok
		    );

parameter  APP_AW   = 26;  // Application Address Width
parameter  APP_DW   = 32;  // Application Data Width 
parameter  APP_BW   = 4;   // Application Byte Width
parameter  APP_RW   = 9;   // Application Request Width

parameter  SDR_DW   = 16;  // SDR Data Width 
parameter  SDR_BW   = 2;   // SDR Byte Width


input                   clk           ;
input                   reset_n       ;
input [1:0]             cfg_colbits   ; // 2'b00 - 8 Bit column address, 2'b01 - 9 Bit, 10 - 10 bit, 11 - 11Bits

/* Request from app */
input 			req           ; // Request 
input [`SDR_REQ_ID_W-1:0] req_id      ; // Request ID
input [APP_AW-1:0] 	req_addr      ; // Request Address
input [APP_RW-1:0] 	req_len       ; // Request length
input 			req_wr_n      ; // 0 -Write, 1 - Read
input                   req_wrap      ; // 1 - Wrap the Address on page boundary
output 			req_ack       ; // Request Ack
		
/* Req to bank_ctl */
output 			r2x_idle      ; 
output                  r2b_req       ; // Request
output                  r2b_start     ; // First Junk of the Burst Access
output                  r2b_last      ; // Last Junk of the Burst Access
output                  r2b_write     ; // 1 - Write, 0 - Read
output                  r2b_wrap      ; // 1 - Wrap the Address at the page boundary.
output [`SDR_REQ_ID_W-1:0] 	r2b_req_id;
output [1:0] 		r2b_ba        ; // Bank Address
output [12:0] 		r2b_raddr     ; // Row Address
output [12:0] 		r2b_caddr     ; // Column Address
output [`REQ_BW-1:0] 	r2b_len       ; // Burst Length
input 			b2r_ack       ; // Request Ack
input                   b2r_arb_ok    ; // Bank controller fifo is not full and ready to accept the command
//
input [1:0] 	        sdr_width; // 2'b00 - 32 Bit, 2'b01 - 16 Bit, 2'b1x - 8Bit
                                         

   /****************************************************************************/
   // Internal Nets

   `define REQ_IDLE        2'b00
   `define REQ_ACTIVE      2'b01
   `define REQ_PAGE_WRAP   2'b10

   reg  [1:0]		req_st, next_req_st;
   reg 			r2x_idle, req_ack, r2b_req, r2b_start, 
			r2b_write, req_idle, req_ld, lcl_wrap;
   reg [`SDR_REQ_ID_W-1:0] 	r2b_req_id;
   reg [`REQ_BW-1:0] 	lcl_req_len;

   wire 		r2b_last, page_ovflw;
   reg page_ovflw_r;
   wire [`REQ_BW-1:0] 	r2b_len, next_req_len;
   wire [12:0] 	        max_r2b_len;
   reg  [12:0] 	        max_r2b_len_r;

   reg [1:0] 		r2b_ba;
   reg [12:0] 		r2b_raddr;
   reg [12:0] 		r2b_caddr;

   reg [APP_AW-1:0] 	curr_sdr_addr ;
   wire [APP_AW-1:0] 	next_sdr_addr ;


//--------------------------------------------------------------------
// Generate the internal Adress and Burst length Based on sdram width
//--------------------------------------------------------------------
reg [APP_AW:0]           req_addr_int;
reg [APP_RW-1:0]         req_len_int;

always @(*) begin
   if(sdr_width == 2'b00) begin // 32 Bit SDR Mode
      req_addr_int     = {1'b0,req_addr};
      req_len_int      = req_len;
   end else if(sdr_width == 2'b01) begin // 16 Bit SDR Mode
      // Changed the address and length to match the 16 bit SDR Mode
      req_addr_int     = {req_addr,1'b0};
      req_len_int      = {req_len,1'b0};
   end else  begin // 8 Bit SDR Mode
      // Changed the address and length to match the 16 bit SDR Mode
      req_addr_int    = {req_addr,2'b0};
      req_len_int     = {req_len,2'b0};
   end
end

   //
   // Identify the page over flow.
   // Find the Maximum Burst length allowed from the selected column
   // address, If the requested burst length is more than the allowed Maximum
   // burst length, then we need to handle the bank cross over case and we
   // need to split the reuest.
   //
   assign max_r2b_len = (cfg_colbits == 2'b00) ? (12'h100 - {4'b0, req_addr_int[7:0]}) :
	                (cfg_colbits == 2'b01) ? (12'h200 - {3'b0, req_addr_int[8:0]}) :
			(cfg_colbits == 2'b10) ? (12'h400 - {2'b0, req_addr_int[9:0]}) : (12'h800 - {1'b0, req_addr_int[10:0]});


     // If the wrap = 0 and current application burst length is crossing the page boundary, 
     // then request will be split into two with corresponding change in request address and request length.
     //
     // If the wrap = 0 and current burst length is not crossing the page boundary, 
     // then request from application layer will be transparently passed on the bank control block.

     //
     // if the wrap = 1, then this block will not modify the request address and length. 
     // The wrapping functionality will be handle by the bank control module and 
     // column address will rewind back as follows XX -> FF ? 00 ? 1
     //
     // Note: With Wrap = 0, each request from Application layer will be spilited into two request, 
     //	if the current burst cross the page boundary. 
   assign page_ovflw = ({1'b0, req_len_int} > max_r2b_len) ? ~r2b_wrap : 1'b0;

   assign r2b_len = r2b_start ? ((page_ovflw_r) ? max_r2b_len_r : lcl_req_len) :
                      lcl_req_len;

   assign next_req_len = lcl_req_len - r2b_len;

   assign next_sdr_addr = curr_sdr_addr + r2b_len;


   assign r2b_wrap = lcl_wrap;

   assign r2b_last = (r2b_start & !page_ovflw_r) | (req_st == `REQ_PAGE_WRAP);
//
//
//
   always @ (posedge clk) begin

      page_ovflw_r   <= (req_ack) ? page_ovflw: 'h0;

      max_r2b_len_r  <= (req_ack) ? max_r2b_len: 'h0;
      r2b_start      <= (req_ack) ? 1'b1 :
		        (b2r_ack) ? 1'b0 : r2b_start;

      r2b_write      <= (req_ack) ? ~req_wr_n : r2b_write;

      r2b_req_id     <= (req_ack) ? req_id : r2b_req_id;

      lcl_wrap       <= (req_ack) ? req_wrap : lcl_wrap;
	     
      lcl_req_len    <= (req_ack) ? req_len_int  :
		        (req_ld) ? next_req_len : lcl_req_len;

      curr_sdr_addr  <= (req_ack) ? req_addr_int :
		        (req_ld) ? next_sdr_addr : curr_sdr_addr;

   end // always @ (posedge clk)
   
   always @ (*) begin
      r2x_idle    = 1'b0;
      req_idle    = 1'b0;
      req_ack     = 1'b0;
      req_ld      = 1'b0;
      r2b_req     = 1'b0;
      next_req_st = `REQ_IDLE;

      case (req_st)      // synopsys full_case parallel_case

	`REQ_IDLE : begin
	   r2x_idle = ~req;
	   req_idle = 1'b1;
	   req_ack = req & b2r_arb_ok;
	   req_ld = 1'b0;
	   r2b_req = 1'b0;
	   next_req_st = (req & b2r_arb_ok) ? `REQ_ACTIVE : `REQ_IDLE;
	end // case: `REQ_IDLE

	`REQ_ACTIVE : begin
	   r2x_idle = 1'b0;
	   req_idle = 1'b0;
	   req_ack = 1'b0;
	   req_ld = b2r_ack;
	   r2b_req = 1'b1;                       // req_gen to bank_req
	   next_req_st = (b2r_ack ) ? ((page_ovflw_r) ? `REQ_PAGE_WRAP :`REQ_IDLE) : `REQ_ACTIVE;
	end // case: `REQ_ACTIVE
	`REQ_PAGE_WRAP : begin
	   r2x_idle = 1'b0;
	   req_idle = 1'b0;
	   req_ack  = 1'b0;
	   req_ld = b2r_ack;
	   r2b_req = 1'b1;                       // req_gen to bank_req
	   next_req_st = (b2r_ack) ? `REQ_IDLE : `REQ_PAGE_WRAP;
	end // case: `REQ_ACTIVE

      endcase // case(req_st)

   end // always @ (req_st or ....)

   always @ (posedge clk)
      if (~reset_n) begin
	 req_st <= `REQ_IDLE;
      end // if (~reset_n)
      else begin
	 req_st <= next_req_st;
      end // else: !if(~reset_n)
//
// addrs bits for the bank, row and column
//
// Register row/column/bank to improve fpga timing issue
wire [APP_AW-1:0] 	map_address ;

assign      map_address  = (req_ack) ? req_addr_int :
		           (req_ld)  ? next_sdr_addr : curr_sdr_addr;

always @ (posedge clk) begin
// Bank Bits are always - 2 Bits
    r2b_ba <= (cfg_colbits == 2'b00) ? {map_address[9:8]}   :
	      (cfg_colbits == 2'b01) ? {map_address[10:9]}  :
	      (cfg_colbits == 2'b10) ? {map_address[11:10]} : map_address[12:11];

/********************
*  Colbits Mapping:
*           2'b00 - 8 Bit
*           2'b01 - 16 Bit
*           2'b10 - 10 Bit
*           2'b11 - 11 Bits
************************/
    r2b_caddr <= (cfg_colbits == 2'b00) ? {5'b0, map_address[7:0]} :
	         (cfg_colbits == 2'b01) ? {4'b0, map_address[8:0]} :
	         (cfg_colbits == 2'b10) ? {3'b0, map_address[9:0]} : {2'b0, map_address[10:0]};

    r2b_raddr <= (cfg_colbits == 2'b00)  ? map_address[22:10] :
	         (cfg_colbits == 2'b01)  ? map_address[23:11] :
	         (cfg_colbits == 2'b10)  ? map_address[24:12] : map_address[25:13];
end	   
   
endmodule // sdr_req_gen
