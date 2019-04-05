//////////////////////////////////////////////////////////////////////
////                                                              ////
////  WISHBONE General-Purpose I/O                                ////
////                                                              ////
////  This file is part of the GPIO project                       ////
////  http://www.opencores.org/cores/gpio/                        ////
////                                                              ////
////  Description                                                 ////
////  Implementation of GPIO IP core according to                 ////
////  GPIO IP core specification document.                        ////
////                                                              ////
////  To Do:                                                      ////
////   Nothing                                                    ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.17  2004/05/05 08:21:00  andreje
// Bugfixes when GPIO_RGPIO_ECLK/GPIO_RGPIO_NEC disabled, gpio oe name change and set to active-high according to spec
//
// Revision 1.16  2003/12/17 13:00:52  gorand
// added ECLK and NEC registers, all tests passed.
//
// Revision 1.15  2003/11/10 23:21:22  gorand
// bug fixed. all tests passed.
//
// Revision 1.14  2003/11/06 13:59:07  gorand
// added support for 8-bit access to registers.
//
// Revision 1.13  2002/11/18 22:35:18  lampret
// Bug fix. Interrupts were also asserted when condition was not met.
//
// Revision 1.12  2002/11/11 21:36:28  lampret
// Added ifdef to remove mux from clk_pad_i if mux is not allowed. This also removes RGPIO_CTRL[NEC].
//
// Revision 1.11  2002/03/13 20:56:28  lampret
// Removed zero padding as per Avi Shamli suggestion.
//
// Revision 1.10  2002/03/13 20:47:57  lampret
// Ports changed per Ran Aviram suggestions.
//
// Revision 1.9  2002/03/09 03:43:27  lampret
// Interrupt is asserted only when an input changes (code patch by Jacob Gorban)
//
// Revision 1.8  2002/01/14 19:06:28  lampret
// Changed registered WISHBONE outputs wb_ack_o/wb_err_o to follow WB specification.
//
// Revision 1.7  2001/12/25 17:21:21  lampret
// Fixed two typos.
//
// Revision 1.6  2001/12/25 17:12:35  lampret
// Added RGPIO_INTS.
//
// Revision 1.5  2001/12/12 20:35:53  lampret
// Fixing style.
//
// Revision 1.4  2001/12/12 07:12:58  lampret
// Fixed bug when wb_inta_o is registered (GPIO_WB_REGISTERED_OUTPUTS)
//
// Revision 1.3  2001/11/15 02:24:37  lampret
// Added GPIO_REGISTERED_WB_OUTPUTS, GPIO_REGISTERED_IO_OUTPUTS and GPIO_NO_NEGEDGE_FLOPS.
//
// Revision 1.2  2001/10/31 02:26:51  lampret
// Fixed wb_err_o.
//
// Revision 1.1  2001/09/18 18:49:07  lampret
// Changed top level ptc into gpio_top. Changed defines.v into gpio_defines.v.
//
// Revision 1.1  2001/08/21 21:39:28  lampret
// Changed directory structure, port names and drfines.
//
// Revision 1.2  2001/07/14 20:39:26  lampret
// Better configurability.
//
// Revision 1.1  2001/06/05 07:45:26  lampret
// Added initial RTL and test benches. There are still some issues with these files.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "gpio_defines.v"

module gpio_top(
	// WISHBONE Interface
	wb_clk_i, wb_rst_i, wb_cyc_i, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_stb_i,
	wb_dat_o, wb_ack_o, wb_err_o, wb_inta_o,

`ifdef GPIO_AUX_IMPLEMENT
	// Auxiliary inputs interface
	aux_i,
`endif //  GPIO_AUX_IMPLEMENT

	// External GPIO Interface
	ext_pad_i, ext_pad_o, ext_padoe_o
`ifdef GPIO_CLKPAD
  , clk_pad_i 
`endif
);

parameter dw = 32;
parameter aw = `GPIO_ADDRHH+1;
parameter gw = `GPIO_IOS;
//
// WISHBONE Interface
//
input             wb_clk_i;	// Clock
input             wb_rst_i;	// Reset
input             wb_cyc_i;	// cycle valid input
input   [aw-1:0]	wb_adr_i;	// address bus inputs
input   [dw-1:0]	wb_dat_i;	// input data bus
input	  [3:0]     wb_sel_i;	// byte select inputs
input             wb_we_i;	// indicates write transfer
input             wb_stb_i;	// strobe input
output  [dw-1:0]  wb_dat_o;	// output data bus
output            wb_ack_o;	// normal termination
output            wb_err_o;	// termination w/ error
output            wb_inta_o;	// Interrupt request output

`ifdef GPIO_AUX_IMPLEMENT
// Auxiliary Inputs Interface
input	  [gw-1:0]  aux_i;		// Auxiliary inputs
`endif // GPIO_AUX_IMPLEMENT

//
// External GPIO Interface
//
input   [gw-1:0]  ext_pad_i;	// GPIO Inputs
`ifdef GPIO_CLKPAD
input             clk_pad_i;	// GPIO Eclk
`endif //  GPIO_CLKPAD
output  [gw-1:0]  ext_pad_o;	// GPIO Outputs
output  [gw-1:0]  ext_padoe_o;	// GPIO output drivers enables

`ifdef GPIO_IMPLEMENTED

//
// GPIO Input Register (or no register)
//
`ifdef GPIO_RGPIO_IN
reg	[gw-1:0]	rgpio_in;	// RGPIO_IN register
`else
wire	[gw-1:0]	rgpio_in;	// No register
`endif

//
// GPIO Output Register (or no register)
//
`ifdef GPIO_RGPIO_OUT
reg	[gw-1:0]	rgpio_out;	// RGPIO_OUT register
`else
wire	[gw-1:0]	rgpio_out;	// No register
`endif

//
// GPIO Output Driver Enable Register (or no register)
//
`ifdef GPIO_RGPIO_OE
reg	[gw-1:0]	rgpio_oe;	// RGPIO_OE register
`else
wire	[gw-1:0]	rgpio_oe;	// No register
`endif

//
// GPIO Interrupt Enable Register (or no register)
//
`ifdef GPIO_RGPIO_INTE
reg	[gw-1:0]	rgpio_inte;	// RGPIO_INTE register
`else
wire	[gw-1:0]	rgpio_inte;	// No register
`endif

//
// GPIO Positive edge Triggered Register (or no register)
//
`ifdef GPIO_RGPIO_PTRIG
reg	[gw-1:0]	rgpio_ptrig;	// RGPIO_PTRIG register
`else
wire	[gw-1:0]	rgpio_ptrig;	// No register
`endif

//
// GPIO Auxiliary select Register (or no register)
//
`ifdef GPIO_RGPIO_AUX
reg	[gw-1:0]	rgpio_aux;	// RGPIO_AUX register
`else
wire	[gw-1:0]	rgpio_aux;	// No register
`endif

//
// GPIO Control Register (or no register)
//
`ifdef GPIO_RGPIO_CTRL
reg	[1:0]		rgpio_ctrl;	// RGPIO_CTRL register
`else
wire	[1:0]		rgpio_ctrl;	// No register
`endif

//
// GPIO Interrupt Status Register (or no register)
//
`ifdef GPIO_RGPIO_INTS
reg	[gw-1:0]	rgpio_ints;	// RGPIO_INTS register
`else
wire	[gw-1:0]	rgpio_ints;	// No register
`endif

//
// GPIO Enable Clock  Register (or no register)
//
`ifdef GPIO_RGPIO_ECLK
reg	[gw-1:0]	rgpio_eclk;	// RGPIO_ECLK register
`else
wire	[gw-1:0]	rgpio_eclk;	// No register
`endif

//
// GPIO Active Negative Edge  Register (or no register)
//
`ifdef GPIO_RGPIO_NEC
reg	[gw-1:0]	rgpio_nec;	// RGPIO_NEC register
`else
wire	[gw-1:0]	rgpio_nec;	// No register
`endif


//
// Synchronization flops for input signals
//
`ifdef GPIO_SYNC_IN_WB 
reg  [gw-1:0]  sync      ,
               ext_pad_s ;
`else 
wire [gw-1:0]  ext_pad_s ;
`endif



//
// Internal wires & regs
//
wire            rgpio_out_sel;  // RGPIO_OUT select
wire            rgpio_oe_sel; // RGPIO_OE select
wire            rgpio_inte_sel; // RGPIO_INTE select
wire            rgpio_ptrig_sel;// RGPIO_PTRIG select
wire            rgpio_aux_sel;  // RGPIO_AUX select
wire            rgpio_ctrl_sel; // RGPIO_CTRL select
wire            rgpio_ints_sel; // RGPIO_INTS select
wire            rgpio_eclk_sel ;
wire            rgpio_nec_sel ;
wire            full_decoding;  // Full address decoding qualification
wire  [gw-1:0]  in_muxed; // Muxed inputs
wire            wb_ack;   // WB Acknowledge
wire            wb_err;   // WB Error
wire            wb_inta;  // WB Interrupt
reg   [dw-1:0]  wb_dat;   // WB Data out
`ifdef GPIO_REGISTERED_WB_OUTPUTS
reg             wb_ack_o; // WB Acknowledge
reg             wb_err_o; // WB Error
reg             wb_inta_o;  // WB Interrupt
reg   [dw-1:0]  wb_dat_o; // WB Data out
`endif
wire  [gw-1:0]  out_pad;  // GPIO Outputs
`ifdef GPIO_REGISTERED_IO_OUTPUTS
reg   [gw-1:0]  ext_pad_o;  // GPIO Outputs
`endif
`ifdef GPIO_CLKPAD
wire  [gw-1:0]  extc_in;  // Muxed inputs sampled by external clock
wire  [gw-1:0]  pext_clk; // External clock for posedge flops
reg   [gw-1:0]  pextc_sampled;  // Posedge external clock sampled inputs
`ifdef GPIO_NO_NEGEDGE_FLOPS
`ifdef GPIO_NO_CLKPAD_LOGIC
`else
reg   [gw-1:0]  nextc_sampled;  // Negedge external clock sampled inputs
`endif //  GPIO_NO_CLKPAD_LOGIC
`else
reg   [gw-1:0]  nextc_sampled;  // Negedge external clock sampled inputs
`endif
`endif //  GPIO_CLKPAD


//
// All WISHBONE transfer terminations are successful except when:
// a) full address decoding is enabled and address doesn't match
//    any of the GPIO registers
// b) wb_sel_i evaluation is enabled and one of the wb_sel_i inputs is zero
//

//
// WB Acknowledge
//
assign wb_ack = wb_cyc_i & wb_stb_i & !wb_err_o;

//
// Optional registration of WB Ack
//
`ifdef GPIO_REGISTERED_WB_OUTPUTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		wb_ack_o <= #1 1'b0;
	else
		wb_ack_o <= #1 wb_ack & ~wb_ack_o & (!wb_err) ;
`else
assign wb_ack_o = wb_ack;
`endif

//
// WB Error
//
`ifdef GPIO_FULL_DECODE
`ifdef GPIO_STRICT_32BIT_ACCESS
assign wb_err = wb_cyc_i & wb_stb_i & (!full_decoding | (wb_sel_i != 4'b1111));
`else
assign wb_err = wb_cyc_i & wb_stb_i & !full_decoding;
`endif
`else
`ifdef GPIO_STRICT_32BIT_ACCESS
assign wb_err = wb_cyc_i & wb_stb_i & (wb_sel_i != 4'b1111);
`else
assign wb_err = 1'b0;
`endif
`endif

//
// Optional registration of WB error
//
`ifdef GPIO_REGISTERED_WB_OUTPUTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		wb_err_o <= #1 1'b0;
	else
		wb_err_o <= #1 wb_err & ~wb_err_o;
`else
assign wb_err_o = wb_err;
`endif

//
// Full address decoder
//
`ifdef GPIO_FULL_DECODE
assign full_decoding = (wb_adr_i[`GPIO_ADDRHH:`GPIO_ADDRHL] == {`GPIO_ADDRHH-`GPIO_ADDRHL+1{1'b0}}) &
			(wb_adr_i[`GPIO_ADDRLH:`GPIO_ADDRLL] == {`GPIO_ADDRLH-`GPIO_ADDRLL+1{1'b0}});
`else
assign full_decoding = 1'b1;
`endif

//
// GPIO registers address decoder
//
`ifdef GPIO_RGPIO_OUT
assign rgpio_out_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_OUT) & full_decoding;
`endif
`ifdef GPIO_RGPIO_OE
assign rgpio_oe_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_OE) & full_decoding;
`endif
`ifdef GPIO_RGPIO_INTE
assign rgpio_inte_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_INTE) & full_decoding;
`endif
`ifdef GPIO_RGPIO_PTRIG
assign rgpio_ptrig_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_PTRIG) & full_decoding;
`endif
`ifdef GPIO_RGPIO_AUX
assign rgpio_aux_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_AUX) & full_decoding;
`endif
`ifdef GPIO_RGPIO_CTRL
assign rgpio_ctrl_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_CTRL) & full_decoding;
`endif
`ifdef GPIO_RGPIO_INTS
assign rgpio_ints_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_INTS) & full_decoding;
`endif
`ifdef GPIO_RGPIO_ECLK
assign rgpio_eclk_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_ECLK) & full_decoding;
`endif
`ifdef GPIO_RGPIO_NEC
assign rgpio_nec_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`GPIO_OFS_BITS] == `GPIO_RGPIO_NEC) & full_decoding;
`endif


//
// Write to RGPIO_CTRL or update of RGPIO_CTRL[INT] bit
//
`ifdef GPIO_RGPIO_CTRL
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_ctrl <= #1 2'b0;
	else if (rgpio_ctrl_sel && wb_we_i)
		rgpio_ctrl <= #1 wb_dat_i[1:0];
	else if (rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])
		rgpio_ctrl[`GPIO_RGPIO_CTRL_INTS] <= #1 rgpio_ctrl[`GPIO_RGPIO_CTRL_INTS] | wb_inta_o;
`else
assign rgpio_ctrl = 2'h01;	// RGPIO_CTRL[EN] = 1
`endif

//
// Write to RGPIO_OUT
//
`ifdef GPIO_RGPIO_OUT
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_out <= #1 {gw{1'b0}};
	else if (rgpio_out_sel && wb_we_i)
    begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_out <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_out [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_out [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_out [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_out [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_out [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_out [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_out [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_out [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_out [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_out [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end

`else
assign rgpio_out = `GPIO_DEF_RGPIO_OUT;	// RGPIO_OUT = 0x0
`endif

//
// Write to RGPIO_OE.
//
`ifdef GPIO_RGPIO_OE
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_oe <= #1 {gw{1'b0}};
	else if (rgpio_oe_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_oe <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_oe [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_oe [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_oe [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_oe [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_oe [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_oe [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_oe [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_oe [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_oe [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_oe [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end

`else
assign rgpio_oe = `GPIO_DEF_RGPIO_OE;	// RGPIO_OE = 0x0
`endif

//
// Write to RGPIO_INTE
//
`ifdef GPIO_RGPIO_INTE
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_inte <= #1 {gw{1'b0}};
	else if (rgpio_inte_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_inte <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_inte [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_inte [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_inte [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_inte [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_inte [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_inte [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_inte [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_inte [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_inte [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_inte [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end


`else
assign rgpio_inte = `GPIO_DEF_RGPIO_INTE;	// RGPIO_INTE = 0x0
`endif

//
// Write to RGPIO_PTRIG
//
`ifdef GPIO_RGPIO_PTRIG
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_ptrig <= #1 {gw{1'b0}};
	else if (rgpio_ptrig_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_ptrig <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_ptrig [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_ptrig [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_ptrig [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_ptrig [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_ptrig [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_ptrig [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_ptrig [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_ptrig [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_ptrig [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_ptrig [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end
    
`else
assign rgpio_ptrig = `GPIO_DEF_RGPIO_PTRIG;	// RGPIO_PTRIG = 0x0
`endif

//
// Write to RGPIO_AUX
//
`ifdef GPIO_RGPIO_AUX
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_aux <= #1 {gw{1'b0}};
	else if (rgpio_aux_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_aux <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_aux [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_aux [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_aux [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_aux [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_aux [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_aux [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_aux [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_aux [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_aux [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_aux [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end

`else
assign rgpio_aux = `GPIO_DEF_RGPIO_AUX;	// RGPIO_AUX = 0x0
`endif


//
// Write to RGPIO_ECLK
//
`ifdef GPIO_RGPIO_ECLK
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_eclk <= #1 {gw{1'b0}};
	else if (rgpio_eclk_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_eclk <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_eclk [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_eclk [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_eclk [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_eclk [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_eclk [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_eclk [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_eclk [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_eclk [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_eclk [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_eclk [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end


`else
assign rgpio_eclk = `GPIO_DEF_RGPIO_ECLK;	// RGPIO_ECLK = 0x0
`endif



//
// Write to RGPIO_NEC
//
`ifdef GPIO_RGPIO_NEC
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_nec <= #1 {gw{1'b0}};
	else if (rgpio_nec_sel && wb_we_i)
  begin
`ifdef GPIO_STRICT_32BIT_ACCESS
		rgpio_nec <= #1 wb_dat_i[gw-1:0];
`endif

`ifdef GPIO_WB_BYTES4
     if ( wb_sel_i [3] == 1'b1 )
       rgpio_nec [gw-1:24] <= #1 wb_dat_i [gw-1:24] ;
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_nec [23:16] <= #1 wb_dat_i [23:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_nec [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_nec [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES3
     if ( wb_sel_i [2] == 1'b1 )
       rgpio_nec [gw-1:16] <= #1 wb_dat_i [gw-1:16] ;
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_nec [15:8] <= #1 wb_dat_i [15:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_nec [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES2
     if ( wb_sel_i [1] == 1'b1 )
       rgpio_nec [gw-1:8] <= #1 wb_dat_i [gw-1:8] ;
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_nec [7:0] <= #1 wb_dat_i [7:0] ;
`endif
`ifdef GPIO_WB_BYTES1
     if ( wb_sel_i [0] == 1'b1 )
       rgpio_nec [gw-1:0] <= #1 wb_dat_i [gw-1:0] ;
`endif
   end


`else
assign rgpio_nec = `GPIO_DEF_RGPIO_NEC;	// RGPIO_NEC = 0x0
`endif

//
// synchronize inputs to systam clock
//
`ifdef  GPIO_SYNC_IN_WB
always @(posedge wb_clk_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    sync      <= #1 {gw{1'b0}} ; 
    ext_pad_s <= #1 {gw{1'b0}} ; 
  end else begin
    sync      <= #1 ext_pad_i  ; 
    ext_pad_s <= #1 sync       ; 
  end
`else 
assign  ext_pad_s = ext_pad_i;
`endif // GPIO_SYNC_IN_WB
  
//
// Latch into RGPIO_IN
//
`ifdef GPIO_RGPIO_IN
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_in <= #1 {gw{1'b0}};
	else
		rgpio_in <= #1 in_muxed;
`else
assign rgpio_in = in_muxed;
`endif

`ifdef GPIO_CLKPAD

`ifdef GPIO_SYNC_CLK_WB
//
// external clock enabled
// synchronized to system clock
// (one clock domain)
//

reg  sync_clk,
     clk_s   ,
     clk_r   ;
wire pedge   ,
     nedge   ;
wire [gw-1:0] pedge_vec   ,
              nedge_vec   ;
wire [gw-1:0] in_lach     ;

assign pedge =  clk_s & !clk_r ; 
assign nedge = !clk_s &  clk_r ; 
assign pedge_vec = {gw{pedge}} ;   
assign nedge_vec = {gw{nedge}} ;   

assign in_lach = (~rgpio_nec & pedge_vec) | (rgpio_nec & nedge_vec) ;
assign extc_in = (in_lach & ext_pad_s) | (~in_lach & pextc_sampled) ;

always @(posedge wb_clk_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    sync_clk <= #1 1'b0 ;
    clk_s    <= #1 1'b0 ;
    clk_r    <= #1 1'b0 ;
  end else begin
    sync_clk <= #1 clk_pad_i ;
    clk_s    <= #1 sync_clk  ;
    clk_r    <= #1 clk_s     ;
  end

always @(posedge wb_clk_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    pextc_sampled <= #1 {gw{1'b0}};
  end else begin
    pextc_sampled <= #1 extc_in ;
  end

assign in_muxed = (rgpio_eclk & pextc_sampled) | (~rgpio_eclk & ext_pad_s) ;

`else
//
// external clock enabled
// not  synchronized to system clock
// (two clock domains)
//

`ifdef GPIO_SYNC_IN_CLK_WB

reg [gw-1:0] syn_extc  ,
             extc_s    ;

always @(posedge wb_clk_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    syn_extc  <= #1 {gw{1'b0}};
    extc_s    <= #1 {gw{1'b0}};
  end else begin
    syn_extc  <= #1 extc_in ;
    extc_s    <= #1 syn_extc;
  end

`else

wire [gw-1:0] extc_s   ;
assign extc_s = syn_extc ;

`endif // GPIO_SYNC_IN_CLK_WB

`ifdef GPIO_SYNC_IN_CLK
reg [gw-1:0] syn_pclk    ,
             ext_pad_spc ;

always @(posedge clk_pad_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    syn_pclk    <= #1 {gw{1'b0}} ; 
    ext_pad_spc <= #1 {gw{1'b0}} ; 
  end else begin
    syn_pclk    <= #1 ext_pad_i ; 
    ext_pad_spc <= #1 syn_pclk  ; 
  end

`else

wire [gw-1:0] ext_pad_spc      ;
assign ext_pad_spc = ext_pad_i ;

`endif // GPIO_SYNC_IN_CLK

always @(posedge clk_pad_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    pextc_sampled <= #1 {gw{1'b0}};
  end else begin
    pextc_sampled <= #1 ext_pad_spc ;
  end


`ifdef GPIO_NO_NEGEDGE_FLOPS

`ifdef GPIO_NO_CLKPAD_LOGIC

assign extc_in = pextc_sampled;

`else

wire  clk_n;
assign clk_n = !clk_pad_i;

`ifdef GPIO_SYNC_IN_CLK
reg [gw-1:0] syn_nclk    ,
             ext_pad_snc ;

always @(posedge clk_n or posedge wb_rst_i)
  if (wb_rst_i) begin
    syn_nclk    <= #1 {gw{1'b0}} ; 
    ext_pad_snc <= #1 {gw{1'b0}} ; 
  end else begin
    syn_nclk    <= #1 ext_pad_i ; 
    ext_pad_snc <= #1 syn_nclk  ; 
  end

`else

wire [gw-1:0] ext_pad_snc      ;
assign ext_pad_snc = ext_pad_i ;

`endif // GPIO_SYNC_IN_CLK

always @(posedge clk_n or posedge wb_rst_i)
  if (wb_rst_i) begin
    nextc_sampled <= #1 {gw{1'b0}};
  end else begin
    nextc_sampled <= #1 ext_pad_snc ;
  end  

assign extc_in = (~rgpio_nec & pextc_sampled) | (rgpio_nec & nextc_sampled) ;

`endif //  GPIO_NO_CLKPAD_LOGIC


`else

`ifdef GPIO_SYNC_IN_CLK
reg [gw-1:0] syn_nclk    ,
             ext_pad_snc ;

always @(negedge clk_n or posedge wb_rst_i)
  if (wb_rst_i) begin
    syn_nclk    <= #1 {gw{1'b0}} ; 
    ext_pad_snc <= #1 {gw{1'b0}} ; 
  end else begin
    syn_nclk    <= #1 ext_pad_i ; 
    ext_pad_snc <= #1 syn_nclk  ; 
  end

`else

wire [gw-1:0] ext_pad_snc      ;
assign ext_pad_snc = ext_pad_i ;

`endif // GPIO_SYNC_IN_CLK

always @(negedge clk_pad_i or posedge wb_rst_i)
  if (wb_rst_i) begin
    nextc_sampled <= #1 {gw{1'b0}};
  end else begin
    nextc_sampled <= #1 ext_pad_snc ;
  end

assign extc_in = (~rgpio_nec & pextc_sampled) | (rgpio_nec & nextc_sampled) ;

`endif //  GPIO_NO_NEGEDGE_FLOPS

assign in_muxed = (rgpio_eclk & extc_s)      | (~rgpio_eclk & ext_pad_s) ;


`endif //  GPIO_SYNC_CLK_WB


`else

assign  in_muxed  = ext_pad_s ;

`endif //  GPIO_CLKPAD



//
// Mux all registers when doing a read of GPIO registers
//
always @(wb_adr_i or rgpio_in or rgpio_out or rgpio_oe or rgpio_inte or
		rgpio_ptrig or rgpio_aux or rgpio_ctrl or rgpio_ints or rgpio_eclk or rgpio_nec)
	case (wb_adr_i[`GPIO_OFS_BITS])	// synopsys full_case parallel_case
`ifdef GPIO_READREGS
  `ifdef GPIO_RGPIO_OUT
  	`GPIO_RGPIO_OUT: begin
			wb_dat[dw-1:0] = rgpio_out;
		end
  `endif
  `ifdef GPIO_RGPIO_OE
		`GPIO_RGPIO_OE: begin
			wb_dat[dw-1:0] = rgpio_oe;
		end
  `endif
  `ifdef GPIO_RGPIO_INTE
		`GPIO_RGPIO_INTE: begin
			wb_dat[dw-1:0] = rgpio_inte;
		end
  `endif
  `ifdef GPIO_RGPIO_PTRIG
		`GPIO_RGPIO_PTRIG: begin
			wb_dat[dw-1:0] = rgpio_ptrig;
		end
  `endif
  `ifdef GPIO_RGPIO_NEC
		`GPIO_RGPIO_NEC: begin
			wb_dat[dw-1:0] = rgpio_nec;
		end
  `endif
  `ifdef GPIO_RGPIO_ECLK
		`GPIO_RGPIO_ECLK: begin
			wb_dat[dw-1:0] = rgpio_eclk;
		end
  `endif
  `ifdef GPIO_RGPIO_AUX
		`GPIO_RGPIO_AUX: begin
			wb_dat[dw-1:0] = rgpio_aux;
		end
  `endif
  `ifdef GPIO_RGPIO_CTRL
		`GPIO_RGPIO_CTRL: begin
			wb_dat[1:0] = rgpio_ctrl;
			wb_dat[dw-1:2] = {dw-2{1'b0}};
		end
  `endif
`endif
  `ifdef GPIO_RGPIO_INTS
		`GPIO_RGPIO_INTS: begin
			wb_dat[dw-1:0] = rgpio_ints;
		end
  `endif
		default: begin
			wb_dat[dw-1:0] = rgpio_in;
		end
	endcase

//
// WB data output
//
`ifdef GPIO_REGISTERED_WB_OUTPUTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		wb_dat_o <= #1 {dw{1'b0}};
	else
		wb_dat_o <= #1 wb_dat;
`else
assign wb_dat_o = wb_dat;
`endif

//
// RGPIO_INTS
//
`ifdef GPIO_RGPIO_INTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		rgpio_ints <= #1 {gw{1'b0}};
	else if (rgpio_ints_sel && wb_we_i)
		rgpio_ints <= #1 wb_dat_i[gw-1:0];
	else if (rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])
		rgpio_ints <= #1 (rgpio_ints | ((in_muxed ^ rgpio_in) & ~(in_muxed ^ rgpio_ptrig)) & rgpio_inte);
`else
assign rgpio_ints = (rgpio_ints | ((in_muxed ^ rgpio_in) & ~(in_muxed ^ rgpio_ptrig)) & rgpio_inte);
`endif

//
// Generate interrupt request
//
assign wb_inta = |rgpio_ints ? rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE] : 1'b0;

//
// Optional registration of WB interrupt
//
`ifdef GPIO_REGISTERED_WB_OUTPUTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		wb_inta_o <= #1 1'b0;
	else
		wb_inta_o <= #1 wb_inta;
`else
assign wb_inta_o = wb_inta;
`endif // GPIO_REGISTERED_WB_OUTPUTS

//
// Output enables are RGPIO_OE bits
//
assign ext_padoe_o = rgpio_oe;

//
// Generate GPIO outputs
//
`ifdef GPIO_AUX_IMPLEMENT
assign out_pad = rgpio_out & ~rgpio_aux | aux_i & rgpio_aux;
`else
assign out_pad = rgpio_out ;
`endif //  GPIO_AUX_IMPLEMENT

//
// Optional registration of GPIO outputs
//
`ifdef GPIO_REGISTERED_IO_OUTPUTS
always @(posedge wb_clk_i or posedge wb_rst_i)
	if (wb_rst_i)
		ext_pad_o <= #1 {gw{1'b0}};
	else
		ext_pad_o <= #1 out_pad;
`else
assign ext_pad_o = out_pad;
`endif // GPIO_REGISTERED_IO_OUTPUTS


`else

//
// When GPIO is not implemented, drive all outputs as would when RGPIO_CTRL
// is cleared and WISHBONE transfers complete with errors
//
assign wb_inta_o = 1'b0;
assign wb_ack_o = 1'b0;
assign wb_err_o = wb_cyc_i & wb_stb_i;
assign ext_padoe_o = {gw{1'b1}};
assign ext_pad_o = {gw{1'b0}};

//
// Read GPIO registers
//
assign wb_dat_o = {dw{1'b0}};

`endif //  GPIO_IMPLEMENTED

endmodule

