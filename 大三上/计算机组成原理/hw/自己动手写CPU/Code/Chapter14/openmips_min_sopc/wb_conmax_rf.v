/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Register File                   ////
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
//  $Id: wb_conmax_rf.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
//
//  $Date: 2002-10-03 05:40:07 $
//  $Revision: 1.2 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/10/19 11:01:42  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "wb_conmax_defines.v"

module wb_conmax_rf(
		clk_i, rst_i,

		// Internal Wishbone Interface
		i_wb_data_i, i_wb_data_o, i_wb_addr_i, i_wb_sel_i, i_wb_we_i, i_wb_cyc_i,
		i_wb_stb_i, i_wb_ack_o, i_wb_err_o, i_wb_rty_o,

		// External Wishbone Interface
		e_wb_data_i, e_wb_data_o, e_wb_addr_o, e_wb_sel_o, e_wb_we_o, e_wb_cyc_o,
		e_wb_stb_o, e_wb_ack_i, e_wb_err_i, e_wb_rty_i,

		// Configuration Registers
		conf0, conf1, conf2, conf3, conf4, conf5, conf6, conf7,
		conf8, conf9, conf10, conf11, conf12, conf13, conf14, conf15

		);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter	[3:0]	rf_addr	= 4'hf;
parameter		dw	= 32;		// Data bus Width
parameter		aw	= 32;		// Address bus Width
parameter		sw	= dw / 8;	// Number of Select Lines

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input		clk_i, rst_i;

// Internal Wishbone Interface
input	[dw-1:0]	i_wb_data_i;
output	[dw-1:0]	i_wb_data_o;
input	[aw-1:0]	i_wb_addr_i;
input	[sw-1:0]	i_wb_sel_i;
input			i_wb_we_i;
input			i_wb_cyc_i;
input			i_wb_stb_i;
output			i_wb_ack_o;
output			i_wb_err_o;
output			i_wb_rty_o;

// External Wishbone Interface
input	[dw-1:0]	e_wb_data_i;
output	[dw-1:0]	e_wb_data_o;
output	[aw-1:0]	e_wb_addr_o;
output	[sw-1:0]	e_wb_sel_o;
output			e_wb_we_o;
output			e_wb_cyc_o;
output			e_wb_stb_o;
input			e_wb_ack_i;
input			e_wb_err_i;
input			e_wb_rty_i;

// Configuration Registers
output	[15:0]		conf0;
output	[15:0]		conf1;
output	[15:0]		conf2;
output	[15:0]		conf3;
output	[15:0]		conf4;
output	[15:0]		conf5;
output	[15:0]		conf6;
output	[15:0]		conf7;
output	[15:0]		conf8;
output	[15:0]		conf9;
output	[15:0]		conf10;
output	[15:0]		conf11;
output	[15:0]		conf12;
output	[15:0]		conf13;
output	[15:0]		conf14;
output	[15:0]		conf15;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[15:0]	conf0, conf1, conf2, conf3, conf4, conf5;
reg	[15:0]	conf6, conf7, conf8, conf9, conf10, conf11;
reg	[15:0]	conf12, conf13, conf14, conf15;

//synopsys infer_multibit "conf0"
//synopsys infer_multibit "conf1"
//synopsys infer_multibit "conf2"
//synopsys infer_multibit "conf3"
//synopsys infer_multibit "conf4"
//synopsys infer_multibit "conf5"
//synopsys infer_multibit "conf6"
//synopsys infer_multibit "conf7"
//synopsys infer_multibit "conf8"
//synopsys infer_multibit "conf9"
//synopsys infer_multibit "conf10"
//synopsys infer_multibit "conf11"
//synopsys infer_multibit "conf12"
//synopsys infer_multibit "conf13"
//synopsys infer_multibit "conf14"
//synopsys infer_multibit "conf15"

wire		rf_sel;
reg	[15:0]	rf_dout;
reg		rf_ack;
reg		rf_we;

////////////////////////////////////////////////////////////////////
//
// Register File Select Logic
//

assign rf_sel = i_wb_cyc_i & i_wb_stb_i & (i_wb_addr_i[aw-5:aw-8] == rf_addr);

////////////////////////////////////////////////////////////////////
//
// Register File Logic
//

always @(posedge clk_i)
	rf_we <= #1 rf_sel & i_wb_we_i & !rf_we;

always @(posedge clk_i)
	rf_ack <= #1 rf_sel & !rf_ack;

// Writre Logic
always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf0 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd0) )		conf0 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf1 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd1) )		conf1 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf2 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd2) )		conf2 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf3 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd3) )		conf3 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf4 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd4) )		conf4 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf5 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd5) )		conf5 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf6 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd6) )		conf6 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf7 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd7) )		conf7 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf8 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd8) )		conf8 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf9 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd9) )		conf9 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf10 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd10) )	conf10 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf11 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd11) )	conf11 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf12 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd12) )	conf12 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf13 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd13) )	conf13 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf14 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd14) )	conf14 <= #1 i_wb_data_i[15:0];

always @(posedge clk_i or posedge rst_i)
	if(rst_i)					conf15 <= #1 16'h0;
	else
	if(rf_we & (i_wb_addr_i[5:2] == 4'd15) )	conf15 <= #1 i_wb_data_i[15:0];

// Read Logic
always @(posedge clk_i)
	if(!rf_sel)	rf_dout <= #1 16'h0;
	else
	case(i_wb_addr_i[5:2])
	   4'd0:	rf_dout <= #1 conf0;
	   4'd1:	rf_dout <= #1 conf1;
	   4'd2:	rf_dout <= #1 conf2;
	   4'd3:	rf_dout <= #1 conf3;
	   4'd4:	rf_dout <= #1 conf4;
	   4'd5:	rf_dout <= #1 conf5;
	   4'd6:	rf_dout <= #1 conf6;
	   4'd7:	rf_dout <= #1 conf7;
	   4'd8:	rf_dout <= #1 conf8;
	   4'd9:	rf_dout <= #1 conf9;
	   4'd10:	rf_dout <= #1 conf10;
	   4'd11:	rf_dout <= #1 conf11;
	   4'd12:	rf_dout <= #1 conf12;
	   4'd13:	rf_dout <= #1 conf13;
	   4'd14:	rf_dout <= #1 conf14;
	   4'd15:	rf_dout <= #1 conf15;
	endcase

////////////////////////////////////////////////////////////////////
//
// Register File By-Pass Logic
//

assign e_wb_addr_o = i_wb_addr_i;
assign e_wb_sel_o  = i_wb_sel_i;
assign e_wb_data_o = i_wb_data_i;

assign e_wb_cyc_o  = rf_sel ? 1'b0 : i_wb_cyc_i;
assign e_wb_stb_o  = i_wb_stb_i;
assign e_wb_we_o   = i_wb_we_i;

assign i_wb_data_o = rf_sel ? { {aw-16{1'b0}}, rf_dout} : e_wb_data_i;
assign i_wb_ack_o  = rf_sel ? rf_ack  : e_wb_ack_i;
assign i_wb_err_o  = rf_sel ? 1'b0    : e_wb_err_i;
assign i_wb_rty_o  = rf_sel ? 1'b0    : e_wb_rty_i;

endmodule
