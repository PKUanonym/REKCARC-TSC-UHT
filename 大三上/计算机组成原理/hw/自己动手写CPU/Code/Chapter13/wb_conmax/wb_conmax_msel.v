/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Master Select                   ////
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
//  $Id: wb_conmax_msel.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
//
//  $Date: 2002-10-03 05:40:07 $
//  $Revision: 1.2 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/10/19 11:01:38  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//

`include "wb_conmax_defines.v"

module wb_conmax_msel(
		clk_i, rst_i,
		conf, req, sel, next
	);

////////////////////////////////////////////////////////////////////
//
// Module Parameters
//

parameter	[1:0]	pri_sel = 2'd0;

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input		clk_i, rst_i;
input	[15:0]	conf;
input	[7:0]	req;
output	[2:0]	sel;
input		next;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[1:0]	pri0, pri1, pri2, pri3;
wire	[1:0]	pri4, pri5, pri6, pri7;
wire	[1:0]	pri_out_d;
reg	[1:0]	pri_out;

wire	[7:0]	req_p0, req_p1, req_p2, req_p3;
wire	[2:0]	gnt_p0, gnt_p1, gnt_p2, gnt_p3;

reg	[2:0]	sel1, sel2;
wire	[2:0]	sel;

////////////////////////////////////////////////////////////////////
//
// Priority Select logic
//

assign pri0[0] = (pri_sel == 2'd0) ? 1'b0 : conf[0];
assign pri0[1] = (pri_sel == 2'd2) ? conf[1] : 1'b0;

assign pri1[0] = (pri_sel == 2'd0) ? 1'b0 : conf[2];
assign pri1[1] = (pri_sel == 2'd2) ? conf[3] : 1'b0;

assign pri2[0] = (pri_sel == 2'd0) ? 1'b0 : conf[4];
assign pri2[1] = (pri_sel == 2'd2) ? conf[5] : 1'b0;

assign pri3[0] = (pri_sel == 2'd0) ? 1'b0 : conf[6];
assign pri3[1] = (pri_sel == 2'd2) ? conf[7] : 1'b0;

assign pri4[0] = (pri_sel == 2'd0) ? 1'b0 : conf[8];
assign pri4[1] = (pri_sel == 2'd2) ? conf[9] : 1'b0;

assign pri5[0] = (pri_sel == 2'd0) ? 1'b0 : conf[10];
assign pri5[1] = (pri_sel == 2'd2) ? conf[11] : 1'b0;

assign pri6[0] = (pri_sel == 2'd0) ? 1'b0 : conf[12];
assign pri6[1] = (pri_sel == 2'd2) ? conf[13] : 1'b0;

assign pri7[0] = (pri_sel == 2'd0) ? 1'b0 : conf[14];
assign pri7[1] = (pri_sel == 2'd2) ? conf[15] : 1'b0;

// Priority Encoder
wb_conmax_pri_enc #(pri_sel) pri_enc(
	.valid(		req		),
	.pri0(		pri0		),
	.pri1(		pri1		),
	.pri2(		pri2		),
	.pri3(		pri3		),
	.pri4(		pri4		),
	.pri5(		pri5		),
	.pri6(		pri6		),
	.pri7(		pri7		),
	.pri_out(	pri_out_d	)
	);

always @(posedge clk_i)
	if(rst_i)	pri_out <= #1 2'h0;
	else
	if(next)	pri_out <= #1 pri_out_d;

////////////////////////////////////////////////////////////////////
//
// Arbiters
//

assign req_p0[0] = req[0] & (pri0 == 2'd0);
assign req_p0[1] = req[1] & (pri1 == 2'd0);
assign req_p0[2] = req[2] & (pri2 == 2'd0);
assign req_p0[3] = req[3] & (pri3 == 2'd0);
assign req_p0[4] = req[4] & (pri4 == 2'd0);
assign req_p0[5] = req[5] & (pri5 == 2'd0);
assign req_p0[6] = req[6] & (pri6 == 2'd0);
assign req_p0[7] = req[7] & (pri7 == 2'd0);

assign req_p1[0] = req[0] & (pri0 == 2'd1);
assign req_p1[1] = req[1] & (pri1 == 2'd1);
assign req_p1[2] = req[2] & (pri2 == 2'd1);
assign req_p1[3] = req[3] & (pri3 == 2'd1);
assign req_p1[4] = req[4] & (pri4 == 2'd1);
assign req_p1[5] = req[5] & (pri5 == 2'd1);
assign req_p1[6] = req[6] & (pri6 == 2'd1);
assign req_p1[7] = req[7] & (pri7 == 2'd1);

assign req_p2[0] = req[0] & (pri0 == 2'd2);
assign req_p2[1] = req[1] & (pri1 == 2'd2);
assign req_p2[2] = req[2] & (pri2 == 2'd2);
assign req_p2[3] = req[3] & (pri3 == 2'd2);
assign req_p2[4] = req[4] & (pri4 == 2'd2);
assign req_p2[5] = req[5] & (pri5 == 2'd2);
assign req_p2[6] = req[6] & (pri6 == 2'd2);
assign req_p2[7] = req[7] & (pri7 == 2'd2);

assign req_p3[0] = req[0] & (pri0 == 2'd3);
assign req_p3[1] = req[1] & (pri1 == 2'd3);
assign req_p3[2] = req[2] & (pri2 == 2'd3);
assign req_p3[3] = req[3] & (pri3 == 2'd3);
assign req_p3[4] = req[4] & (pri4 == 2'd3);
assign req_p3[5] = req[5] & (pri5 == 2'd3);
assign req_p3[6] = req[6] & (pri6 == 2'd3);
assign req_p3[7] = req[7] & (pri7 == 2'd3);

wb_conmax_arb arb0(
	.clk(		clk_i		),
	.rst(		rst_i		),
	.req(		req_p0		),
	.gnt(		gnt_p0		),
	.next(		1'b0		)
	);

wb_conmax_arb arb1(
	.clk(		clk_i		),
	.rst(		rst_i		),
	.req(		req_p1		),
	.gnt(		gnt_p1		),
	.next(		1'b0		)
	);

wb_conmax_arb arb2(
	.clk(		clk_i		),
	.rst(		rst_i		),
	.req(		req_p2		),
	.gnt(		gnt_p2		),
	.next(		1'b0		)
	);

wb_conmax_arb arb3(
	.clk(		clk_i		),
	.rst(		rst_i		),
	.req(		req_p3		),
	.gnt(		gnt_p3		),
	.next(		1'b0		)
	);

////////////////////////////////////////////////////////////////////
//
// Final Master Select
//

always @(pri_out or gnt_p0 or gnt_p1)
	if(pri_out[0])	sel1 = gnt_p1;
	else		sel1 = gnt_p0;


always @(pri_out or gnt_p0 or gnt_p1 or gnt_p2 or gnt_p3)
	case(pri_out)
	   2'd0: sel2 = gnt_p0;
	   2'd1: sel2 = gnt_p1;
	   2'd2: sel2 = gnt_p2;
	   2'd3: sel2 = gnt_p3;
	endcase


assign sel = (pri_sel==2'd0) ? gnt_p0 : ( (pri_sel==2'd1) ? sel1 : sel2 );

endmodule

