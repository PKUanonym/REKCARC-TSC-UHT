/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Master Interface                ////
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
//  $Id: wb_conmax_master_if.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
//
//  $Date: 2002-10-03 05:40:07 $
//  $Revision: 1.2 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/10/19 11:01:41  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "wb_conmax_defines.v"

module wb_conmax_master_if(

	clk_i, rst_i,

	// Master interface
	wb_data_i, wb_data_o, wb_addr_i, wb_sel_i, wb_we_i, wb_cyc_i,
	wb_stb_i, wb_ack_o, wb_err_o, wb_rty_o,

	// Slave 0 Interface
	s0_data_i, s0_data_o, s0_addr_o, s0_sel_o, s0_we_o, s0_cyc_o,
	s0_stb_o, s0_ack_i, s0_err_i, s0_rty_i,

	// Slave 1 Interface
	s1_data_i, s1_data_o, s1_addr_o, s1_sel_o, s1_we_o, s1_cyc_o,
	s1_stb_o, s1_ack_i, s1_err_i, s1_rty_i,

	// Slave 2 Interface
	s2_data_i, s2_data_o, s2_addr_o, s2_sel_o, s2_we_o, s2_cyc_o,
	s2_stb_o, s2_ack_i, s2_err_i, s2_rty_i,

	// Slave 3 Interface
	s3_data_i, s3_data_o, s3_addr_o, s3_sel_o, s3_we_o, s3_cyc_o,
	s3_stb_o, s3_ack_i, s3_err_i, s3_rty_i,

	// Slave 4 Interface
	s4_data_i, s4_data_o, s4_addr_o, s4_sel_o, s4_we_o, s4_cyc_o,
	s4_stb_o, s4_ack_i, s4_err_i, s4_rty_i,

	// Slave 5 Interface
	s5_data_i, s5_data_o, s5_addr_o, s5_sel_o, s5_we_o, s5_cyc_o,
	s5_stb_o, s5_ack_i, s5_err_i, s5_rty_i,

	// Slave 6 Interface
	s6_data_i, s6_data_o, s6_addr_o, s6_sel_o, s6_we_o, s6_cyc_o,
	s6_stb_o, s6_ack_i, s6_err_i, s6_rty_i,

	// Slave 7 Interface
	s7_data_i, s7_data_o, s7_addr_o, s7_sel_o, s7_we_o, s7_cyc_o,
	s7_stb_o, s7_ack_i, s7_err_i, s7_rty_i,

	// Slave 8 Interface
	s8_data_i, s8_data_o, s8_addr_o, s8_sel_o, s8_we_o, s8_cyc_o,
	s8_stb_o, s8_ack_i, s8_err_i, s8_rty_i,

	// Slave 9 Interface
	s9_data_i, s9_data_o, s9_addr_o, s9_sel_o, s9_we_o, s9_cyc_o,
	s9_stb_o, s9_ack_i, s9_err_i, s9_rty_i,

	// Slave 10 Interface
	s10_data_i, s10_data_o, s10_addr_o, s10_sel_o, s10_we_o, s10_cyc_o,
	s10_stb_o, s10_ack_i, s10_err_i, s10_rty_i,

	// Slave 11 Interface
	s11_data_i, s11_data_o, s11_addr_o, s11_sel_o, s11_we_o, s11_cyc_o,
	s11_stb_o, s11_ack_i, s11_err_i, s11_rty_i,

	// Slave 12 Interface
	s12_data_i, s12_data_o, s12_addr_o, s12_sel_o, s12_we_o, s12_cyc_o,
	s12_stb_o, s12_ack_i, s12_err_i, s12_rty_i,

	// Slave 13 Interface
	s13_data_i, s13_data_o, s13_addr_o, s13_sel_o, s13_we_o, s13_cyc_o,
	s13_stb_o, s13_ack_i, s13_err_i, s13_rty_i,

	// Slave 14 Interface
	s14_data_i, s14_data_o, s14_addr_o, s14_sel_o, s14_we_o, s14_cyc_o,
	s14_stb_o, s14_ack_i, s14_err_i, s14_rty_i,

	// Slave 15 Interface
	s15_data_i, s15_data_o, s15_addr_o, s15_sel_o, s15_we_o, s15_cyc_o,
	s15_stb_o, s15_ack_i, s15_err_i, s15_rty_i
	);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter		dw	= 32;		// Data bus Width
parameter		aw	= 32;		// Address bus Width
parameter		sw	= dw / 8;	// Number of Select Lines

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input			clk_i, rst_i;

// Master Interface
input	[dw-1:0]	wb_data_i;
output	[dw-1:0]	wb_data_o;
input	[aw-1:0]	wb_addr_i;
input	[sw-1:0]	wb_sel_i;
input			wb_we_i;
input			wb_cyc_i;
input			wb_stb_i;
output			wb_ack_o;
output			wb_err_o;
output			wb_rty_o;

// Slave 0 Interface
input	[dw-1:0]	s0_data_i;
output	[dw-1:0]	s0_data_o;
output	[aw-1:0]	s0_addr_o;
output	[sw-1:0]	s0_sel_o;
output			s0_we_o;
output			s0_cyc_o;
output			s0_stb_o;
input			s0_ack_i;
input			s0_err_i;
input			s0_rty_i;

// Slave 1 Interface
input	[dw-1:0]	s1_data_i;
output	[dw-1:0]	s1_data_o;
output	[aw-1:0]	s1_addr_o;
output	[sw-1:0]	s1_sel_o;
output			s1_we_o;
output			s1_cyc_o;
output			s1_stb_o;
input			s1_ack_i;
input			s1_err_i;
input			s1_rty_i;

// Slave 2 Interface
input	[dw-1:0]	s2_data_i;
output	[dw-1:0]	s2_data_o;
output	[aw-1:0]	s2_addr_o;
output	[sw-1:0]	s2_sel_o;
output			s2_we_o;
output			s2_cyc_o;
output			s2_stb_o;
input			s2_ack_i;
input			s2_err_i;
input			s2_rty_i;

// Slave 3 Interface
input	[dw-1:0]	s3_data_i;
output	[dw-1:0]	s3_data_o;
output	[aw-1:0]	s3_addr_o;
output	[sw-1:0]	s3_sel_o;
output			s3_we_o;
output			s3_cyc_o;
output			s3_stb_o;
input			s3_ack_i;
input			s3_err_i;
input			s3_rty_i;

// Slave 4 Interface
input	[dw-1:0]	s4_data_i;
output	[dw-1:0]	s4_data_o;
output	[aw-1:0]	s4_addr_o;
output	[sw-1:0]	s4_sel_o;
output			s4_we_o;
output			s4_cyc_o;
output			s4_stb_o;
input			s4_ack_i;
input			s4_err_i;
input			s4_rty_i;

// Slave 5 Interface
input	[dw-1:0]	s5_data_i;
output	[dw-1:0]	s5_data_o;
output	[aw-1:0]	s5_addr_o;
output	[sw-1:0]	s5_sel_o;
output			s5_we_o;
output			s5_cyc_o;
output			s5_stb_o;
input			s5_ack_i;
input			s5_err_i;
input			s5_rty_i;

// Slave 6 Interface
input	[dw-1:0]	s6_data_i;
output	[dw-1:0]	s6_data_o;
output	[aw-1:0]	s6_addr_o;
output	[sw-1:0]	s6_sel_o;
output			s6_we_o;
output			s6_cyc_o;
output			s6_stb_o;
input			s6_ack_i;
input			s6_err_i;
input			s6_rty_i;

// Slave 7 Interface
input	[dw-1:0]	s7_data_i;
output	[dw-1:0]	s7_data_o;
output	[aw-1:0]	s7_addr_o;
output	[sw-1:0]	s7_sel_o;
output			s7_we_o;
output			s7_cyc_o;
output			s7_stb_o;
input			s7_ack_i;
input			s7_err_i;
input			s7_rty_i;

// Slave 8 Interface
input	[dw-1:0]	s8_data_i;
output	[dw-1:0]	s8_data_o;
output	[aw-1:0]	s8_addr_o;
output	[sw-1:0]	s8_sel_o;
output			s8_we_o;
output			s8_cyc_o;
output			s8_stb_o;
input			s8_ack_i;
input			s8_err_i;
input			s8_rty_i;

// Slave 9 Interface
input	[dw-1:0]	s9_data_i;
output	[dw-1:0]	s9_data_o;
output	[aw-1:0]	s9_addr_o;
output	[sw-1:0]	s9_sel_o;
output			s9_we_o;
output			s9_cyc_o;
output			s9_stb_o;
input			s9_ack_i;
input			s9_err_i;
input			s9_rty_i;

// Slave 10 Interface
input	[dw-1:0]	s10_data_i;
output	[dw-1:0]	s10_data_o;
output	[aw-1:0]	s10_addr_o;
output	[sw-1:0]	s10_sel_o;
output			s10_we_o;
output			s10_cyc_o;
output			s10_stb_o;
input			s10_ack_i;
input			s10_err_i;
input			s10_rty_i;

// Slave 11 Interface
input	[dw-1:0]	s11_data_i;
output	[dw-1:0]	s11_data_o;
output	[aw-1:0]	s11_addr_o;
output	[sw-1:0]	s11_sel_o;
output			s11_we_o;
output			s11_cyc_o;
output			s11_stb_o;
input			s11_ack_i;
input			s11_err_i;
input			s11_rty_i;

// Slave 12 Interface
input	[dw-1:0]	s12_data_i;
output	[dw-1:0]	s12_data_o;
output	[aw-1:0]	s12_addr_o;
output	[sw-1:0]	s12_sel_o;
output			s12_we_o;
output			s12_cyc_o;
output			s12_stb_o;
input			s12_ack_i;
input			s12_err_i;
input			s12_rty_i;

// Slave 13 Interface
input	[dw-1:0]	s13_data_i;
output	[dw-1:0]	s13_data_o;
output	[aw-1:0]	s13_addr_o;
output	[sw-1:0]	s13_sel_o;
output			s13_we_o;
output			s13_cyc_o;
output			s13_stb_o;
input			s13_ack_i;
input			s13_err_i;
input			s13_rty_i;

// Slave 14 Interface
input	[dw-1:0]	s14_data_i;
output	[dw-1:0]	s14_data_o;
output	[aw-1:0]	s14_addr_o;
output	[sw-1:0]	s14_sel_o;
output			s14_we_o;
output			s14_cyc_o;
output			s14_stb_o;
input			s14_ack_i;
input			s14_err_i;
input			s14_rty_i;

// Slave 15 Interface
input	[dw-1:0]	s15_data_i;
output	[dw-1:0]	s15_data_o;
output	[aw-1:0]	s15_addr_o;
output	[sw-1:0]	s15_sel_o;
output			s15_we_o;
output			s15_cyc_o;
output			s15_stb_o;
input			s15_ack_i;
input			s15_err_i;
input			s15_rty_i;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[dw-1:0]	wb_data_o;
reg			wb_ack_o;
reg			wb_err_o;
reg			wb_rty_o;
wire	[3:0]		slv_sel;

wire		s0_cyc_o_next, s1_cyc_o_next, s2_cyc_o_next, s3_cyc_o_next;
wire		s4_cyc_o_next, s5_cyc_o_next, s6_cyc_o_next, s7_cyc_o_next;
wire		s8_cyc_o_next, s9_cyc_o_next, s10_cyc_o_next, s11_cyc_o_next;
wire		s12_cyc_o_next, s13_cyc_o_next, s14_cyc_o_next, s15_cyc_o_next;

reg		s0_cyc_o, s1_cyc_o, s2_cyc_o, s3_cyc_o;
reg		s4_cyc_o, s5_cyc_o, s6_cyc_o, s7_cyc_o;
reg		s8_cyc_o, s9_cyc_o, s10_cyc_o, s11_cyc_o;
reg		s12_cyc_o, s13_cyc_o, s14_cyc_o, s15_cyc_o;

////////////////////////////////////////////////////////////////////
//
// Select logic
//

assign slv_sel = wb_addr_i[aw-1:aw-4];

////////////////////////////////////////////////////////////////////
//
// Address & Data Pass
//

assign s0_addr_o = wb_addr_i;
assign s1_addr_o = wb_addr_i;
assign s2_addr_o = wb_addr_i;
assign s3_addr_o = wb_addr_i;
assign s4_addr_o = wb_addr_i;
assign s5_addr_o = wb_addr_i;
assign s6_addr_o = wb_addr_i;
assign s7_addr_o = wb_addr_i;
assign s8_addr_o = wb_addr_i;
assign s9_addr_o = wb_addr_i;
assign s10_addr_o = wb_addr_i;
assign s11_addr_o = wb_addr_i;
assign s12_addr_o = wb_addr_i;
assign s13_addr_o = wb_addr_i;
assign s14_addr_o = wb_addr_i;
assign s15_addr_o = wb_addr_i;

assign s0_sel_o = wb_sel_i;
assign s1_sel_o = wb_sel_i;
assign s2_sel_o = wb_sel_i;
assign s3_sel_o = wb_sel_i;
assign s4_sel_o = wb_sel_i;
assign s5_sel_o = wb_sel_i;
assign s6_sel_o = wb_sel_i;
assign s7_sel_o = wb_sel_i;
assign s8_sel_o = wb_sel_i;
assign s9_sel_o = wb_sel_i;
assign s10_sel_o = wb_sel_i;
assign s11_sel_o = wb_sel_i;
assign s12_sel_o = wb_sel_i;
assign s13_sel_o = wb_sel_i;
assign s14_sel_o = wb_sel_i;
assign s15_sel_o = wb_sel_i;

assign s0_data_o = wb_data_i;
assign s1_data_o = wb_data_i;
assign s2_data_o = wb_data_i;
assign s3_data_o = wb_data_i;
assign s4_data_o = wb_data_i;
assign s5_data_o = wb_data_i;
assign s6_data_o = wb_data_i;
assign s7_data_o = wb_data_i;
assign s8_data_o = wb_data_i;
assign s9_data_o = wb_data_i;
assign s10_data_o = wb_data_i;
assign s11_data_o = wb_data_i;
assign s12_data_o = wb_data_i;
assign s13_data_o = wb_data_i;
assign s14_data_o = wb_data_i;
assign s15_data_o = wb_data_i;

always @(slv_sel or s0_data_i or s1_data_i or s2_data_i or s3_data_i or
	s4_data_i or s5_data_i or s6_data_i or s7_data_i or s8_data_i or
	s9_data_i or s10_data_i or s11_data_i or s12_data_i or
	s13_data_i or s14_data_i or s15_data_i)
	case(slv_sel)	// synopsys parallel_case
	   4'd0:	wb_data_o = s0_data_i;
	   4'd1:	wb_data_o = s1_data_i;
	   4'd2:	wb_data_o = s2_data_i;
	   4'd3:	wb_data_o = s3_data_i;
	   4'd4:	wb_data_o = s4_data_i;
	   4'd5:	wb_data_o = s5_data_i;
	   4'd6:	wb_data_o = s6_data_i;
	   4'd7:	wb_data_o = s7_data_i;
	   4'd8:	wb_data_o = s8_data_i;
	   4'd9:	wb_data_o = s9_data_i;
	   4'd10:	wb_data_o = s10_data_i;
	   4'd11:	wb_data_o = s11_data_i;
	   4'd12:	wb_data_o = s12_data_i;
	   4'd13:	wb_data_o = s13_data_i;
	   4'd14:	wb_data_o = s14_data_i;
	   4'd15:	wb_data_o = s15_data_i;
	   default:	wb_data_o = {dw{1'bx}};
	endcase

////////////////////////////////////////////////////////////////////
//
// Control Signal Pass
//

assign s0_we_o = wb_we_i;
assign s1_we_o = wb_we_i;
assign s2_we_o = wb_we_i;
assign s3_we_o = wb_we_i;
assign s4_we_o = wb_we_i;
assign s5_we_o = wb_we_i;
assign s6_we_o = wb_we_i;
assign s7_we_o = wb_we_i;
assign s8_we_o = wb_we_i;
assign s9_we_o = wb_we_i;
assign s10_we_o = wb_we_i;
assign s11_we_o = wb_we_i;
assign s12_we_o = wb_we_i;
assign s13_we_o = wb_we_i;
assign s14_we_o = wb_we_i;
assign s15_we_o = wb_we_i;

assign s0_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s0_cyc_o : ((slv_sel==4'd0) ? wb_cyc_i : 1'b0);
assign s1_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s1_cyc_o : ((slv_sel==4'd1) ? wb_cyc_i : 1'b0);
assign s2_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s2_cyc_o : ((slv_sel==4'd2) ? wb_cyc_i : 1'b0);
assign s3_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s3_cyc_o : ((slv_sel==4'd3) ? wb_cyc_i : 1'b0);
assign s4_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s4_cyc_o : ((slv_sel==4'd4) ? wb_cyc_i : 1'b0);
assign s5_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s5_cyc_o : ((slv_sel==4'd5) ? wb_cyc_i : 1'b0);
assign s6_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s6_cyc_o : ((slv_sel==4'd6) ? wb_cyc_i : 1'b0);
assign s7_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s7_cyc_o : ((slv_sel==4'd7) ? wb_cyc_i : 1'b0);
assign s8_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s8_cyc_o : ((slv_sel==4'd8) ? wb_cyc_i : 1'b0);
assign s9_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s9_cyc_o : ((slv_sel==4'd9) ? wb_cyc_i : 1'b0);
assign s10_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s10_cyc_o : ((slv_sel==4'd10) ? wb_cyc_i : 1'b0);
assign s11_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s11_cyc_o : ((slv_sel==4'd11) ? wb_cyc_i : 1'b0);
assign s12_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s12_cyc_o : ((slv_sel==4'd12) ? wb_cyc_i : 1'b0);
assign s13_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s13_cyc_o : ((slv_sel==4'd13) ? wb_cyc_i : 1'b0);
assign s14_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s14_cyc_o : ((slv_sel==4'd14) ? wb_cyc_i : 1'b0);
assign s15_cyc_o_next = (wb_cyc_i & !wb_stb_i) ? s15_cyc_o : ((slv_sel==4'd15) ? wb_cyc_i : 1'b0);

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s0_cyc_o <= #1 1'b0; 
	else		s0_cyc_o <= #1 s0_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s1_cyc_o <= #1 1'b0; 
	else		s1_cyc_o <= #1 s1_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s2_cyc_o <= #1 1'b0; 
	else		s2_cyc_o <= #1 s2_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s3_cyc_o <= #1 1'b0; 
	else		s3_cyc_o <= #1 s3_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s4_cyc_o <= #1 1'b0; 
	else		s4_cyc_o <= #1 s4_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s5_cyc_o <= #1 1'b0; 
	else		s5_cyc_o <= #1 s5_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s6_cyc_o <= #1 1'b0; 
	else		s6_cyc_o <= #1 s6_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s7_cyc_o <= #1 1'b0; 
	else		s7_cyc_o <= #1 s7_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s8_cyc_o <= #1 1'b0; 
	else		s8_cyc_o <= #1 s8_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s9_cyc_o <= #1 1'b0; 
	else		s9_cyc_o <= #1 s9_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s10_cyc_o <= #1 1'b0; 
	else		s10_cyc_o <= #1 s10_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s11_cyc_o <= #1 1'b0; 
	else		s11_cyc_o <= #1 s11_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s12_cyc_o <= #1 1'b0; 
	else		s12_cyc_o <= #1 s12_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s13_cyc_o <= #1 1'b0; 
	else		s13_cyc_o <= #1 s13_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s14_cyc_o <= #1 1'b0; 
	else		s14_cyc_o <= #1 s14_cyc_o_next; 

always @(posedge clk_i or posedge rst_i) 
	if(rst_i)	s15_cyc_o <= #1 1'b0; 
	else		s15_cyc_o <= #1 s15_cyc_o_next; 

assign s0_stb_o = (slv_sel==4'd0) ? wb_stb_i : 1'b0;
assign s1_stb_o = (slv_sel==4'd1) ? wb_stb_i : 1'b0;
assign s2_stb_o = (slv_sel==4'd2) ? wb_stb_i : 1'b0;
assign s3_stb_o = (slv_sel==4'd3) ? wb_stb_i : 1'b0;
assign s4_stb_o = (slv_sel==4'd4) ? wb_stb_i : 1'b0;
assign s5_stb_o = (slv_sel==4'd5) ? wb_stb_i : 1'b0;
assign s6_stb_o = (slv_sel==4'd6) ? wb_stb_i : 1'b0;
assign s7_stb_o = (slv_sel==4'd7) ? wb_stb_i : 1'b0;
assign s8_stb_o = (slv_sel==4'd8) ? wb_stb_i : 1'b0;
assign s9_stb_o = (slv_sel==4'd9) ? wb_stb_i : 1'b0;
assign s10_stb_o = (slv_sel==4'd10) ? wb_stb_i : 1'b0;
assign s11_stb_o = (slv_sel==4'd11) ? wb_stb_i : 1'b0;
assign s12_stb_o = (slv_sel==4'd12) ? wb_stb_i : 1'b0;
assign s13_stb_o = (slv_sel==4'd13) ? wb_stb_i : 1'b0;
assign s14_stb_o = (slv_sel==4'd14) ? wb_stb_i : 1'b0;
assign s15_stb_o = (slv_sel==4'd15) ? wb_stb_i : 1'b0;

always @(slv_sel or s0_ack_i or s1_ack_i or s2_ack_i or s3_ack_i or
	s4_ack_i or s5_ack_i or s6_ack_i or s7_ack_i or s8_ack_i or
	s9_ack_i or s10_ack_i or s11_ack_i or s12_ack_i or
	s13_ack_i or s14_ack_i or s15_ack_i)
	case(slv_sel)	// synopsys parallel_case
	   4'd0:	wb_ack_o = s0_ack_i;
	   4'd1:	wb_ack_o = s1_ack_i;
	   4'd2:	wb_ack_o = s2_ack_i;
	   4'd3:	wb_ack_o = s3_ack_i;
	   4'd4:	wb_ack_o = s4_ack_i;
	   4'd5:	wb_ack_o = s5_ack_i;
	   4'd6:	wb_ack_o = s6_ack_i;
	   4'd7:	wb_ack_o = s7_ack_i;
	   4'd8:	wb_ack_o = s8_ack_i;
	   4'd9:	wb_ack_o = s9_ack_i;
	   4'd10:	wb_ack_o = s10_ack_i;
	   4'd11:	wb_ack_o = s11_ack_i;
	   4'd12:	wb_ack_o = s12_ack_i;
	   4'd13:	wb_ack_o = s13_ack_i;
	   4'd14:	wb_ack_o = s14_ack_i;
	   4'd15:	wb_ack_o = s15_ack_i;
	   default:	wb_ack_o = 1'b0;
	endcase

always @(slv_sel or s0_err_i or s1_err_i or s2_err_i or s3_err_i or
	s4_err_i or s5_err_i or s6_err_i or s7_err_i or s8_err_i or
	s9_err_i or s10_err_i or s11_err_i or s12_err_i or
	s13_err_i or s14_err_i or s15_err_i)
	case(slv_sel)	// synopsys parallel_case
	   4'd0:	wb_err_o = s0_err_i;
	   4'd1:	wb_err_o = s1_err_i;
	   4'd2:	wb_err_o = s2_err_i;
	   4'd3:	wb_err_o = s3_err_i;
	   4'd4:	wb_err_o = s4_err_i;
	   4'd5:	wb_err_o = s5_err_i;
	   4'd6:	wb_err_o = s6_err_i;
	   4'd7:	wb_err_o = s7_err_i;
	   4'd8:	wb_err_o = s8_err_i;
	   4'd9:	wb_err_o = s9_err_i;
	   4'd10:	wb_err_o = s10_err_i;
	   4'd11:	wb_err_o = s11_err_i;
	   4'd12:	wb_err_o = s12_err_i;
	   4'd13:	wb_err_o = s13_err_i;
	   4'd14:	wb_err_o = s14_err_i;
	   4'd15:	wb_err_o = s15_err_i;
	   default:	wb_err_o = 1'b0;
	endcase

always @(slv_sel or s0_rty_i or s1_rty_i or s2_rty_i or s3_rty_i or
	s4_rty_i or s5_rty_i or s6_rty_i or s7_rty_i or s8_rty_i or
	s9_rty_i or s10_rty_i or s11_rty_i or s12_rty_i or
	s13_rty_i or s14_rty_i or s15_rty_i)
	case(slv_sel)	// synopsys parallel_case
	   4'd0:	wb_rty_o = s0_rty_i;
	   4'd1:	wb_rty_o = s1_rty_i;
	   4'd2:	wb_rty_o = s2_rty_i;
	   4'd3:	wb_rty_o = s3_rty_i;
	   4'd4:	wb_rty_o = s4_rty_i;
	   4'd5:	wb_rty_o = s5_rty_i;
	   4'd6:	wb_rty_o = s6_rty_i;
	   4'd7:	wb_rty_o = s7_rty_i;
	   4'd8:	wb_rty_o = s8_rty_i;
	   4'd9:	wb_rty_o = s9_rty_i;
	   4'd10:	wb_rty_o = s10_rty_i;
	   4'd11:	wb_rty_o = s11_rty_i;
	   4'd12:	wb_rty_o = s12_rty_i;
	   4'd13:	wb_rty_o = s13_rty_i;
	   4'd14:	wb_rty_o = s14_rty_i;
	   4'd15:	wb_rty_o = s15_rty_i;
	   default:	wb_rty_o = 1'b0;
	endcase

endmodule


