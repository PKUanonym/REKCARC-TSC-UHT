/*********************************************************************
                                                              
  SDRAM Controller Bank Controller
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: 
    This module takes requests from sdrc_req_gen, checks for page hit/miss and
    issues precharge/activate commands and then passes the request to sdrc_xfr_ctl. 
                                                              
  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesha@opencores.org                 
  Version  :  1.0  - 8th Jan 2012
                                                              

                                                             
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

module sdrc_bank_ctl (clk,
		     reset_n,
		     a2b_req_depth,  // Number of requests we can buffer

		     /* Req from req_gen */
		     r2b_req,	   // request
		     r2b_req_id,   // ID
		     r2b_start,	   // First chunk of burst
		     r2b_last,	   // Last chunk of burst
		     r2b_wrap,
		     r2b_ba,	   // bank address
		     r2b_raddr,	   // row address
		     r2b_caddr,	   // col address
		     r2b_len,	   // length
		     r2b_write,	   // write request
		     b2r_arb_ok,   // OK to arbitrate for next xfr
		     b2r_ack,

		     /* Transfer request to xfr_ctl */
		     b2x_idle,	   // All banks are idle
		     b2x_req,	   // Request to xfr_ctl
		     b2x_start,	   // first chunk of transfer
		     b2x_last,	   // last chunk of transfer
		     b2x_wrap,
		     b2x_id,	   // Transfer ID
		     b2x_ba,	   // bank address
		     b2x_addr,	   // row/col address
		     b2x_len,	   // transfer length
		     b2x_cmd,	   // transfer command
		     x2b_ack,	   // command accepted
		     
		     /* Status to/from xfr_ctl */
		     b2x_tras_ok,  // TRAS OK for all banks
		     x2b_refresh,  // We did a refresh
		     x2b_pre_ok,   // OK to do a precharge (per bank)
		     x2b_act_ok,   // OK to do an activate
		     x2b_rdok,	   // OK to do a read
		     x2b_wrok,	   // OK to do a write

		     /* xfr msb address */
		     xfr_bank_sel,
                     sdr_req_norm_dma_last,

		     /* SDRAM Timing */
		     tras_delay,   // Active to precharge delay
		     trp_delay,	   // Precharge to active delay
		     trcd_delay);  // Active to R/W delay
   
parameter  SDR_DW   = 16;  // SDR Data Width 
parameter  SDR_BW   = 2;   // SDR Byte Width
   input                        clk, reset_n;

   input [1:0] 			a2b_req_depth;
   
   /* Req from bank_ctl */
   input 			r2b_req, r2b_start, r2b_last,
				r2b_write, r2b_wrap;
   input [`SDR_REQ_ID_W-1:0] 	r2b_req_id;
   input [1:0] 			r2b_ba;
   input [12:0] 		r2b_raddr;
   input [12:0] 		r2b_caddr;
   input [`REQ_BW-1:0] 	        r2b_len;
   output 			b2r_arb_ok, b2r_ack;
   input                        sdr_req_norm_dma_last;

   /* Req to xfr_ctl */
   output 			b2x_idle, b2x_req, b2x_start, b2x_last,
				b2x_tras_ok, b2x_wrap;
   output [`SDR_REQ_ID_W-1:0] 	b2x_id;
   output [1:0] 		b2x_ba;
   output [12:0] 		b2x_addr;
   output [`REQ_BW-1:0] 	b2x_len;
   output [1:0] 		b2x_cmd;
   input 			x2b_ack;

   /* Status from xfr_ctl */
   input [3:0] 			x2b_pre_ok;
   input 			x2b_refresh, x2b_act_ok, x2b_rdok,
				x2b_wrok;
   
   input [3:0] 			tras_delay, trp_delay, trcd_delay;

   input [1:0] xfr_bank_sel;

   /****************************************************************************/
   // Internal Nets

   wire [3:0] 			r2i_req, i2r_ack, i2x_req, 
				i2x_start, i2x_last, i2x_wrap, tras_ok;
   wire [12:0] 			i2x_addr0, i2x_addr1, i2x_addr2, i2x_addr3;
   wire [`REQ_BW-1:0] 	i2x_len0, i2x_len1, i2x_len2, i2x_len3;
   wire [1:0] 			i2x_cmd0, i2x_cmd1, i2x_cmd2, i2x_cmd3;
   wire [`SDR_REQ_ID_W-1:0] 	i2x_id0, i2x_id1, i2x_id2, i2x_id3;

   reg 				b2x_req;
   wire 			b2x_idle, b2x_start, b2x_last, b2x_wrap;
   wire [`SDR_REQ_ID_W-1:0] 	b2x_id;
   wire [12:0] 			b2x_addr;
   wire [`REQ_BW-1:0] 	b2x_len;
   wire [1:0] 			b2x_cmd;
   wire [3:0] 			x2i_ack;
   reg [1:0] 			b2x_ba;
   
   reg [`SDR_REQ_ID_W-1:0] 	curr_id;

   wire [1:0] 			xfr_ba;
   wire  			xfr_ba_last;
   wire [3:0] 			xfr_ok;

   // This 8 bit register stores the bank addresses for upto 4 requests.
   reg [7:0] 			rank_ba;
   reg [3:0] 			rank_ba_last;
   // This 3 bit counter counts the number of requests we have
   // buffered so far, legal values are 0, 1, 2, 3, or 4.
   reg [2:0] 			rank_cnt;
   wire [3:0] 			rank_req, rank_wr_sel;
   wire 			rank_fifo_wr, rank_fifo_rd;
   wire 			rank_fifo_full, rank_fifo_mt;
   
   wire [12:0] bank0_row, bank1_row, bank2_row, bank3_row;

   assign  b2x_tras_ok        = &tras_ok;


   // Distribute the request from req_gen

   assign r2i_req[0] = (r2b_ba == 2'b00) ? r2b_req & ~rank_fifo_full : 1'b0;
   assign r2i_req[1] = (r2b_ba == 2'b01) ? r2b_req & ~rank_fifo_full : 1'b0;
   assign r2i_req[2] = (r2b_ba == 2'b10) ? r2b_req & ~rank_fifo_full : 1'b0;
   assign r2i_req[3] = (r2b_ba == 2'b11) ? r2b_req & ~rank_fifo_full : 1'b0;

   /******************
   Modified the Better FPGA Timing Purpose
   assign b2r_ack = (r2b_ba == 2'b00) ? i2r_ack[0] :
		    (r2b_ba == 2'b01) ? i2r_ack[1] :
		    (r2b_ba == 2'b10) ? i2r_ack[2] :
		    (r2b_ba == 2'b11) ? i2r_ack[3] : 1'b0;
   ********************/
   // Assumption: Only one Ack Will be asserted at a time.
   assign b2r_ack  =|i2r_ack; 

   assign b2r_arb_ok = ~rank_fifo_full;
   
   // Put the requests from the 4 bank_fsms into a 4 deep shift
   // register file. The earliest request is prioritized over the
   // later requests. Also the number of requests we are allowed to
   // buffer is limited by a 2 bit external input
   
   // Mux the req/cmd to xfr_ctl. Allow RD/WR commands from the request in
   // rank0, allow only PR/ACT commands from the requests in other ranks
   // If the rank_fifo is empty, send the request from the bank addressed by
   // r2b_ba 

   // In FPGA Mode, to improve the timing, also send the rank_ba
   assign xfr_ba = (`TARGET_DESIGN == `FPGA) ? rank_ba[1:0]:
	           ((rank_fifo_mt) ? r2b_ba : rank_ba[1:0]);
   assign xfr_ba_last = (`TARGET_DESIGN == `FPGA) ? rank_ba_last[0]:
	                ((rank_fifo_mt) ? sdr_req_norm_dma_last : rank_ba_last[0]);
   
   assign rank_req[0] = i2x_req[xfr_ba];     // each rank generates requests
			
   assign rank_req[1] = (rank_cnt < 3'h2) ? 1'b0 :
			(rank_ba[3:2] == 2'b00) ? i2x_req[0] & ~i2x_cmd0[1] :
			(rank_ba[3:2] == 2'b01) ? i2x_req[1] & ~i2x_cmd1[1] :
			(rank_ba[3:2] == 2'b10) ? i2x_req[2] & ~i2x_cmd2[1] : 
			i2x_req[3] & ~i2x_cmd3[1];
			
   assign rank_req[2] = (rank_cnt < 3'h3) ? 1'b0 :
			(rank_ba[5:4] == 2'b00) ? i2x_req[0] & ~i2x_cmd0[1] :
			(rank_ba[5:4] == 2'b01) ? i2x_req[1] & ~i2x_cmd1[1] :
			(rank_ba[5:4] == 2'b10) ? i2x_req[2] & ~i2x_cmd2[1] : 
			i2x_req[3] & ~i2x_cmd3[1];
			
   assign rank_req[3] = (rank_cnt < 3'h4) ? 1'b0 :
			(rank_ba[7:6] == 2'b00) ? i2x_req[0] & ~i2x_cmd0[1] :
			(rank_ba[7:6] == 2'b01) ? i2x_req[1] & ~i2x_cmd1[1] :
			(rank_ba[7:6] == 2'b10) ? i2x_req[2] & ~i2x_cmd2[1] : 
			i2x_req[3] & ~i2x_cmd3[1];
			
   always @ (*) begin
      b2x_req = 1'b0;
      b2x_ba =   xfr_ba;

      if(`TARGET_DESIGN == `ASIC) begin // Support Multiple Rank request only on ASIC
         if (rank_req[0]) begin 
	    b2x_req = 1'b1;
	    b2x_ba = xfr_ba;
         end // if (rank_req[0])
	 else if (rank_req[1]) begin 
	   b2x_req = 1'b1;
	   b2x_ba = rank_ba[3:2];
        end // if (rank_req[1])
        else if (rank_req[2]) begin 
	  b2x_req = 1'b1;
	  b2x_ba = rank_ba[5:4];
        end // if (rank_req[2])
        else if (rank_req[3]) begin 
	  b2x_req = 1'b1;
	  b2x_ba = rank_ba[7:6];
        end // if (rank_req[3])
      end else begin // If FPGA
         if (rank_req[0]) begin 
	    b2x_req = 1'b1;
	 end
      end
  end // always @ (rank_req or rank_fifo_mt or r2b_ba or rank_ba)

   assign b2x_idle = rank_fifo_mt;
   assign b2x_start = i2x_start[b2x_ba];
   assign b2x_last = i2x_last[b2x_ba];
   assign b2x_wrap = i2x_wrap[b2x_ba];

   assign b2x_addr = (b2x_ba == 2'b11) ? i2x_addr3 :
		     (b2x_ba == 2'b10) ? i2x_addr2 :
		     (b2x_ba == 2'b01) ? i2x_addr1 : i2x_addr0;
   
   assign b2x_len = (b2x_ba == 2'b11) ? i2x_len3 :
		    (b2x_ba == 2'b10) ? i2x_len2 :
		    (b2x_ba == 2'b01) ? i2x_len1 : i2x_len0;
   
   assign b2x_cmd = (b2x_ba == 2'b11) ? i2x_cmd3 :
		    (b2x_ba == 2'b10) ? i2x_cmd2 :
		    (b2x_ba == 2'b01) ? i2x_cmd1 : i2x_cmd0;
   
   assign b2x_id = (b2x_ba == 2'b11) ? i2x_id3 :
		   (b2x_ba == 2'b10) ? i2x_id2 :
		   (b2x_ba == 2'b01) ? i2x_id1 : i2x_id0;
   
   assign x2i_ack[0] = (b2x_ba == 2'b00) ? x2b_ack : 1'b0;
   assign x2i_ack[1] = (b2x_ba == 2'b01) ? x2b_ack : 1'b0;
   assign x2i_ack[2] = (b2x_ba == 2'b10) ? x2b_ack : 1'b0;
   assign x2i_ack[3] = (b2x_ba == 2'b11) ? x2b_ack : 1'b0;

   // Rank Fifo
   // On a write write to selected rank and increment rank_cnt
   // On a read shift rank_ba right 2 bits and decrement rank_cnt

   assign rank_fifo_wr = b2r_ack;

   assign rank_fifo_rd = b2x_req & b2x_cmd[1] & x2b_ack;
   
   assign rank_wr_sel[0] = (rank_cnt == 3'h0) ? rank_fifo_wr : 
			   (rank_cnt == 3'h1) ? rank_fifo_wr & rank_fifo_rd : 
			   1'b0;

   assign rank_wr_sel[1] = (rank_cnt == 3'h1) ? rank_fifo_wr & ~rank_fifo_rd :
			   (rank_cnt == 3'h2) ? rank_fifo_wr & rank_fifo_rd :
			   1'b0; 

   assign rank_wr_sel[2] = (rank_cnt == 3'h2) ? rank_fifo_wr & ~rank_fifo_rd :
			   (rank_cnt == 3'h3) ? rank_fifo_wr & rank_fifo_rd :
			   1'b0; 

   assign rank_wr_sel[3] = (rank_cnt == 3'h3) ? rank_fifo_wr & ~rank_fifo_rd :
			   (rank_cnt == 3'h4) ? rank_fifo_wr & rank_fifo_rd :
			   1'b0; 

   assign rank_fifo_mt = (rank_cnt == 3'b0) ? 1'b1 : 1'b0;

   assign rank_fifo_full = (rank_cnt[2]) ? 1'b1 : 
			   (rank_cnt[1:0] == a2b_req_depth) ? 1'b1 : 1'b0; 

   // FIFO Check

   // synopsys translate_off

   always @ (posedge clk) begin

      if (~rank_fifo_wr & rank_fifo_rd && rank_cnt == 3'h0) begin
	 $display ("%t: %m: ERROR!!! Read from empty Fifo", $time);
	 $stop;
      end // if (rank_fifo_rd && rank_cnt == 3'h0)

      if (rank_fifo_wr && ~rank_fifo_rd && rank_cnt == 3'h4) begin
	 $display ("%t: %m: ERROR!!! Write to full Fifo", $time);
	 $stop;
      end // if (rank_fifo_wr && ~rank_fifo_rd && rank_cnt == 3'h4)
      
   end // always @ (posedge clk)
   
   // synopsys translate_on
      
   always @ (posedge clk)
      if (~reset_n) begin
	 rank_cnt <= 3'b0;
	 rank_ba <= 8'b0;
	 rank_ba_last <= 4'b0;

      end // if (~reset_n)
      else begin

	 rank_cnt <= (rank_fifo_wr & ~rank_fifo_rd) ? rank_cnt + 3'b1 :
		     (~rank_fifo_wr & rank_fifo_rd) ? rank_cnt - 3'b1 :
		     rank_cnt;

	 rank_ba[1:0] <= (rank_wr_sel[0]) ? r2b_ba :
			 (rank_fifo_rd) ? rank_ba[3:2] : rank_ba[1:0];
	 
	 rank_ba[3:2] <= (rank_wr_sel[1]) ? r2b_ba :
			 (rank_fifo_rd) ? rank_ba[5:4] : rank_ba[3:2];
	 
	 rank_ba[5:4] <= (rank_wr_sel[2]) ? r2b_ba :
			 (rank_fifo_rd) ? rank_ba[7:6] : rank_ba[5:4];
	 
	 rank_ba[7:6] <= (rank_wr_sel[3]) ? r2b_ba :
			 (rank_fifo_rd) ? 2'b00 : rank_ba[7:6];

	 if(`TARGET_DESIGN == `ASIC) begin // This Logic is implemented for ASIC Only
	    // Note: Currenly top-level does not generate the
	    // sdr_req_norm_dma_last signal and can be tied zero at top-level
            rank_ba_last[0] <= (rank_wr_sel[0]) ? sdr_req_norm_dma_last :
                            (rank_fifo_rd) ?  rank_ba_last[1] : rank_ba_last[0];

            rank_ba_last[1] <= (rank_wr_sel[1]) ? sdr_req_norm_dma_last :
                               (rank_fifo_rd) ?  rank_ba_last[2] : rank_ba_last[1];

            rank_ba_last[2] <= (rank_wr_sel[2]) ? sdr_req_norm_dma_last :
                               (rank_fifo_rd) ?  rank_ba_last[3] : rank_ba_last[2];

            rank_ba_last[3] <= (rank_wr_sel[3]) ? sdr_req_norm_dma_last :
                               (rank_fifo_rd) ?  1'b0 : rank_ba_last[3];
         end

      end // else: !if(~reset_n)
   
   assign xfr_ok[0] = (xfr_ba == 2'b00) ? 1'b1 : 1'b0;
   assign xfr_ok[1] = (xfr_ba == 2'b01) ? 1'b1 : 1'b0;
   assign xfr_ok[2] = (xfr_ba == 2'b10) ? 1'b1 : 1'b0;
   assign xfr_ok[3] = (xfr_ba == 2'b11) ? 1'b1 : 1'b0;
   
   /****************************************************************************/
   // Instantiate Bank Ctl FSM 0

   sdrc_bank_fsm bank0_fsm (.clk (clk),
			   .reset_n (reset_n),

			   /* Req from req_gen */
			   .r2b_req (r2i_req[0]),
			   .r2b_req_id (r2b_req_id),
			   .r2b_start (r2b_start),
			   .r2b_last (r2b_last),
			   .r2b_wrap (r2b_wrap),
			   .r2b_raddr (r2b_raddr),
			   .r2b_caddr (r2b_caddr),
			   .r2b_len (r2b_len),
			   .r2b_write (r2b_write),
			   .b2r_ack (i2r_ack[0]),
                           .sdr_dma_last(rank_ba_last[0]),

			   /* Transfer request to xfr_ctl */
			   .b2x_req (i2x_req[0]),
			   .b2x_start (i2x_start[0]),
			   .b2x_last (i2x_last[0]),
			   .b2x_wrap (i2x_wrap[0]),
			   .b2x_id (i2x_id0),
			   .b2x_addr (i2x_addr0),
			   .b2x_len (i2x_len0),
			   .b2x_cmd (i2x_cmd0),
			   .x2b_ack (x2i_ack[0]),
		     
			   /* Status to/from xfr_ctl */
			   .tras_ok (tras_ok[0]),
			   .xfr_ok (xfr_ok[0]),
			   .x2b_refresh (x2b_refresh),
			   .x2b_pre_ok (x2b_pre_ok[0]),
			   .x2b_act_ok (x2b_act_ok),
			   .x2b_rdok (x2b_rdok),
			   .x2b_wrok (x2b_wrok),

			   .bank_row(bank0_row),

			   /* SDRAM Timing */
			   .tras_delay (tras_delay),
			   .trp_delay (trp_delay),
			   .trcd_delay (trcd_delay));
   
   /****************************************************************************/
   // Instantiate Bank Ctl FSM 1

   sdrc_bank_fsm bank1_fsm (.clk (clk),
			   .reset_n (reset_n),

			   /* Req from req_gen */
			   .r2b_req (r2i_req[1]),
			   .r2b_req_id (r2b_req_id),
			   .r2b_start (r2b_start),
			   .r2b_last (r2b_last),
			   .r2b_wrap (r2b_wrap),
			   .r2b_raddr (r2b_raddr),
			   .r2b_caddr (r2b_caddr),
			   .r2b_len (r2b_len),
			   .r2b_write (r2b_write),
			   .b2r_ack (i2r_ack[1]),
                           .sdr_dma_last(rank_ba_last[1]),

			   /* Transfer request to xfr_ctl */
			   .b2x_req (i2x_req[1]),
			   .b2x_start (i2x_start[1]),
			   .b2x_last (i2x_last[1]),
			   .b2x_wrap (i2x_wrap[1]),
			   .b2x_id (i2x_id1),
			   .b2x_addr (i2x_addr1),
			   .b2x_len (i2x_len1),
			   .b2x_cmd (i2x_cmd1),
			   .x2b_ack (x2i_ack[1]),
		     
			   /* Status to/from xfr_ctl */
			   .tras_ok (tras_ok[1]),           
			   .xfr_ok (xfr_ok[1]),
			   .x2b_refresh (x2b_refresh),
			   .x2b_pre_ok (x2b_pre_ok[1]),
			   .x2b_act_ok (x2b_act_ok),
			   .x2b_rdok (x2b_rdok),
			   .x2b_wrok (x2b_wrok),

			   .bank_row(bank1_row),

			   /* SDRAM Timing */
			   .tras_delay (tras_delay),
			   .trp_delay (trp_delay),
			   .trcd_delay (trcd_delay));
   
   /****************************************************************************/
   // Instantiate Bank Ctl FSM 2

   sdrc_bank_fsm bank2_fsm (.clk (clk),
			   .reset_n (reset_n),

			   /* Req from req_gen */
			   .r2b_req (r2i_req[2]),
			   .r2b_req_id (r2b_req_id),
			   .r2b_start (r2b_start),
			   .r2b_last (r2b_last),
			   .r2b_wrap (r2b_wrap),
			   .r2b_raddr (r2b_raddr),
			   .r2b_caddr (r2b_caddr),
			   .r2b_len (r2b_len),
			   .r2b_write (r2b_write),
			   .b2r_ack (i2r_ack[2]),
                           .sdr_dma_last(rank_ba_last[2]),

			   /* Transfer request to xfr_ctl */
			   .b2x_req (i2x_req[2]),
			   .b2x_start (i2x_start[2]),
			   .b2x_last (i2x_last[2]),
			   .b2x_wrap (i2x_wrap[2]),
			   .b2x_id (i2x_id2),
			   .b2x_addr (i2x_addr2),
			   .b2x_len (i2x_len2),
			   .b2x_cmd (i2x_cmd2),
			   .x2b_ack (x2i_ack[2]),
		     
			   /* Status to/from xfr_ctl */
			   .tras_ok (tras_ok[2]),           
			   .xfr_ok (xfr_ok[2]),
			   .x2b_refresh (x2b_refresh),
			   .x2b_pre_ok (x2b_pre_ok[2]),
			   .x2b_act_ok (x2b_act_ok),
			   .x2b_rdok (x2b_rdok),
			   .x2b_wrok (x2b_wrok),

			   .bank_row(bank2_row),

			   /* SDRAM Timing */
			   .tras_delay (tras_delay),
			   .trp_delay (trp_delay),
			   .trcd_delay (trcd_delay));
   
   /****************************************************************************/
   // Instantiate Bank Ctl FSM 3

   sdrc_bank_fsm bank3_fsm (.clk (clk),
			   .reset_n (reset_n),

			   /* Req from req_gen */
			   .r2b_req (r2i_req[3]),
			   .r2b_req_id (r2b_req_id),
			   .r2b_start (r2b_start),
			   .r2b_last (r2b_last),
			   .r2b_wrap (r2b_wrap),
			   .r2b_raddr (r2b_raddr),
			   .r2b_caddr (r2b_caddr),
			   .r2b_len (r2b_len),
			   .r2b_write (r2b_write),
			   .b2r_ack (i2r_ack[3]),
                           .sdr_dma_last(rank_ba_last[3]),

			   /* Transfer request to xfr_ctl */
			   .b2x_req (i2x_req[3]),
			   .b2x_start (i2x_start[3]),
			   .b2x_last (i2x_last[3]),
			   .b2x_wrap (i2x_wrap[3]),
			   .b2x_id (i2x_id3),
			   .b2x_addr (i2x_addr3),
			   .b2x_len (i2x_len3),
			   .b2x_cmd (i2x_cmd3),
			   .x2b_ack (x2i_ack[3]),
		     
			   /* Status to/from xfr_ctl */
			   .tras_ok (tras_ok[3]),           
			   .xfr_ok (xfr_ok[3]),
			   .x2b_refresh (x2b_refresh),
			   .x2b_pre_ok (x2b_pre_ok[3]),
			   .x2b_act_ok (x2b_act_ok),
			   .x2b_rdok (x2b_rdok),
			   .x2b_wrok (x2b_wrok),

			   .bank_row(bank3_row),

			   /* SDRAM Timing */
			   .tras_delay (tras_delay),
			   .trp_delay (trp_delay),
			   .trcd_delay (trcd_delay));
   

/* address for current xfr, debug only */
wire [12:0] cur_row = (xfr_bank_sel==3) ? bank3_row:
			(xfr_bank_sel==2) ? bank2_row: 
			(xfr_bank_sel==1) ? bank1_row: bank0_row; 

 

endmodule // sdr_bank_ctl
