/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Slave Interface                 ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/wb_conmax/ ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: wb_conmax_slave_if.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
//
//  $Date: 2002-10-03 05:40:07 $
//  $Revision: 1.2 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/10/19 11:01:39  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "wb_conmax_defines.v"

module wb_conmax_slave_if(

	clk_i, rst_i, conf,

	// Slave interface
	wb_data_i, wb_data_o, wb_addr_o, wb_sel_o, wb_we_o, wb_cyc_o,
	wb_stb_o, wb_ack_i, wb_err_i, wb_rty_i,

	// Master 0 Interface
	m0_data_i, m0_data_o, m0_addr_i, m0_sel_i, m0_we_i, m0_cyc_i,
	m0_stb_i, m0_ack_o, m0_err_o, m0_rty_o,

	// Master 1 Interface
	m1_data_i, m1_data_o, m1_addr_i, m1_sel_i, m1_we_i, m1_cyc_i,
	m1_stb_i, m1_ack_o, m1_err_o, m1_rty_o,

	// Master 2 Interface
	m2_data_i, m2_data_o, m2_addr_i, m2_sel_i, m2_we_i, m2_cyc_i,
	m2_stb_i, m2_ack_o, m2_err_o, m2_rty_o,

	// Master 3 Interface
	m3_data_i, m3_data_o, m3_addr_i, m3_sel_i, m3_we_i, m3_cyc_i,
	m3_stb_i, m3_ack_o, m3_err_o, m3_rty_o,

	// Master 4 Interface
	m4_data_i, m4_data_o, m4_addr_i, m4_sel_i, m4_we_i, m4_cyc_i,
	m4_stb_i, m4_ack_o, m4_err_o, m4_rty_o,

	// Master 5 Interface
	m5_data_i, m5_data_o, m5_addr_i, m5_sel_i, m5_we_i, m5_cyc_i,
	m5_stb_i, m5_ack_o, m5_err_o, m5_rty_o,

	// Master 6 Interface
	m6_data_i, m6_data_o, m6_addr_i, m6_sel_i, m6_we_i, m6_cyc_i,
	m6_stb_i, m6_ack_o, m6_err_o, m6_rty_o,

	// Master 7 Interface
	m7_data_i, m7_data_o, m7_addr_i, m7_sel_i, m7_we_i, m7_cyc_i,
	m7_stb_i, m7_ack_o, m7_err_o, m7_rty_o
	);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter [1:0]		pri_sel = 2'd2;
parameter		aw	= 32;		// Address bus Width
parameter		dw	= 32;		// Data bus Width
parameter		sw	= dw / 8;	// Number of Select Lines

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input			clk_i, rst_i;
input	[15:0]		conf;

// Slave Interface
input	[dw-1:0]	wb_data_i;
output	[dw-1:0]	wb_data_o;
output	[aw-1:0]	wb_addr_o;
output	[sw-1:0]	wb_sel_o;
output			wb_we_o;
output			wb_cyc_o;
output			wb_stb_o;
input			wb_ack_i;
input			wb_err_i;
input			wb_rty_i;

// Master 0 Interface
input	[dw-1:0]	m0_data_i;
output	[dw-1:0]	m0_data_o;
input	[aw-1:0]	m0_addr_i;
input	[sw-1:0]	m0_sel_i;
input			m0_we_i;
input			m0_cyc_i;
input			m0_stb_i;
output			m0_ack_o;
output			m0_err_o;
output			m0_rty_o;

// Master 1 Interface
input	[dw-1:0]	m1_data_i;
output	[dw-1:0]	m1_data_o;
input	[aw-1:0]	m1_addr_i;
input	[sw-1:0]	m1_sel_i;
input			m1_we_i;
input			m1_cyc_i;
input			m1_stb_i;
output			m1_ack_o;
output			m1_err_o;
output			m1_rty_o;

// Master 2 Interface
input	[dw-1:0]	m2_data_i;
output	[dw-1:0]	m2_data_o;
input	[aw-1:0]	m2_addr_i;
input	[sw-1:0]	m2_sel_i;
input			m2_we_i;
input			m2_cyc_i;
input			m2_stb_i;
output			m2_ack_o;
output			m2_err_o;
output			m2_rty_o;

// Master 3 Interface
input	[dw-1:0]	m3_data_i;
output	[dw-1:0]	m3_data_o;
input	[aw-1:0]	m3_addr_i;
input	[sw-1:0]	m3_sel_i;
input			m3_we_i;
input			m3_cyc_i;
input			m3_stb_i;
output			m3_ack_o;
output			m3_err_o;
output			m3_rty_o;

// Master 4 Interface
input	[dw-1:0]	m4_data_i;
output	[dw-1:0]	m4_data_o;
input	[aw-1:0]	m4_addr_i;
input	[sw-1:0]	m4_sel_i;
input			m4_we_i;
input			m4_cyc_i;
input			m4_stb_i;
output			m4_ack_o;
output			m4_err_o;
output			m4_rty_o;

// Master 5 Interface
input	[dw-1:0]	m5_data_i;
output	[dw-1:0]	m5_data_o;
input	[aw-1:0]	m5_addr_i;
input	[sw-1:0]	m5_sel_i;
input			m5_we_i;
input			m5_cyc_i;
input			m5_stb_i;
output			m5_ack_o;
output			m5_err_o;
output			m5_rty_o;

// Master 6 Interface
input	[dw-1:0]	m6_data_i;
output	[dw-1:0]	m6_data_o;
input	[aw-1:0]	m6_addr_i;
input	[sw-1:0]	m6_sel_i;
input			m6_we_i;
input			m6_cyc_i;
input			m6_stb_i;
output			m6_ack_o;
output			m6_err_o;
output			m6_rty_o;

// Master 7 Interface
input	[dw-1:0]	m7_data_i;
output	[dw-1:0]	m7_data_o;
input	[aw-1:0]	m7_addr_i;
input	[sw-1:0]	m7_sel_i;
input			m7_we_i;
input			m7_cyc_i;
input			m7_stb_i;
output			m7_ack_o;
output			m7_err_o;
output			m7_rty_o;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[aw-1:0]	wb_addr_o;
reg	[dw-1:0]	wb_data_o;
reg	[sw-1:0]	wb_sel_o;
reg			wb_we_o;
reg			wb_cyc_o;
reg			wb_stb_o;
wire	[2:0]		mast_sel_simple;
wire	[2:0]		mast_sel_pe;
wire	[2:0]		mast_sel;

reg			next;
reg			m0_cyc_r, m1_cyc_r, m2_cyc_r, m3_cyc_r;
reg			m4_cyc_r, m5_cyc_r, m6_cyc_r, m7_cyc_r;

////////////////////////////////////////////////////////////////////
//
// Select logic
//

always @(posedge clk_i)
	next <= #1 ~wb_cyc_o;


wb_conmax_arb arb(
	.clk(		clk_i		),
	.rst(		rst_i		),
	.req(	{	m7_cyc_i,
			m6_cyc_i,
			m5_cyc_i,
			m4_cyc_i,
			m3_cyc_i,
			m2_cyc_i,
			m1_cyc_i,
			m0_cyc_i }	),
	.gnt(		mast_sel_simple	),
	.next(		1'b0		)
	);

wb_conmax_msel #(pri_sel) msel(
	.clk_i(		clk_i		),
	.rst_i(		rst_i		),
	.conf(		conf		),
	.req(	{	m7_cyc_i,
			m6_cyc_i,
			m5_cyc_i,
			m4_cyc_i,
			m3_cyc_i,
			m2_cyc_i,
			m1_cyc_i,
			m0_cyc_i}	),
	.sel(		mast_sel_pe	),
	.next(		next		)
	);

assign mast_sel = (pri_sel == 2'd0) ? mast_sel_simple : mast_sel_pe;

////////////////////////////////////////////////////////////////////
//
// Address & Data Pass
//

always @(mast_sel or m0_addr_i or m1_addr_i or m2_addr_i or m3_addr_i
	or m4_addr_i or m5_addr_i or m6_addr_i or m7_addr_i)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_addr_o = m0_addr_i;
	   3'd1: wb_addr_o = m1_addr_i;
	   3'd2: wb_addr_o = m2_addr_i;
	   3'd3: wb_addr_o = m3_addr_i;
	   3'd4: wb_addr_o = m4_addr_i;
	   3'd5: wb_addr_o = m5_addr_i;
	   3'd6: wb_addr_o = m6_addr_i;
	   3'd7: wb_addr_o = m7_addr_i;
	   default: wb_addr_o = {aw{1'bx}};
	endcase

always @(mast_sel or m0_sel_i or m1_sel_i or m2_sel_i or m3_sel_i
	or m4_sel_i or m5_sel_i or m6_sel_i or m7_sel_i)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_sel_o = m0_sel_i;
	   3'd1: wb_sel_o = m1_sel_i;
	   3'd2: wb_sel_o = m2_sel_i;
	   3'd3: wb_sel_o = m3_sel_i;
	   3'd4: wb_sel_o = m4_sel_i;
	   3'd5: wb_sel_o = m5_sel_i;
	   3'd6: wb_sel_o = m6_sel_i;
	   3'd7: wb_sel_o = m7_sel_i;
	   default: wb_sel_o = {sw{1'bx}};
	endcase

always @(mast_sel or m0_data_i or m1_data_i or m2_data_i or m3_data_i
	or m4_data_i or m5_data_i or m6_data_i or m7_data_i)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_data_o = m0_data_i;
	   3'd1: wb_data_o = m1_data_i;
	   3'd2: wb_data_o = m2_data_i;
	   3'd3: wb_data_o = m3_data_i;
	   3'd4: wb_data_o = m4_data_i;
	   3'd5: wb_data_o = m5_data_i;
	   3'd6: wb_data_o = m6_data_i;
	   3'd7: wb_data_o = m7_data_i;
	   default: wb_data_o = {dw{1'bx}};
	endcase

assign m0_data_o = wb_data_i;
assign m1_data_o = wb_data_i;
assign m2_data_o = wb_data_i;
assign m3_data_o = wb_data_i;
assign m4_data_o = wb_data_i;
assign m5_data_o = wb_data_i;
assign m6_data_o = wb_data_i;
assign m7_data_o = wb_data_i;

////////////////////////////////////////////////////////////////////
//
// Control Signal Pass
//

always @(mast_sel or m0_we_i or m1_we_i or m2_we_i or m3_we_i
	or m4_we_i or m5_we_i or m6_we_i or m7_we_i)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_we_o = m0_we_i;
	   3'd1: wb_we_o = m1_we_i;
	   3'd2: wb_we_o = m2_we_i;
	   3'd3: wb_we_o = m3_we_i;
	   3'd4: wb_we_o = m4_we_i;
	   3'd5: wb_we_o = m5_we_i;
	   3'd6: wb_we_o = m6_we_i;
	   3'd7: wb_we_o = m7_we_i;
	   default: wb_we_o = 1'bx;
	endcase

always @(posedge clk_i)
	m0_cyc_r <= #1 m0_cyc_i;

always @(posedge clk_i)
	m1_cyc_r <= #1 m1_cyc_i;

always @(posedge clk_i)
	m2_cyc_r <= #1 m2_cyc_i;

always @(posedge clk_i)
	m3_cyc_r <= #1 m3_cyc_i;

always @(posedge clk_i)
	m4_cyc_r <= #1 m4_cyc_i;

always @(posedge clk_i)
	m5_cyc_r <= #1 m5_cyc_i;

always @(posedge clk_i)
	m6_cyc_r <= #1 m6_cyc_i;

always @(posedge clk_i)
	m7_cyc_r <= #1 m7_cyc_i;

always @(mast_sel or m0_cyc_i or m1_cyc_i or m2_cyc_i or m3_cyc_i
	or m4_cyc_i or m5_cyc_i or m6_cyc_i or m7_cyc_i
	or m0_cyc_r or m1_cyc_r or m2_cyc_r or m3_cyc_r
	or m4_cyc_r or m5_cyc_r or m6_cyc_r or m7_cyc_r)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_cyc_o = m0_cyc_i & m0_cyc_r;
	   3'd1: wb_cyc_o = m1_cyc_i & m1_cyc_r;
	   3'd2: wb_cyc_o = m2_cyc_i & m2_cyc_r;
	   3'd3: wb_cyc_o = m3_cyc_i & m3_cyc_r;
	   3'd4: wb_cyc_o = m4_cyc_i & m4_cyc_r;
	   3'd5: wb_cyc_o = m5_cyc_i & m5_cyc_r;
	   3'd6: wb_cyc_o = m6_cyc_i & m6_cyc_r;
	   3'd7: wb_cyc_o = m7_cyc_i & m7_cyc_r;
	   default: wb_cyc_o = 1'b0;
	endcase

always @(mast_sel or m0_stb_i or m1_stb_i or m2_stb_i or m3_stb_i
	or m4_stb_i or m5_stb_i or m6_stb_i or m7_stb_i)
	case(mast_sel)	// synopsys parallel_case
	   3'd0: wb_stb_o = m0_stb_i;
	   3'd1: wb_stb_o = m1_stb_i;
	   3'd2: wb_stb_o = m2_stb_i;
	   3'd3: wb_stb_o = m3_stb_i;
	   3'd4: wb_stb_o = m4_stb_i;
	   3'd5: wb_stb_o = m5_stb_i;
	   3'd6: wb_stb_o = m6_stb_i;
	   3'd7: wb_stb_o = m7_stb_i;
	   default: wb_stb_o = 1'b0;
	endcase

assign m0_ack_o = (mast_sel==3'd0) & wb_ack_i;
assign m1_ack_o = (mast_sel==3'd1) & wb_ack_i;
assign m2_ack_o = (mast_sel==3'd2) & wb_ack_i;
assign m3_ack_o = (mast_sel==3'd3) & wb_ack_i;
assign m4_ack_o = (mast_sel==3'd4) & wb_ack_i;
assign m5_ack_o = (mast_sel==3'd5) & wb_ack_i;
assign m6_ack_o = (mast_sel==3'd6) & wb_ack_i;
assign m7_ack_o = (mast_sel==3'd7) & wb_ack_i;

assign m0_err_o = (mast_sel==3'd0) & wb_err_i;
assign m1_err_o = (mast_sel==3'd1) & wb_err_i;
assign m2_err_o = (mast_sel==3'd2) & wb_err_i;
assign m3_err_o = (mast_sel==3'd3) & wb_err_i;
assign m4_err_o = (mast_sel==3'd4) & wb_err_i;
assign m5_err_o = (mast_sel==3'd5) & wb_err_i;
assign m6_err_o = (mast_sel==3'd6) & wb_err_i;
assign m7_err_o = (mast_sel==3'd7) & wb_err_i;

assign m0_rty_o = (mast_sel==3'd0) & wb_rty_i;
assign m1_rty_o = (mast_sel==3'd1) & wb_rty_i;
assign m2_rty_o = (mast_sel==3'd2) & wb_rty_i;
assign m3_rty_o = (mast_sel==3'd3) & wb_rty_i;
assign m4_rty_o = (mast_sel==3'd4) & wb_rty_i;
assign m5_rty_o = (mast_sel==3'd5) & wb_rty_i;
assign m6_rty_o = (mast_sel==3'd6) & wb_rty_i;
assign m7_rty_o = (mast_sel==3'd7) & wb_rty_i;

endmodule

