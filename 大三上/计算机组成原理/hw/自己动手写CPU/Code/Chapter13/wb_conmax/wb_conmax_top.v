/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE Connection Matrix Top Level                       ////
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
//  $Id: wb_conmax_top.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
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

module wb_conmax_top(
	clk_i, rst_i,

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
	m7_stb_i, m7_ack_o, m7_err_o, m7_rty_o,

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

parameter		dw	 = 32;		// Data bus Width
parameter		aw	 = 32;		// Address bus Width
parameter	[3:0]	rf_addr  = 4'hf;
parameter	[1:0]	pri_sel0 = 2'd2;
parameter	[1:0]	pri_sel1 = 2'd2;
parameter	[1:0]	pri_sel2 = 2'd2;
parameter	[1:0]	pri_sel3 = 2'd2;
parameter	[1:0]	pri_sel4 = 2'd2;
parameter	[1:0]	pri_sel5 = 2'd2;
parameter	[1:0]	pri_sel6 = 2'd2;
parameter	[1:0]	pri_sel7 = 2'd2;
parameter	[1:0]	pri_sel8 = 2'd2;
parameter	[1:0]	pri_sel9 = 2'd2;
parameter	[1:0]	pri_sel10 = 2'd2;
parameter	[1:0]	pri_sel11 = 2'd2;
parameter	[1:0]	pri_sel12 = 2'd2;
parameter	[1:0]	pri_sel13 = 2'd2;
parameter	[1:0]	pri_sel14 = 2'd2;
parameter	[1:0]	pri_sel15 = 2'd2;

parameter		sw = dw / 8;	// Number of Select Lines

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input		clk_i, rst_i;

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
// Local wires
//

wire	[dw-1:0]	i_s15_data_i;
wire	[dw-1:0]	i_s15_data_o;
wire	[aw-1:0]	i_s15_addr_o;
wire	[sw-1:0]	i_s15_sel_o;
wire			i_s15_we_o;
wire			i_s15_cyc_o;
wire			i_s15_stb_o;
wire			i_s15_ack_i;
wire			i_s15_err_i;
wire			i_s15_rty_i;

wire	[dw-1:0]	m0s0_data_i;
wire	[dw-1:0]	m0s0_data_o;
wire	[aw-1:0]	m0s0_addr;
wire	[sw-1:0]	m0s0_sel;
wire			m0s0_we;
wire			m0s0_cyc;
wire			m0s0_stb;
wire			m0s0_ack;
wire			m0s0_err;
wire			m0s0_rty;
wire	[dw-1:0]	m0s1_data_i;
wire	[dw-1:0]	m0s1_data_o;
wire	[aw-1:0]	m0s1_addr;
wire	[sw-1:0]	m0s1_sel;
wire			m0s1_we;
wire			m0s1_cyc;
wire			m0s1_stb;
wire			m0s1_ack;
wire			m0s1_err;
wire			m0s1_rty;
wire	[dw-1:0]	m0s2_data_i;
wire	[dw-1:0]	m0s2_data_o;
wire	[aw-1:0]	m0s2_addr;
wire	[sw-1:0]	m0s2_sel;
wire			m0s2_we;
wire			m0s2_cyc;
wire			m0s2_stb;
wire			m0s2_ack;
wire			m0s2_err;
wire			m0s2_rty;
wire	[dw-1:0]	m0s3_data_i;
wire	[dw-1:0]	m0s3_data_o;
wire	[aw-1:0]	m0s3_addr;
wire	[sw-1:0]	m0s3_sel;
wire			m0s3_we;
wire			m0s3_cyc;
wire			m0s3_stb;
wire			m0s3_ack;
wire			m0s3_err;
wire			m0s3_rty;
wire	[dw-1:0]	m0s4_data_i;
wire	[dw-1:0]	m0s4_data_o;
wire	[aw-1:0]	m0s4_addr;
wire	[sw-1:0]	m0s4_sel;
wire			m0s4_we;
wire			m0s4_cyc;
wire			m0s4_stb;
wire			m0s4_ack;
wire			m0s4_err;
wire			m0s4_rty;
wire	[dw-1:0]	m0s5_data_i;
wire	[dw-1:0]	m0s5_data_o;
wire	[aw-1:0]	m0s5_addr;
wire	[sw-1:0]	m0s5_sel;
wire			m0s5_we;
wire			m0s5_cyc;
wire			m0s5_stb;
wire			m0s5_ack;
wire			m0s5_err;
wire			m0s5_rty;
wire	[dw-1:0]	m0s6_data_i;
wire	[dw-1:0]	m0s6_data_o;
wire	[aw-1:0]	m0s6_addr;
wire	[sw-1:0]	m0s6_sel;
wire			m0s6_we;
wire			m0s6_cyc;
wire			m0s6_stb;
wire			m0s6_ack;
wire			m0s6_err;
wire			m0s6_rty;
wire	[dw-1:0]	m0s7_data_i;
wire	[dw-1:0]	m0s7_data_o;
wire	[aw-1:0]	m0s7_addr;
wire	[sw-1:0]	m0s7_sel;
wire			m0s7_we;
wire			m0s7_cyc;
wire			m0s7_stb;
wire			m0s7_ack;
wire			m0s7_err;
wire			m0s7_rty;
wire	[dw-1:0]	m0s8_data_i;
wire	[dw-1:0]	m0s8_data_o;
wire	[aw-1:0]	m0s8_addr;
wire	[sw-1:0]	m0s8_sel;
wire			m0s8_we;
wire			m0s8_cyc;
wire			m0s8_stb;
wire			m0s8_ack;
wire			m0s8_err;
wire			m0s8_rty;
wire	[dw-1:0]	m0s9_data_i;
wire	[dw-1:0]	m0s9_data_o;
wire	[aw-1:0]	m0s9_addr;
wire	[sw-1:0]	m0s9_sel;
wire			m0s9_we;
wire			m0s9_cyc;
wire			m0s9_stb;
wire			m0s9_ack;
wire			m0s9_err;
wire			m0s9_rty;
wire	[dw-1:0]	m0s10_data_i;
wire	[dw-1:0]	m0s10_data_o;
wire	[aw-1:0]	m0s10_addr;
wire	[sw-1:0]	m0s10_sel;
wire			m0s10_we;
wire			m0s10_cyc;
wire			m0s10_stb;
wire			m0s10_ack;
wire			m0s10_err;
wire			m0s10_rty;
wire	[dw-1:0]	m0s11_data_i;
wire	[dw-1:0]	m0s11_data_o;
wire	[aw-1:0]	m0s11_addr;
wire	[sw-1:0]	m0s11_sel;
wire			m0s11_we;
wire			m0s11_cyc;
wire			m0s11_stb;
wire			m0s11_ack;
wire			m0s11_err;
wire			m0s11_rty;
wire	[dw-1:0]	m0s12_data_i;
wire	[dw-1:0]	m0s12_data_o;
wire	[aw-1:0]	m0s12_addr;
wire	[sw-1:0]	m0s12_sel;
wire			m0s12_we;
wire			m0s12_cyc;
wire			m0s12_stb;
wire			m0s12_ack;
wire			m0s12_err;
wire			m0s12_rty;
wire	[dw-1:0]	m0s13_data_i;
wire	[dw-1:0]	m0s13_data_o;
wire	[aw-1:0]	m0s13_addr;
wire	[sw-1:0]	m0s13_sel;
wire			m0s13_we;
wire			m0s13_cyc;
wire			m0s13_stb;
wire			m0s13_ack;
wire			m0s13_err;
wire			m0s13_rty;
wire	[dw-1:0]	m0s14_data_i;
wire	[dw-1:0]	m0s14_data_o;
wire	[aw-1:0]	m0s14_addr;
wire	[sw-1:0]	m0s14_sel;
wire			m0s14_we;
wire			m0s14_cyc;
wire			m0s14_stb;
wire			m0s14_ack;
wire			m0s14_err;
wire			m0s14_rty;
wire	[dw-1:0]	m0s15_data_i;
wire	[dw-1:0]	m0s15_data_o;
wire	[aw-1:0]	m0s15_addr;
wire	[sw-1:0]	m0s15_sel;
wire			m0s15_we;
wire			m0s15_cyc;
wire			m0s15_stb;
wire			m0s15_ack;
wire			m0s15_err;
wire			m0s15_rty;
wire	[dw-1:0]	m1s0_data_i;
wire	[dw-1:0]	m1s0_data_o;
wire	[aw-1:0]	m1s0_addr;
wire	[sw-1:0]	m1s0_sel;
wire			m1s0_we;
wire			m1s0_cyc;
wire			m1s0_stb;
wire			m1s0_ack;
wire			m1s0_err;
wire			m1s0_rty;
wire	[dw-1:0]	m1s1_data_i;
wire	[dw-1:0]	m1s1_data_o;
wire	[aw-1:0]	m1s1_addr;
wire	[sw-1:0]	m1s1_sel;
wire			m1s1_we;
wire			m1s1_cyc;
wire			m1s1_stb;
wire			m1s1_ack;
wire			m1s1_err;
wire			m1s1_rty;
wire	[dw-1:0]	m1s2_data_i;
wire	[dw-1:0]	m1s2_data_o;
wire	[aw-1:0]	m1s2_addr;
wire	[sw-1:0]	m1s2_sel;
wire			m1s2_we;
wire			m1s2_cyc;
wire			m1s2_stb;
wire			m1s2_ack;
wire			m1s2_err;
wire			m1s2_rty;
wire	[dw-1:0]	m1s3_data_i;
wire	[dw-1:0]	m1s3_data_o;
wire	[aw-1:0]	m1s3_addr;
wire	[sw-1:0]	m1s3_sel;
wire			m1s3_we;
wire			m1s3_cyc;
wire			m1s3_stb;
wire			m1s3_ack;
wire			m1s3_err;
wire			m1s3_rty;
wire	[dw-1:0]	m1s4_data_i;
wire	[dw-1:0]	m1s4_data_o;
wire	[aw-1:0]	m1s4_addr;
wire	[sw-1:0]	m1s4_sel;
wire			m1s4_we;
wire			m1s4_cyc;
wire			m1s4_stb;
wire			m1s4_ack;
wire			m1s4_err;
wire			m1s4_rty;
wire	[dw-1:0]	m1s5_data_i;
wire	[dw-1:0]	m1s5_data_o;
wire	[aw-1:0]	m1s5_addr;
wire	[sw-1:0]	m1s5_sel;
wire			m1s5_we;
wire			m1s5_cyc;
wire			m1s5_stb;
wire			m1s5_ack;
wire			m1s5_err;
wire			m1s5_rty;
wire	[dw-1:0]	m1s6_data_i;
wire	[dw-1:0]	m1s6_data_o;
wire	[aw-1:0]	m1s6_addr;
wire	[sw-1:0]	m1s6_sel;
wire			m1s6_we;
wire			m1s6_cyc;
wire			m1s6_stb;
wire			m1s6_ack;
wire			m1s6_err;
wire			m1s6_rty;
wire	[dw-1:0]	m1s7_data_i;
wire	[dw-1:0]	m1s7_data_o;
wire	[aw-1:0]	m1s7_addr;
wire	[sw-1:0]	m1s7_sel;
wire			m1s7_we;
wire			m1s7_cyc;
wire			m1s7_stb;
wire			m1s7_ack;
wire			m1s7_err;
wire			m1s7_rty;
wire	[dw-1:0]	m1s8_data_i;
wire	[dw-1:0]	m1s8_data_o;
wire	[aw-1:0]	m1s8_addr;
wire	[sw-1:0]	m1s8_sel;
wire			m1s8_we;
wire			m1s8_cyc;
wire			m1s8_stb;
wire			m1s8_ack;
wire			m1s8_err;
wire			m1s8_rty;
wire	[dw-1:0]	m1s9_data_i;
wire	[dw-1:0]	m1s9_data_o;
wire	[aw-1:0]	m1s9_addr;
wire	[sw-1:0]	m1s9_sel;
wire			m1s9_we;
wire			m1s9_cyc;
wire			m1s9_stb;
wire			m1s9_ack;
wire			m1s9_err;
wire			m1s9_rty;
wire	[dw-1:0]	m1s10_data_i;
wire	[dw-1:0]	m1s10_data_o;
wire	[aw-1:0]	m1s10_addr;
wire	[sw-1:0]	m1s10_sel;
wire			m1s10_we;
wire			m1s10_cyc;
wire			m1s10_stb;
wire			m1s10_ack;
wire			m1s10_err;
wire			m1s10_rty;
wire	[dw-1:0]	m1s11_data_i;
wire	[dw-1:0]	m1s11_data_o;
wire	[aw-1:0]	m1s11_addr;
wire	[sw-1:0]	m1s11_sel;
wire			m1s11_we;
wire			m1s11_cyc;
wire			m1s11_stb;
wire			m1s11_ack;
wire			m1s11_err;
wire			m1s11_rty;
wire	[dw-1:0]	m1s12_data_i;
wire	[dw-1:0]	m1s12_data_o;
wire	[aw-1:0]	m1s12_addr;
wire	[sw-1:0]	m1s12_sel;
wire			m1s12_we;
wire			m1s12_cyc;
wire			m1s12_stb;
wire			m1s12_ack;
wire			m1s12_err;
wire			m1s12_rty;
wire	[dw-1:0]	m1s13_data_i;
wire	[dw-1:0]	m1s13_data_o;
wire	[aw-1:0]	m1s13_addr;
wire	[sw-1:0]	m1s13_sel;
wire			m1s13_we;
wire			m1s13_cyc;
wire			m1s13_stb;
wire			m1s13_ack;
wire			m1s13_err;
wire			m1s13_rty;
wire	[dw-1:0]	m1s14_data_i;
wire	[dw-1:0]	m1s14_data_o;
wire	[aw-1:0]	m1s14_addr;
wire	[sw-1:0]	m1s14_sel;
wire			m1s14_we;
wire			m1s14_cyc;
wire			m1s14_stb;
wire			m1s14_ack;
wire			m1s14_err;
wire			m1s14_rty;
wire	[dw-1:0]	m1s15_data_i;
wire	[dw-1:0]	m1s15_data_o;
wire	[aw-1:0]	m1s15_addr;
wire	[sw-1:0]	m1s15_sel;
wire			m1s15_we;
wire			m1s15_cyc;
wire			m1s15_stb;
wire			m1s15_ack;
wire			m1s15_err;
wire			m1s15_rty;
wire	[dw-1:0]	m2s0_data_i;
wire	[dw-1:0]	m2s0_data_o;
wire	[aw-1:0]	m2s0_addr;
wire	[sw-1:0]	m2s0_sel;
wire			m2s0_we;
wire			m2s0_cyc;
wire			m2s0_stb;
wire			m2s0_ack;
wire			m2s0_err;
wire			m2s0_rty;
wire	[dw-1:0]	m2s1_data_i;
wire	[dw-1:0]	m2s1_data_o;
wire	[aw-1:0]	m2s1_addr;
wire	[sw-1:0]	m2s1_sel;
wire			m2s1_we;
wire			m2s1_cyc;
wire			m2s1_stb;
wire			m2s1_ack;
wire			m2s1_err;
wire			m2s1_rty;
wire	[dw-1:0]	m2s2_data_i;
wire	[dw-1:0]	m2s2_data_o;
wire	[aw-1:0]	m2s2_addr;
wire	[sw-1:0]	m2s2_sel;
wire			m2s2_we;
wire			m2s2_cyc;
wire			m2s2_stb;
wire			m2s2_ack;
wire			m2s2_err;
wire			m2s2_rty;
wire	[dw-1:0]	m2s3_data_i;
wire	[dw-1:0]	m2s3_data_o;
wire	[aw-1:0]	m2s3_addr;
wire	[sw-1:0]	m2s3_sel;
wire			m2s3_we;
wire			m2s3_cyc;
wire			m2s3_stb;
wire			m2s3_ack;
wire			m2s3_err;
wire			m2s3_rty;
wire	[dw-1:0]	m2s4_data_i;
wire	[dw-1:0]	m2s4_data_o;
wire	[aw-1:0]	m2s4_addr;
wire	[sw-1:0]	m2s4_sel;
wire			m2s4_we;
wire			m2s4_cyc;
wire			m2s4_stb;
wire			m2s4_ack;
wire			m2s4_err;
wire			m2s4_rty;
wire	[dw-1:0]	m2s5_data_i;
wire	[dw-1:0]	m2s5_data_o;
wire	[aw-1:0]	m2s5_addr;
wire	[sw-1:0]	m2s5_sel;
wire			m2s5_we;
wire			m2s5_cyc;
wire			m2s5_stb;
wire			m2s5_ack;
wire			m2s5_err;
wire			m2s5_rty;
wire	[dw-1:0]	m2s6_data_i;
wire	[dw-1:0]	m2s6_data_o;
wire	[aw-1:0]	m2s6_addr;
wire	[sw-1:0]	m2s6_sel;
wire			m2s6_we;
wire			m2s6_cyc;
wire			m2s6_stb;
wire			m2s6_ack;
wire			m2s6_err;
wire			m2s6_rty;
wire	[dw-1:0]	m2s7_data_i;
wire	[dw-1:0]	m2s7_data_o;
wire	[aw-1:0]	m2s7_addr;
wire	[sw-1:0]	m2s7_sel;
wire			m2s7_we;
wire			m2s7_cyc;
wire			m2s7_stb;
wire			m2s7_ack;
wire			m2s7_err;
wire			m2s7_rty;
wire	[dw-1:0]	m2s8_data_i;
wire	[dw-1:0]	m2s8_data_o;
wire	[aw-1:0]	m2s8_addr;
wire	[sw-1:0]	m2s8_sel;
wire			m2s8_we;
wire			m2s8_cyc;
wire			m2s8_stb;
wire			m2s8_ack;
wire			m2s8_err;
wire			m2s8_rty;
wire	[dw-1:0]	m2s9_data_i;
wire	[dw-1:0]	m2s9_data_o;
wire	[aw-1:0]	m2s9_addr;
wire	[sw-1:0]	m2s9_sel;
wire			m2s9_we;
wire			m2s9_cyc;
wire			m2s9_stb;
wire			m2s9_ack;
wire			m2s9_err;
wire			m2s9_rty;
wire	[dw-1:0]	m2s10_data_i;
wire	[dw-1:0]	m2s10_data_o;
wire	[aw-1:0]	m2s10_addr;
wire	[sw-1:0]	m2s10_sel;
wire			m2s10_we;
wire			m2s10_cyc;
wire			m2s10_stb;
wire			m2s10_ack;
wire			m2s10_err;
wire			m2s10_rty;
wire	[dw-1:0]	m2s11_data_i;
wire	[dw-1:0]	m2s11_data_o;
wire	[aw-1:0]	m2s11_addr;
wire	[sw-1:0]	m2s11_sel;
wire			m2s11_we;
wire			m2s11_cyc;
wire			m2s11_stb;
wire			m2s11_ack;
wire			m2s11_err;
wire			m2s11_rty;
wire	[dw-1:0]	m2s12_data_i;
wire	[dw-1:0]	m2s12_data_o;
wire	[aw-1:0]	m2s12_addr;
wire	[sw-1:0]	m2s12_sel;
wire			m2s12_we;
wire			m2s12_cyc;
wire			m2s12_stb;
wire			m2s12_ack;
wire			m2s12_err;
wire			m2s12_rty;
wire	[dw-1:0]	m2s13_data_i;
wire	[dw-1:0]	m2s13_data_o;
wire	[aw-1:0]	m2s13_addr;
wire	[sw-1:0]	m2s13_sel;
wire			m2s13_we;
wire			m2s13_cyc;
wire			m2s13_stb;
wire			m2s13_ack;
wire			m2s13_err;
wire			m2s13_rty;
wire	[dw-1:0]	m2s14_data_i;
wire	[dw-1:0]	m2s14_data_o;
wire	[aw-1:0]	m2s14_addr;
wire	[sw-1:0]	m2s14_sel;
wire			m2s14_we;
wire			m2s14_cyc;
wire			m2s14_stb;
wire			m2s14_ack;
wire			m2s14_err;
wire			m2s14_rty;
wire	[dw-1:0]	m2s15_data_i;
wire	[dw-1:0]	m2s15_data_o;
wire	[aw-1:0]	m2s15_addr;
wire	[sw-1:0]	m2s15_sel;
wire			m2s15_we;
wire			m2s15_cyc;
wire			m2s15_stb;
wire			m2s15_ack;
wire			m2s15_err;
wire			m2s15_rty;
wire	[dw-1:0]	m3s0_data_i;
wire	[dw-1:0]	m3s0_data_o;
wire	[aw-1:0]	m3s0_addr;
wire	[sw-1:0]	m3s0_sel;
wire			m3s0_we;
wire			m3s0_cyc;
wire			m3s0_stb;
wire			m3s0_ack;
wire			m3s0_err;
wire			m3s0_rty;
wire	[dw-1:0]	m3s1_data_i;
wire	[dw-1:0]	m3s1_data_o;
wire	[aw-1:0]	m3s1_addr;
wire	[sw-1:0]	m3s1_sel;
wire			m3s1_we;
wire			m3s1_cyc;
wire			m3s1_stb;
wire			m3s1_ack;
wire			m3s1_err;
wire			m3s1_rty;
wire	[dw-1:0]	m3s2_data_i;
wire	[dw-1:0]	m3s2_data_o;
wire	[aw-1:0]	m3s2_addr;
wire	[sw-1:0]	m3s2_sel;
wire			m3s2_we;
wire			m3s2_cyc;
wire			m3s2_stb;
wire			m3s2_ack;
wire			m3s2_err;
wire			m3s2_rty;
wire	[dw-1:0]	m3s3_data_i;
wire	[dw-1:0]	m3s3_data_o;
wire	[aw-1:0]	m3s3_addr;
wire	[sw-1:0]	m3s3_sel;
wire			m3s3_we;
wire			m3s3_cyc;
wire			m3s3_stb;
wire			m3s3_ack;
wire			m3s3_err;
wire			m3s3_rty;
wire	[dw-1:0]	m3s4_data_i;
wire	[dw-1:0]	m3s4_data_o;
wire	[aw-1:0]	m3s4_addr;
wire	[sw-1:0]	m3s4_sel;
wire			m3s4_we;
wire			m3s4_cyc;
wire			m3s4_stb;
wire			m3s4_ack;
wire			m3s4_err;
wire			m3s4_rty;
wire	[dw-1:0]	m3s5_data_i;
wire	[dw-1:0]	m3s5_data_o;
wire	[aw-1:0]	m3s5_addr;
wire	[sw-1:0]	m3s5_sel;
wire			m3s5_we;
wire			m3s5_cyc;
wire			m3s5_stb;
wire			m3s5_ack;
wire			m3s5_err;
wire			m3s5_rty;
wire	[dw-1:0]	m3s6_data_i;
wire	[dw-1:0]	m3s6_data_o;
wire	[aw-1:0]	m3s6_addr;
wire	[sw-1:0]	m3s6_sel;
wire			m3s6_we;
wire			m3s6_cyc;
wire			m3s6_stb;
wire			m3s6_ack;
wire			m3s6_err;
wire			m3s6_rty;
wire	[dw-1:0]	m3s7_data_i;
wire	[dw-1:0]	m3s7_data_o;
wire	[aw-1:0]	m3s7_addr;
wire	[sw-1:0]	m3s7_sel;
wire			m3s7_we;
wire			m3s7_cyc;
wire			m3s7_stb;
wire			m3s7_ack;
wire			m3s7_err;
wire			m3s7_rty;
wire	[dw-1:0]	m3s8_data_i;
wire	[dw-1:0]	m3s8_data_o;
wire	[aw-1:0]	m3s8_addr;
wire	[sw-1:0]	m3s8_sel;
wire			m3s8_we;
wire			m3s8_cyc;
wire			m3s8_stb;
wire			m3s8_ack;
wire			m3s8_err;
wire			m3s8_rty;
wire	[dw-1:0]	m3s9_data_i;
wire	[dw-1:0]	m3s9_data_o;
wire	[aw-1:0]	m3s9_addr;
wire	[sw-1:0]	m3s9_sel;
wire			m3s9_we;
wire			m3s9_cyc;
wire			m3s9_stb;
wire			m3s9_ack;
wire			m3s9_err;
wire			m3s9_rty;
wire	[dw-1:0]	m3s10_data_i;
wire	[dw-1:0]	m3s10_data_o;
wire	[aw-1:0]	m3s10_addr;
wire	[sw-1:0]	m3s10_sel;
wire			m3s10_we;
wire			m3s10_cyc;
wire			m3s10_stb;
wire			m3s10_ack;
wire			m3s10_err;
wire			m3s10_rty;
wire	[dw-1:0]	m3s11_data_i;
wire	[dw-1:0]	m3s11_data_o;
wire	[aw-1:0]	m3s11_addr;
wire	[sw-1:0]	m3s11_sel;
wire			m3s11_we;
wire			m3s11_cyc;
wire			m3s11_stb;
wire			m3s11_ack;
wire			m3s11_err;
wire			m3s11_rty;
wire	[dw-1:0]	m3s12_data_i;
wire	[dw-1:0]	m3s12_data_o;
wire	[aw-1:0]	m3s12_addr;
wire	[sw-1:0]	m3s12_sel;
wire			m3s12_we;
wire			m3s12_cyc;
wire			m3s12_stb;
wire			m3s12_ack;
wire			m3s12_err;
wire			m3s12_rty;
wire	[dw-1:0]	m3s13_data_i;
wire	[dw-1:0]	m3s13_data_o;
wire	[aw-1:0]	m3s13_addr;
wire	[sw-1:0]	m3s13_sel;
wire			m3s13_we;
wire			m3s13_cyc;
wire			m3s13_stb;
wire			m3s13_ack;
wire			m3s13_err;
wire			m3s13_rty;
wire	[dw-1:0]	m3s14_data_i;
wire	[dw-1:0]	m3s14_data_o;
wire	[aw-1:0]	m3s14_addr;
wire	[sw-1:0]	m3s14_sel;
wire			m3s14_we;
wire			m3s14_cyc;
wire			m3s14_stb;
wire			m3s14_ack;
wire			m3s14_err;
wire			m3s14_rty;
wire	[dw-1:0]	m3s15_data_i;
wire	[dw-1:0]	m3s15_data_o;
wire	[aw-1:0]	m3s15_addr;
wire	[sw-1:0]	m3s15_sel;
wire			m3s15_we;
wire			m3s15_cyc;
wire			m3s15_stb;
wire			m3s15_ack;
wire			m3s15_err;
wire			m3s15_rty;
wire	[dw-1:0]	m4s0_data_i;
wire	[dw-1:0]	m4s0_data_o;
wire	[aw-1:0]	m4s0_addr;
wire	[sw-1:0]	m4s0_sel;
wire			m4s0_we;
wire			m4s0_cyc;
wire			m4s0_stb;
wire			m4s0_ack;
wire			m4s0_err;
wire			m4s0_rty;
wire	[dw-1:0]	m4s1_data_i;
wire	[dw-1:0]	m4s1_data_o;
wire	[aw-1:0]	m4s1_addr;
wire	[sw-1:0]	m4s1_sel;
wire			m4s1_we;
wire			m4s1_cyc;
wire			m4s1_stb;
wire			m4s1_ack;
wire			m4s1_err;
wire			m4s1_rty;
wire	[dw-1:0]	m4s2_data_i;
wire	[dw-1:0]	m4s2_data_o;
wire	[aw-1:0]	m4s2_addr;
wire	[sw-1:0]	m4s2_sel;
wire			m4s2_we;
wire			m4s2_cyc;
wire			m4s2_stb;
wire			m4s2_ack;
wire			m4s2_err;
wire			m4s2_rty;
wire	[dw-1:0]	m4s3_data_i;
wire	[dw-1:0]	m4s3_data_o;
wire	[aw-1:0]	m4s3_addr;
wire	[sw-1:0]	m4s3_sel;
wire			m4s3_we;
wire			m4s3_cyc;
wire			m4s3_stb;
wire			m4s3_ack;
wire			m4s3_err;
wire			m4s3_rty;
wire	[dw-1:0]	m4s4_data_i;
wire	[dw-1:0]	m4s4_data_o;
wire	[aw-1:0]	m4s4_addr;
wire	[sw-1:0]	m4s4_sel;
wire			m4s4_we;
wire			m4s4_cyc;
wire			m4s4_stb;
wire			m4s4_ack;
wire			m4s4_err;
wire			m4s4_rty;
wire	[dw-1:0]	m4s5_data_i;
wire	[dw-1:0]	m4s5_data_o;
wire	[aw-1:0]	m4s5_addr;
wire	[sw-1:0]	m4s5_sel;
wire			m4s5_we;
wire			m4s5_cyc;
wire			m4s5_stb;
wire			m4s5_ack;
wire			m4s5_err;
wire			m4s5_rty;
wire	[dw-1:0]	m4s6_data_i;
wire	[dw-1:0]	m4s6_data_o;
wire	[aw-1:0]	m4s6_addr;
wire	[sw-1:0]	m4s6_sel;
wire			m4s6_we;
wire			m4s6_cyc;
wire			m4s6_stb;
wire			m4s6_ack;
wire			m4s6_err;
wire			m4s6_rty;
wire	[dw-1:0]	m4s7_data_i;
wire	[dw-1:0]	m4s7_data_o;
wire	[aw-1:0]	m4s7_addr;
wire	[sw-1:0]	m4s7_sel;
wire			m4s7_we;
wire			m4s7_cyc;
wire			m4s7_stb;
wire			m4s7_ack;
wire			m4s7_err;
wire			m4s7_rty;
wire	[dw-1:0]	m4s8_data_i;
wire	[dw-1:0]	m4s8_data_o;
wire	[aw-1:0]	m4s8_addr;
wire	[sw-1:0]	m4s8_sel;
wire			m4s8_we;
wire			m4s8_cyc;
wire			m4s8_stb;
wire			m4s8_ack;
wire			m4s8_err;
wire			m4s8_rty;
wire	[dw-1:0]	m4s9_data_i;
wire	[dw-1:0]	m4s9_data_o;
wire	[aw-1:0]	m4s9_addr;
wire	[sw-1:0]	m4s9_sel;
wire			m4s9_we;
wire			m4s9_cyc;
wire			m4s9_stb;
wire			m4s9_ack;
wire			m4s9_err;
wire			m4s9_rty;
wire	[dw-1:0]	m4s10_data_i;
wire	[dw-1:0]	m4s10_data_o;
wire	[aw-1:0]	m4s10_addr;
wire	[sw-1:0]	m4s10_sel;
wire			m4s10_we;
wire			m4s10_cyc;
wire			m4s10_stb;
wire			m4s10_ack;
wire			m4s10_err;
wire			m4s10_rty;
wire	[dw-1:0]	m4s11_data_i;
wire	[dw-1:0]	m4s11_data_o;
wire	[aw-1:0]	m4s11_addr;
wire	[sw-1:0]	m4s11_sel;
wire			m4s11_we;
wire			m4s11_cyc;
wire			m4s11_stb;
wire			m4s11_ack;
wire			m4s11_err;
wire			m4s11_rty;
wire	[dw-1:0]	m4s12_data_i;
wire	[dw-1:0]	m4s12_data_o;
wire	[aw-1:0]	m4s12_addr;
wire	[sw-1:0]	m4s12_sel;
wire			m4s12_we;
wire			m4s12_cyc;
wire			m4s12_stb;
wire			m4s12_ack;
wire			m4s12_err;
wire			m4s12_rty;
wire	[dw-1:0]	m4s13_data_i;
wire	[dw-1:0]	m4s13_data_o;
wire	[aw-1:0]	m4s13_addr;
wire	[sw-1:0]	m4s13_sel;
wire			m4s13_we;
wire			m4s13_cyc;
wire			m4s13_stb;
wire			m4s13_ack;
wire			m4s13_err;
wire			m4s13_rty;
wire	[dw-1:0]	m4s14_data_i;
wire	[dw-1:0]	m4s14_data_o;
wire	[aw-1:0]	m4s14_addr;
wire	[sw-1:0]	m4s14_sel;
wire			m4s14_we;
wire			m4s14_cyc;
wire			m4s14_stb;
wire			m4s14_ack;
wire			m4s14_err;
wire			m4s14_rty;
wire	[dw-1:0]	m4s15_data_i;
wire	[dw-1:0]	m4s15_data_o;
wire	[aw-1:0]	m4s15_addr;
wire	[sw-1:0]	m4s15_sel;
wire			m4s15_we;
wire			m4s15_cyc;
wire			m4s15_stb;
wire			m4s15_ack;
wire			m4s15_err;
wire			m4s15_rty;
wire	[dw-1:0]	m5s0_data_i;
wire	[dw-1:0]	m5s0_data_o;
wire	[aw-1:0]	m5s0_addr;
wire	[sw-1:0]	m5s0_sel;
wire			m5s0_we;
wire			m5s0_cyc;
wire			m5s0_stb;
wire			m5s0_ack;
wire			m5s0_err;
wire			m5s0_rty;
wire	[dw-1:0]	m5s1_data_i;
wire	[dw-1:0]	m5s1_data_o;
wire	[aw-1:0]	m5s1_addr;
wire	[sw-1:0]	m5s1_sel;
wire			m5s1_we;
wire			m5s1_cyc;
wire			m5s1_stb;
wire			m5s1_ack;
wire			m5s1_err;
wire			m5s1_rty;
wire	[dw-1:0]	m5s2_data_i;
wire	[dw-1:0]	m5s2_data_o;
wire	[aw-1:0]	m5s2_addr;
wire	[sw-1:0]	m5s2_sel;
wire			m5s2_we;
wire			m5s2_cyc;
wire			m5s2_stb;
wire			m5s2_ack;
wire			m5s2_err;
wire			m5s2_rty;
wire	[dw-1:0]	m5s3_data_i;
wire	[dw-1:0]	m5s3_data_o;
wire	[aw-1:0]	m5s3_addr;
wire	[sw-1:0]	m5s3_sel;
wire			m5s3_we;
wire			m5s3_cyc;
wire			m5s3_stb;
wire			m5s3_ack;
wire			m5s3_err;
wire			m5s3_rty;
wire	[dw-1:0]	m5s4_data_i;
wire	[dw-1:0]	m5s4_data_o;
wire	[aw-1:0]	m5s4_addr;
wire	[sw-1:0]	m5s4_sel;
wire			m5s4_we;
wire			m5s4_cyc;
wire			m5s4_stb;
wire			m5s4_ack;
wire			m5s4_err;
wire			m5s4_rty;
wire	[dw-1:0]	m5s5_data_i;
wire	[dw-1:0]	m5s5_data_o;
wire	[aw-1:0]	m5s5_addr;
wire	[sw-1:0]	m5s5_sel;
wire			m5s5_we;
wire			m5s5_cyc;
wire			m5s5_stb;
wire			m5s5_ack;
wire			m5s5_err;
wire			m5s5_rty;
wire	[dw-1:0]	m5s6_data_i;
wire	[dw-1:0]	m5s6_data_o;
wire	[aw-1:0]	m5s6_addr;
wire	[sw-1:0]	m5s6_sel;
wire			m5s6_we;
wire			m5s6_cyc;
wire			m5s6_stb;
wire			m5s6_ack;
wire			m5s6_err;
wire			m5s6_rty;
wire	[dw-1:0]	m5s7_data_i;
wire	[dw-1:0]	m5s7_data_o;
wire	[aw-1:0]	m5s7_addr;
wire	[sw-1:0]	m5s7_sel;
wire			m5s7_we;
wire			m5s7_cyc;
wire			m5s7_stb;
wire			m5s7_ack;
wire			m5s7_err;
wire			m5s7_rty;
wire	[dw-1:0]	m5s8_data_i;
wire	[dw-1:0]	m5s8_data_o;
wire	[aw-1:0]	m5s8_addr;
wire	[sw-1:0]	m5s8_sel;
wire			m5s8_we;
wire			m5s8_cyc;
wire			m5s8_stb;
wire			m5s8_ack;
wire			m5s8_err;
wire			m5s8_rty;
wire	[dw-1:0]	m5s9_data_i;
wire	[dw-1:0]	m5s9_data_o;
wire	[aw-1:0]	m5s9_addr;
wire	[sw-1:0]	m5s9_sel;
wire			m5s9_we;
wire			m5s9_cyc;
wire			m5s9_stb;
wire			m5s9_ack;
wire			m5s9_err;
wire			m5s9_rty;
wire	[dw-1:0]	m5s10_data_i;
wire	[dw-1:0]	m5s10_data_o;
wire	[aw-1:0]	m5s10_addr;
wire	[sw-1:0]	m5s10_sel;
wire			m5s10_we;
wire			m5s10_cyc;
wire			m5s10_stb;
wire			m5s10_ack;
wire			m5s10_err;
wire			m5s10_rty;
wire	[dw-1:0]	m5s11_data_i;
wire	[dw-1:0]	m5s11_data_o;
wire	[aw-1:0]	m5s11_addr;
wire	[sw-1:0]	m5s11_sel;
wire			m5s11_we;
wire			m5s11_cyc;
wire			m5s11_stb;
wire			m5s11_ack;
wire			m5s11_err;
wire			m5s11_rty;
wire	[dw-1:0]	m5s12_data_i;
wire	[dw-1:0]	m5s12_data_o;
wire	[aw-1:0]	m5s12_addr;
wire	[sw-1:0]	m5s12_sel;
wire			m5s12_we;
wire			m5s12_cyc;
wire			m5s12_stb;
wire			m5s12_ack;
wire			m5s12_err;
wire			m5s12_rty;
wire	[dw-1:0]	m5s13_data_i;
wire	[dw-1:0]	m5s13_data_o;
wire	[aw-1:0]	m5s13_addr;
wire	[sw-1:0]	m5s13_sel;
wire			m5s13_we;
wire			m5s13_cyc;
wire			m5s13_stb;
wire			m5s13_ack;
wire			m5s13_err;
wire			m5s13_rty;
wire	[dw-1:0]	m5s14_data_i;
wire	[dw-1:0]	m5s14_data_o;
wire	[aw-1:0]	m5s14_addr;
wire	[sw-1:0]	m5s14_sel;
wire			m5s14_we;
wire			m5s14_cyc;
wire			m5s14_stb;
wire			m5s14_ack;
wire			m5s14_err;
wire			m5s14_rty;
wire	[dw-1:0]	m5s15_data_i;
wire	[dw-1:0]	m5s15_data_o;
wire	[aw-1:0]	m5s15_addr;
wire	[sw-1:0]	m5s15_sel;
wire			m5s15_we;
wire			m5s15_cyc;
wire			m5s15_stb;
wire			m5s15_ack;
wire			m5s15_err;
wire			m5s15_rty;
wire	[dw-1:0]	m6s0_data_i;
wire	[dw-1:0]	m6s0_data_o;
wire	[aw-1:0]	m6s0_addr;
wire	[sw-1:0]	m6s0_sel;
wire			m6s0_we;
wire			m6s0_cyc;
wire			m6s0_stb;
wire			m6s0_ack;
wire			m6s0_err;
wire			m6s0_rty;
wire	[dw-1:0]	m6s1_data_i;
wire	[dw-1:0]	m6s1_data_o;
wire	[aw-1:0]	m6s1_addr;
wire	[sw-1:0]	m6s1_sel;
wire			m6s1_we;
wire			m6s1_cyc;
wire			m6s1_stb;
wire			m6s1_ack;
wire			m6s1_err;
wire			m6s1_rty;
wire	[dw-1:0]	m6s2_data_i;
wire	[dw-1:0]	m6s2_data_o;
wire	[aw-1:0]	m6s2_addr;
wire	[sw-1:0]	m6s2_sel;
wire			m6s2_we;
wire			m6s2_cyc;
wire			m6s2_stb;
wire			m6s2_ack;
wire			m6s2_err;
wire			m6s2_rty;
wire	[dw-1:0]	m6s3_data_i;
wire	[dw-1:0]	m6s3_data_o;
wire	[aw-1:0]	m6s3_addr;
wire	[sw-1:0]	m6s3_sel;
wire			m6s3_we;
wire			m6s3_cyc;
wire			m6s3_stb;
wire			m6s3_ack;
wire			m6s3_err;
wire			m6s3_rty;
wire	[dw-1:0]	m6s4_data_i;
wire	[dw-1:0]	m6s4_data_o;
wire	[aw-1:0]	m6s4_addr;
wire	[sw-1:0]	m6s4_sel;
wire			m6s4_we;
wire			m6s4_cyc;
wire			m6s4_stb;
wire			m6s4_ack;
wire			m6s4_err;
wire			m6s4_rty;
wire	[dw-1:0]	m6s5_data_i;
wire	[dw-1:0]	m6s5_data_o;
wire	[aw-1:0]	m6s5_addr;
wire	[sw-1:0]	m6s5_sel;
wire			m6s5_we;
wire			m6s5_cyc;
wire			m6s5_stb;
wire			m6s5_ack;
wire			m6s5_err;
wire			m6s5_rty;
wire	[dw-1:0]	m6s6_data_i;
wire	[dw-1:0]	m6s6_data_o;
wire	[aw-1:0]	m6s6_addr;
wire	[sw-1:0]	m6s6_sel;
wire			m6s6_we;
wire			m6s6_cyc;
wire			m6s6_stb;
wire			m6s6_ack;
wire			m6s6_err;
wire			m6s6_rty;
wire	[dw-1:0]	m6s7_data_i;
wire	[dw-1:0]	m6s7_data_o;
wire	[aw-1:0]	m6s7_addr;
wire	[sw-1:0]	m6s7_sel;
wire			m6s7_we;
wire			m6s7_cyc;
wire			m6s7_stb;
wire			m6s7_ack;
wire			m6s7_err;
wire			m6s7_rty;
wire	[dw-1:0]	m6s8_data_i;
wire	[dw-1:0]	m6s8_data_o;
wire	[aw-1:0]	m6s8_addr;
wire	[sw-1:0]	m6s8_sel;
wire			m6s8_we;
wire			m6s8_cyc;
wire			m6s8_stb;
wire			m6s8_ack;
wire			m6s8_err;
wire			m6s8_rty;
wire	[dw-1:0]	m6s9_data_i;
wire	[dw-1:0]	m6s9_data_o;
wire	[aw-1:0]	m6s9_addr;
wire	[sw-1:0]	m6s9_sel;
wire			m6s9_we;
wire			m6s9_cyc;
wire			m6s9_stb;
wire			m6s9_ack;
wire			m6s9_err;
wire			m6s9_rty;
wire	[dw-1:0]	m6s10_data_i;
wire	[dw-1:0]	m6s10_data_o;
wire	[aw-1:0]	m6s10_addr;
wire	[sw-1:0]	m6s10_sel;
wire			m6s10_we;
wire			m6s10_cyc;
wire			m6s10_stb;
wire			m6s10_ack;
wire			m6s10_err;
wire			m6s10_rty;
wire	[dw-1:0]	m6s11_data_i;
wire	[dw-1:0]	m6s11_data_o;
wire	[aw-1:0]	m6s11_addr;
wire	[sw-1:0]	m6s11_sel;
wire			m6s11_we;
wire			m6s11_cyc;
wire			m6s11_stb;
wire			m6s11_ack;
wire			m6s11_err;
wire			m6s11_rty;
wire	[dw-1:0]	m6s12_data_i;
wire	[dw-1:0]	m6s12_data_o;
wire	[aw-1:0]	m6s12_addr;
wire	[sw-1:0]	m6s12_sel;
wire			m6s12_we;
wire			m6s12_cyc;
wire			m6s12_stb;
wire			m6s12_ack;
wire			m6s12_err;
wire			m6s12_rty;
wire	[dw-1:0]	m6s13_data_i;
wire	[dw-1:0]	m6s13_data_o;
wire	[aw-1:0]	m6s13_addr;
wire	[sw-1:0]	m6s13_sel;
wire			m6s13_we;
wire			m6s13_cyc;
wire			m6s13_stb;
wire			m6s13_ack;
wire			m6s13_err;
wire			m6s13_rty;
wire	[dw-1:0]	m6s14_data_i;
wire	[dw-1:0]	m6s14_data_o;
wire	[aw-1:0]	m6s14_addr;
wire	[sw-1:0]	m6s14_sel;
wire			m6s14_we;
wire			m6s14_cyc;
wire			m6s14_stb;
wire			m6s14_ack;
wire			m6s14_err;
wire			m6s14_rty;
wire	[dw-1:0]	m6s15_data_i;
wire	[dw-1:0]	m6s15_data_o;
wire	[aw-1:0]	m6s15_addr;
wire	[sw-1:0]	m6s15_sel;
wire			m6s15_we;
wire			m6s15_cyc;
wire			m6s15_stb;
wire			m6s15_ack;
wire			m6s15_err;
wire			m6s15_rty;
wire	[dw-1:0]	m7s0_data_i;
wire	[dw-1:0]	m7s0_data_o;
wire	[aw-1:0]	m7s0_addr;
wire	[sw-1:0]	m7s0_sel;
wire			m7s0_we;
wire			m7s0_cyc;
wire			m7s0_stb;
wire			m7s0_ack;
wire			m7s0_err;
wire			m7s0_rty;
wire	[dw-1:0]	m7s1_data_i;
wire	[dw-1:0]	m7s1_data_o;
wire	[aw-1:0]	m7s1_addr;
wire	[sw-1:0]	m7s1_sel;
wire			m7s1_we;
wire			m7s1_cyc;
wire			m7s1_stb;
wire			m7s1_ack;
wire			m7s1_err;
wire			m7s1_rty;
wire	[dw-1:0]	m7s2_data_i;
wire	[dw-1:0]	m7s2_data_o;
wire	[aw-1:0]	m7s2_addr;
wire	[sw-1:0]	m7s2_sel;
wire			m7s2_we;
wire			m7s2_cyc;
wire			m7s2_stb;
wire			m7s2_ack;
wire			m7s2_err;
wire			m7s2_rty;
wire	[dw-1:0]	m7s3_data_i;
wire	[dw-1:0]	m7s3_data_o;
wire	[aw-1:0]	m7s3_addr;
wire	[sw-1:0]	m7s3_sel;
wire			m7s3_we;
wire			m7s3_cyc;
wire			m7s3_stb;
wire			m7s3_ack;
wire			m7s3_err;
wire			m7s3_rty;
wire	[dw-1:0]	m7s4_data_i;
wire	[dw-1:0]	m7s4_data_o;
wire	[aw-1:0]	m7s4_addr;
wire	[sw-1:0]	m7s4_sel;
wire			m7s4_we;
wire			m7s4_cyc;
wire			m7s4_stb;
wire			m7s4_ack;
wire			m7s4_err;
wire			m7s4_rty;
wire	[dw-1:0]	m7s5_data_i;
wire	[dw-1:0]	m7s5_data_o;
wire	[aw-1:0]	m7s5_addr;
wire	[sw-1:0]	m7s5_sel;
wire			m7s5_we;
wire			m7s5_cyc;
wire			m7s5_stb;
wire			m7s5_ack;
wire			m7s5_err;
wire			m7s5_rty;
wire	[dw-1:0]	m7s6_data_i;
wire	[dw-1:0]	m7s6_data_o;
wire	[aw-1:0]	m7s6_addr;
wire	[sw-1:0]	m7s6_sel;
wire			m7s6_we;
wire			m7s6_cyc;
wire			m7s6_stb;
wire			m7s6_ack;
wire			m7s6_err;
wire			m7s6_rty;
wire	[dw-1:0]	m7s7_data_i;
wire	[dw-1:0]	m7s7_data_o;
wire	[aw-1:0]	m7s7_addr;
wire	[sw-1:0]	m7s7_sel;
wire			m7s7_we;
wire			m7s7_cyc;
wire			m7s7_stb;
wire			m7s7_ack;
wire			m7s7_err;
wire			m7s7_rty;
wire	[dw-1:0]	m7s8_data_i;
wire	[dw-1:0]	m7s8_data_o;
wire	[aw-1:0]	m7s8_addr;
wire	[sw-1:0]	m7s8_sel;
wire			m7s8_we;
wire			m7s8_cyc;
wire			m7s8_stb;
wire			m7s8_ack;
wire			m7s8_err;
wire			m7s8_rty;
wire	[dw-1:0]	m7s9_data_i;
wire	[dw-1:0]	m7s9_data_o;
wire	[aw-1:0]	m7s9_addr;
wire	[sw-1:0]	m7s9_sel;
wire			m7s9_we;
wire			m7s9_cyc;
wire			m7s9_stb;
wire			m7s9_ack;
wire			m7s9_err;
wire			m7s9_rty;
wire	[dw-1:0]	m7s10_data_i;
wire	[dw-1:0]	m7s10_data_o;
wire	[aw-1:0]	m7s10_addr;
wire	[sw-1:0]	m7s10_sel;
wire			m7s10_we;
wire			m7s10_cyc;
wire			m7s10_stb;
wire			m7s10_ack;
wire			m7s10_err;
wire			m7s10_rty;
wire	[dw-1:0]	m7s11_data_i;
wire	[dw-1:0]	m7s11_data_o;
wire	[aw-1:0]	m7s11_addr;
wire	[sw-1:0]	m7s11_sel;
wire			m7s11_we;
wire			m7s11_cyc;
wire			m7s11_stb;
wire			m7s11_ack;
wire			m7s11_err;
wire			m7s11_rty;
wire	[dw-1:0]	m7s12_data_i;
wire	[dw-1:0]	m7s12_data_o;
wire	[aw-1:0]	m7s12_addr;
wire	[sw-1:0]	m7s12_sel;
wire			m7s12_we;
wire			m7s12_cyc;
wire			m7s12_stb;
wire			m7s12_ack;
wire			m7s12_err;
wire			m7s12_rty;
wire	[dw-1:0]	m7s13_data_i;
wire	[dw-1:0]	m7s13_data_o;
wire	[aw-1:0]	m7s13_addr;
wire	[sw-1:0]	m7s13_sel;
wire			m7s13_we;
wire			m7s13_cyc;
wire			m7s13_stb;
wire			m7s13_ack;
wire			m7s13_err;
wire			m7s13_rty;
wire	[dw-1:0]	m7s14_data_i;
wire	[dw-1:0]	m7s14_data_o;
wire	[aw-1:0]	m7s14_addr;
wire	[sw-1:0]	m7s14_sel;
wire			m7s14_we;
wire			m7s14_cyc;
wire			m7s14_stb;
wire			m7s14_ack;
wire			m7s14_err;
wire			m7s14_rty;
wire	[dw-1:0]	m7s15_data_i;
wire	[dw-1:0]	m7s15_data_o;
wire	[aw-1:0]	m7s15_addr;
wire	[sw-1:0]	m7s15_sel;
wire			m7s15_we;
wire			m7s15_cyc;
wire			m7s15_stb;
wire			m7s15_ack;
wire			m7s15_err;
wire			m7s15_rty;

wire	[15:0]		conf0;
wire	[15:0]		conf1;
wire	[15:0]		conf2;
wire	[15:0]		conf3;
wire	[15:0]		conf4;
wire	[15:0]		conf5;
wire	[15:0]		conf6;
wire	[15:0]		conf7;
wire	[15:0]		conf8;
wire	[15:0]		conf9;
wire	[15:0]		conf10;
wire	[15:0]		conf11;
wire	[15:0]		conf12;
wire	[15:0]		conf13;
wire	[15:0]		conf14;
wire	[15:0]		conf15;

////////////////////////////////////////////////////////////////////
//
// Initial Configuration Check
//

// synopsys translate_off
initial
   begin
	if(dw<16)
	   begin
		$display("ERROR: Setting Data bus width to less than 16 bits, will");
		$display("       make it impossible to use the configurations registers.");
		$finish;
	   end
   end
// synopsys translate_on

////////////////////////////////////////////////////////////////////
//
// Master Interfaces
//

wb_conmax_master_if #(dw,aw,sw)	m0(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m0_data_i	),
		.wb_data_o(	m0_data_o	),
		.wb_addr_i(	m0_addr_i	),
		.wb_sel_i(	m0_sel_i	),
		.wb_we_i(	m0_we_i		),
		.wb_cyc_i(	m0_cyc_i	),
		.wb_stb_i(	m0_stb_i	),
		.wb_ack_o(	m0_ack_o	),
		.wb_err_o(	m0_err_o	),
		.wb_rty_o(	m0_rty_o	),
		.s0_data_i(	m0s0_data_i	),
		.s0_data_o(	m0s0_data_o	),
		.s0_addr_o(	m0s0_addr	),
		.s0_sel_o(	m0s0_sel	),
		.s0_we_o(	m0s0_we		),
		.s0_cyc_o(	m0s0_cyc	),
		.s0_stb_o(	m0s0_stb	),
		.s0_ack_i(	m0s0_ack	),
		.s0_err_i(	m0s0_err	),
		.s0_rty_i(	m0s0_rty	),
		.s1_data_i(	m0s1_data_i	),
		.s1_data_o(	m0s1_data_o	),
		.s1_addr_o(	m0s1_addr	),
		.s1_sel_o(	m0s1_sel	),
		.s1_we_o(	m0s1_we		),
		.s1_cyc_o(	m0s1_cyc	),
		.s1_stb_o(	m0s1_stb	),
		.s1_ack_i(	m0s1_ack	),
		.s1_err_i(	m0s1_err	),
		.s1_rty_i(	m0s1_rty	),
		.s2_data_i(	m0s2_data_i	),
		.s2_data_o(	m0s2_data_o	),
		.s2_addr_o(	m0s2_addr	),
		.s2_sel_o(	m0s2_sel	),
		.s2_we_o(	m0s2_we		),
		.s2_cyc_o(	m0s2_cyc	),
		.s2_stb_o(	m0s2_stb	),
		.s2_ack_i(	m0s2_ack	),
		.s2_err_i(	m0s2_err	),
		.s2_rty_i(	m0s2_rty	),
		.s3_data_i(	m0s3_data_i	),
		.s3_data_o(	m0s3_data_o	),
		.s3_addr_o(	m0s3_addr	),
		.s3_sel_o(	m0s3_sel	),
		.s3_we_o(	m0s3_we		),
		.s3_cyc_o(	m0s3_cyc	),
		.s3_stb_o(	m0s3_stb	),
		.s3_ack_i(	m0s3_ack	),
		.s3_err_i(	m0s3_err	),
		.s3_rty_i(	m0s3_rty	),
		.s4_data_i(	m0s4_data_i	),
		.s4_data_o(	m0s4_data_o	),
		.s4_addr_o(	m0s4_addr	),
		.s4_sel_o(	m0s4_sel	),
		.s4_we_o(	m0s4_we		),
		.s4_cyc_o(	m0s4_cyc	),
		.s4_stb_o(	m0s4_stb	),
		.s4_ack_i(	m0s4_ack	),
		.s4_err_i(	m0s4_err	),
		.s4_rty_i(	m0s4_rty	),
		.s5_data_i(	m0s5_data_i	),
		.s5_data_o(	m0s5_data_o	),
		.s5_addr_o(	m0s5_addr	),
		.s5_sel_o(	m0s5_sel	),
		.s5_we_o(	m0s5_we		),
		.s5_cyc_o(	m0s5_cyc	),
		.s5_stb_o(	m0s5_stb	),
		.s5_ack_i(	m0s5_ack	),
		.s5_err_i(	m0s5_err	),
		.s5_rty_i(	m0s5_rty	),
		.s6_data_i(	m0s6_data_i	),
		.s6_data_o(	m0s6_data_o	),
		.s6_addr_o(	m0s6_addr	),
		.s6_sel_o(	m0s6_sel	),
		.s6_we_o(	m0s6_we		),
		.s6_cyc_o(	m0s6_cyc	),
		.s6_stb_o(	m0s6_stb	),
		.s6_ack_i(	m0s6_ack	),
		.s6_err_i(	m0s6_err	),
		.s6_rty_i(	m0s6_rty	),
		.s7_data_i(	m0s7_data_i	),
		.s7_data_o(	m0s7_data_o	),
		.s7_addr_o(	m0s7_addr	),
		.s7_sel_o(	m0s7_sel	),
		.s7_we_o(	m0s7_we		),
		.s7_cyc_o(	m0s7_cyc	),
		.s7_stb_o(	m0s7_stb	),
		.s7_ack_i(	m0s7_ack	),
		.s7_err_i(	m0s7_err	),
		.s7_rty_i(	m0s7_rty	),
		.s8_data_i(	m0s8_data_i	),
		.s8_data_o(	m0s8_data_o	),
		.s8_addr_o(	m0s8_addr	),
		.s8_sel_o(	m0s8_sel	),
		.s8_we_o(	m0s8_we		),
		.s8_cyc_o(	m0s8_cyc	),
		.s8_stb_o(	m0s8_stb	),
		.s8_ack_i(	m0s8_ack	),
		.s8_err_i(	m0s8_err	),
		.s8_rty_i(	m0s8_rty	),
		.s9_data_i(	m0s9_data_i	),
		.s9_data_o(	m0s9_data_o	),
		.s9_addr_o(	m0s9_addr	),
		.s9_sel_o(	m0s9_sel	),
		.s9_we_o(	m0s9_we		),
		.s9_cyc_o(	m0s9_cyc	),
		.s9_stb_o(	m0s9_stb	),
		.s9_ack_i(	m0s9_ack	),
		.s9_err_i(	m0s9_err	),
		.s9_rty_i(	m0s9_rty	),
		.s10_data_i(	m0s10_data_i	),
		.s10_data_o(	m0s10_data_o	),
		.s10_addr_o(	m0s10_addr	),
		.s10_sel_o(	m0s10_sel	),
		.s10_we_o(	m0s10_we	),
		.s10_cyc_o(	m0s10_cyc	),
		.s10_stb_o(	m0s10_stb	),
		.s10_ack_i(	m0s10_ack	),
		.s10_err_i(	m0s10_err	),
		.s10_rty_i(	m0s10_rty	),
		.s11_data_i(	m0s11_data_i	),
		.s11_data_o(	m0s11_data_o	),
		.s11_addr_o(	m0s11_addr	),
		.s11_sel_o(	m0s11_sel	),
		.s11_we_o(	m0s11_we	),
		.s11_cyc_o(	m0s11_cyc	),
		.s11_stb_o(	m0s11_stb	),
		.s11_ack_i(	m0s11_ack	),
		.s11_err_i(	m0s11_err	),
		.s11_rty_i(	m0s11_rty	),
		.s12_data_i(	m0s12_data_i	),
		.s12_data_o(	m0s12_data_o	),
		.s12_addr_o(	m0s12_addr	),
		.s12_sel_o(	m0s12_sel	),
		.s12_we_o(	m0s12_we	),
		.s12_cyc_o(	m0s12_cyc	),
		.s12_stb_o(	m0s12_stb	),
		.s12_ack_i(	m0s12_ack	),
		.s12_err_i(	m0s12_err	),
		.s12_rty_i(	m0s12_rty	),
		.s13_data_i(	m0s13_data_i	),
		.s13_data_o(	m0s13_data_o	),
		.s13_addr_o(	m0s13_addr	),
		.s13_sel_o(	m0s13_sel	),
		.s13_we_o(	m0s13_we	),
		.s13_cyc_o(	m0s13_cyc	),
		.s13_stb_o(	m0s13_stb	),
		.s13_ack_i(	m0s13_ack	),
		.s13_err_i(	m0s13_err	),
		.s13_rty_i(	m0s13_rty	),
		.s14_data_i(	m0s14_data_i	),
		.s14_data_o(	m0s14_data_o	),
		.s14_addr_o(	m0s14_addr	),
		.s14_sel_o(	m0s14_sel	),
		.s14_we_o(	m0s14_we	),
		.s14_cyc_o(	m0s14_cyc	),
		.s14_stb_o(	m0s14_stb	),
		.s14_ack_i(	m0s14_ack	),
		.s14_err_i(	m0s14_err	),
		.s14_rty_i(	m0s14_rty	),
		.s15_data_i(	m0s15_data_i	),
		.s15_data_o(	m0s15_data_o	),
		.s15_addr_o(	m0s15_addr	),
		.s15_sel_o(	m0s15_sel	),
		.s15_we_o(	m0s15_we	),
		.s15_cyc_o(	m0s15_cyc	),
		.s15_stb_o(	m0s15_stb	),
		.s15_ack_i(	m0s15_ack	),
		.s15_err_i(	m0s15_err	),
		.s15_rty_i(	m0s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m1(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m1_data_i	),
		.wb_data_o(	m1_data_o	),
		.wb_addr_i(	m1_addr_i	),
		.wb_sel_i(	m1_sel_i	),
		.wb_we_i(	m1_we_i		),
		.wb_cyc_i(	m1_cyc_i	),
		.wb_stb_i(	m1_stb_i	),
		.wb_ack_o(	m1_ack_o	),
		.wb_err_o(	m1_err_o	),
		.wb_rty_o(	m1_rty_o	),
		.s0_data_i(	m1s0_data_i	),
		.s0_data_o(	m1s0_data_o	),
		.s0_addr_o(	m1s0_addr	),
		.s0_sel_o(	m1s0_sel	),
		.s0_we_o(	m1s0_we		),
		.s0_cyc_o(	m1s0_cyc	),
		.s0_stb_o(	m1s0_stb	),
		.s0_ack_i(	m1s0_ack	),
		.s0_err_i(	m1s0_err	),
		.s0_rty_i(	m1s0_rty	),
		.s1_data_i(	m1s1_data_i	),
		.s1_data_o(	m1s1_data_o	),
		.s1_addr_o(	m1s1_addr	),
		.s1_sel_o(	m1s1_sel	),
		.s1_we_o(	m1s1_we		),
		.s1_cyc_o(	m1s1_cyc	),
		.s1_stb_o(	m1s1_stb	),
		.s1_ack_i(	m1s1_ack	),
		.s1_err_i(	m1s1_err	),
		.s1_rty_i(	m1s1_rty	),
		.s2_data_i(	m1s2_data_i	),
		.s2_data_o(	m1s2_data_o	),
		.s2_addr_o(	m1s2_addr	),
		.s2_sel_o(	m1s2_sel	),
		.s2_we_o(	m1s2_we		),
		.s2_cyc_o(	m1s2_cyc	),
		.s2_stb_o(	m1s2_stb	),
		.s2_ack_i(	m1s2_ack	),
		.s2_err_i(	m1s2_err	),
		.s2_rty_i(	m1s2_rty	),
		.s3_data_i(	m1s3_data_i	),
		.s3_data_o(	m1s3_data_o	),
		.s3_addr_o(	m1s3_addr	),
		.s3_sel_o(	m1s3_sel	),
		.s3_we_o(	m1s3_we		),
		.s3_cyc_o(	m1s3_cyc	),
		.s3_stb_o(	m1s3_stb	),
		.s3_ack_i(	m1s3_ack	),
		.s3_err_i(	m1s3_err	),
		.s3_rty_i(	m1s3_rty	),
		.s4_data_i(	m1s4_data_i	),
		.s4_data_o(	m1s4_data_o	),
		.s4_addr_o(	m1s4_addr	),
		.s4_sel_o(	m1s4_sel	),
		.s4_we_o(	m1s4_we		),
		.s4_cyc_o(	m1s4_cyc	),
		.s4_stb_o(	m1s4_stb	),
		.s4_ack_i(	m1s4_ack	),
		.s4_err_i(	m1s4_err	),
		.s4_rty_i(	m1s4_rty	),
		.s5_data_i(	m1s5_data_i	),
		.s5_data_o(	m1s5_data_o	),
		.s5_addr_o(	m1s5_addr	),
		.s5_sel_o(	m1s5_sel	),
		.s5_we_o(	m1s5_we		),
		.s5_cyc_o(	m1s5_cyc	),
		.s5_stb_o(	m1s5_stb	),
		.s5_ack_i(	m1s5_ack	),
		.s5_err_i(	m1s5_err	),
		.s5_rty_i(	m1s5_rty	),
		.s6_data_i(	m1s6_data_i	),
		.s6_data_o(	m1s6_data_o	),
		.s6_addr_o(	m1s6_addr	),
		.s6_sel_o(	m1s6_sel	),
		.s6_we_o(	m1s6_we		),
		.s6_cyc_o(	m1s6_cyc	),
		.s6_stb_o(	m1s6_stb	),
		.s6_ack_i(	m1s6_ack	),
		.s6_err_i(	m1s6_err	),
		.s6_rty_i(	m1s6_rty	),
		.s7_data_i(	m1s7_data_i	),
		.s7_data_o(	m1s7_data_o	),
		.s7_addr_o(	m1s7_addr	),
		.s7_sel_o(	m1s7_sel	),
		.s7_we_o(	m1s7_we		),
		.s7_cyc_o(	m1s7_cyc	),
		.s7_stb_o(	m1s7_stb	),
		.s7_ack_i(	m1s7_ack	),
		.s7_err_i(	m1s7_err	),
		.s7_rty_i(	m1s7_rty	),
		.s8_data_i(	m1s8_data_i	),
		.s8_data_o(	m1s8_data_o	),
		.s8_addr_o(	m1s8_addr	),
		.s8_sel_o(	m1s8_sel	),
		.s8_we_o(	m1s8_we		),
		.s8_cyc_o(	m1s8_cyc	),
		.s8_stb_o(	m1s8_stb	),
		.s8_ack_i(	m1s8_ack	),
		.s8_err_i(	m1s8_err	),
		.s8_rty_i(	m1s8_rty	),
		.s9_data_i(	m1s9_data_i	),
		.s9_data_o(	m1s9_data_o	),
		.s9_addr_o(	m1s9_addr	),
		.s9_sel_o(	m1s9_sel	),
		.s9_we_o(	m1s9_we		),
		.s9_cyc_o(	m1s9_cyc	),
		.s9_stb_o(	m1s9_stb	),
		.s9_ack_i(	m1s9_ack	),
		.s9_err_i(	m1s9_err	),
		.s9_rty_i(	m1s9_rty	),
		.s10_data_i(	m1s10_data_i	),
		.s10_data_o(	m1s10_data_o	),
		.s10_addr_o(	m1s10_addr	),
		.s10_sel_o(	m1s10_sel	),
		.s10_we_o(	m1s10_we	),
		.s10_cyc_o(	m1s10_cyc	),
		.s10_stb_o(	m1s10_stb	),
		.s10_ack_i(	m1s10_ack	),
		.s10_err_i(	m1s10_err	),
		.s10_rty_i(	m1s10_rty	),
		.s11_data_i(	m1s11_data_i	),
		.s11_data_o(	m1s11_data_o	),
		.s11_addr_o(	m1s11_addr	),
		.s11_sel_o(	m1s11_sel	),
		.s11_we_o(	m1s11_we	),
		.s11_cyc_o(	m1s11_cyc	),
		.s11_stb_o(	m1s11_stb	),
		.s11_ack_i(	m1s11_ack	),
		.s11_err_i(	m1s11_err	),
		.s11_rty_i(	m1s11_rty	),
		.s12_data_i(	m1s12_data_i	),
		.s12_data_o(	m1s12_data_o	),
		.s12_addr_o(	m1s12_addr	),
		.s12_sel_o(	m1s12_sel	),
		.s12_we_o(	m1s12_we	),
		.s12_cyc_o(	m1s12_cyc	),
		.s12_stb_o(	m1s12_stb	),
		.s12_ack_i(	m1s12_ack	),
		.s12_err_i(	m1s12_err	),
		.s12_rty_i(	m1s12_rty	),
		.s13_data_i(	m1s13_data_i	),
		.s13_data_o(	m1s13_data_o	),
		.s13_addr_o(	m1s13_addr	),
		.s13_sel_o(	m1s13_sel	),
		.s13_we_o(	m1s13_we	),
		.s13_cyc_o(	m1s13_cyc	),
		.s13_stb_o(	m1s13_stb	),
		.s13_ack_i(	m1s13_ack	),
		.s13_err_i(	m1s13_err	),
		.s13_rty_i(	m1s13_rty	),
		.s14_data_i(	m1s14_data_i	),
		.s14_data_o(	m1s14_data_o	),
		.s14_addr_o(	m1s14_addr	),
		.s14_sel_o(	m1s14_sel	),
		.s14_we_o(	m1s14_we	),
		.s14_cyc_o(	m1s14_cyc	),
		.s14_stb_o(	m1s14_stb	),
		.s14_ack_i(	m1s14_ack	),
		.s14_err_i(	m1s14_err	),
		.s14_rty_i(	m1s14_rty	),
		.s15_data_i(	m1s15_data_i	),
		.s15_data_o(	m1s15_data_o	),
		.s15_addr_o(	m1s15_addr	),
		.s15_sel_o(	m1s15_sel	),
		.s15_we_o(	m1s15_we	),
		.s15_cyc_o(	m1s15_cyc	),
		.s15_stb_o(	m1s15_stb	),
		.s15_ack_i(	m1s15_ack	),
		.s15_err_i(	m1s15_err	),
		.s15_rty_i(	m1s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m2(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m2_data_i	),
		.wb_data_o(	m2_data_o	),
		.wb_addr_i(	m2_addr_i	),
		.wb_sel_i(	m2_sel_i	),
		.wb_we_i(	m2_we_i		),
		.wb_cyc_i(	m2_cyc_i	),
		.wb_stb_i(	m2_stb_i	),
		.wb_ack_o(	m2_ack_o	),
		.wb_err_o(	m2_err_o	),
		.wb_rty_o(	m2_rty_o	),
		.s0_data_i(	m2s0_data_i	),
		.s0_data_o(	m2s0_data_o	),
		.s0_addr_o(	m2s0_addr	),
		.s0_sel_o(	m2s0_sel	),
		.s0_we_o(	m2s0_we		),
		.s0_cyc_o(	m2s0_cyc	),
		.s0_stb_o(	m2s0_stb	),
		.s0_ack_i(	m2s0_ack	),
		.s0_err_i(	m2s0_err	),
		.s0_rty_i(	m2s0_rty	),
		.s1_data_i(	m2s1_data_i	),
		.s1_data_o(	m2s1_data_o	),
		.s1_addr_o(	m2s1_addr	),
		.s1_sel_o(	m2s1_sel	),
		.s1_we_o(	m2s1_we		),
		.s1_cyc_o(	m2s1_cyc	),
		.s1_stb_o(	m2s1_stb	),
		.s1_ack_i(	m2s1_ack	),
		.s1_err_i(	m2s1_err	),
		.s1_rty_i(	m2s1_rty	),
		.s2_data_i(	m2s2_data_i	),
		.s2_data_o(	m2s2_data_o	),
		.s2_addr_o(	m2s2_addr	),
		.s2_sel_o(	m2s2_sel	),
		.s2_we_o(	m2s2_we		),
		.s2_cyc_o(	m2s2_cyc	),
		.s2_stb_o(	m2s2_stb	),
		.s2_ack_i(	m2s2_ack	),
		.s2_err_i(	m2s2_err	),
		.s2_rty_i(	m2s2_rty	),
		.s3_data_i(	m2s3_data_i	),
		.s3_data_o(	m2s3_data_o	),
		.s3_addr_o(	m2s3_addr	),
		.s3_sel_o(	m2s3_sel	),
		.s3_we_o(	m2s3_we		),
		.s3_cyc_o(	m2s3_cyc	),
		.s3_stb_o(	m2s3_stb	),
		.s3_ack_i(	m2s3_ack	),
		.s3_err_i(	m2s3_err	),
		.s3_rty_i(	m2s3_rty	),
		.s4_data_i(	m2s4_data_i	),
		.s4_data_o(	m2s4_data_o	),
		.s4_addr_o(	m2s4_addr	),
		.s4_sel_o(	m2s4_sel	),
		.s4_we_o(	m2s4_we		),
		.s4_cyc_o(	m2s4_cyc	),
		.s4_stb_o(	m2s4_stb	),
		.s4_ack_i(	m2s4_ack	),
		.s4_err_i(	m2s4_err	),
		.s4_rty_i(	m2s4_rty	),
		.s5_data_i(	m2s5_data_i	),
		.s5_data_o(	m2s5_data_o	),
		.s5_addr_o(	m2s5_addr	),
		.s5_sel_o(	m2s5_sel	),
		.s5_we_o(	m2s5_we		),
		.s5_cyc_o(	m2s5_cyc	),
		.s5_stb_o(	m2s5_stb	),
		.s5_ack_i(	m2s5_ack	),
		.s5_err_i(	m2s5_err	),
		.s5_rty_i(	m2s5_rty	),
		.s6_data_i(	m2s6_data_i	),
		.s6_data_o(	m2s6_data_o	),
		.s6_addr_o(	m2s6_addr	),
		.s6_sel_o(	m2s6_sel	),
		.s6_we_o(	m2s6_we		),
		.s6_cyc_o(	m2s6_cyc	),
		.s6_stb_o(	m2s6_stb	),
		.s6_ack_i(	m2s6_ack	),
		.s6_err_i(	m2s6_err	),
		.s6_rty_i(	m2s6_rty	),
		.s7_data_i(	m2s7_data_i	),
		.s7_data_o(	m2s7_data_o	),
		.s7_addr_o(	m2s7_addr	),
		.s7_sel_o(	m2s7_sel	),
		.s7_we_o(	m2s7_we		),
		.s7_cyc_o(	m2s7_cyc	),
		.s7_stb_o(	m2s7_stb	),
		.s7_ack_i(	m2s7_ack	),
		.s7_err_i(	m2s7_err	),
		.s7_rty_i(	m2s7_rty	),
		.s8_data_i(	m2s8_data_i	),
		.s8_data_o(	m2s8_data_o	),
		.s8_addr_o(	m2s8_addr	),
		.s8_sel_o(	m2s8_sel	),
		.s8_we_o(	m2s8_we		),
		.s8_cyc_o(	m2s8_cyc	),
		.s8_stb_o(	m2s8_stb	),
		.s8_ack_i(	m2s8_ack	),
		.s8_err_i(	m2s8_err	),
		.s8_rty_i(	m2s8_rty	),
		.s9_data_i(	m2s9_data_i	),
		.s9_data_o(	m2s9_data_o	),
		.s9_addr_o(	m2s9_addr	),
		.s9_sel_o(	m2s9_sel	),
		.s9_we_o(	m2s9_we		),
		.s9_cyc_o(	m2s9_cyc	),
		.s9_stb_o(	m2s9_stb	),
		.s9_ack_i(	m2s9_ack	),
		.s9_err_i(	m2s9_err	),
		.s9_rty_i(	m2s9_rty	),
		.s10_data_i(	m2s10_data_i	),
		.s10_data_o(	m2s10_data_o	),
		.s10_addr_o(	m2s10_addr	),
		.s10_sel_o(	m2s10_sel	),
		.s10_we_o(	m2s10_we	),
		.s10_cyc_o(	m2s10_cyc	),
		.s10_stb_o(	m2s10_stb	),
		.s10_ack_i(	m2s10_ack	),
		.s10_err_i(	m2s10_err	),
		.s10_rty_i(	m2s10_rty	),
		.s11_data_i(	m2s11_data_i	),
		.s11_data_o(	m2s11_data_o	),
		.s11_addr_o(	m2s11_addr	),
		.s11_sel_o(	m2s11_sel	),
		.s11_we_o(	m2s11_we	),
		.s11_cyc_o(	m2s11_cyc	),
		.s11_stb_o(	m2s11_stb	),
		.s11_ack_i(	m2s11_ack	),
		.s11_err_i(	m2s11_err	),
		.s11_rty_i(	m2s11_rty	),
		.s12_data_i(	m2s12_data_i	),
		.s12_data_o(	m2s12_data_o	),
		.s12_addr_o(	m2s12_addr	),
		.s12_sel_o(	m2s12_sel	),
		.s12_we_o(	m2s12_we	),
		.s12_cyc_o(	m2s12_cyc	),
		.s12_stb_o(	m2s12_stb	),
		.s12_ack_i(	m2s12_ack	),
		.s12_err_i(	m2s12_err	),
		.s12_rty_i(	m2s12_rty	),
		.s13_data_i(	m2s13_data_i	),
		.s13_data_o(	m2s13_data_o	),
		.s13_addr_o(	m2s13_addr	),
		.s13_sel_o(	m2s13_sel	),
		.s13_we_o(	m2s13_we	),
		.s13_cyc_o(	m2s13_cyc	),
		.s13_stb_o(	m2s13_stb	),
		.s13_ack_i(	m2s13_ack	),
		.s13_err_i(	m2s13_err	),
		.s13_rty_i(	m2s13_rty	),
		.s14_data_i(	m2s14_data_i	),
		.s14_data_o(	m2s14_data_o	),
		.s14_addr_o(	m2s14_addr	),
		.s14_sel_o(	m2s14_sel	),
		.s14_we_o(	m2s14_we	),
		.s14_cyc_o(	m2s14_cyc	),
		.s14_stb_o(	m2s14_stb	),
		.s14_ack_i(	m2s14_ack	),
		.s14_err_i(	m2s14_err	),
		.s14_rty_i(	m2s14_rty	),
		.s15_data_i(	m2s15_data_i	),
		.s15_data_o(	m2s15_data_o	),
		.s15_addr_o(	m2s15_addr	),
		.s15_sel_o(	m2s15_sel	),
		.s15_we_o(	m2s15_we	),
		.s15_cyc_o(	m2s15_cyc	),
		.s15_stb_o(	m2s15_stb	),
		.s15_ack_i(	m2s15_ack	),
		.s15_err_i(	m2s15_err	),
		.s15_rty_i(	m2s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m3(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m3_data_i	),
		.wb_data_o(	m3_data_o	),
		.wb_addr_i(	m3_addr_i	),
		.wb_sel_i(	m3_sel_i	),
		.wb_we_i(	m3_we_i		),
		.wb_cyc_i(	m3_cyc_i	),
		.wb_stb_i(	m3_stb_i	),
		.wb_ack_o(	m3_ack_o	),
		.wb_err_o(	m3_err_o	),
		.wb_rty_o(	m3_rty_o	),
		.s0_data_i(	m3s0_data_i	),
		.s0_data_o(	m3s0_data_o	),
		.s0_addr_o(	m3s0_addr	),
		.s0_sel_o(	m3s0_sel	),
		.s0_we_o(	m3s0_we		),
		.s0_cyc_o(	m3s0_cyc	),
		.s0_stb_o(	m3s0_stb	),
		.s0_ack_i(	m3s0_ack	),
		.s0_err_i(	m3s0_err	),
		.s0_rty_i(	m3s0_rty	),
		.s1_data_i(	m3s1_data_i	),
		.s1_data_o(	m3s1_data_o	),
		.s1_addr_o(	m3s1_addr	),
		.s1_sel_o(	m3s1_sel	),
		.s1_we_o(	m3s1_we		),
		.s1_cyc_o(	m3s1_cyc	),
		.s1_stb_o(	m3s1_stb	),
		.s1_ack_i(	m3s1_ack	),
		.s1_err_i(	m3s1_err	),
		.s1_rty_i(	m3s1_rty	),
		.s2_data_i(	m3s2_data_i	),
		.s2_data_o(	m3s2_data_o	),
		.s2_addr_o(	m3s2_addr	),
		.s2_sel_o(	m3s2_sel	),
		.s2_we_o(	m3s2_we		),
		.s2_cyc_o(	m3s2_cyc	),
		.s2_stb_o(	m3s2_stb	),
		.s2_ack_i(	m3s2_ack	),
		.s2_err_i(	m3s2_err	),
		.s2_rty_i(	m3s2_rty	),
		.s3_data_i(	m3s3_data_i	),
		.s3_data_o(	m3s3_data_o	),
		.s3_addr_o(	m3s3_addr	),
		.s3_sel_o(	m3s3_sel	),
		.s3_we_o(	m3s3_we		),
		.s3_cyc_o(	m3s3_cyc	),
		.s3_stb_o(	m3s3_stb	),
		.s3_ack_i(	m3s3_ack	),
		.s3_err_i(	m3s3_err	),
		.s3_rty_i(	m3s3_rty	),
		.s4_data_i(	m3s4_data_i	),
		.s4_data_o(	m3s4_data_o	),
		.s4_addr_o(	m3s4_addr	),
		.s4_sel_o(	m3s4_sel	),
		.s4_we_o(	m3s4_we		),
		.s4_cyc_o(	m3s4_cyc	),
		.s4_stb_o(	m3s4_stb	),
		.s4_ack_i(	m3s4_ack	),
		.s4_err_i(	m3s4_err	),
		.s4_rty_i(	m3s4_rty	),
		.s5_data_i(	m3s5_data_i	),
		.s5_data_o(	m3s5_data_o	),
		.s5_addr_o(	m3s5_addr	),
		.s5_sel_o(	m3s5_sel	),
		.s5_we_o(	m3s5_we		),
		.s5_cyc_o(	m3s5_cyc	),
		.s5_stb_o(	m3s5_stb	),
		.s5_ack_i(	m3s5_ack	),
		.s5_err_i(	m3s5_err	),
		.s5_rty_i(	m3s5_rty	),
		.s6_data_i(	m3s6_data_i	),
		.s6_data_o(	m3s6_data_o	),
		.s6_addr_o(	m3s6_addr	),
		.s6_sel_o(	m3s6_sel	),
		.s6_we_o(	m3s6_we		),
		.s6_cyc_o(	m3s6_cyc	),
		.s6_stb_o(	m3s6_stb	),
		.s6_ack_i(	m3s6_ack	),
		.s6_err_i(	m3s6_err	),
		.s6_rty_i(	m3s6_rty	),
		.s7_data_i(	m3s7_data_i	),
		.s7_data_o(	m3s7_data_o	),
		.s7_addr_o(	m3s7_addr	),
		.s7_sel_o(	m3s7_sel	),
		.s7_we_o(	m3s7_we		),
		.s7_cyc_o(	m3s7_cyc	),
		.s7_stb_o(	m3s7_stb	),
		.s7_ack_i(	m3s7_ack	),
		.s7_err_i(	m3s7_err	),
		.s7_rty_i(	m3s7_rty	),
		.s8_data_i(	m3s8_data_i	),
		.s8_data_o(	m3s8_data_o	),
		.s8_addr_o(	m3s8_addr	),
		.s8_sel_o(	m3s8_sel	),
		.s8_we_o(	m3s8_we		),
		.s8_cyc_o(	m3s8_cyc	),
		.s8_stb_o(	m3s8_stb	),
		.s8_ack_i(	m3s8_ack	),
		.s8_err_i(	m3s8_err	),
		.s8_rty_i(	m3s8_rty	),
		.s9_data_i(	m3s9_data_i	),
		.s9_data_o(	m3s9_data_o	),
		.s9_addr_o(	m3s9_addr	),
		.s9_sel_o(	m3s9_sel	),
		.s9_we_o(	m3s9_we		),
		.s9_cyc_o(	m3s9_cyc	),
		.s9_stb_o(	m3s9_stb	),
		.s9_ack_i(	m3s9_ack	),
		.s9_err_i(	m3s9_err	),
		.s9_rty_i(	m3s9_rty	),
		.s10_data_i(	m3s10_data_i	),
		.s10_data_o(	m3s10_data_o	),
		.s10_addr_o(	m3s10_addr	),
		.s10_sel_o(	m3s10_sel	),
		.s10_we_o(	m3s10_we	),
		.s10_cyc_o(	m3s10_cyc	),
		.s10_stb_o(	m3s10_stb	),
		.s10_ack_i(	m3s10_ack	),
		.s10_err_i(	m3s10_err	),
		.s10_rty_i(	m3s10_rty	),
		.s11_data_i(	m3s11_data_i	),
		.s11_data_o(	m3s11_data_o	),
		.s11_addr_o(	m3s11_addr	),
		.s11_sel_o(	m3s11_sel	),
		.s11_we_o(	m3s11_we	),
		.s11_cyc_o(	m3s11_cyc	),
		.s11_stb_o(	m3s11_stb	),
		.s11_ack_i(	m3s11_ack	),
		.s11_err_i(	m3s11_err	),
		.s11_rty_i(	m3s11_rty	),
		.s12_data_i(	m3s12_data_i	),
		.s12_data_o(	m3s12_data_o	),
		.s12_addr_o(	m3s12_addr	),
		.s12_sel_o(	m3s12_sel	),
		.s12_we_o(	m3s12_we	),
		.s12_cyc_o(	m3s12_cyc	),
		.s12_stb_o(	m3s12_stb	),
		.s12_ack_i(	m3s12_ack	),
		.s12_err_i(	m3s12_err	),
		.s12_rty_i(	m3s12_rty	),
		.s13_data_i(	m3s13_data_i	),
		.s13_data_o(	m3s13_data_o	),
		.s13_addr_o(	m3s13_addr	),
		.s13_sel_o(	m3s13_sel	),
		.s13_we_o(	m3s13_we	),
		.s13_cyc_o(	m3s13_cyc	),
		.s13_stb_o(	m3s13_stb	),
		.s13_ack_i(	m3s13_ack	),
		.s13_err_i(	m3s13_err	),
		.s13_rty_i(	m3s13_rty	),
		.s14_data_i(	m3s14_data_i	),
		.s14_data_o(	m3s14_data_o	),
		.s14_addr_o(	m3s14_addr	),
		.s14_sel_o(	m3s14_sel	),
		.s14_we_o(	m3s14_we	),
		.s14_cyc_o(	m3s14_cyc	),
		.s14_stb_o(	m3s14_stb	),
		.s14_ack_i(	m3s14_ack	),
		.s14_err_i(	m3s14_err	),
		.s14_rty_i(	m3s14_rty	),
		.s15_data_i(	m3s15_data_i	),
		.s15_data_o(	m3s15_data_o	),
		.s15_addr_o(	m3s15_addr	),
		.s15_sel_o(	m3s15_sel	),
		.s15_we_o(	m3s15_we	),
		.s15_cyc_o(	m3s15_cyc	),
		.s15_stb_o(	m3s15_stb	),
		.s15_ack_i(	m3s15_ack	),
		.s15_err_i(	m3s15_err	),
		.s15_rty_i(	m3s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m4(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m4_data_i	),
		.wb_data_o(	m4_data_o	),
		.wb_addr_i(	m4_addr_i	),
		.wb_sel_i(	m4_sel_i	),
		.wb_we_i(	m4_we_i		),
		.wb_cyc_i(	m4_cyc_i	),
		.wb_stb_i(	m4_stb_i	),
		.wb_ack_o(	m4_ack_o	),
		.wb_err_o(	m4_err_o	),
		.wb_rty_o(	m4_rty_o	),
		.s0_data_i(	m4s0_data_i	),
		.s0_data_o(	m4s0_data_o	),
		.s0_addr_o(	m4s0_addr	),
		.s0_sel_o(	m4s0_sel	),
		.s0_we_o(	m4s0_we		),
		.s0_cyc_o(	m4s0_cyc	),
		.s0_stb_o(	m4s0_stb	),
		.s0_ack_i(	m4s0_ack	),
		.s0_err_i(	m4s0_err	),
		.s0_rty_i(	m4s0_rty	),
		.s1_data_i(	m4s1_data_i	),
		.s1_data_o(	m4s1_data_o	),
		.s1_addr_o(	m4s1_addr	),
		.s1_sel_o(	m4s1_sel	),
		.s1_we_o(	m4s1_we		),
		.s1_cyc_o(	m4s1_cyc	),
		.s1_stb_o(	m4s1_stb	),
		.s1_ack_i(	m4s1_ack	),
		.s1_err_i(	m4s1_err	),
		.s1_rty_i(	m4s1_rty	),
		.s2_data_i(	m4s2_data_i	),
		.s2_data_o(	m4s2_data_o	),
		.s2_addr_o(	m4s2_addr	),
		.s2_sel_o(	m4s2_sel	),
		.s2_we_o(	m4s2_we		),
		.s2_cyc_o(	m4s2_cyc	),
		.s2_stb_o(	m4s2_stb	),
		.s2_ack_i(	m4s2_ack	),
		.s2_err_i(	m4s2_err	),
		.s2_rty_i(	m4s2_rty	),
		.s3_data_i(	m4s3_data_i	),
		.s3_data_o(	m4s3_data_o	),
		.s3_addr_o(	m4s3_addr	),
		.s3_sel_o(	m4s3_sel	),
		.s3_we_o(	m4s3_we		),
		.s3_cyc_o(	m4s3_cyc	),
		.s3_stb_o(	m4s3_stb	),
		.s3_ack_i(	m4s3_ack	),
		.s3_err_i(	m4s3_err	),
		.s3_rty_i(	m4s3_rty	),
		.s4_data_i(	m4s4_data_i	),
		.s4_data_o(	m4s4_data_o	),
		.s4_addr_o(	m4s4_addr	),
		.s4_sel_o(	m4s4_sel	),
		.s4_we_o(	m4s4_we		),
		.s4_cyc_o(	m4s4_cyc	),
		.s4_stb_o(	m4s4_stb	),
		.s4_ack_i(	m4s4_ack	),
		.s4_err_i(	m4s4_err	),
		.s4_rty_i(	m4s4_rty	),
		.s5_data_i(	m4s5_data_i	),
		.s5_data_o(	m4s5_data_o	),
		.s5_addr_o(	m4s5_addr	),
		.s5_sel_o(	m4s5_sel	),
		.s5_we_o(	m4s5_we		),
		.s5_cyc_o(	m4s5_cyc	),
		.s5_stb_o(	m4s5_stb	),
		.s5_ack_i(	m4s5_ack	),
		.s5_err_i(	m4s5_err	),
		.s5_rty_i(	m4s5_rty	),
		.s6_data_i(	m4s6_data_i	),
		.s6_data_o(	m4s6_data_o	),
		.s6_addr_o(	m4s6_addr	),
		.s6_sel_o(	m4s6_sel	),
		.s6_we_o(	m4s6_we		),
		.s6_cyc_o(	m4s6_cyc	),
		.s6_stb_o(	m4s6_stb	),
		.s6_ack_i(	m4s6_ack	),
		.s6_err_i(	m4s6_err	),
		.s6_rty_i(	m4s6_rty	),
		.s7_data_i(	m4s7_data_i	),
		.s7_data_o(	m4s7_data_o	),
		.s7_addr_o(	m4s7_addr	),
		.s7_sel_o(	m4s7_sel	),
		.s7_we_o(	m4s7_we		),
		.s7_cyc_o(	m4s7_cyc	),
		.s7_stb_o(	m4s7_stb	),
		.s7_ack_i(	m4s7_ack	),
		.s7_err_i(	m4s7_err	),
		.s7_rty_i(	m4s7_rty	),
		.s8_data_i(	m4s8_data_i	),
		.s8_data_o(	m4s8_data_o	),
		.s8_addr_o(	m4s8_addr	),
		.s8_sel_o(	m4s8_sel	),
		.s8_we_o(	m4s8_we		),
		.s8_cyc_o(	m4s8_cyc	),
		.s8_stb_o(	m4s8_stb	),
		.s8_ack_i(	m4s8_ack	),
		.s8_err_i(	m4s8_err	),
		.s8_rty_i(	m4s8_rty	),
		.s9_data_i(	m4s9_data_i	),
		.s9_data_o(	m4s9_data_o	),
		.s9_addr_o(	m4s9_addr	),
		.s9_sel_o(	m4s9_sel	),
		.s9_we_o(	m4s9_we		),
		.s9_cyc_o(	m4s9_cyc	),
		.s9_stb_o(	m4s9_stb	),
		.s9_ack_i(	m4s9_ack	),
		.s9_err_i(	m4s9_err	),
		.s9_rty_i(	m4s9_rty	),
		.s10_data_i(	m4s10_data_i	),
		.s10_data_o(	m4s10_data_o	),
		.s10_addr_o(	m4s10_addr	),
		.s10_sel_o(	m4s10_sel	),
		.s10_we_o(	m4s10_we	),
		.s10_cyc_o(	m4s10_cyc	),
		.s10_stb_o(	m4s10_stb	),
		.s10_ack_i(	m4s10_ack	),
		.s10_err_i(	m4s10_err	),
		.s10_rty_i(	m4s10_rty	),
		.s11_data_i(	m4s11_data_i	),
		.s11_data_o(	m4s11_data_o	),
		.s11_addr_o(	m4s11_addr	),
		.s11_sel_o(	m4s11_sel	),
		.s11_we_o(	m4s11_we	),
		.s11_cyc_o(	m4s11_cyc	),
		.s11_stb_o(	m4s11_stb	),
		.s11_ack_i(	m4s11_ack	),
		.s11_err_i(	m4s11_err	),
		.s11_rty_i(	m4s11_rty	),
		.s12_data_i(	m4s12_data_i	),
		.s12_data_o(	m4s12_data_o	),
		.s12_addr_o(	m4s12_addr	),
		.s12_sel_o(	m4s12_sel	),
		.s12_we_o(	m4s12_we	),
		.s12_cyc_o(	m4s12_cyc	),
		.s12_stb_o(	m4s12_stb	),
		.s12_ack_i(	m4s12_ack	),
		.s12_err_i(	m4s12_err	),
		.s12_rty_i(	m4s12_rty	),
		.s13_data_i(	m4s13_data_i	),
		.s13_data_o(	m4s13_data_o	),
		.s13_addr_o(	m4s13_addr	),
		.s13_sel_o(	m4s13_sel	),
		.s13_we_o(	m4s13_we	),
		.s13_cyc_o(	m4s13_cyc	),
		.s13_stb_o(	m4s13_stb	),
		.s13_ack_i(	m4s13_ack	),
		.s13_err_i(	m4s13_err	),
		.s13_rty_i(	m4s13_rty	),
		.s14_data_i(	m4s14_data_i	),
		.s14_data_o(	m4s14_data_o	),
		.s14_addr_o(	m4s14_addr	),
		.s14_sel_o(	m4s14_sel	),
		.s14_we_o(	m4s14_we	),
		.s14_cyc_o(	m4s14_cyc	),
		.s14_stb_o(	m4s14_stb	),
		.s14_ack_i(	m4s14_ack	),
		.s14_err_i(	m4s14_err	),
		.s14_rty_i(	m4s14_rty	),
		.s15_data_i(	m4s15_data_i	),
		.s15_data_o(	m4s15_data_o	),
		.s15_addr_o(	m4s15_addr	),
		.s15_sel_o(	m4s15_sel	),
		.s15_we_o(	m4s15_we	),
		.s15_cyc_o(	m4s15_cyc	),
		.s15_stb_o(	m4s15_stb	),
		.s15_ack_i(	m4s15_ack	),
		.s15_err_i(	m4s15_err	),
		.s15_rty_i(	m4s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m5(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m5_data_i	),
		.wb_data_o(	m5_data_o	),
		.wb_addr_i(	m5_addr_i	),
		.wb_sel_i(	m5_sel_i	),
		.wb_we_i(	m5_we_i		),
		.wb_cyc_i(	m5_cyc_i	),
		.wb_stb_i(	m5_stb_i	),
		.wb_ack_o(	m5_ack_o	),
		.wb_err_o(	m5_err_o	),
		.wb_rty_o(	m5_rty_o	),
		.s0_data_i(	m5s0_data_i	),
		.s0_data_o(	m5s0_data_o	),
		.s0_addr_o(	m5s0_addr	),
		.s0_sel_o(	m5s0_sel	),
		.s0_we_o(	m5s0_we		),
		.s0_cyc_o(	m5s0_cyc	),
		.s0_stb_o(	m5s0_stb	),
		.s0_ack_i(	m5s0_ack	),
		.s0_err_i(	m5s0_err	),
		.s0_rty_i(	m5s0_rty	),
		.s1_data_i(	m5s1_data_i	),
		.s1_data_o(	m5s1_data_o	),
		.s1_addr_o(	m5s1_addr	),
		.s1_sel_o(	m5s1_sel	),
		.s1_we_o(	m5s1_we		),
		.s1_cyc_o(	m5s1_cyc	),
		.s1_stb_o(	m5s1_stb	),
		.s1_ack_i(	m5s1_ack	),
		.s1_err_i(	m5s1_err	),
		.s1_rty_i(	m5s1_rty	),
		.s2_data_i(	m5s2_data_i	),
		.s2_data_o(	m5s2_data_o	),
		.s2_addr_o(	m5s2_addr	),
		.s2_sel_o(	m5s2_sel	),
		.s2_we_o(	m5s2_we		),
		.s2_cyc_o(	m5s2_cyc	),
		.s2_stb_o(	m5s2_stb	),
		.s2_ack_i(	m5s2_ack	),
		.s2_err_i(	m5s2_err	),
		.s2_rty_i(	m5s2_rty	),
		.s3_data_i(	m5s3_data_i	),
		.s3_data_o(	m5s3_data_o	),
		.s3_addr_o(	m5s3_addr	),
		.s3_sel_o(	m5s3_sel	),
		.s3_we_o(	m5s3_we		),
		.s3_cyc_o(	m5s3_cyc	),
		.s3_stb_o(	m5s3_stb	),
		.s3_ack_i(	m5s3_ack	),
		.s3_err_i(	m5s3_err	),
		.s3_rty_i(	m5s3_rty	),
		.s4_data_i(	m5s4_data_i	),
		.s4_data_o(	m5s4_data_o	),
		.s4_addr_o(	m5s4_addr	),
		.s4_sel_o(	m5s4_sel	),
		.s4_we_o(	m5s4_we		),
		.s4_cyc_o(	m5s4_cyc	),
		.s4_stb_o(	m5s4_stb	),
		.s4_ack_i(	m5s4_ack	),
		.s4_err_i(	m5s4_err	),
		.s4_rty_i(	m5s4_rty	),
		.s5_data_i(	m5s5_data_i	),
		.s5_data_o(	m5s5_data_o	),
		.s5_addr_o(	m5s5_addr	),
		.s5_sel_o(	m5s5_sel	),
		.s5_we_o(	m5s5_we		),
		.s5_cyc_o(	m5s5_cyc	),
		.s5_stb_o(	m5s5_stb	),
		.s5_ack_i(	m5s5_ack	),
		.s5_err_i(	m5s5_err	),
		.s5_rty_i(	m5s5_rty	),
		.s6_data_i(	m5s6_data_i	),
		.s6_data_o(	m5s6_data_o	),
		.s6_addr_o(	m5s6_addr	),
		.s6_sel_o(	m5s6_sel	),
		.s6_we_o(	m5s6_we		),
		.s6_cyc_o(	m5s6_cyc	),
		.s6_stb_o(	m5s6_stb	),
		.s6_ack_i(	m5s6_ack	),
		.s6_err_i(	m5s6_err	),
		.s6_rty_i(	m5s6_rty	),
		.s7_data_i(	m5s7_data_i	),
		.s7_data_o(	m5s7_data_o	),
		.s7_addr_o(	m5s7_addr	),
		.s7_sel_o(	m5s7_sel	),
		.s7_we_o(	m5s7_we		),
		.s7_cyc_o(	m5s7_cyc	),
		.s7_stb_o(	m5s7_stb	),
		.s7_ack_i(	m5s7_ack	),
		.s7_err_i(	m5s7_err	),
		.s7_rty_i(	m5s7_rty	),
		.s8_data_i(	m5s8_data_i	),
		.s8_data_o(	m5s8_data_o	),
		.s8_addr_o(	m5s8_addr	),
		.s8_sel_o(	m5s8_sel	),
		.s8_we_o(	m5s8_we		),
		.s8_cyc_o(	m5s8_cyc	),
		.s8_stb_o(	m5s8_stb	),
		.s8_ack_i(	m5s8_ack	),
		.s8_err_i(	m5s8_err	),
		.s8_rty_i(	m5s8_rty	),
		.s9_data_i(	m5s9_data_i	),
		.s9_data_o(	m5s9_data_o	),
		.s9_addr_o(	m5s9_addr	),
		.s9_sel_o(	m5s9_sel	),
		.s9_we_o(	m5s9_we		),
		.s9_cyc_o(	m5s9_cyc	),
		.s9_stb_o(	m5s9_stb	),
		.s9_ack_i(	m5s9_ack	),
		.s9_err_i(	m5s9_err	),
		.s9_rty_i(	m5s9_rty	),
		.s10_data_i(	m5s10_data_i	),
		.s10_data_o(	m5s10_data_o	),
		.s10_addr_o(	m5s10_addr	),
		.s10_sel_o(	m5s10_sel	),
		.s10_we_o(	m5s10_we	),
		.s10_cyc_o(	m5s10_cyc	),
		.s10_stb_o(	m5s10_stb	),
		.s10_ack_i(	m5s10_ack	),
		.s10_err_i(	m5s10_err	),
		.s10_rty_i(	m5s10_rty	),
		.s11_data_i(	m5s11_data_i	),
		.s11_data_o(	m5s11_data_o	),
		.s11_addr_o(	m5s11_addr	),
		.s11_sel_o(	m5s11_sel	),
		.s11_we_o(	m5s11_we	),
		.s11_cyc_o(	m5s11_cyc	),
		.s11_stb_o(	m5s11_stb	),
		.s11_ack_i(	m5s11_ack	),
		.s11_err_i(	m5s11_err	),
		.s11_rty_i(	m5s11_rty	),
		.s12_data_i(	m5s12_data_i	),
		.s12_data_o(	m5s12_data_o	),
		.s12_addr_o(	m5s12_addr	),
		.s12_sel_o(	m5s12_sel	),
		.s12_we_o(	m5s12_we	),
		.s12_cyc_o(	m5s12_cyc	),
		.s12_stb_o(	m5s12_stb	),
		.s12_ack_i(	m5s12_ack	),
		.s12_err_i(	m5s12_err	),
		.s12_rty_i(	m5s12_rty	),
		.s13_data_i(	m5s13_data_i	),
		.s13_data_o(	m5s13_data_o	),
		.s13_addr_o(	m5s13_addr	),
		.s13_sel_o(	m5s13_sel	),
		.s13_we_o(	m5s13_we	),
		.s13_cyc_o(	m5s13_cyc	),
		.s13_stb_o(	m5s13_stb	),
		.s13_ack_i(	m5s13_ack	),
		.s13_err_i(	m5s13_err	),
		.s13_rty_i(	m5s13_rty	),
		.s14_data_i(	m5s14_data_i	),
		.s14_data_o(	m5s14_data_o	),
		.s14_addr_o(	m5s14_addr	),
		.s14_sel_o(	m5s14_sel	),
		.s14_we_o(	m5s14_we	),
		.s14_cyc_o(	m5s14_cyc	),
		.s14_stb_o(	m5s14_stb	),
		.s14_ack_i(	m5s14_ack	),
		.s14_err_i(	m5s14_err	),
		.s14_rty_i(	m5s14_rty	),
		.s15_data_i(	m5s15_data_i	),
		.s15_data_o(	m5s15_data_o	),
		.s15_addr_o(	m5s15_addr	),
		.s15_sel_o(	m5s15_sel	),
		.s15_we_o(	m5s15_we	),
		.s15_cyc_o(	m5s15_cyc	),
		.s15_stb_o(	m5s15_stb	),
		.s15_ack_i(	m5s15_ack	),
		.s15_err_i(	m5s15_err	),
		.s15_rty_i(	m5s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m6(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m6_data_i	),
		.wb_data_o(	m6_data_o	),
		.wb_addr_i(	m6_addr_i	),
		.wb_sel_i(	m6_sel_i	),
		.wb_we_i(	m6_we_i		),
		.wb_cyc_i(	m6_cyc_i	),
		.wb_stb_i(	m6_stb_i	),
		.wb_ack_o(	m6_ack_o	),
		.wb_err_o(	m6_err_o	),
		.wb_rty_o(	m6_rty_o	),
		.s0_data_i(	m6s0_data_i	),
		.s0_data_o(	m6s0_data_o	),
		.s0_addr_o(	m6s0_addr	),
		.s0_sel_o(	m6s0_sel	),
		.s0_we_o(	m6s0_we		),
		.s0_cyc_o(	m6s0_cyc	),
		.s0_stb_o(	m6s0_stb	),
		.s0_ack_i(	m6s0_ack	),
		.s0_err_i(	m6s0_err	),
		.s0_rty_i(	m6s0_rty	),
		.s1_data_i(	m6s1_data_i	),
		.s1_data_o(	m6s1_data_o	),
		.s1_addr_o(	m6s1_addr	),
		.s1_sel_o(	m6s1_sel	),
		.s1_we_o(	m6s1_we		),
		.s1_cyc_o(	m6s1_cyc	),
		.s1_stb_o(	m6s1_stb	),
		.s1_ack_i(	m6s1_ack	),
		.s1_err_i(	m6s1_err	),
		.s1_rty_i(	m6s1_rty	),
		.s2_data_i(	m6s2_data_i	),
		.s2_data_o(	m6s2_data_o	),
		.s2_addr_o(	m6s2_addr	),
		.s2_sel_o(	m6s2_sel	),
		.s2_we_o(	m6s2_we		),
		.s2_cyc_o(	m6s2_cyc	),
		.s2_stb_o(	m6s2_stb	),
		.s2_ack_i(	m6s2_ack	),
		.s2_err_i(	m6s2_err	),
		.s2_rty_i(	m6s2_rty	),
		.s3_data_i(	m6s3_data_i	),
		.s3_data_o(	m6s3_data_o	),
		.s3_addr_o(	m6s3_addr	),
		.s3_sel_o(	m6s3_sel	),
		.s3_we_o(	m6s3_we		),
		.s3_cyc_o(	m6s3_cyc	),
		.s3_stb_o(	m6s3_stb	),
		.s3_ack_i(	m6s3_ack	),
		.s3_err_i(	m6s3_err	),
		.s3_rty_i(	m6s3_rty	),
		.s4_data_i(	m6s4_data_i	),
		.s4_data_o(	m6s4_data_o	),
		.s4_addr_o(	m6s4_addr	),
		.s4_sel_o(	m6s4_sel	),
		.s4_we_o(	m6s4_we		),
		.s4_cyc_o(	m6s4_cyc	),
		.s4_stb_o(	m6s4_stb	),
		.s4_ack_i(	m6s4_ack	),
		.s4_err_i(	m6s4_err	),
		.s4_rty_i(	m6s4_rty	),
		.s5_data_i(	m6s5_data_i	),
		.s5_data_o(	m6s5_data_o	),
		.s5_addr_o(	m6s5_addr	),
		.s5_sel_o(	m6s5_sel	),
		.s5_we_o(	m6s5_we		),
		.s5_cyc_o(	m6s5_cyc	),
		.s5_stb_o(	m6s5_stb	),
		.s5_ack_i(	m6s5_ack	),
		.s5_err_i(	m6s5_err	),
		.s5_rty_i(	m6s5_rty	),
		.s6_data_i(	m6s6_data_i	),
		.s6_data_o(	m6s6_data_o	),
		.s6_addr_o(	m6s6_addr	),
		.s6_sel_o(	m6s6_sel	),
		.s6_we_o(	m6s6_we		),
		.s6_cyc_o(	m6s6_cyc	),
		.s6_stb_o(	m6s6_stb	),
		.s6_ack_i(	m6s6_ack	),
		.s6_err_i(	m6s6_err	),
		.s6_rty_i(	m6s6_rty	),
		.s7_data_i(	m6s7_data_i	),
		.s7_data_o(	m6s7_data_o	),
		.s7_addr_o(	m6s7_addr	),
		.s7_sel_o(	m6s7_sel	),
		.s7_we_o(	m6s7_we		),
		.s7_cyc_o(	m6s7_cyc	),
		.s7_stb_o(	m6s7_stb	),
		.s7_ack_i(	m6s7_ack	),
		.s7_err_i(	m6s7_err	),
		.s7_rty_i(	m6s7_rty	),
		.s8_data_i(	m6s8_data_i	),
		.s8_data_o(	m6s8_data_o	),
		.s8_addr_o(	m6s8_addr	),
		.s8_sel_o(	m6s8_sel	),
		.s8_we_o(	m6s8_we		),
		.s8_cyc_o(	m6s8_cyc	),
		.s8_stb_o(	m6s8_stb	),
		.s8_ack_i(	m6s8_ack	),
		.s8_err_i(	m6s8_err	),
		.s8_rty_i(	m6s8_rty	),
		.s9_data_i(	m6s9_data_i	),
		.s9_data_o(	m6s9_data_o	),
		.s9_addr_o(	m6s9_addr	),
		.s9_sel_o(	m6s9_sel	),
		.s9_we_o(	m6s9_we		),
		.s9_cyc_o(	m6s9_cyc	),
		.s9_stb_o(	m6s9_stb	),
		.s9_ack_i(	m6s9_ack	),
		.s9_err_i(	m6s9_err	),
		.s9_rty_i(	m6s9_rty	),
		.s10_data_i(	m6s10_data_i	),
		.s10_data_o(	m6s10_data_o	),
		.s10_addr_o(	m6s10_addr	),
		.s10_sel_o(	m6s10_sel	),
		.s10_we_o(	m6s10_we	),
		.s10_cyc_o(	m6s10_cyc	),
		.s10_stb_o(	m6s10_stb	),
		.s10_ack_i(	m6s10_ack	),
		.s10_err_i(	m6s10_err	),
		.s10_rty_i(	m6s10_rty	),
		.s11_data_i(	m6s11_data_i	),
		.s11_data_o(	m6s11_data_o	),
		.s11_addr_o(	m6s11_addr	),
		.s11_sel_o(	m6s11_sel	),
		.s11_we_o(	m6s11_we	),
		.s11_cyc_o(	m6s11_cyc	),
		.s11_stb_o(	m6s11_stb	),
		.s11_ack_i(	m6s11_ack	),
		.s11_err_i(	m6s11_err	),
		.s11_rty_i(	m6s11_rty	),
		.s12_data_i(	m6s12_data_i	),
		.s12_data_o(	m6s12_data_o	),
		.s12_addr_o(	m6s12_addr	),
		.s12_sel_o(	m6s12_sel	),
		.s12_we_o(	m6s12_we	),
		.s12_cyc_o(	m6s12_cyc	),
		.s12_stb_o(	m6s12_stb	),
		.s12_ack_i(	m6s12_ack	),
		.s12_err_i(	m6s12_err	),
		.s12_rty_i(	m6s12_rty	),
		.s13_data_i(	m6s13_data_i	),
		.s13_data_o(	m6s13_data_o	),
		.s13_addr_o(	m6s13_addr	),
		.s13_sel_o(	m6s13_sel	),
		.s13_we_o(	m6s13_we	),
		.s13_cyc_o(	m6s13_cyc	),
		.s13_stb_o(	m6s13_stb	),
		.s13_ack_i(	m6s13_ack	),
		.s13_err_i(	m6s13_err	),
		.s13_rty_i(	m6s13_rty	),
		.s14_data_i(	m6s14_data_i	),
		.s14_data_o(	m6s14_data_o	),
		.s14_addr_o(	m6s14_addr	),
		.s14_sel_o(	m6s14_sel	),
		.s14_we_o(	m6s14_we	),
		.s14_cyc_o(	m6s14_cyc	),
		.s14_stb_o(	m6s14_stb	),
		.s14_ack_i(	m6s14_ack	),
		.s14_err_i(	m6s14_err	),
		.s14_rty_i(	m6s14_rty	),
		.s15_data_i(	m6s15_data_i	),
		.s15_data_o(	m6s15_data_o	),
		.s15_addr_o(	m6s15_addr	),
		.s15_sel_o(	m6s15_sel	),
		.s15_we_o(	m6s15_we	),
		.s15_cyc_o(	m6s15_cyc	),
		.s15_stb_o(	m6s15_stb	),
		.s15_ack_i(	m6s15_ack	),
		.s15_err_i(	m6s15_err	),
		.s15_rty_i(	m6s15_rty	)
		);

wb_conmax_master_if #(dw,aw,sw)	m7(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.wb_data_i(	m7_data_i	),
		.wb_data_o(	m7_data_o	),
		.wb_addr_i(	m7_addr_i	),
		.wb_sel_i(	m7_sel_i	),
		.wb_we_i(	m7_we_i		),
		.wb_cyc_i(	m7_cyc_i	),
		.wb_stb_i(	m7_stb_i	),
		.wb_ack_o(	m7_ack_o	),
		.wb_err_o(	m7_err_o	),
		.wb_rty_o(	m7_rty_o	),
		.s0_data_i(	m7s0_data_i	),
		.s0_data_o(	m7s0_data_o	),
		.s0_addr_o(	m7s0_addr	),
		.s0_sel_o(	m7s0_sel	),
		.s0_we_o(	m7s0_we		),
		.s0_cyc_o(	m7s0_cyc	),
		.s0_stb_o(	m7s0_stb	),
		.s0_ack_i(	m7s0_ack	),
		.s0_err_i(	m7s0_err	),
		.s0_rty_i(	m7s0_rty	),
		.s1_data_i(	m7s1_data_i	),
		.s1_data_o(	m7s1_data_o	),
		.s1_addr_o(	m7s1_addr	),
		.s1_sel_o(	m7s1_sel	),
		.s1_we_o(	m7s1_we		),
		.s1_cyc_o(	m7s1_cyc	),
		.s1_stb_o(	m7s1_stb	),
		.s1_ack_i(	m7s1_ack	),
		.s1_err_i(	m7s1_err	),
		.s1_rty_i(	m7s1_rty	),
		.s2_data_i(	m7s2_data_i	),
		.s2_data_o(	m7s2_data_o	),
		.s2_addr_o(	m7s2_addr	),
		.s2_sel_o(	m7s2_sel	),
		.s2_we_o(	m7s2_we		),
		.s2_cyc_o(	m7s2_cyc	),
		.s2_stb_o(	m7s2_stb	),
		.s2_ack_i(	m7s2_ack	),
		.s2_err_i(	m7s2_err	),
		.s2_rty_i(	m7s2_rty	),
		.s3_data_i(	m7s3_data_i	),
		.s3_data_o(	m7s3_data_o	),
		.s3_addr_o(	m7s3_addr	),
		.s3_sel_o(	m7s3_sel	),
		.s3_we_o(	m7s3_we		),
		.s3_cyc_o(	m7s3_cyc	),
		.s3_stb_o(	m7s3_stb	),
		.s3_ack_i(	m7s3_ack	),
		.s3_err_i(	m7s3_err	),
		.s3_rty_i(	m7s3_rty	),
		.s4_data_i(	m7s4_data_i	),
		.s4_data_o(	m7s4_data_o	),
		.s4_addr_o(	m7s4_addr	),
		.s4_sel_o(	m7s4_sel	),
		.s4_we_o(	m7s4_we		),
		.s4_cyc_o(	m7s4_cyc	),
		.s4_stb_o(	m7s4_stb	),
		.s4_ack_i(	m7s4_ack	),
		.s4_err_i(	m7s4_err	),
		.s4_rty_i(	m7s4_rty	),
		.s5_data_i(	m7s5_data_i	),
		.s5_data_o(	m7s5_data_o	),
		.s5_addr_o(	m7s5_addr	),
		.s5_sel_o(	m7s5_sel	),
		.s5_we_o(	m7s5_we		),
		.s5_cyc_o(	m7s5_cyc	),
		.s5_stb_o(	m7s5_stb	),
		.s5_ack_i(	m7s5_ack	),
		.s5_err_i(	m7s5_err	),
		.s5_rty_i(	m7s5_rty	),
		.s6_data_i(	m7s6_data_i	),
		.s6_data_o(	m7s6_data_o	),
		.s6_addr_o(	m7s6_addr	),
		.s6_sel_o(	m7s6_sel	),
		.s6_we_o(	m7s6_we		),
		.s6_cyc_o(	m7s6_cyc	),
		.s6_stb_o(	m7s6_stb	),
		.s6_ack_i(	m7s6_ack	),
		.s6_err_i(	m7s6_err	),
		.s6_rty_i(	m7s6_rty	),
		.s7_data_i(	m7s7_data_i	),
		.s7_data_o(	m7s7_data_o	),
		.s7_addr_o(	m7s7_addr	),
		.s7_sel_o(	m7s7_sel	),
		.s7_we_o(	m7s7_we		),
		.s7_cyc_o(	m7s7_cyc	),
		.s7_stb_o(	m7s7_stb	),
		.s7_ack_i(	m7s7_ack	),
		.s7_err_i(	m7s7_err	),
		.s7_rty_i(	m7s7_rty	),
		.s8_data_i(	m7s8_data_i	),
		.s8_data_o(	m7s8_data_o	),
		.s8_addr_o(	m7s8_addr	),
		.s8_sel_o(	m7s8_sel	),
		.s8_we_o(	m7s8_we		),
		.s8_cyc_o(	m7s8_cyc	),
		.s8_stb_o(	m7s8_stb	),
		.s8_ack_i(	m7s8_ack	),
		.s8_err_i(	m7s8_err	),
		.s8_rty_i(	m7s8_rty	),
		.s9_data_i(	m7s9_data_i	),
		.s9_data_o(	m7s9_data_o	),
		.s9_addr_o(	m7s9_addr	),
		.s9_sel_o(	m7s9_sel	),
		.s9_we_o(	m7s9_we		),
		.s9_cyc_o(	m7s9_cyc	),
		.s9_stb_o(	m7s9_stb	),
		.s9_ack_i(	m7s9_ack	),
		.s9_err_i(	m7s9_err	),
		.s9_rty_i(	m7s9_rty	),
		.s10_data_i(	m7s10_data_i	),
		.s10_data_o(	m7s10_data_o	),
		.s10_addr_o(	m7s10_addr	),
		.s10_sel_o(	m7s10_sel	),
		.s10_we_o(	m7s10_we	),
		.s10_cyc_o(	m7s10_cyc	),
		.s10_stb_o(	m7s10_stb	),
		.s10_ack_i(	m7s10_ack	),
		.s10_err_i(	m7s10_err	),
		.s10_rty_i(	m7s10_rty	),
		.s11_data_i(	m7s11_data_i	),
		.s11_data_o(	m7s11_data_o	),
		.s11_addr_o(	m7s11_addr	),
		.s11_sel_o(	m7s11_sel	),
		.s11_we_o(	m7s11_we	),
		.s11_cyc_o(	m7s11_cyc	),
		.s11_stb_o(	m7s11_stb	),
		.s11_ack_i(	m7s11_ack	),
		.s11_err_i(	m7s11_err	),
		.s11_rty_i(	m7s11_rty	),
		.s12_data_i(	m7s12_data_i	),
		.s12_data_o(	m7s12_data_o	),
		.s12_addr_o(	m7s12_addr	),
		.s12_sel_o(	m7s12_sel	),
		.s12_we_o(	m7s12_we	),
		.s12_cyc_o(	m7s12_cyc	),
		.s12_stb_o(	m7s12_stb	),
		.s12_ack_i(	m7s12_ack	),
		.s12_err_i(	m7s12_err	),
		.s12_rty_i(	m7s12_rty	),
		.s13_data_i(	m7s13_data_i	),
		.s13_data_o(	m7s13_data_o	),
		.s13_addr_o(	m7s13_addr	),
		.s13_sel_o(	m7s13_sel	),
		.s13_we_o(	m7s13_we	),
		.s13_cyc_o(	m7s13_cyc	),
		.s13_stb_o(	m7s13_stb	),
		.s13_ack_i(	m7s13_ack	),
		.s13_err_i(	m7s13_err	),
		.s13_rty_i(	m7s13_rty	),
		.s14_data_i(	m7s14_data_i	),
		.s14_data_o(	m7s14_data_o	),
		.s14_addr_o(	m7s14_addr	),
		.s14_sel_o(	m7s14_sel	),
		.s14_we_o(	m7s14_we	),
		.s14_cyc_o(	m7s14_cyc	),
		.s14_stb_o(	m7s14_stb	),
		.s14_ack_i(	m7s14_ack	),
		.s14_err_i(	m7s14_err	),
		.s14_rty_i(	m7s14_rty	),
		.s15_data_i(	m7s15_data_i	),
		.s15_data_o(	m7s15_data_o	),
		.s15_addr_o(	m7s15_addr	),
		.s15_sel_o(	m7s15_sel	),
		.s15_we_o(	m7s15_we	),
		.s15_cyc_o(	m7s15_cyc	),
		.s15_stb_o(	m7s15_stb	),
		.s15_ack_i(	m7s15_ack	),
		.s15_err_i(	m7s15_err	),
		.s15_rty_i(	m7s15_rty	)
		);

////////////////////////////////////////////////////////////////////
//
// Slave Interfaces
//

wb_conmax_slave_if #(pri_sel0,aw,dw,sw) s0(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf0		),
		.wb_data_i(	s0_data_i	),
		.wb_data_o(	s0_data_o	),
		.wb_addr_o(	s0_addr_o	),
		.wb_sel_o(	s0_sel_o	),
		.wb_we_o(	s0_we_o		),
		.wb_cyc_o(	s0_cyc_o	),
		.wb_stb_o(	s0_stb_o	),
		.wb_ack_i(	s0_ack_i	),
		.wb_err_i(	s0_err_i	),
		.wb_rty_i(	s0_rty_i	),
		.m0_data_i(	m0s0_data_o	),
		.m0_data_o(	m0s0_data_i	),
		.m0_addr_i(	m0s0_addr	),
		.m0_sel_i(	m0s0_sel	),
		.m0_we_i(	m0s0_we	),
		.m0_cyc_i(	m0s0_cyc	),
		.m0_stb_i(	m0s0_stb	),
		.m0_ack_o(	m0s0_ack	),
		.m0_err_o(	m0s0_err	),
		.m0_rty_o(	m0s0_rty	),
		.m1_data_i(	m1s0_data_o	),
		.m1_data_o(	m1s0_data_i	),
		.m1_addr_i(	m1s0_addr	),
		.m1_sel_i(	m1s0_sel	),
		.m1_we_i(	m1s0_we	),
		.m1_cyc_i(	m1s0_cyc	),
		.m1_stb_i(	m1s0_stb	),
		.m1_ack_o(	m1s0_ack	),
		.m1_err_o(	m1s0_err	),
		.m1_rty_o(	m1s0_rty	),
		.m2_data_i(	m2s0_data_o	),
		.m2_data_o(	m2s0_data_i	),
		.m2_addr_i(	m2s0_addr	),
		.m2_sel_i(	m2s0_sel	),
		.m2_we_i(	m2s0_we	),
		.m2_cyc_i(	m2s0_cyc	),
		.m2_stb_i(	m2s0_stb	),
		.m2_ack_o(	m2s0_ack	),
		.m2_err_o(	m2s0_err	),
		.m2_rty_o(	m2s0_rty	),
		.m3_data_i(	m3s0_data_o	),
		.m3_data_o(	m3s0_data_i	),
		.m3_addr_i(	m3s0_addr	),
		.m3_sel_i(	m3s0_sel	),
		.m3_we_i(	m3s0_we	),
		.m3_cyc_i(	m3s0_cyc	),
		.m3_stb_i(	m3s0_stb	),
		.m3_ack_o(	m3s0_ack	),
		.m3_err_o(	m3s0_err	),
		.m3_rty_o(	m3s0_rty	),
		.m4_data_i(	m4s0_data_o	),
		.m4_data_o(	m4s0_data_i	),
		.m4_addr_i(	m4s0_addr	),
		.m4_sel_i(	m4s0_sel	),
		.m4_we_i(	m4s0_we	),
		.m4_cyc_i(	m4s0_cyc	),
		.m4_stb_i(	m4s0_stb	),
		.m4_ack_o(	m4s0_ack	),
		.m4_err_o(	m4s0_err	),
		.m4_rty_o(	m4s0_rty	),
		.m5_data_i(	m5s0_data_o	),
		.m5_data_o(	m5s0_data_i	),
		.m5_addr_i(	m5s0_addr	),
		.m5_sel_i(	m5s0_sel	),
		.m5_we_i(	m5s0_we	),
		.m5_cyc_i(	m5s0_cyc	),
		.m5_stb_i(	m5s0_stb	),
		.m5_ack_o(	m5s0_ack	),
		.m5_err_o(	m5s0_err	),
		.m5_rty_o(	m5s0_rty	),
		.m6_data_i(	m6s0_data_o	),
		.m6_data_o(	m6s0_data_i	),
		.m6_addr_i(	m6s0_addr	),
		.m6_sel_i(	m6s0_sel	),
		.m6_we_i(	m6s0_we	),
		.m6_cyc_i(	m6s0_cyc	),
		.m6_stb_i(	m6s0_stb	),
		.m6_ack_o(	m6s0_ack	),
		.m6_err_o(	m6s0_err	),
		.m6_rty_o(	m6s0_rty	),
		.m7_data_i(	m7s0_data_o	),
		.m7_data_o(	m7s0_data_i	),
		.m7_addr_i(	m7s0_addr	),
		.m7_sel_i(	m7s0_sel	),
		.m7_we_i(	m7s0_we	),
		.m7_cyc_i(	m7s0_cyc	),
		.m7_stb_i(	m7s0_stb	),
		.m7_ack_o(	m7s0_ack	),
		.m7_err_o(	m7s0_err	),
		.m7_rty_o(	m7s0_rty	)
		);

wb_conmax_slave_if #(pri_sel1,aw,dw,sw) s1(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf1		),
		.wb_data_i(	s1_data_i	),
		.wb_data_o(	s1_data_o	),
		.wb_addr_o(	s1_addr_o	),
		.wb_sel_o(	s1_sel_o	),
		.wb_we_o(	s1_we_o		),
		.wb_cyc_o(	s1_cyc_o	),
		.wb_stb_o(	s1_stb_o	),
		.wb_ack_i(	s1_ack_i	),
		.wb_err_i(	s1_err_i	),
		.wb_rty_i(	s1_rty_i	),
		.m0_data_i(	m0s1_data_o	),
		.m0_data_o(	m0s1_data_i	),
		.m0_addr_i(	m0s1_addr	),
		.m0_sel_i(	m0s1_sel	),
		.m0_we_i(	m0s1_we	),
		.m0_cyc_i(	m0s1_cyc	),
		.m0_stb_i(	m0s1_stb	),
		.m0_ack_o(	m0s1_ack	),
		.m0_err_o(	m0s1_err	),
		.m0_rty_o(	m0s1_rty	),
		.m1_data_i(	m1s1_data_o	),
		.m1_data_o(	m1s1_data_i	),
		.m1_addr_i(	m1s1_addr	),
		.m1_sel_i(	m1s1_sel	),
		.m1_we_i(	m1s1_we	),
		.m1_cyc_i(	m1s1_cyc	),
		.m1_stb_i(	m1s1_stb	),
		.m1_ack_o(	m1s1_ack	),
		.m1_err_o(	m1s1_err	),
		.m1_rty_o(	m1s1_rty	),
		.m2_data_i(	m2s1_data_o	),
		.m2_data_o(	m2s1_data_i	),
		.m2_addr_i(	m2s1_addr	),
		.m2_sel_i(	m2s1_sel	),
		.m2_we_i(	m2s1_we	),
		.m2_cyc_i(	m2s1_cyc	),
		.m2_stb_i(	m2s1_stb	),
		.m2_ack_o(	m2s1_ack	),
		.m2_err_o(	m2s1_err	),
		.m2_rty_o(	m2s1_rty	),
		.m3_data_i(	m3s1_data_o	),
		.m3_data_o(	m3s1_data_i	),
		.m3_addr_i(	m3s1_addr	),
		.m3_sel_i(	m3s1_sel	),
		.m3_we_i(	m3s1_we	),
		.m3_cyc_i(	m3s1_cyc	),
		.m3_stb_i(	m3s1_stb	),
		.m3_ack_o(	m3s1_ack	),
		.m3_err_o(	m3s1_err	),
		.m3_rty_o(	m3s1_rty	),
		.m4_data_i(	m4s1_data_o	),
		.m4_data_o(	m4s1_data_i	),
		.m4_addr_i(	m4s1_addr	),
		.m4_sel_i(	m4s1_sel	),
		.m4_we_i(	m4s1_we	),
		.m4_cyc_i(	m4s1_cyc	),
		.m4_stb_i(	m4s1_stb	),
		.m4_ack_o(	m4s1_ack	),
		.m4_err_o(	m4s1_err	),
		.m4_rty_o(	m4s1_rty	),
		.m5_data_i(	m5s1_data_o	),
		.m5_data_o(	m5s1_data_i	),
		.m5_addr_i(	m5s1_addr	),
		.m5_sel_i(	m5s1_sel	),
		.m5_we_i(	m5s1_we	),
		.m5_cyc_i(	m5s1_cyc	),
		.m5_stb_i(	m5s1_stb	),
		.m5_ack_o(	m5s1_ack	),
		.m5_err_o(	m5s1_err	),
		.m5_rty_o(	m5s1_rty	),
		.m6_data_i(	m6s1_data_o	),
		.m6_data_o(	m6s1_data_i	),
		.m6_addr_i(	m6s1_addr	),
		.m6_sel_i(	m6s1_sel	),
		.m6_we_i(	m6s1_we	),
		.m6_cyc_i(	m6s1_cyc	),
		.m6_stb_i(	m6s1_stb	),
		.m6_ack_o(	m6s1_ack	),
		.m6_err_o(	m6s1_err	),
		.m6_rty_o(	m6s1_rty	),
		.m7_data_i(	m7s1_data_o	),
		.m7_data_o(	m7s1_data_i	),
		.m7_addr_i(	m7s1_addr	),
		.m7_sel_i(	m7s1_sel	),
		.m7_we_i(	m7s1_we	),
		.m7_cyc_i(	m7s1_cyc	),
		.m7_stb_i(	m7s1_stb	),
		.m7_ack_o(	m7s1_ack	),
		.m7_err_o(	m7s1_err	),
		.m7_rty_o(	m7s1_rty	)
		);

wb_conmax_slave_if #(pri_sel2,aw,dw,sw) s2(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf2		),
		.wb_data_i(	s2_data_i	),
		.wb_data_o(	s2_data_o	),
		.wb_addr_o(	s2_addr_o	),
		.wb_sel_o(	s2_sel_o	),
		.wb_we_o(	s2_we_o		),
		.wb_cyc_o(	s2_cyc_o	),
		.wb_stb_o(	s2_stb_o	),
		.wb_ack_i(	s2_ack_i	),
		.wb_err_i(	s2_err_i	),
		.wb_rty_i(	s2_rty_i	),
		.m0_data_i(	m0s2_data_o	),
		.m0_data_o(	m0s2_data_i	),
		.m0_addr_i(	m0s2_addr	),
		.m0_sel_i(	m0s2_sel	),
		.m0_we_i(	m0s2_we	),
		.m0_cyc_i(	m0s2_cyc	),
		.m0_stb_i(	m0s2_stb	),
		.m0_ack_o(	m0s2_ack	),
		.m0_err_o(	m0s2_err	),
		.m0_rty_o(	m0s2_rty	),
		.m1_data_i(	m1s2_data_o	),
		.m1_data_o(	m1s2_data_i	),
		.m1_addr_i(	m1s2_addr	),
		.m1_sel_i(	m1s2_sel	),
		.m1_we_i(	m1s2_we	),
		.m1_cyc_i(	m1s2_cyc	),
		.m1_stb_i(	m1s2_stb	),
		.m1_ack_o(	m1s2_ack	),
		.m1_err_o(	m1s2_err	),
		.m1_rty_o(	m1s2_rty	),
		.m2_data_i(	m2s2_data_o	),
		.m2_data_o(	m2s2_data_i	),
		.m2_addr_i(	m2s2_addr	),
		.m2_sel_i(	m2s2_sel	),
		.m2_we_i(	m2s2_we	),
		.m2_cyc_i(	m2s2_cyc	),
		.m2_stb_i(	m2s2_stb	),
		.m2_ack_o(	m2s2_ack	),
		.m2_err_o(	m2s2_err	),
		.m2_rty_o(	m2s2_rty	),
		.m3_data_i(	m3s2_data_o	),
		.m3_data_o(	m3s2_data_i	),
		.m3_addr_i(	m3s2_addr	),
		.m3_sel_i(	m3s2_sel	),
		.m3_we_i(	m3s2_we	),
		.m3_cyc_i(	m3s2_cyc	),
		.m3_stb_i(	m3s2_stb	),
		.m3_ack_o(	m3s2_ack	),
		.m3_err_o(	m3s2_err	),
		.m3_rty_o(	m3s2_rty	),
		.m4_data_i(	m4s2_data_o	),
		.m4_data_o(	m4s2_data_i	),
		.m4_addr_i(	m4s2_addr	),
		.m4_sel_i(	m4s2_sel	),
		.m4_we_i(	m4s2_we	),
		.m4_cyc_i(	m4s2_cyc	),
		.m4_stb_i(	m4s2_stb	),
		.m4_ack_o(	m4s2_ack	),
		.m4_err_o(	m4s2_err	),
		.m4_rty_o(	m4s2_rty	),
		.m5_data_i(	m5s2_data_o	),
		.m5_data_o(	m5s2_data_i	),
		.m5_addr_i(	m5s2_addr	),
		.m5_sel_i(	m5s2_sel	),
		.m5_we_i(	m5s2_we	),
		.m5_cyc_i(	m5s2_cyc	),
		.m5_stb_i(	m5s2_stb	),
		.m5_ack_o(	m5s2_ack	),
		.m5_err_o(	m5s2_err	),
		.m5_rty_o(	m5s2_rty	),
		.m6_data_i(	m6s2_data_o	),
		.m6_data_o(	m6s2_data_i	),
		.m6_addr_i(	m6s2_addr	),
		.m6_sel_i(	m6s2_sel	),
		.m6_we_i(	m6s2_we	),
		.m6_cyc_i(	m6s2_cyc	),
		.m6_stb_i(	m6s2_stb	),
		.m6_ack_o(	m6s2_ack	),
		.m6_err_o(	m6s2_err	),
		.m6_rty_o(	m6s2_rty	),
		.m7_data_i(	m7s2_data_o	),
		.m7_data_o(	m7s2_data_i	),
		.m7_addr_i(	m7s2_addr	),
		.m7_sel_i(	m7s2_sel	),
		.m7_we_i(	m7s2_we	),
		.m7_cyc_i(	m7s2_cyc	),
		.m7_stb_i(	m7s2_stb	),
		.m7_ack_o(	m7s2_ack	),
		.m7_err_o(	m7s2_err	),
		.m7_rty_o(	m7s2_rty	)
		);

wb_conmax_slave_if #(pri_sel3,aw,dw,sw) s3(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf3		),
		.wb_data_i(	s3_data_i	),
		.wb_data_o(	s3_data_o	),
		.wb_addr_o(	s3_addr_o	),
		.wb_sel_o(	s3_sel_o	),
		.wb_we_o(	s3_we_o		),
		.wb_cyc_o(	s3_cyc_o	),
		.wb_stb_o(	s3_stb_o	),
		.wb_ack_i(	s3_ack_i	),
		.wb_err_i(	s3_err_i	),
		.wb_rty_i(	s3_rty_i	),
		.m0_data_i(	m0s3_data_o	),
		.m0_data_o(	m0s3_data_i	),
		.m0_addr_i(	m0s3_addr	),
		.m0_sel_i(	m0s3_sel	),
		.m0_we_i(	m0s3_we	),
		.m0_cyc_i(	m0s3_cyc	),
		.m0_stb_i(	m0s3_stb	),
		.m0_ack_o(	m0s3_ack	),
		.m0_err_o(	m0s3_err	),
		.m0_rty_o(	m0s3_rty	),
		.m1_data_i(	m1s3_data_o	),
		.m1_data_o(	m1s3_data_i	),
		.m1_addr_i(	m1s3_addr	),
		.m1_sel_i(	m1s3_sel	),
		.m1_we_i(	m1s3_we	),
		.m1_cyc_i(	m1s3_cyc	),
		.m1_stb_i(	m1s3_stb	),
		.m1_ack_o(	m1s3_ack	),
		.m1_err_o(	m1s3_err	),
		.m1_rty_o(	m1s3_rty	),
		.m2_data_i(	m2s3_data_o	),
		.m2_data_o(	m2s3_data_i	),
		.m2_addr_i(	m2s3_addr	),
		.m2_sel_i(	m2s3_sel	),
		.m2_we_i(	m2s3_we	),
		.m2_cyc_i(	m2s3_cyc	),
		.m2_stb_i(	m2s3_stb	),
		.m2_ack_o(	m2s3_ack	),
		.m2_err_o(	m2s3_err	),
		.m2_rty_o(	m2s3_rty	),
		.m3_data_i(	m3s3_data_o	),
		.m3_data_o(	m3s3_data_i	),
		.m3_addr_i(	m3s3_addr	),
		.m3_sel_i(	m3s3_sel	),
		.m3_we_i(	m3s3_we	),
		.m3_cyc_i(	m3s3_cyc	),
		.m3_stb_i(	m3s3_stb	),
		.m3_ack_o(	m3s3_ack	),
		.m3_err_o(	m3s3_err	),
		.m3_rty_o(	m3s3_rty	),
		.m4_data_i(	m4s3_data_o	),
		.m4_data_o(	m4s3_data_i	),
		.m4_addr_i(	m4s3_addr	),
		.m4_sel_i(	m4s3_sel	),
		.m4_we_i(	m4s3_we	),
		.m4_cyc_i(	m4s3_cyc	),
		.m4_stb_i(	m4s3_stb	),
		.m4_ack_o(	m4s3_ack	),
		.m4_err_o(	m4s3_err	),
		.m4_rty_o(	m4s3_rty	),
		.m5_data_i(	m5s3_data_o	),
		.m5_data_o(	m5s3_data_i	),
		.m5_addr_i(	m5s3_addr	),
		.m5_sel_i(	m5s3_sel	),
		.m5_we_i(	m5s3_we	),
		.m5_cyc_i(	m5s3_cyc	),
		.m5_stb_i(	m5s3_stb	),
		.m5_ack_o(	m5s3_ack	),
		.m5_err_o(	m5s3_err	),
		.m5_rty_o(	m5s3_rty	),
		.m6_data_i(	m6s3_data_o	),
		.m6_data_o(	m6s3_data_i	),
		.m6_addr_i(	m6s3_addr	),
		.m6_sel_i(	m6s3_sel	),
		.m6_we_i(	m6s3_we	),
		.m6_cyc_i(	m6s3_cyc	),
		.m6_stb_i(	m6s3_stb	),
		.m6_ack_o(	m6s3_ack	),
		.m6_err_o(	m6s3_err	),
		.m6_rty_o(	m6s3_rty	),
		.m7_data_i(	m7s3_data_o	),
		.m7_data_o(	m7s3_data_i	),
		.m7_addr_i(	m7s3_addr	),
		.m7_sel_i(	m7s3_sel	),
		.m7_we_i(	m7s3_we	),
		.m7_cyc_i(	m7s3_cyc	),
		.m7_stb_i(	m7s3_stb	),
		.m7_ack_o(	m7s3_ack	),
		.m7_err_o(	m7s3_err	),
		.m7_rty_o(	m7s3_rty	)
		);

wb_conmax_slave_if #(pri_sel4,aw,dw,sw) s4(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf4		),
		.wb_data_i(	s4_data_i	),
		.wb_data_o(	s4_data_o	),
		.wb_addr_o(	s4_addr_o	),
		.wb_sel_o(	s4_sel_o	),
		.wb_we_o(	s4_we_o		),
		.wb_cyc_o(	s4_cyc_o	),
		.wb_stb_o(	s4_stb_o	),
		.wb_ack_i(	s4_ack_i	),
		.wb_err_i(	s4_err_i	),
		.wb_rty_i(	s4_rty_i	),
		.m0_data_i(	m0s4_data_o	),
		.m0_data_o(	m0s4_data_i	),
		.m0_addr_i(	m0s4_addr	),
		.m0_sel_i(	m0s4_sel	),
		.m0_we_i(	m0s4_we	),
		.m0_cyc_i(	m0s4_cyc	),
		.m0_stb_i(	m0s4_stb	),
		.m0_ack_o(	m0s4_ack	),
		.m0_err_o(	m0s4_err	),
		.m0_rty_o(	m0s4_rty	),
		.m1_data_i(	m1s4_data_o	),
		.m1_data_o(	m1s4_data_i	),
		.m1_addr_i(	m1s4_addr	),
		.m1_sel_i(	m1s4_sel	),
		.m1_we_i(	m1s4_we	),
		.m1_cyc_i(	m1s4_cyc	),
		.m1_stb_i(	m1s4_stb	),
		.m1_ack_o(	m1s4_ack	),
		.m1_err_o(	m1s4_err	),
		.m1_rty_o(	m1s4_rty	),
		.m2_data_i(	m2s4_data_o	),
		.m2_data_o(	m2s4_data_i	),
		.m2_addr_i(	m2s4_addr	),
		.m2_sel_i(	m2s4_sel	),
		.m2_we_i(	m2s4_we	),
		.m2_cyc_i(	m2s4_cyc	),
		.m2_stb_i(	m2s4_stb	),
		.m2_ack_o(	m2s4_ack	),
		.m2_err_o(	m2s4_err	),
		.m2_rty_o(	m2s4_rty	),
		.m3_data_i(	m3s4_data_o	),
		.m3_data_o(	m3s4_data_i	),
		.m3_addr_i(	m3s4_addr	),
		.m3_sel_i(	m3s4_sel	),
		.m3_we_i(	m3s4_we	),
		.m3_cyc_i(	m3s4_cyc	),
		.m3_stb_i(	m3s4_stb	),
		.m3_ack_o(	m3s4_ack	),
		.m3_err_o(	m3s4_err	),
		.m3_rty_o(	m3s4_rty	),
		.m4_data_i(	m4s4_data_o	),
		.m4_data_o(	m4s4_data_i	),
		.m4_addr_i(	m4s4_addr	),
		.m4_sel_i(	m4s4_sel	),
		.m4_we_i(	m4s4_we	),
		.m4_cyc_i(	m4s4_cyc	),
		.m4_stb_i(	m4s4_stb	),
		.m4_ack_o(	m4s4_ack	),
		.m4_err_o(	m4s4_err	),
		.m4_rty_o(	m4s4_rty	),
		.m5_data_i(	m5s4_data_o	),
		.m5_data_o(	m5s4_data_i	),
		.m5_addr_i(	m5s4_addr	),
		.m5_sel_i(	m5s4_sel	),
		.m5_we_i(	m5s4_we	),
		.m5_cyc_i(	m5s4_cyc	),
		.m5_stb_i(	m5s4_stb	),
		.m5_ack_o(	m5s4_ack	),
		.m5_err_o(	m5s4_err	),
		.m5_rty_o(	m5s4_rty	),
		.m6_data_i(	m6s4_data_o	),
		.m6_data_o(	m6s4_data_i	),
		.m6_addr_i(	m6s4_addr	),
		.m6_sel_i(	m6s4_sel	),
		.m6_we_i(	m6s4_we	),
		.m6_cyc_i(	m6s4_cyc	),
		.m6_stb_i(	m6s4_stb	),
		.m6_ack_o(	m6s4_ack	),
		.m6_err_o(	m6s4_err	),
		.m6_rty_o(	m6s4_rty	),
		.m7_data_i(	m7s4_data_o	),
		.m7_data_o(	m7s4_data_i	),
		.m7_addr_i(	m7s4_addr	),
		.m7_sel_i(	m7s4_sel	),
		.m7_we_i(	m7s4_we	),
		.m7_cyc_i(	m7s4_cyc	),
		.m7_stb_i(	m7s4_stb	),
		.m7_ack_o(	m7s4_ack	),
		.m7_err_o(	m7s4_err	),
		.m7_rty_o(	m7s4_rty	)
		);

wb_conmax_slave_if #(pri_sel5,aw,dw,sw) s5(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf5		),
		.wb_data_i(	s5_data_i	),
		.wb_data_o(	s5_data_o	),
		.wb_addr_o(	s5_addr_o	),
		.wb_sel_o(	s5_sel_o	),
		.wb_we_o(	s5_we_o		),
		.wb_cyc_o(	s5_cyc_o	),
		.wb_stb_o(	s5_stb_o	),
		.wb_ack_i(	s5_ack_i	),
		.wb_err_i(	s5_err_i	),
		.wb_rty_i(	s5_rty_i	),
		.m0_data_i(	m0s5_data_o	),
		.m0_data_o(	m0s5_data_i	),
		.m0_addr_i(	m0s5_addr	),
		.m0_sel_i(	m0s5_sel	),
		.m0_we_i(	m0s5_we	),
		.m0_cyc_i(	m0s5_cyc	),
		.m0_stb_i(	m0s5_stb	),
		.m0_ack_o(	m0s5_ack	),
		.m0_err_o(	m0s5_err	),
		.m0_rty_o(	m0s5_rty	),
		.m1_data_i(	m1s5_data_o	),
		.m1_data_o(	m1s5_data_i	),
		.m1_addr_i(	m1s5_addr	),
		.m1_sel_i(	m1s5_sel	),
		.m1_we_i(	m1s5_we	),
		.m1_cyc_i(	m1s5_cyc	),
		.m1_stb_i(	m1s5_stb	),
		.m1_ack_o(	m1s5_ack	),
		.m1_err_o(	m1s5_err	),
		.m1_rty_o(	m1s5_rty	),
		.m2_data_i(	m2s5_data_o	),
		.m2_data_o(	m2s5_data_i	),
		.m2_addr_i(	m2s5_addr	),
		.m2_sel_i(	m2s5_sel	),
		.m2_we_i(	m2s5_we	),
		.m2_cyc_i(	m2s5_cyc	),
		.m2_stb_i(	m2s5_stb	),
		.m2_ack_o(	m2s5_ack	),
		.m2_err_o(	m2s5_err	),
		.m2_rty_o(	m2s5_rty	),
		.m3_data_i(	m3s5_data_o	),
		.m3_data_o(	m3s5_data_i	),
		.m3_addr_i(	m3s5_addr	),
		.m3_sel_i(	m3s5_sel	),
		.m3_we_i(	m3s5_we	),
		.m3_cyc_i(	m3s5_cyc	),
		.m3_stb_i(	m3s5_stb	),
		.m3_ack_o(	m3s5_ack	),
		.m3_err_o(	m3s5_err	),
		.m3_rty_o(	m3s5_rty	),
		.m4_data_i(	m4s5_data_o	),
		.m4_data_o(	m4s5_data_i	),
		.m4_addr_i(	m4s5_addr	),
		.m4_sel_i(	m4s5_sel	),
		.m4_we_i(	m4s5_we	),
		.m4_cyc_i(	m4s5_cyc	),
		.m4_stb_i(	m4s5_stb	),
		.m4_ack_o(	m4s5_ack	),
		.m4_err_o(	m4s5_err	),
		.m4_rty_o(	m4s5_rty	),
		.m5_data_i(	m5s5_data_o	),
		.m5_data_o(	m5s5_data_i	),
		.m5_addr_i(	m5s5_addr	),
		.m5_sel_i(	m5s5_sel	),
		.m5_we_i(	m5s5_we	),
		.m5_cyc_i(	m5s5_cyc	),
		.m5_stb_i(	m5s5_stb	),
		.m5_ack_o(	m5s5_ack	),
		.m5_err_o(	m5s5_err	),
		.m5_rty_o(	m5s5_rty	),
		.m6_data_i(	m6s5_data_o	),
		.m6_data_o(	m6s5_data_i	),
		.m6_addr_i(	m6s5_addr	),
		.m6_sel_i(	m6s5_sel	),
		.m6_we_i(	m6s5_we	),
		.m6_cyc_i(	m6s5_cyc	),
		.m6_stb_i(	m6s5_stb	),
		.m6_ack_o(	m6s5_ack	),
		.m6_err_o(	m6s5_err	),
		.m6_rty_o(	m6s5_rty	),
		.m7_data_i(	m7s5_data_o	),
		.m7_data_o(	m7s5_data_i	),
		.m7_addr_i(	m7s5_addr	),
		.m7_sel_i(	m7s5_sel	),
		.m7_we_i(	m7s5_we	),
		.m7_cyc_i(	m7s5_cyc	),
		.m7_stb_i(	m7s5_stb	),
		.m7_ack_o(	m7s5_ack	),
		.m7_err_o(	m7s5_err	),
		.m7_rty_o(	m7s5_rty	)
		);

wb_conmax_slave_if #(pri_sel6,aw,dw,sw) s6(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf6		),
		.wb_data_i(	s6_data_i	),
		.wb_data_o(	s6_data_o	),
		.wb_addr_o(	s6_addr_o	),
		.wb_sel_o(	s6_sel_o	),
		.wb_we_o(	s6_we_o		),
		.wb_cyc_o(	s6_cyc_o	),
		.wb_stb_o(	s6_stb_o	),
		.wb_ack_i(	s6_ack_i	),
		.wb_err_i(	s6_err_i	),
		.wb_rty_i(	s6_rty_i	),
		.m0_data_i(	m0s6_data_o	),
		.m0_data_o(	m0s6_data_i	),
		.m0_addr_i(	m0s6_addr	),
		.m0_sel_i(	m0s6_sel	),
		.m0_we_i(	m0s6_we	),
		.m0_cyc_i(	m0s6_cyc	),
		.m0_stb_i(	m0s6_stb	),
		.m0_ack_o(	m0s6_ack	),
		.m0_err_o(	m0s6_err	),
		.m0_rty_o(	m0s6_rty	),
		.m1_data_i(	m1s6_data_o	),
		.m1_data_o(	m1s6_data_i	),
		.m1_addr_i(	m1s6_addr	),
		.m1_sel_i(	m1s6_sel	),
		.m1_we_i(	m1s6_we	),
		.m1_cyc_i(	m1s6_cyc	),
		.m1_stb_i(	m1s6_stb	),
		.m1_ack_o(	m1s6_ack	),
		.m1_err_o(	m1s6_err	),
		.m1_rty_o(	m1s6_rty	),
		.m2_data_i(	m2s6_data_o	),
		.m2_data_o(	m2s6_data_i	),
		.m2_addr_i(	m2s6_addr	),
		.m2_sel_i(	m2s6_sel	),
		.m2_we_i(	m2s6_we	),
		.m2_cyc_i(	m2s6_cyc	),
		.m2_stb_i(	m2s6_stb	),
		.m2_ack_o(	m2s6_ack	),
		.m2_err_o(	m2s6_err	),
		.m2_rty_o(	m2s6_rty	),
		.m3_data_i(	m3s6_data_o	),
		.m3_data_o(	m3s6_data_i	),
		.m3_addr_i(	m3s6_addr	),
		.m3_sel_i(	m3s6_sel	),
		.m3_we_i(	m3s6_we	),
		.m3_cyc_i(	m3s6_cyc	),
		.m3_stb_i(	m3s6_stb	),
		.m3_ack_o(	m3s6_ack	),
		.m3_err_o(	m3s6_err	),
		.m3_rty_o(	m3s6_rty	),
		.m4_data_i(	m4s6_data_o	),
		.m4_data_o(	m4s6_data_i	),
		.m4_addr_i(	m4s6_addr	),
		.m4_sel_i(	m4s6_sel	),
		.m4_we_i(	m4s6_we	),
		.m4_cyc_i(	m4s6_cyc	),
		.m4_stb_i(	m4s6_stb	),
		.m4_ack_o(	m4s6_ack	),
		.m4_err_o(	m4s6_err	),
		.m4_rty_o(	m4s6_rty	),
		.m5_data_i(	m5s6_data_o	),
		.m5_data_o(	m5s6_data_i	),
		.m5_addr_i(	m5s6_addr	),
		.m5_sel_i(	m5s6_sel	),
		.m5_we_i(	m5s6_we	),
		.m5_cyc_i(	m5s6_cyc	),
		.m5_stb_i(	m5s6_stb	),
		.m5_ack_o(	m5s6_ack	),
		.m5_err_o(	m5s6_err	),
		.m5_rty_o(	m5s6_rty	),
		.m6_data_i(	m6s6_data_o	),
		.m6_data_o(	m6s6_data_i	),
		.m6_addr_i(	m6s6_addr	),
		.m6_sel_i(	m6s6_sel	),
		.m6_we_i(	m6s6_we	),
		.m6_cyc_i(	m6s6_cyc	),
		.m6_stb_i(	m6s6_stb	),
		.m6_ack_o(	m6s6_ack	),
		.m6_err_o(	m6s6_err	),
		.m6_rty_o(	m6s6_rty	),
		.m7_data_i(	m7s6_data_o	),
		.m7_data_o(	m7s6_data_i	),
		.m7_addr_i(	m7s6_addr	),
		.m7_sel_i(	m7s6_sel	),
		.m7_we_i(	m7s6_we	),
		.m7_cyc_i(	m7s6_cyc	),
		.m7_stb_i(	m7s6_stb	),
		.m7_ack_o(	m7s6_ack	),
		.m7_err_o(	m7s6_err	),
		.m7_rty_o(	m7s6_rty	)
		);

wb_conmax_slave_if #(pri_sel7,aw,dw,sw) s7(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf7		),
		.wb_data_i(	s7_data_i	),
		.wb_data_o(	s7_data_o	),
		.wb_addr_o(	s7_addr_o	),
		.wb_sel_o(	s7_sel_o	),
		.wb_we_o(	s7_we_o		),
		.wb_cyc_o(	s7_cyc_o	),
		.wb_stb_o(	s7_stb_o	),
		.wb_ack_i(	s7_ack_i	),
		.wb_err_i(	s7_err_i	),
		.wb_rty_i(	s7_rty_i	),
		.m0_data_i(	m0s7_data_o	),
		.m0_data_o(	m0s7_data_i	),
		.m0_addr_i(	m0s7_addr	),
		.m0_sel_i(	m0s7_sel	),
		.m0_we_i(	m0s7_we	),
		.m0_cyc_i(	m0s7_cyc	),
		.m0_stb_i(	m0s7_stb	),
		.m0_ack_o(	m0s7_ack	),
		.m0_err_o(	m0s7_err	),
		.m0_rty_o(	m0s7_rty	),
		.m1_data_i(	m1s7_data_o	),
		.m1_data_o(	m1s7_data_i	),
		.m1_addr_i(	m1s7_addr	),
		.m1_sel_i(	m1s7_sel	),
		.m1_we_i(	m1s7_we	),
		.m1_cyc_i(	m1s7_cyc	),
		.m1_stb_i(	m1s7_stb	),
		.m1_ack_o(	m1s7_ack	),
		.m1_err_o(	m1s7_err	),
		.m1_rty_o(	m1s7_rty	),
		.m2_data_i(	m2s7_data_o	),
		.m2_data_o(	m2s7_data_i	),
		.m2_addr_i(	m2s7_addr	),
		.m2_sel_i(	m2s7_sel	),
		.m2_we_i(	m2s7_we	),
		.m2_cyc_i(	m2s7_cyc	),
		.m2_stb_i(	m2s7_stb	),
		.m2_ack_o(	m2s7_ack	),
		.m2_err_o(	m2s7_err	),
		.m2_rty_o(	m2s7_rty	),
		.m3_data_i(	m3s7_data_o	),
		.m3_data_o(	m3s7_data_i	),
		.m3_addr_i(	m3s7_addr	),
		.m3_sel_i(	m3s7_sel	),
		.m3_we_i(	m3s7_we	),
		.m3_cyc_i(	m3s7_cyc	),
		.m3_stb_i(	m3s7_stb	),
		.m3_ack_o(	m3s7_ack	),
		.m3_err_o(	m3s7_err	),
		.m3_rty_o(	m3s7_rty	),
		.m4_data_i(	m4s7_data_o	),
		.m4_data_o(	m4s7_data_i	),
		.m4_addr_i(	m4s7_addr	),
		.m4_sel_i(	m4s7_sel	),
		.m4_we_i(	m4s7_we	),
		.m4_cyc_i(	m4s7_cyc	),
		.m4_stb_i(	m4s7_stb	),
		.m4_ack_o(	m4s7_ack	),
		.m4_err_o(	m4s7_err	),
		.m4_rty_o(	m4s7_rty	),
		.m5_data_i(	m5s7_data_o	),
		.m5_data_o(	m5s7_data_i	),
		.m5_addr_i(	m5s7_addr	),
		.m5_sel_i(	m5s7_sel	),
		.m5_we_i(	m5s7_we	),
		.m5_cyc_i(	m5s7_cyc	),
		.m5_stb_i(	m5s7_stb	),
		.m5_ack_o(	m5s7_ack	),
		.m5_err_o(	m5s7_err	),
		.m5_rty_o(	m5s7_rty	),
		.m6_data_i(	m6s7_data_o	),
		.m6_data_o(	m6s7_data_i	),
		.m6_addr_i(	m6s7_addr	),
		.m6_sel_i(	m6s7_sel	),
		.m6_we_i(	m6s7_we	),
		.m6_cyc_i(	m6s7_cyc	),
		.m6_stb_i(	m6s7_stb	),
		.m6_ack_o(	m6s7_ack	),
		.m6_err_o(	m6s7_err	),
		.m6_rty_o(	m6s7_rty	),
		.m7_data_i(	m7s7_data_o	),
		.m7_data_o(	m7s7_data_i	),
		.m7_addr_i(	m7s7_addr	),
		.m7_sel_i(	m7s7_sel	),
		.m7_we_i(	m7s7_we	),
		.m7_cyc_i(	m7s7_cyc	),
		.m7_stb_i(	m7s7_stb	),
		.m7_ack_o(	m7s7_ack	),
		.m7_err_o(	m7s7_err	),
		.m7_rty_o(	m7s7_rty	)
		);

wb_conmax_slave_if #(pri_sel8,aw,dw,sw) s8(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf8		),
		.wb_data_i(	s8_data_i	),
		.wb_data_o(	s8_data_o	),
		.wb_addr_o(	s8_addr_o	),
		.wb_sel_o(	s8_sel_o	),
		.wb_we_o(	s8_we_o		),
		.wb_cyc_o(	s8_cyc_o	),
		.wb_stb_o(	s8_stb_o	),
		.wb_ack_i(	s8_ack_i	),
		.wb_err_i(	s8_err_i	),
		.wb_rty_i(	s8_rty_i	),
		.m0_data_i(	m0s8_data_o	),
		.m0_data_o(	m0s8_data_i	),
		.m0_addr_i(	m0s8_addr	),
		.m0_sel_i(	m0s8_sel	),
		.m0_we_i(	m0s8_we	),
		.m0_cyc_i(	m0s8_cyc	),
		.m0_stb_i(	m0s8_stb	),
		.m0_ack_o(	m0s8_ack	),
		.m0_err_o(	m0s8_err	),
		.m0_rty_o(	m0s8_rty	),
		.m1_data_i(	m1s8_data_o	),
		.m1_data_o(	m1s8_data_i	),
		.m1_addr_i(	m1s8_addr	),
		.m1_sel_i(	m1s8_sel	),
		.m1_we_i(	m1s8_we	),
		.m1_cyc_i(	m1s8_cyc	),
		.m1_stb_i(	m1s8_stb	),
		.m1_ack_o(	m1s8_ack	),
		.m1_err_o(	m1s8_err	),
		.m1_rty_o(	m1s8_rty	),
		.m2_data_i(	m2s8_data_o	),
		.m2_data_o(	m2s8_data_i	),
		.m2_addr_i(	m2s8_addr	),
		.m2_sel_i(	m2s8_sel	),
		.m2_we_i(	m2s8_we	),
		.m2_cyc_i(	m2s8_cyc	),
		.m2_stb_i(	m2s8_stb	),
		.m2_ack_o(	m2s8_ack	),
		.m2_err_o(	m2s8_err	),
		.m2_rty_o(	m2s8_rty	),
		.m3_data_i(	m3s8_data_o	),
		.m3_data_o(	m3s8_data_i	),
		.m3_addr_i(	m3s8_addr	),
		.m3_sel_i(	m3s8_sel	),
		.m3_we_i(	m3s8_we	),
		.m3_cyc_i(	m3s8_cyc	),
		.m3_stb_i(	m3s8_stb	),
		.m3_ack_o(	m3s8_ack	),
		.m3_err_o(	m3s8_err	),
		.m3_rty_o(	m3s8_rty	),
		.m4_data_i(	m4s8_data_o	),
		.m4_data_o(	m4s8_data_i	),
		.m4_addr_i(	m4s8_addr	),
		.m4_sel_i(	m4s8_sel	),
		.m4_we_i(	m4s8_we	),
		.m4_cyc_i(	m4s8_cyc	),
		.m4_stb_i(	m4s8_stb	),
		.m4_ack_o(	m4s8_ack	),
		.m4_err_o(	m4s8_err	),
		.m4_rty_o(	m4s8_rty	),
		.m5_data_i(	m5s8_data_o	),
		.m5_data_o(	m5s8_data_i	),
		.m5_addr_i(	m5s8_addr	),
		.m5_sel_i(	m5s8_sel	),
		.m5_we_i(	m5s8_we	),
		.m5_cyc_i(	m5s8_cyc	),
		.m5_stb_i(	m5s8_stb	),
		.m5_ack_o(	m5s8_ack	),
		.m5_err_o(	m5s8_err	),
		.m5_rty_o(	m5s8_rty	),
		.m6_data_i(	m6s8_data_o	),
		.m6_data_o(	m6s8_data_i	),
		.m6_addr_i(	m6s8_addr	),
		.m6_sel_i(	m6s8_sel	),
		.m6_we_i(	m6s8_we	),
		.m6_cyc_i(	m6s8_cyc	),
		.m6_stb_i(	m6s8_stb	),
		.m6_ack_o(	m6s8_ack	),
		.m6_err_o(	m6s8_err	),
		.m6_rty_o(	m6s8_rty	),
		.m7_data_i(	m7s8_data_o	),
		.m7_data_o(	m7s8_data_i	),
		.m7_addr_i(	m7s8_addr	),
		.m7_sel_i(	m7s8_sel	),
		.m7_we_i(	m7s8_we	),
		.m7_cyc_i(	m7s8_cyc	),
		.m7_stb_i(	m7s8_stb	),
		.m7_ack_o(	m7s8_ack	),
		.m7_err_o(	m7s8_err	),
		.m7_rty_o(	m7s8_rty	)
		);

wb_conmax_slave_if #(pri_sel9,aw,dw,sw) s9(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf9		),
		.wb_data_i(	s9_data_i	),
		.wb_data_o(	s9_data_o	),
		.wb_addr_o(	s9_addr_o	),
		.wb_sel_o(	s9_sel_o	),
		.wb_we_o(	s9_we_o		),
		.wb_cyc_o(	s9_cyc_o	),
		.wb_stb_o(	s9_stb_o	),
		.wb_ack_i(	s9_ack_i	),
		.wb_err_i(	s9_err_i	),
		.wb_rty_i(	s9_rty_i	),
		.m0_data_i(	m0s9_data_o	),
		.m0_data_o(	m0s9_data_i	),
		.m0_addr_i(	m0s9_addr	),
		.m0_sel_i(	m0s9_sel	),
		.m0_we_i(	m0s9_we	),
		.m0_cyc_i(	m0s9_cyc	),
		.m0_stb_i(	m0s9_stb	),
		.m0_ack_o(	m0s9_ack	),
		.m0_err_o(	m0s9_err	),
		.m0_rty_o(	m0s9_rty	),
		.m1_data_i(	m1s9_data_o	),
		.m1_data_o(	m1s9_data_i	),
		.m1_addr_i(	m1s9_addr	),
		.m1_sel_i(	m1s9_sel	),
		.m1_we_i(	m1s9_we	),
		.m1_cyc_i(	m1s9_cyc	),
		.m1_stb_i(	m1s9_stb	),
		.m1_ack_o(	m1s9_ack	),
		.m1_err_o(	m1s9_err	),
		.m1_rty_o(	m1s9_rty	),
		.m2_data_i(	m2s9_data_o	),
		.m2_data_o(	m2s9_data_i	),
		.m2_addr_i(	m2s9_addr	),
		.m2_sel_i(	m2s9_sel	),
		.m2_we_i(	m2s9_we	),
		.m2_cyc_i(	m2s9_cyc	),
		.m2_stb_i(	m2s9_stb	),
		.m2_ack_o(	m2s9_ack	),
		.m2_err_o(	m2s9_err	),
		.m2_rty_o(	m2s9_rty	),
		.m3_data_i(	m3s9_data_o	),
		.m3_data_o(	m3s9_data_i	),
		.m3_addr_i(	m3s9_addr	),
		.m3_sel_i(	m3s9_sel	),
		.m3_we_i(	m3s9_we	),
		.m3_cyc_i(	m3s9_cyc	),
		.m3_stb_i(	m3s9_stb	),
		.m3_ack_o(	m3s9_ack	),
		.m3_err_o(	m3s9_err	),
		.m3_rty_o(	m3s9_rty	),
		.m4_data_i(	m4s9_data_o	),
		.m4_data_o(	m4s9_data_i	),
		.m4_addr_i(	m4s9_addr	),
		.m4_sel_i(	m4s9_sel	),
		.m4_we_i(	m4s9_we	),
		.m4_cyc_i(	m4s9_cyc	),
		.m4_stb_i(	m4s9_stb	),
		.m4_ack_o(	m4s9_ack	),
		.m4_err_o(	m4s9_err	),
		.m4_rty_o(	m4s9_rty	),
		.m5_data_i(	m5s9_data_o	),
		.m5_data_o(	m5s9_data_i	),
		.m5_addr_i(	m5s9_addr	),
		.m5_sel_i(	m5s9_sel	),
		.m5_we_i(	m5s9_we	),
		.m5_cyc_i(	m5s9_cyc	),
		.m5_stb_i(	m5s9_stb	),
		.m5_ack_o(	m5s9_ack	),
		.m5_err_o(	m5s9_err	),
		.m5_rty_o(	m5s9_rty	),
		.m6_data_i(	m6s9_data_o	),
		.m6_data_o(	m6s9_data_i	),
		.m6_addr_i(	m6s9_addr	),
		.m6_sel_i(	m6s9_sel	),
		.m6_we_i(	m6s9_we	),
		.m6_cyc_i(	m6s9_cyc	),
		.m6_stb_i(	m6s9_stb	),
		.m6_ack_o(	m6s9_ack	),
		.m6_err_o(	m6s9_err	),
		.m6_rty_o(	m6s9_rty	),
		.m7_data_i(	m7s9_data_o	),
		.m7_data_o(	m7s9_data_i	),
		.m7_addr_i(	m7s9_addr	),
		.m7_sel_i(	m7s9_sel	),
		.m7_we_i(	m7s9_we	),
		.m7_cyc_i(	m7s9_cyc	),
		.m7_stb_i(	m7s9_stb	),
		.m7_ack_o(	m7s9_ack	),
		.m7_err_o(	m7s9_err	),
		.m7_rty_o(	m7s9_rty	)
		);

wb_conmax_slave_if #(pri_sel10,aw,dw,sw) s10(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf10		),
		.wb_data_i(	s10_data_i	),
		.wb_data_o(	s10_data_o	),
		.wb_addr_o(	s10_addr_o	),
		.wb_sel_o(	s10_sel_o	),
		.wb_we_o(	s10_we_o	),
		.wb_cyc_o(	s10_cyc_o	),
		.wb_stb_o(	s10_stb_o	),
		.wb_ack_i(	s10_ack_i	),
		.wb_err_i(	s10_err_i	),
		.wb_rty_i(	s10_rty_i	),
		.m0_data_i(	m0s10_data_o	),
		.m0_data_o(	m0s10_data_i	),
		.m0_addr_i(	m0s10_addr	),
		.m0_sel_i(	m0s10_sel	),
		.m0_we_i(	m0s10_we	),
		.m0_cyc_i(	m0s10_cyc	),
		.m0_stb_i(	m0s10_stb	),
		.m0_ack_o(	m0s10_ack	),
		.m0_err_o(	m0s10_err	),
		.m0_rty_o(	m0s10_rty	),
		.m1_data_i(	m1s10_data_o	),
		.m1_data_o(	m1s10_data_i	),
		.m1_addr_i(	m1s10_addr	),
		.m1_sel_i(	m1s10_sel	),
		.m1_we_i(	m1s10_we	),
		.m1_cyc_i(	m1s10_cyc	),
		.m1_stb_i(	m1s10_stb	),
		.m1_ack_o(	m1s10_ack	),
		.m1_err_o(	m1s10_err	),
		.m1_rty_o(	m1s10_rty	),
		.m2_data_i(	m2s10_data_o	),
		.m2_data_o(	m2s10_data_i	),
		.m2_addr_i(	m2s10_addr	),
		.m2_sel_i(	m2s10_sel	),
		.m2_we_i(	m2s10_we	),
		.m2_cyc_i(	m2s10_cyc	),
		.m2_stb_i(	m2s10_stb	),
		.m2_ack_o(	m2s10_ack	),
		.m2_err_o(	m2s10_err	),
		.m2_rty_o(	m2s10_rty	),
		.m3_data_i(	m3s10_data_o	),
		.m3_data_o(	m3s10_data_i	),
		.m3_addr_i(	m3s10_addr	),
		.m3_sel_i(	m3s10_sel	),
		.m3_we_i(	m3s10_we	),
		.m3_cyc_i(	m3s10_cyc	),
		.m3_stb_i(	m3s10_stb	),
		.m3_ack_o(	m3s10_ack	),
		.m3_err_o(	m3s10_err	),
		.m3_rty_o(	m3s10_rty	),
		.m4_data_i(	m4s10_data_o	),
		.m4_data_o(	m4s10_data_i	),
		.m4_addr_i(	m4s10_addr	),
		.m4_sel_i(	m4s10_sel	),
		.m4_we_i(	m4s10_we	),
		.m4_cyc_i(	m4s10_cyc	),
		.m4_stb_i(	m4s10_stb	),
		.m4_ack_o(	m4s10_ack	),
		.m4_err_o(	m4s10_err	),
		.m4_rty_o(	m4s10_rty	),
		.m5_data_i(	m5s10_data_o	),
		.m5_data_o(	m5s10_data_i	),
		.m5_addr_i(	m5s10_addr	),
		.m5_sel_i(	m5s10_sel	),
		.m5_we_i(	m5s10_we	),
		.m5_cyc_i(	m5s10_cyc	),
		.m5_stb_i(	m5s10_stb	),
		.m5_ack_o(	m5s10_ack	),
		.m5_err_o(	m5s10_err	),
		.m5_rty_o(	m5s10_rty	),
		.m6_data_i(	m6s10_data_o	),
		.m6_data_o(	m6s10_data_i	),
		.m6_addr_i(	m6s10_addr	),
		.m6_sel_i(	m6s10_sel	),
		.m6_we_i(	m6s10_we	),
		.m6_cyc_i(	m6s10_cyc	),
		.m6_stb_i(	m6s10_stb	),
		.m6_ack_o(	m6s10_ack	),
		.m6_err_o(	m6s10_err	),
		.m6_rty_o(	m6s10_rty	),
		.m7_data_i(	m7s10_data_o	),
		.m7_data_o(	m7s10_data_i	),
		.m7_addr_i(	m7s10_addr	),
		.m7_sel_i(	m7s10_sel	),
		.m7_we_i(	m7s10_we	),
		.m7_cyc_i(	m7s10_cyc	),
		.m7_stb_i(	m7s10_stb	),
		.m7_ack_o(	m7s10_ack	),
		.m7_err_o(	m7s10_err	),
		.m7_rty_o(	m7s10_rty	)
		);

wb_conmax_slave_if #(pri_sel11,aw,dw,sw) s11(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf11		),
		.wb_data_i(	s11_data_i	),
		.wb_data_o(	s11_data_o	),
		.wb_addr_o(	s11_addr_o	),
		.wb_sel_o(	s11_sel_o	),
		.wb_we_o(	s11_we_o	),
		.wb_cyc_o(	s11_cyc_o	),
		.wb_stb_o(	s11_stb_o	),
		.wb_ack_i(	s11_ack_i	),
		.wb_err_i(	s11_err_i	),
		.wb_rty_i(	s11_rty_i	),
		.m0_data_i(	m0s11_data_o	),
		.m0_data_o(	m0s11_data_i	),
		.m0_addr_i(	m0s11_addr	),
		.m0_sel_i(	m0s11_sel	),
		.m0_we_i(	m0s11_we	),
		.m0_cyc_i(	m0s11_cyc	),
		.m0_stb_i(	m0s11_stb	),
		.m0_ack_o(	m0s11_ack	),
		.m0_err_o(	m0s11_err	),
		.m0_rty_o(	m0s11_rty	),
		.m1_data_i(	m1s11_data_o	),
		.m1_data_o(	m1s11_data_i	),
		.m1_addr_i(	m1s11_addr	),
		.m1_sel_i(	m1s11_sel	),
		.m1_we_i(	m1s11_we	),
		.m1_cyc_i(	m1s11_cyc	),
		.m1_stb_i(	m1s11_stb	),
		.m1_ack_o(	m1s11_ack	),
		.m1_err_o(	m1s11_err	),
		.m1_rty_o(	m1s11_rty	),
		.m2_data_i(	m2s11_data_o	),
		.m2_data_o(	m2s11_data_i	),
		.m2_addr_i(	m2s11_addr	),
		.m2_sel_i(	m2s11_sel	),
		.m2_we_i(	m2s11_we	),
		.m2_cyc_i(	m2s11_cyc	),
		.m2_stb_i(	m2s11_stb	),
		.m2_ack_o(	m2s11_ack	),
		.m2_err_o(	m2s11_err	),
		.m2_rty_o(	m2s11_rty	),
		.m3_data_i(	m3s11_data_o	),
		.m3_data_o(	m3s11_data_i	),
		.m3_addr_i(	m3s11_addr	),
		.m3_sel_i(	m3s11_sel	),
		.m3_we_i(	m3s11_we	),
		.m3_cyc_i(	m3s11_cyc	),
		.m3_stb_i(	m3s11_stb	),
		.m3_ack_o(	m3s11_ack	),
		.m3_err_o(	m3s11_err	),
		.m3_rty_o(	m3s11_rty	),
		.m4_data_i(	m4s11_data_o	),
		.m4_data_o(	m4s11_data_i	),
		.m4_addr_i(	m4s11_addr	),
		.m4_sel_i(	m4s11_sel	),
		.m4_we_i(	m4s11_we	),
		.m4_cyc_i(	m4s11_cyc	),
		.m4_stb_i(	m4s11_stb	),
		.m4_ack_o(	m4s11_ack	),
		.m4_err_o(	m4s11_err	),
		.m4_rty_o(	m4s11_rty	),
		.m5_data_i(	m5s11_data_o	),
		.m5_data_o(	m5s11_data_i	),
		.m5_addr_i(	m5s11_addr	),
		.m5_sel_i(	m5s11_sel	),
		.m5_we_i(	m5s11_we	),
		.m5_cyc_i(	m5s11_cyc	),
		.m5_stb_i(	m5s11_stb	),
		.m5_ack_o(	m5s11_ack	),
		.m5_err_o(	m5s11_err	),
		.m5_rty_o(	m5s11_rty	),
		.m6_data_i(	m6s11_data_o	),
		.m6_data_o(	m6s11_data_i	),
		.m6_addr_i(	m6s11_addr	),
		.m6_sel_i(	m6s11_sel	),
		.m6_we_i(	m6s11_we	),
		.m6_cyc_i(	m6s11_cyc	),
		.m6_stb_i(	m6s11_stb	),
		.m6_ack_o(	m6s11_ack	),
		.m6_err_o(	m6s11_err	),
		.m6_rty_o(	m6s11_rty	),
		.m7_data_i(	m7s11_data_o	),
		.m7_data_o(	m7s11_data_i	),
		.m7_addr_i(	m7s11_addr	),
		.m7_sel_i(	m7s11_sel	),
		.m7_we_i(	m7s11_we	),
		.m7_cyc_i(	m7s11_cyc	),
		.m7_stb_i(	m7s11_stb	),
		.m7_ack_o(	m7s11_ack	),
		.m7_err_o(	m7s11_err	),
		.m7_rty_o(	m7s11_rty	)
		);

wb_conmax_slave_if #(pri_sel12,aw,dw,sw) s12(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf12		),
		.wb_data_i(	s12_data_i	),
		.wb_data_o(	s12_data_o	),
		.wb_addr_o(	s12_addr_o	),
		.wb_sel_o(	s12_sel_o	),
		.wb_we_o(	s12_we_o	),
		.wb_cyc_o(	s12_cyc_o	),
		.wb_stb_o(	s12_stb_o	),
		.wb_ack_i(	s12_ack_i	),
		.wb_err_i(	s12_err_i	),
		.wb_rty_i(	s12_rty_i	),
		.m0_data_i(	m0s12_data_o	),
		.m0_data_o(	m0s12_data_i	),
		.m0_addr_i(	m0s12_addr	),
		.m0_sel_i(	m0s12_sel	),
		.m0_we_i(	m0s12_we	),
		.m0_cyc_i(	m0s12_cyc	),
		.m0_stb_i(	m0s12_stb	),
		.m0_ack_o(	m0s12_ack	),
		.m0_err_o(	m0s12_err	),
		.m0_rty_o(	m0s12_rty	),
		.m1_data_i(	m1s12_data_o	),
		.m1_data_o(	m1s12_data_i	),
		.m1_addr_i(	m1s12_addr	),
		.m1_sel_i(	m1s12_sel	),
		.m1_we_i(	m1s12_we	),
		.m1_cyc_i(	m1s12_cyc	),
		.m1_stb_i(	m1s12_stb	),
		.m1_ack_o(	m1s12_ack	),
		.m1_err_o(	m1s12_err	),
		.m1_rty_o(	m1s12_rty	),
		.m2_data_i(	m2s12_data_o	),
		.m2_data_o(	m2s12_data_i	),
		.m2_addr_i(	m2s12_addr	),
		.m2_sel_i(	m2s12_sel	),
		.m2_we_i(	m2s12_we	),
		.m2_cyc_i(	m2s12_cyc	),
		.m2_stb_i(	m2s12_stb	),
		.m2_ack_o(	m2s12_ack	),
		.m2_err_o(	m2s12_err	),
		.m2_rty_o(	m2s12_rty	),
		.m3_data_i(	m3s12_data_o	),
		.m3_data_o(	m3s12_data_i	),
		.m3_addr_i(	m3s12_addr	),
		.m3_sel_i(	m3s12_sel	),
		.m3_we_i(	m3s12_we	),
		.m3_cyc_i(	m3s12_cyc	),
		.m3_stb_i(	m3s12_stb	),
		.m3_ack_o(	m3s12_ack	),
		.m3_err_o(	m3s12_err	),
		.m3_rty_o(	m3s12_rty	),
		.m4_data_i(	m4s12_data_o	),
		.m4_data_o(	m4s12_data_i	),
		.m4_addr_i(	m4s12_addr	),
		.m4_sel_i(	m4s12_sel	),
		.m4_we_i(	m4s12_we	),
		.m4_cyc_i(	m4s12_cyc	),
		.m4_stb_i(	m4s12_stb	),
		.m4_ack_o(	m4s12_ack	),
		.m4_err_o(	m4s12_err	),
		.m4_rty_o(	m4s12_rty	),
		.m5_data_i(	m5s12_data_o	),
		.m5_data_o(	m5s12_data_i	),
		.m5_addr_i(	m5s12_addr	),
		.m5_sel_i(	m5s12_sel	),
		.m5_we_i(	m5s12_we	),
		.m5_cyc_i(	m5s12_cyc	),
		.m5_stb_i(	m5s12_stb	),
		.m5_ack_o(	m5s12_ack	),
		.m5_err_o(	m5s12_err	),
		.m5_rty_o(	m5s12_rty	),
		.m6_data_i(	m6s12_data_o	),
		.m6_data_o(	m6s12_data_i	),
		.m6_addr_i(	m6s12_addr	),
		.m6_sel_i(	m6s12_sel	),
		.m6_we_i(	m6s12_we	),
		.m6_cyc_i(	m6s12_cyc	),
		.m6_stb_i(	m6s12_stb	),
		.m6_ack_o(	m6s12_ack	),
		.m6_err_o(	m6s12_err	),
		.m6_rty_o(	m6s12_rty	),
		.m7_data_i(	m7s12_data_o	),
		.m7_data_o(	m7s12_data_i	),
		.m7_addr_i(	m7s12_addr	),
		.m7_sel_i(	m7s12_sel	),
		.m7_we_i(	m7s12_we	),
		.m7_cyc_i(	m7s12_cyc	),
		.m7_stb_i(	m7s12_stb	),
		.m7_ack_o(	m7s12_ack	),
		.m7_err_o(	m7s12_err	),
		.m7_rty_o(	m7s12_rty	)
		);

wb_conmax_slave_if #(pri_sel13,aw,dw,sw) s13(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf13		),
		.wb_data_i(	s13_data_i	),
		.wb_data_o(	s13_data_o	),
		.wb_addr_o(	s13_addr_o	),
		.wb_sel_o(	s13_sel_o	),
		.wb_we_o(	s13_we_o	),
		.wb_cyc_o(	s13_cyc_o	),
		.wb_stb_o(	s13_stb_o	),
		.wb_ack_i(	s13_ack_i	),
		.wb_err_i(	s13_err_i	),
		.wb_rty_i(	s13_rty_i	),
		.m0_data_i(	m0s13_data_o	),
		.m0_data_o(	m0s13_data_i	),
		.m0_addr_i(	m0s13_addr	),
		.m0_sel_i(	m0s13_sel	),
		.m0_we_i(	m0s13_we	),
		.m0_cyc_i(	m0s13_cyc	),
		.m0_stb_i(	m0s13_stb	),
		.m0_ack_o(	m0s13_ack	),
		.m0_err_o(	m0s13_err	),
		.m0_rty_o(	m0s13_rty	),
		.m1_data_i(	m1s13_data_o	),
		.m1_data_o(	m1s13_data_i	),
		.m1_addr_i(	m1s13_addr	),
		.m1_sel_i(	m1s13_sel	),
		.m1_we_i(	m1s13_we	),
		.m1_cyc_i(	m1s13_cyc	),
		.m1_stb_i(	m1s13_stb	),
		.m1_ack_o(	m1s13_ack	),
		.m1_err_o(	m1s13_err	),
		.m1_rty_o(	m1s13_rty	),
		.m2_data_i(	m2s13_data_o	),
		.m2_data_o(	m2s13_data_i	),
		.m2_addr_i(	m2s13_addr	),
		.m2_sel_i(	m2s13_sel	),
		.m2_we_i(	m2s13_we	),
		.m2_cyc_i(	m2s13_cyc	),
		.m2_stb_i(	m2s13_stb	),
		.m2_ack_o(	m2s13_ack	),
		.m2_err_o(	m2s13_err	),
		.m2_rty_o(	m2s13_rty	),
		.m3_data_i(	m3s13_data_o	),
		.m3_data_o(	m3s13_data_i	),
		.m3_addr_i(	m3s13_addr	),
		.m3_sel_i(	m3s13_sel	),
		.m3_we_i(	m3s13_we	),
		.m3_cyc_i(	m3s13_cyc	),
		.m3_stb_i(	m3s13_stb	),
		.m3_ack_o(	m3s13_ack	),
		.m3_err_o(	m3s13_err	),
		.m3_rty_o(	m3s13_rty	),
		.m4_data_i(	m4s13_data_o	),
		.m4_data_o(	m4s13_data_i	),
		.m4_addr_i(	m4s13_addr	),
		.m4_sel_i(	m4s13_sel	),
		.m4_we_i(	m4s13_we	),
		.m4_cyc_i(	m4s13_cyc	),
		.m4_stb_i(	m4s13_stb	),
		.m4_ack_o(	m4s13_ack	),
		.m4_err_o(	m4s13_err	),
		.m4_rty_o(	m4s13_rty	),
		.m5_data_i(	m5s13_data_o	),
		.m5_data_o(	m5s13_data_i	),
		.m5_addr_i(	m5s13_addr	),
		.m5_sel_i(	m5s13_sel	),
		.m5_we_i(	m5s13_we	),
		.m5_cyc_i(	m5s13_cyc	),
		.m5_stb_i(	m5s13_stb	),
		.m5_ack_o(	m5s13_ack	),
		.m5_err_o(	m5s13_err	),
		.m5_rty_o(	m5s13_rty	),
		.m6_data_i(	m6s13_data_o	),
		.m6_data_o(	m6s13_data_i	),
		.m6_addr_i(	m6s13_addr	),
		.m6_sel_i(	m6s13_sel	),
		.m6_we_i(	m6s13_we	),
		.m6_cyc_i(	m6s13_cyc	),
		.m6_stb_i(	m6s13_stb	),
		.m6_ack_o(	m6s13_ack	),
		.m6_err_o(	m6s13_err	),
		.m6_rty_o(	m6s13_rty	),
		.m7_data_i(	m7s13_data_o	),
		.m7_data_o(	m7s13_data_i	),
		.m7_addr_i(	m7s13_addr	),
		.m7_sel_i(	m7s13_sel	),
		.m7_we_i(	m7s13_we	),
		.m7_cyc_i(	m7s13_cyc	),
		.m7_stb_i(	m7s13_stb	),
		.m7_ack_o(	m7s13_ack	),
		.m7_err_o(	m7s13_err	),
		.m7_rty_o(	m7s13_rty	)
		);

wb_conmax_slave_if #(pri_sel14,aw,dw,sw) s14(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf14		),
		.wb_data_i(	s14_data_i	),
		.wb_data_o(	s14_data_o	),
		.wb_addr_o(	s14_addr_o	),
		.wb_sel_o(	s14_sel_o	),
		.wb_we_o(	s14_we_o	),
		.wb_cyc_o(	s14_cyc_o	),
		.wb_stb_o(	s14_stb_o	),
		.wb_ack_i(	s14_ack_i	),
		.wb_err_i(	s14_err_i	),
		.wb_rty_i(	s14_rty_i	),
		.m0_data_i(	m0s14_data_o	),
		.m0_data_o(	m0s14_data_i	),
		.m0_addr_i(	m0s14_addr	),
		.m0_sel_i(	m0s14_sel	),
		.m0_we_i(	m0s14_we	),
		.m0_cyc_i(	m0s14_cyc	),
		.m0_stb_i(	m0s14_stb	),
		.m0_ack_o(	m0s14_ack	),
		.m0_err_o(	m0s14_err	),
		.m0_rty_o(	m0s14_rty	),
		.m1_data_i(	m1s14_data_o	),
		.m1_data_o(	m1s14_data_i	),
		.m1_addr_i(	m1s14_addr	),
		.m1_sel_i(	m1s14_sel	),
		.m1_we_i(	m1s14_we	),
		.m1_cyc_i(	m1s14_cyc	),
		.m1_stb_i(	m1s14_stb	),
		.m1_ack_o(	m1s14_ack	),
		.m1_err_o(	m1s14_err	),
		.m1_rty_o(	m1s14_rty	),
		.m2_data_i(	m2s14_data_o	),
		.m2_data_o(	m2s14_data_i	),
		.m2_addr_i(	m2s14_addr	),
		.m2_sel_i(	m2s14_sel	),
		.m2_we_i(	m2s14_we	),
		.m2_cyc_i(	m2s14_cyc	),
		.m2_stb_i(	m2s14_stb	),
		.m2_ack_o(	m2s14_ack	),
		.m2_err_o(	m2s14_err	),
		.m2_rty_o(	m2s14_rty	),
		.m3_data_i(	m3s14_data_o	),
		.m3_data_o(	m3s14_data_i	),
		.m3_addr_i(	m3s14_addr	),
		.m3_sel_i(	m3s14_sel	),
		.m3_we_i(	m3s14_we	),
		.m3_cyc_i(	m3s14_cyc	),
		.m3_stb_i(	m3s14_stb	),
		.m3_ack_o(	m3s14_ack	),
		.m3_err_o(	m3s14_err	),
		.m3_rty_o(	m3s14_rty	),
		.m4_data_i(	m4s14_data_o	),
		.m4_data_o(	m4s14_data_i	),
		.m4_addr_i(	m4s14_addr	),
		.m4_sel_i(	m4s14_sel	),
		.m4_we_i(	m4s14_we	),
		.m4_cyc_i(	m4s14_cyc	),
		.m4_stb_i(	m4s14_stb	),
		.m4_ack_o(	m4s14_ack	),
		.m4_err_o(	m4s14_err	),
		.m4_rty_o(	m4s14_rty	),
		.m5_data_i(	m5s14_data_o	),
		.m5_data_o(	m5s14_data_i	),
		.m5_addr_i(	m5s14_addr	),
		.m5_sel_i(	m5s14_sel	),
		.m5_we_i(	m5s14_we	),
		.m5_cyc_i(	m5s14_cyc	),
		.m5_stb_i(	m5s14_stb	),
		.m5_ack_o(	m5s14_ack	),
		.m5_err_o(	m5s14_err	),
		.m5_rty_o(	m5s14_rty	),
		.m6_data_i(	m6s14_data_o	),
		.m6_data_o(	m6s14_data_i	),
		.m6_addr_i(	m6s14_addr	),
		.m6_sel_i(	m6s14_sel	),
		.m6_we_i(	m6s14_we	),
		.m6_cyc_i(	m6s14_cyc	),
		.m6_stb_i(	m6s14_stb	),
		.m6_ack_o(	m6s14_ack	),
		.m6_err_o(	m6s14_err	),
		.m6_rty_o(	m6s14_rty	),
		.m7_data_i(	m7s14_data_o	),
		.m7_data_o(	m7s14_data_i	),
		.m7_addr_i(	m7s14_addr	),
		.m7_sel_i(	m7s14_sel	),
		.m7_we_i(	m7s14_we	),
		.m7_cyc_i(	m7s14_cyc	),
		.m7_stb_i(	m7s14_stb	),
		.m7_ack_o(	m7s14_ack	),
		.m7_err_o(	m7s14_err	),
		.m7_rty_o(	m7s14_rty	)
		);

wb_conmax_slave_if #(pri_sel15,aw,dw,sw) s15(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.conf(		conf15		),
		.wb_data_i(	i_s15_data_i	),
		.wb_data_o(	i_s15_data_o	),
		.wb_addr_o(	i_s15_addr_o	),
		.wb_sel_o(	i_s15_sel_o	),
		.wb_we_o(	i_s15_we_o	),
		.wb_cyc_o(	i_s15_cyc_o	),
		.wb_stb_o(	i_s15_stb_o	),
		.wb_ack_i(	i_s15_ack_i	),
		.wb_err_i(	i_s15_err_i	),
		.wb_rty_i(	i_s15_rty_i	),
		.m0_data_i(	m0s15_data_o	),
		.m0_data_o(	m0s15_data_i	),
		.m0_addr_i(	m0s15_addr	),
		.m0_sel_i(	m0s15_sel	),
		.m0_we_i(	m0s15_we	),
		.m0_cyc_i(	m0s15_cyc	),
		.m0_stb_i(	m0s15_stb	),
		.m0_ack_o(	m0s15_ack	),
		.m0_err_o(	m0s15_err	),
		.m0_rty_o(	m0s15_rty	),
		.m1_data_i(	m1s15_data_o	),
		.m1_data_o(	m1s15_data_i	),
		.m1_addr_i(	m1s15_addr	),
		.m1_sel_i(	m1s15_sel	),
		.m1_we_i(	m1s15_we	),
		.m1_cyc_i(	m1s15_cyc	),
		.m1_stb_i(	m1s15_stb	),
		.m1_ack_o(	m1s15_ack	),
		.m1_err_o(	m1s15_err	),
		.m1_rty_o(	m1s15_rty	),
		.m2_data_i(	m2s15_data_o	),
		.m2_data_o(	m2s15_data_i	),
		.m2_addr_i(	m2s15_addr	),
		.m2_sel_i(	m2s15_sel	),
		.m2_we_i(	m2s15_we	),
		.m2_cyc_i(	m2s15_cyc	),
		.m2_stb_i(	m2s15_stb	),
		.m2_ack_o(	m2s15_ack	),
		.m2_err_o(	m2s15_err	),
		.m2_rty_o(	m2s15_rty	),
		.m3_data_i(	m3s15_data_o	),
		.m3_data_o(	m3s15_data_i	),
		.m3_addr_i(	m3s15_addr	),
		.m3_sel_i(	m3s15_sel	),
		.m3_we_i(	m3s15_we	),
		.m3_cyc_i(	m3s15_cyc	),
		.m3_stb_i(	m3s15_stb	),
		.m3_ack_o(	m3s15_ack	),
		.m3_err_o(	m3s15_err	),
		.m3_rty_o(	m3s15_rty	),
		.m4_data_i(	m4s15_data_o	),
		.m4_data_o(	m4s15_data_i	),
		.m4_addr_i(	m4s15_addr	),
		.m4_sel_i(	m4s15_sel	),
		.m4_we_i(	m4s15_we	),
		.m4_cyc_i(	m4s15_cyc	),
		.m4_stb_i(	m4s15_stb	),
		.m4_ack_o(	m4s15_ack	),
		.m4_err_o(	m4s15_err	),
		.m4_rty_o(	m4s15_rty	),
		.m5_data_i(	m5s15_data_o	),
		.m5_data_o(	m5s15_data_i	),
		.m5_addr_i(	m5s15_addr	),
		.m5_sel_i(	m5s15_sel	),
		.m5_we_i(	m5s15_we	),
		.m5_cyc_i(	m5s15_cyc	),
		.m5_stb_i(	m5s15_stb	),
		.m5_ack_o(	m5s15_ack	),
		.m5_err_o(	m5s15_err	),
		.m5_rty_o(	m5s15_rty	),
		.m6_data_i(	m6s15_data_o	),
		.m6_data_o(	m6s15_data_i	),
		.m6_addr_i(	m6s15_addr	),
		.m6_sel_i(	m6s15_sel	),
		.m6_we_i(	m6s15_we	),
		.m6_cyc_i(	m6s15_cyc	),
		.m6_stb_i(	m6s15_stb	),
		.m6_ack_o(	m6s15_ack	),
		.m6_err_o(	m6s15_err	),
		.m6_rty_o(	m6s15_rty	),
		.m7_data_i(	m7s15_data_o	),
		.m7_data_o(	m7s15_data_i	),
		.m7_addr_i(	m7s15_addr	),
		.m7_sel_i(	m7s15_sel	),
		.m7_we_i(	m7s15_we	),
		.m7_cyc_i(	m7s15_cyc	),
		.m7_stb_i(	m7s15_stb	),
		.m7_ack_o(	m7s15_ack	),
		.m7_err_o(	m7s15_err	),
		.m7_rty_o(	m7s15_rty	)
		);

wb_conmax_rf #(rf_addr,dw,aw,sw) rf(
		.clk_i(		clk_i		),
		.rst_i(		rst_i		),
		.i_wb_data_i(	i_s15_data_o	),
		.i_wb_data_o(	i_s15_data_i	),
		.i_wb_addr_i(	i_s15_addr_o	),
		.i_wb_sel_i(	i_s15_sel_o	),
		.i_wb_we_i(	i_s15_we_o	),
		.i_wb_cyc_i(	i_s15_cyc_o	),
		.i_wb_stb_i(	i_s15_stb_o	),
		.i_wb_ack_o(	i_s15_ack_i	),
		.i_wb_err_o(	i_s15_err_i	),
		.i_wb_rty_o(	i_s15_rty_i	),

		.e_wb_data_i(	s15_data_i	),
		.e_wb_data_o(	s15_data_o	),
		.e_wb_addr_o(	s15_addr_o	),
		.e_wb_sel_o(	s15_sel_o	),
		.e_wb_we_o(	s15_we_o	),
		.e_wb_cyc_o(	s15_cyc_o	),
		.e_wb_stb_o(	s15_stb_o	),
		.e_wb_ack_i(	s15_ack_i	),
		.e_wb_err_i(	s15_err_i	),
		.e_wb_rty_i(	s15_rty_i	),

		.conf0(         conf0           ),
		.conf1(         conf1           ),
		.conf2(         conf2           ),
		.conf3(         conf3           ),
		.conf4(         conf4           ),
		.conf5(         conf5           ),
		.conf6(         conf6           ),
		.conf7(         conf7           ),
		.conf8(         conf8           ),
		.conf9(         conf9           ),
		.conf10(        conf10          ),
		.conf11(        conf11          ),
		.conf12(        conf12          ),
		.conf13(        conf13          ),
		.conf14(        conf14          ),
		.conf15(        conf15          )
		);
endmodule

