/*********************************************************************
                                                              
  SDRAM Controller Transfer control
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: SDRAM Controller Transfer control

  This module takes requests from sdrc_bank_ctl and runs the
  transfer. The input request is guaranteed to be in a bank that is
  precharged and activated. This block runs the transfer until a
  burst boundary is reached, then issues another read/write command
  to sequentially step thru memory if wrap=0, until the transfer is
  completed.
   
  if a read transfer finishes and the caddr is not at a burst boundary 
  a burst terminate command is issued unless another read/write or
  precharge to the same bank is pending.
  
  if a write transfer finishes and the caddr is not at a burst boundary 
  a burst terminate command is issued unless a read/write is pending.
  
   If a refresh request is made, the bank_ctl will be held off until
   the number of refreshes requested are completed.

   This block also handles SDRAM initialization.
  

  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesha@opencores.org                 
  Version  : 1.0 - 8th Jan 2012
                                                              

                                                             
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

module sdrc_xfr_ctl (clk,
		    reset_n,
		    
		    /* Transfer request from bank_ctl */
		    r2x_idle,	   // Req is idle
		    b2x_idle,      // All banks are idle
		    b2x_req,	   // Req from bank_ctl
		    b2x_start,	   // first chunk of transfer
		    b2x_last,	   // last chunk of transfer
		    b2x_id,	   // Transfer ID
		    b2x_ba,	   // bank address
		    b2x_addr,	   // row/col address
		    b2x_len,	   // transfer length
		    b2x_cmd,	   // transfer command
		    b2x_wrap,	   // Wrap mode transfer
		    x2b_ack,	   // command accepted
		     
		    /* Status to bank_ctl, req_gen */
		    b2x_tras_ok,   // Tras for all banks expired
		    x2b_refresh,   // We did a refresh
		    x2b_pre_ok,	   // OK to do a precharge (per bank)
		    x2b_act_ok,	   // OK to do an activate
		    x2b_rdok,	   // OK to do a read
		    x2b_wrok,	   // OK to do a write
		    
		    /* SDRAM I/O */
		    sdr_cs_n,
		    sdr_cke,
		    sdr_ras_n,
		    sdr_cas_n,
		    sdr_we_n,
		    sdr_dqm,
		    sdr_ba,
		    sdr_addr, 
		    sdr_din,
		    sdr_dout,
		    sdr_den_n,
		    
		    /* Data Flow to the app */
		    x2a_rdstart,
		    x2a_wrstart,
		    x2a_rdlast,
		    x2a_wrlast,
		    x2a_id,
		    a2x_wrdt,
		    a2x_wren_n,
		    x2a_wrnext,
		    x2a_rddt,
		    x2a_rdok,
		    sdr_init_done,
		    
		    /* SDRAM Parameters */
		    sdram_enable,
		    sdram_mode_reg,
		    
		    /* output for generate row address of the transfer */
		    xfr_bank_sel,

		    /* SDRAM Timing */
		    cas_latency,
		    trp_delay,	   // Precharge to refresh delay
		    trcar_delay,   // Auto-refresh period
		    twr_delay,	   // Write recovery delay
		    rfsh_time,	   // time per row (31.25 or 15.6125 uS)
		    rfsh_rmax);	   // Number of rows to rfsh at a time (<120uS)
   
parameter  SDR_DW   = 16;  // SDR Data Width 
parameter  SDR_BW   = 2;   // SDR Byte Width


input            clk, reset_n; 

   /* Req from bank_ctl */
input 			b2x_req, b2x_start, b2x_last, b2x_tras_ok,
				b2x_wrap, r2x_idle, b2x_idle; 
input [`SDR_REQ_ID_W-1:0] 	b2x_id;
input [1:0] 			b2x_ba;
input [12:0] 		b2x_addr;
input [`REQ_BW-1:0] 	b2x_len;
input [1:0] 			b2x_cmd;
output 			x2b_ack;

/* Status to bank_ctl */
output [3:0] 		x2b_pre_ok;
output 			x2b_refresh, x2b_act_ok, x2b_rdok,
				x2b_wrok;
/* Data Flow to the app */
output 			x2a_rdstart, x2a_wrstart, x2a_rdlast, x2a_wrlast;
output [`SDR_REQ_ID_W-1:0] 	x2a_id;

input [SDR_DW-1:0] 	a2x_wrdt;
input [SDR_BW-1:0] 	a2x_wren_n;
output [SDR_DW-1:0] 	x2a_rddt;
output 			x2a_wrnext, x2a_rdok, sdr_init_done;
		
/* Interface to SDRAMs */
output 			sdr_cs_n, sdr_cke, sdr_ras_n, sdr_cas_n,
				sdr_we_n; 
output [SDR_BW-1:0] 	sdr_dqm;
output [1:0] 		sdr_ba;
output [12:0] 		sdr_addr;
input [SDR_DW-1:0] 	sdr_din;
output [SDR_DW-1:0] 	sdr_dout;
output [SDR_BW-1:0] 	sdr_den_n;

   output [1:0]			xfr_bank_sel;

   input 			sdram_enable;
   input [12:0] 		sdram_mode_reg;
   input [2:0] 			cas_latency;
   input [3:0] 			trp_delay, trcar_delay, twr_delay;
   input [`SDR_RFSH_TIMER_W-1 : 0] rfsh_time;
   input [`SDR_RFSH_ROW_CNT_W-1:0] rfsh_rmax;
   

   /************************************************************************/
   // Internal Nets

   `define XFR_IDLE        2'b00
   `define XFR_WRITE       2'b01
   `define XFR_READ        2'b10
   `define XFR_RDWT        2'b11

   reg [1:0] 			xfr_st, next_xfr_st;
   reg [12:0] 			xfr_caddr;
   wire 			last_burst;
   wire 			x2a_rdstart, x2a_wrstart, x2a_rdlast, x2a_wrlast;
   reg 				l_start, l_last, l_wrap;
   wire [`SDR_REQ_ID_W-1:0] 	x2a_id;
   reg [`SDR_REQ_ID_W-1:0] 	l_id;
   wire [1:0] 			xfr_ba;
   reg [1:0] 			l_ba;
   wire [12:0] 			xfr_addr;
   wire [`REQ_BW-1:0] 	xfr_len, next_xfr_len;
   reg [`REQ_BW-1:0] 	l_len;

   reg 				mgmt_idle, mgmt_req;
   reg [3:0] 			mgmt_cmd;
   reg [12:0] 			mgmt_addr;
   reg [1:0] 			mgmt_ba;

   reg 				sel_mgmt, sel_b2x;
   reg 				cb_pre_ok, rdok, wrok, wr_next,
				rd_next, sdr_init_done, act_cmd, d_act_cmd;
   wire [3:0] 			b2x_sdr_cmd, xfr_cmd;
   reg [3:0] 			i_xfr_cmd;
   wire 			mgmt_ack, x2b_ack, b2x_read, b2x_write, 
				b2x_prechg, d_rd_next, dt_next, xfr_end,
				rd_pipe_mt, ld_xfr, rd_last, d_rd_last, 
				wr_last, l_xfr_end, rd_start, d_rd_start,
				wr_start, page_hit, burst_bdry, xfr_wrap,
				b2x_prechg_hit;
   reg [6:0] 			l_rd_next, l_rd_start, l_rd_last;
   
   assign b2x_read = (b2x_cmd == `OP_RD) ? 1'b1 : 1'b0;

   assign b2x_write = (b2x_cmd == `OP_WR) ? 1'b1 : 1'b0;

   assign b2x_prechg = (b2x_cmd == `OP_PRE) ? 1'b1 : 1'b0;
   
   assign b2x_sdr_cmd = (b2x_cmd == `OP_PRE) ? `SDR_PRECHARGE :
			(b2x_cmd == `OP_ACT) ? `SDR_ACTIVATE :
			(b2x_cmd == `OP_RD) ? `SDR_READ :
			(b2x_cmd == `OP_WR) ? `SDR_WRITE : `SDR_DESEL;

   assign page_hit = (b2x_ba == l_ba) ? 1'b1 : 1'b0;

   assign b2x_prechg_hit = b2x_prechg & page_hit;
   
   assign xfr_cmd = (sel_mgmt) ? mgmt_cmd :
		    (sel_b2x) ? b2x_sdr_cmd : i_xfr_cmd;

   assign xfr_addr = (sel_mgmt) ? mgmt_addr : 
		     (sel_b2x) ? b2x_addr : xfr_caddr+1;

   assign mgmt_ack = sel_mgmt;

   assign x2b_ack = sel_b2x;

   assign ld_xfr = sel_b2x & (b2x_read | b2x_write);
   
   assign xfr_len = (ld_xfr) ? b2x_len : l_len;

   //assign next_xfr_len = (l_xfr_end && !ld_xfr) ? l_len : xfr_len - 1;
   assign next_xfr_len = (ld_xfr) ? b2x_len : 
	                 (l_xfr_end) ? l_len:  l_len - 1;

   assign d_rd_next = (cas_latency == 3'b001) ? l_rd_next[2] :
		      (cas_latency == 3'b010) ? l_rd_next[3] :
		      (cas_latency == 3'b011) ? l_rd_next[4] :
		      (cas_latency == 3'b100) ? l_rd_next[5] :
		      l_rd_next[6];

   assign d_rd_last = (cas_latency == 3'b001) ? l_rd_last[2] :
		      (cas_latency == 3'b010) ? l_rd_last[3] :
		      (cas_latency == 3'b011) ? l_rd_last[4] :
		      (cas_latency == 3'b100) ? l_rd_last[5] :
		      l_rd_last[6];

   assign d_rd_start = (cas_latency == 3'b001) ? l_rd_start[2] :
		       (cas_latency == 3'b010) ? l_rd_start[3] :
		       (cas_latency == 3'b011) ? l_rd_start[4] :
		       (cas_latency == 3'b100) ? l_rd_start[5] :
		       l_rd_start[6];

   assign rd_pipe_mt = (cas_latency == 3'b001) ? ~|l_rd_next[1:0] :
		       (cas_latency == 3'b010) ? ~|l_rd_next[2:0] :
		       (cas_latency == 3'b011) ? ~|l_rd_next[3:0] :
		       (cas_latency == 3'b100) ? ~|l_rd_next[4:0] :
		       ~|l_rd_next[5:0];

   assign dt_next = wr_next | d_rd_next;

   assign xfr_end = ~|xfr_len;

   assign l_xfr_end = ~|(l_len-1);

   assign rd_start = ld_xfr & b2x_read & b2x_start;

   assign wr_start = ld_xfr & b2x_write & b2x_start;
   
   assign rd_last = rd_next & last_burst & ~|xfr_len[`REQ_BW-1:1];

   //assign wr_last = wr_next & last_burst & ~|xfr_len[APP_RW-1:1];

   assign wr_last = last_burst & ~|xfr_len[`REQ_BW-1:1];
   
   //assign xfr_ba = (ld_xfr) ? b2x_ba : l_ba;
   assign xfr_ba = (sel_mgmt) ? mgmt_ba : 
		   (sel_b2x) ? b2x_ba : l_ba;

   assign xfr_wrap = (ld_xfr) ? b2x_wrap : l_wrap;
   
//   assign burst_bdry = ~|xfr_caddr[2:0];
   wire [1:0] xfr_caddr_lsb = (xfr_caddr[1:0]+1);
   assign burst_bdry = ~|(xfr_caddr_lsb[1:0]);
  
   always @ (posedge clk) begin
      if (~reset_n) begin
	 xfr_caddr <= 13'b0;
	 l_start <= 1'b0;
	 l_last <= 1'b0;
	 l_wrap <= 1'b0;
	 l_id <= 0;
	 l_ba <= 0;
	 l_len <= 0;
	 l_rd_next <= 7'b0;
	 l_rd_start <= 7'b0;
	 l_rd_last <= 7'b0;
	 act_cmd <= 1'b0;
	 d_act_cmd <= 1'b0;
	 xfr_st <= `XFR_IDLE;
      end // if (~reset_n)

      else begin
	 xfr_caddr <= (ld_xfr) ? b2x_addr :
		      (rd_next | wr_next) ? xfr_caddr + 1 : xfr_caddr; 
	 l_start <= (dt_next) ? 1'b0 : 
		   (ld_xfr) ? b2x_start : l_start;
	 l_last <= (ld_xfr) ? b2x_last : l_last;
	 l_wrap <= (ld_xfr) ? b2x_wrap : l_wrap;
	 l_id <= (ld_xfr) ? b2x_id : l_id;
	 l_ba <= (ld_xfr) ? b2x_ba : l_ba;
	 l_len <= next_xfr_len;
	 l_rd_next <= {l_rd_next[5:0], rd_next};
	 l_rd_start <= {l_rd_start[5:0], rd_start};
	 l_rd_last <= {l_rd_last[5:0], rd_last};
	 act_cmd <= (xfr_cmd == `SDR_ACTIVATE) ? 1'b1 : 1'b0;
	 d_act_cmd <= act_cmd;
	 xfr_st <= next_xfr_st;
      end // else: !if(~reset_n)
      
   end // always @ (posedge clk)
   

   always @ (*) begin 
      case (xfr_st)

	`XFR_IDLE : begin

	   sel_mgmt = mgmt_req;
	   sel_b2x = ~mgmt_req & sdr_init_done & b2x_req;
	   i_xfr_cmd = `SDR_DESEL;
	   rd_next = ~mgmt_req & sdr_init_done & b2x_req & b2x_read;
	   wr_next = ~mgmt_req & sdr_init_done & b2x_req & b2x_write;
	   rdok = ~mgmt_req;
	   cb_pre_ok = 1'b1;
	   wrok = ~mgmt_req;
	   next_xfr_st = (mgmt_req | ~sdr_init_done) ? `XFR_IDLE :
			 (~b2x_req) ? `XFR_IDLE :
			 (b2x_read) ? `XFR_READ :
			 (b2x_write) ? `XFR_WRITE : `XFR_IDLE;

	end // case: `XFR_IDLE
	   
	`XFR_READ : begin
	   rd_next = ~l_xfr_end |
		     l_xfr_end & ~mgmt_req & b2x_req & b2x_read;
	   wr_next = 1'b0;
	   rdok = l_xfr_end & ~mgmt_req;
	   // Break the timing path for FPGA Based Design
	   cb_pre_ok = (`TARGET_DESIGN == `FPGA) ? 1'b0 : l_xfr_end;
	   wrok = 1'b0;
	   sel_mgmt = 1'b0;

	   if (l_xfr_end) begin		  // end of transfer

	      if (~l_wrap) begin
		 // Current transfer was not wrap mode, may need BT
		 // If next cmd is a R or W or PRE to same bank allow
		 // it else issue BT 
		 // This is a little pessimistic since BT is issued
		 // for non-wrap mode transfers even if the transfer
		 // ends on a burst boundary, but is felt to be of
		 // minimal performance impact.

		 i_xfr_cmd = `SDR_BT;
		 sel_b2x = b2x_req & ~mgmt_req & (b2x_read | b2x_prechg_hit);

	      end // if (~l_wrap)
	      
	      else begin
		 // Wrap mode transfer, by definition is end of burst
		 // boundary 

		 i_xfr_cmd = `SDR_DESEL;
		 sel_b2x = b2x_req & ~mgmt_req & ~b2x_write;

	      end // else: !if(~l_wrap)
		 
	      next_xfr_st = (sdr_init_done) ? ((b2x_req & ~mgmt_req & b2x_read) ? `XFR_READ : `XFR_RDWT) : `XFR_IDLE;

	   end // if (l_xfr_end)

	   else begin
	      // Not end of transfer
	      // If current transfer was not wrap mode and we are at
	      // the start of a burst boundary issue another R cmd to
	      // step sequemtially thru memory, ELSE,
	      // issue precharge/activate commands from the bank control

	      i_xfr_cmd = (burst_bdry & ~l_wrap) ? `SDR_READ : `SDR_DESEL;
	      sel_b2x = ~(burst_bdry & ~l_wrap) & b2x_req;
	      next_xfr_st = `XFR_READ;

	   end // else: !if(l_xfr_end)
	   
	end // case: `XFR_READ
	
	`XFR_RDWT : begin 
	   rd_next = ~mgmt_req & b2x_req & b2x_read;
	   wr_next = rd_pipe_mt & ~mgmt_req & b2x_req & b2x_write;
	   rdok = ~mgmt_req;
	   cb_pre_ok = 1'b1;
	   wrok = rd_pipe_mt & ~mgmt_req;

	   sel_mgmt = mgmt_req;
	   
	   sel_b2x = ~mgmt_req & b2x_req;

	   i_xfr_cmd = `SDR_DESEL;

	   next_xfr_st = (~mgmt_req & b2x_req & b2x_read) ? `XFR_READ : 
			 (~rd_pipe_mt) ? `XFR_RDWT :
			 (~mgmt_req & b2x_req & b2x_write) ? `XFR_WRITE : 
			 `XFR_IDLE;

	end // case: `XFR_RDWT
	
	`XFR_WRITE : begin
	   rd_next = l_xfr_end & ~mgmt_req & b2x_req & b2x_read;
	   wr_next = ~l_xfr_end |
		     l_xfr_end & ~mgmt_req & b2x_req & b2x_write;
	   rdok = l_xfr_end & ~mgmt_req;
	   cb_pre_ok = 1'b0;
	   wrok = l_xfr_end & ~mgmt_req;
	   sel_mgmt = 1'b0;

	   if (l_xfr_end) begin		  // End of transfer

	      if (~l_wrap) begin
		 // Current transfer was not wrap mode, may need BT
		 // If next cmd is a R or W allow it else issue BT 
		 // This is a little pessimistic since BT is issued
		 // for non-wrap mode transfers even if the transfer
		 // ends on a burst boundary, but is felt to be of
		 // minimal performance impact.


		 sel_b2x = b2x_req & ~mgmt_req & (b2x_read | b2x_write);
		 i_xfr_cmd = `SDR_BT;
	      end // if (~l_wrap)

	      else begin
		 // Wrap mode transfer, by definition is end of burst
		 // boundary 

		 sel_b2x = b2x_req & ~mgmt_req & ~b2x_prechg_hit;
		 i_xfr_cmd = `SDR_DESEL;
	      end // else: !if(~l_wrap)
	      
	      next_xfr_st = (~mgmt_req & b2x_req & b2x_read) ? `XFR_READ : 
			    (~mgmt_req & b2x_req & b2x_write) ? `XFR_WRITE : 
			    `XFR_IDLE;

	   end // if (l_xfr_end)

	   else begin
	      // Not end of transfer
	      // If current transfer was not wrap mode and we are at
	      // the start of a burst boundary issue another R cmd to
	      // step sequemtially thru memory, ELSE,
	      // issue precharge/activate commands from the bank control

	      if (burst_bdry & ~l_wrap) begin
		 sel_b2x = 1'b0;
		 i_xfr_cmd = `SDR_WRITE;
	      end // if (burst_bdry & ~l_wrap)
	      
	      else begin
		 sel_b2x = b2x_req & ~mgmt_req;
		 i_xfr_cmd = `SDR_DESEL;
	      end // else: !if(burst_bdry & ~l_wrap)

	      next_xfr_st = `XFR_WRITE;
	   end // else: !if(l_xfr_end)

	end // case: `XFR_WRITE

      endcase // case(xfr_st)

   end // always @ (xfr_st or ...)

   // signals to bank_ctl (x2b_refresh, x2b_act_ok, x2b_rdok, x2b_wrok,
   // x2b_pre_ok[3:0] 

   assign x2b_refresh = (xfr_cmd == `SDR_REFRESH) ? 1'b1 : 1'b0;

   assign x2b_act_ok = ~act_cmd & ~d_act_cmd;

   assign x2b_rdok = rdok;

   assign x2b_wrok = wrok;

   //assign x2b_pre_ok[0] = (l_ba == 2'b00) ? cb_pre_ok : 1'b1;
   //assign x2b_pre_ok[1] = (l_ba == 2'b01) ? cb_pre_ok : 1'b1;
   //assign x2b_pre_ok[2] = (l_ba == 2'b10) ? cb_pre_ok : 1'b1;
   //assign x2b_pre_ok[3] = (l_ba == 2'b11) ? cb_pre_ok : 1'b1;
   
   assign x2b_pre_ok[0] = cb_pre_ok;
   assign x2b_pre_ok[1] = cb_pre_ok;
   assign x2b_pre_ok[2] = cb_pre_ok;
   assign x2b_pre_ok[3] = cb_pre_ok;
   assign last_burst = (ld_xfr) ? b2x_last : l_last;
   
   /************************************************************************/
   // APP Data I/F

   wire [SDR_DW-1:0] 	x2a_rddt;

   //assign x2a_start = (ld_xfr) ? b2x_start : l_start;
   assign x2a_rdstart = d_rd_start;
   assign x2a_wrstart = wr_start;
   
   assign x2a_rdlast = d_rd_last;
   assign x2a_wrlast = wr_last;

   assign x2a_id = (ld_xfr) ? b2x_id : l_id;

   assign x2a_rddt = sdr_din;

   assign x2a_wrnext = wr_next;

   assign x2a_rdok = d_rd_next;
   
   /************************************************************************/
   // SDRAM I/F

   reg 				sdr_cs_n, sdr_cke, sdr_ras_n, sdr_cas_n,
				sdr_we_n; 
   reg [SDR_BW-1:0] 	sdr_dqm;
   reg [1:0] 			sdr_ba;
   reg [12:0] 			sdr_addr;
   reg [SDR_DW-1:0] 	sdr_dout;
   reg [SDR_BW-1:0] 	sdr_den_n;

   always @ (posedge clk)
      if (~reset_n) begin
	 sdr_cs_n <= 1'b1;
	 sdr_cke <= 1'b1;
	 sdr_ras_n <= 1'b1;
	 sdr_cas_n <= 1'b1;
	 sdr_we_n <= 1'b1;
	 sdr_dqm   <= {SDR_BW{1'b1}};
	 sdr_den_n <= {SDR_BW{1'b1}};
      end // if (~reset_n)
      else begin
	 sdr_cs_n <= xfr_cmd[3];
	 sdr_ras_n <= xfr_cmd[2];
	 sdr_cas_n <= xfr_cmd[1];
	 sdr_we_n <= xfr_cmd[0];
	 sdr_cke <= (xfr_st != `XFR_IDLE) ? 1'b1 : 
		    ~(mgmt_idle & b2x_idle & r2x_idle);
	 sdr_dqm <= (wr_next) ? a2x_wren_n : {SDR_BW{1'b0}};
         sdr_den_n <= (wr_next) ? {SDR_BW{1'b0}} : {SDR_BW{1'b1}};
      end // else: !if(~reset_n)

   always @ (posedge clk) begin 

      if (~xfr_cmd[3]) begin 
	 sdr_addr <= xfr_addr;
	 sdr_ba <= xfr_ba;
      end // if (~xfr_cmd[3])
      
      sdr_dout <= (wr_next) ? a2x_wrdt : sdr_dout;

   end // always @ (posedge clk)
   
   /************************************************************************/
   // Refresh and Initialization

   `define MGM_POWERUP         3'b000
   `define MGM_PRECHARGE    3'b001
   `define MGM_PCHWT        3'b010
   `define MGM_REFRESH      3'b011
   `define MGM_REFWT        3'b100
   `define MGM_MODE_REG     3'b101
   `define MGM_MODE_WT      3'b110
   `define MGM_ACTIVE       3'b111
   
   reg [2:0]       mgmt_st, next_mgmt_st;
   reg [3:0] 	   tmr0, tmr0_d;
   reg [3:0] 	   cntr1, cntr1_d;
   wire 	   tmr0_tc, cntr1_tc, rfsh_timer_tc, ref_req, precharge_ok;
   reg 		   ld_tmr0, ld_cntr1, dec_cntr1, set_sdr_init_done;
   reg [`SDR_RFSH_TIMER_W-1 : 0]  rfsh_timer;
   reg [`SDR_RFSH_ROW_CNT_W-1:0]  rfsh_row_cnt;
   
   always @ (posedge clk) 
      if (~reset_n) begin
	 mgmt_st <= `MGM_POWERUP;
	 tmr0 <= 4'b0;
	 cntr1 <= 4'h7;
	 rfsh_timer <= 0;
	 rfsh_row_cnt <= 0;
	 sdr_init_done <= 1'b0;
      end // if (~reset_n)
      else begin
	 mgmt_st <= next_mgmt_st;
	 tmr0 <= (ld_tmr0) ? tmr0_d :
		  (~tmr0_tc) ? tmr0 - 1 : tmr0;
	 cntr1 <= (ld_cntr1) ? cntr1_d :
		  (dec_cntr1) ? cntr1 - 1 : cntr1;
	 sdr_init_done <= (set_sdr_init_done | sdr_init_done) & sdram_enable;
	 rfsh_timer <= (rfsh_timer_tc) ? 0 : rfsh_timer + 1;
	 rfsh_row_cnt <= (~set_sdr_init_done) ? 0 :
			 (rfsh_timer_tc) ? rfsh_row_cnt + 1 : rfsh_row_cnt;
      end // else: !if(~reset_n)

   assign tmr0_tc = ~|tmr0;

   assign cntr1_tc = ~|cntr1;

   assign rfsh_timer_tc = (rfsh_timer == rfsh_time) ? 1'b1 : 1'b0;

   assign ref_req = (rfsh_row_cnt >= rfsh_rmax) ? 1'b1 : 1'b0;

   assign precharge_ok = cb_pre_ok & b2x_tras_ok;

   assign xfr_bank_sel = l_ba;
   
   always @ (mgmt_st or sdram_enable or mgmt_ack or trp_delay or tmr0_tc or
	     cntr1_tc or trcar_delay or rfsh_row_cnt or ref_req or sdr_init_done
	     or precharge_ok or sdram_mode_reg) begin 

      case (mgmt_st)          // synopsys full_case parallel_case

	`MGM_POWERUP : begin
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b0;
	   mgmt_cmd = `SDR_DESEL;
	   mgmt_ba = 2'b0;
	   mgmt_addr = 13'h400;    // A10 = 1 => all banks
	   ld_tmr0 = 1'b0;
	   tmr0_d = 4'b0;
	   dec_cntr1 = 1'b0;
	   ld_cntr1 = 1'b1;
	   cntr1_d = 4'hf; // changed for sdrams with higher refresh cycles during initialization
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (sdram_enable) ? `MGM_PRECHARGE : `MGM_POWERUP; 
	end // case: `MGM_POWERUP

	`MGM_PRECHARGE : begin	   // Precharge all banks
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = (precharge_ok) ? `SDR_PRECHARGE : `SDR_DESEL;
	   mgmt_ba = 2'b0;
	   mgmt_addr = 13'h400;	   // A10 = 1 => all banks
	   ld_tmr0 = mgmt_ack;
	   tmr0_d = trp_delay;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'h7;
	   dec_cntr1 = 1'b0;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (precharge_ok & mgmt_ack) ? `MGM_PCHWT : `MGM_PRECHARGE;
	end // case: `MGM_PRECHARGE
	
	`MGM_PCHWT : begin	   // Wait for Trp
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = `SDR_DESEL;
	   mgmt_ba = 2'b0;
	   mgmt_addr = 13'h400;	   // A10 = 1 => all banks
	   ld_tmr0 = 1'b0;
	   tmr0_d = trp_delay;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'b0;
	   dec_cntr1 = 1'b0;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (tmr0_tc) ? `MGM_REFRESH : `MGM_PCHWT;
	end // case: `MGM_PRECHARGE
	
	`MGM_REFRESH : begin	   // Refresh
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = `SDR_REFRESH;
	   mgmt_ba = 2'b0;
	   mgmt_addr = 13'h400;	   // A10 = 1 => all banks
	   ld_tmr0 = mgmt_ack;
	   tmr0_d = trcar_delay;
	   dec_cntr1 = mgmt_ack;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'h7;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (mgmt_ack) ? `MGM_REFWT : `MGM_REFRESH;
	end // case: `MGM_REFRESH
	
	`MGM_REFWT : begin	   // Wait for trcar
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = `SDR_DESEL;
	   mgmt_ba = 2'b0;
	   mgmt_addr = 13'h400;	   // A10 = 1 => all banks
	   ld_tmr0 = 1'b0;
	   tmr0_d = trcar_delay;
	   dec_cntr1 = 1'b0;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'h7;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (~tmr0_tc) ? `MGM_REFWT : 
			  (~cntr1_tc) ? `MGM_REFRESH :
			  (sdr_init_done) ? `MGM_ACTIVE : `MGM_MODE_REG;
	end // case: `MGM_REFWT
	
	`MGM_MODE_REG : begin	   // Program mode Register & wait for 
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = `SDR_MODE;
	   mgmt_ba = {1'b0, sdram_mode_reg[11]};
	   mgmt_addr = sdram_mode_reg;
	   ld_tmr0 = mgmt_ack;
	   tmr0_d = 4'h7;
	   dec_cntr1 = 1'b0;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'h7;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (mgmt_ack) ? `MGM_MODE_WT : `MGM_MODE_REG;
	end // case: `MGM_MODE_REG
	
	`MGM_MODE_WT : begin	   // Wait for tMRD
	   mgmt_idle = 1'b0;
	   mgmt_req = 1'b1;
	   mgmt_cmd = `SDR_DESEL;
	   mgmt_ba = 2'bx;
	   mgmt_addr = 13'bx;
	   ld_tmr0 = 1'b0;
	   tmr0_d = 4'h7;
	   dec_cntr1 = 1'b0;
	   ld_cntr1 = 1'b0;
	   cntr1_d = 4'h7;
	   set_sdr_init_done = 1'b0;
	   next_mgmt_st = (~tmr0_tc) ? `MGM_MODE_WT : `MGM_ACTIVE;
	end // case: `MGM_MODE_WT
	
	`MGM_ACTIVE : begin	   // Wait for ref_req
	   mgmt_idle = ~ref_req;
	   mgmt_req = 1'b0;
	   mgmt_cmd = `SDR_DESEL;
	   mgmt_ba = 2'bx;
	   mgmt_addr = 13'bx;
	   ld_tmr0 = 1'b0;
	   tmr0_d = 4'h7;
	   dec_cntr1 = 1'b0;
	   ld_cntr1 = ref_req;
	   cntr1_d = rfsh_row_cnt;
	   set_sdr_init_done = 1'b1;
	   next_mgmt_st =  (~sdram_enable) ? `MGM_POWERUP :
                           (ref_req) ? `MGM_PRECHARGE : `MGM_ACTIVE;
	end // case: `MGM_MODE_WT
	
      endcase // case(mgmt_st)

   end // always @ (mgmt_st or ....)
   
	   

endmodule // sdr_xfr_ctl
