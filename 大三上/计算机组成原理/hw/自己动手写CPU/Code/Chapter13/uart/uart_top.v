//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top.v                                                  ////
////                                                              ////
////                                                              ////
////  This file is part of the "UART 16550 compatible" project    ////
////  http://www.opencores.org/cores/uart16550/                   ////
////                                                              ////
////  Documentation related to this project:                      ////
////  - http://www.opencores.org/cores/uart16550/                 ////
////                                                              ////
////  Projects compatibility:                                     ////
////  - WISHBONE                                                  ////
////  RS232 Protocol                                              ////
////  16550D uart (mostly supported)                              ////
////                                                              ////
////  Overview (main Features):                                   ////
////  UART core top level.                                        ////
////                                                              ////
////  Known problems (limits):                                    ////
////  Note that transmitter and receiver instances are inside     ////
////  the uart_regs.v file.                                       ////
////                                                              ////
////  To Do:                                                      ////
////  Nothing so far.                                             ////
////                                                              ////
////  Author(s):                                                  ////
////      - gorban@opencores.org                                  ////
////      - Jacob Gorban                                          ////
////      - Igor Mohor (igorm@opencores.org)                      ////
////                                                              ////
////  Created:        2001/05/12                                  ////
////  Last Updated:   2001/05/17                                  ////
////                  (See log for the revision history)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000, 2001 Authors                             ////
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
// Revision 1.18  2002/07/22 23:02:23  gorban
// Bug Fixes:
//  * Possible loss of sync and bad reception of stop bit on slow baud rates fixed.
//   Problem reported by Kenny.Tung.
//  * Bad (or lack of ) loopback handling fixed. Reported by Cherry Withers.
//
// Improvements:
//  * Made FIFO's as general inferrable memory where possible.
//  So on FPGA they should be inferred as RAM (Distributed RAM on Xilinx).
//  This saves about 1/3 of the Slice count and reduces P&R and synthesis times.
//
//  * Added optional baudrate output (baud_o).
//  This is identical to BAUDOUT* signal on 16550 chip.
//  It outputs 16xbit_clock_rate - the divided clock.
//  It's disabled by default. Define UART_HAS_BAUDRATE_OUTPUT to use.
//
// Revision 1.17  2001/12/19 08:40:03  mohor
// Warnings fixed (unused signals removed).
//
// Revision 1.16  2001/12/06 14:51:04  gorban
// Bug in LSR[0] is fixed.
// All WISHBONE signals are now sampled, so another wait-state is introduced on all transfers.
//
// Revision 1.15  2001/12/03 21:44:29  gorban
// Updated specification documentation.
// Added full 32-bit data bus interface, now as default.
// Address is 5-bit wide in 32-bit data bus mode.
// Added wb_sel_i input to the core. It's used in the 32-bit mode.
// Added debug interface with two 32-bit read-only registers in 32-bit mode.
// Bits 5 and 6 of LSR are now only cleared on TX FIFO write.
// My small test bench is modified to work with 32-bit mode.
//
// Revision 1.14  2001/11/07 17:51:52  gorban
// Heavily rewritten interrupt and LSR subsystems.
// Many bugs hopefully squashed.
//
// Revision 1.13  2001/10/20 09:58:40  gorban
// Small synopsis fixes
//
// Revision 1.12  2001/08/25 15:46:19  gorban
// Modified port names again
//
// Revision 1.11  2001/08/24 21:01:12  mohor
// Things connected to parity changed.
// Clock devider changed.
//
// Revision 1.10  2001/08/23 16:05:05  mohor
// Stop bit bug fixed.
// Parity bug fixed.
// WISHBONE read cycle bug fixed,
// OE indicator (Overrun Error) bug fixed.
// PE indicator (Parity Error) bug fixed.
// Register read bug fixed.
//
// Revision 1.4  2001/05/31 20:08:01  gorban
// FIFO changes and other corrections.
//
// Revision 1.3  2001/05/21 19:12:02  gorban
// Corrected some Linter messages.
//
// Revision 1.2  2001/05/17 18:34:18  gorban
// First 'stable' release. Should be sythesizable now. Also added new header.
//
// Revision 1.0  2001-05-17 21:27:12+02  jacob
// Initial revision
//
//
// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

`include "uart_defines.v"

module uart_top	(
	wb_clk_i, 
	
	// Wishbone signals
	wb_rst_i, wb_adr_i, wb_dat_i, wb_dat_o, wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_sel_i,
	int_o, // interrupt request

	// UART	signals
	// serial input/output
	stx_pad_o, srx_pad_i,

	// modem signals
	rts_pad_o, cts_pad_i, dtr_pad_o, dsr_pad_i, ri_pad_i, dcd_pad_i
`ifdef UART_HAS_BAUDRATE_OUTPUT
	, baud_o
`endif
	);

parameter 							 uart_data_width = `UART_DATA_WIDTH;
parameter 							 uart_addr_width = `UART_ADDR_WIDTH;

input 								 wb_clk_i;

// WISHBONE interface
input 								 wb_rst_i;
input [uart_addr_width-1:0] 	 wb_adr_i;
input [uart_data_width-1:0] 	 wb_dat_i;
output [uart_data_width-1:0] 	 wb_dat_o;
input 								 wb_we_i;
input 								 wb_stb_i;
input 								 wb_cyc_i;
input [3:0]							 wb_sel_i;
output 								 wb_ack_o;
output 								 int_o;

// UART	signals
input 								 srx_pad_i;
output 								 stx_pad_o;
output 								 rts_pad_o;
input 								 cts_pad_i;
output 								 dtr_pad_o;
input 								 dsr_pad_i;
input 								 ri_pad_i;
input 								 dcd_pad_i;

// optional baudrate output
`ifdef UART_HAS_BAUDRATE_OUTPUT
output	baud_o;
`endif


wire 									 stx_pad_o;
wire 									 rts_pad_o;
wire 									 dtr_pad_o;

wire [uart_addr_width-1:0] 	 wb_adr_i;
wire [uart_data_width-1:0] 	 wb_dat_i;
wire [uart_data_width-1:0] 	 wb_dat_o;

wire [7:0] 							 wb_dat8_i; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o; // debug interface 32-bit output
wire [3:0] 							 wb_sel_i;  // WISHBONE select signal
wire [uart_addr_width-1:0] 	 wb_adr_int;
wire 									 we_o;	// Write enable for registers
wire		          	     re_o;	// Read enable for registers
//
// MODULE INSTANCES
//

`ifdef DATA_BUS_WIDTH_8
`else
// debug interface wires
wire	[3:0] ier;
wire	[3:0] iir;
wire	[1:0] fcr;
wire	[4:0] mcr;
wire	[7:0] lcr;
wire	[7:0] msr;
wire	[7:0] lsr;
wire	[`UART_FIFO_COUNTER_W-1:0] rf_count;
wire	[`UART_FIFO_COUNTER_W-1:0] tf_count;
wire	[2:0] tstate;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_8
////  WISHBONE interface module
uart_wb		wb_interface(
		.clk(		wb_clk_i		),
		.wb_rst_i(	wb_rst_i	),
	.wb_dat_i(wb_dat_i),
	.wb_dat_o(wb_dat_o),
	.wb_dat8_i(wb_dat8_i),
	.wb_dat8_o(wb_dat8_o),
	 .wb_dat32_o(32'b0),								 
	 .wb_sel_i(4'b0),
		.wb_we_i(	wb_we_i		),
		.wb_stb_i(	wb_stb_i	),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_ack_o(	wb_ack_o	),
	.wb_adr_i(wb_adr_i),
	.wb_adr_int(wb_adr_int),
		.we_o(		we_o		),
		.re_o(re_o)
		);
`else
uart_wb		wb_interface(
		.clk(		wb_clk_i		),
		.wb_rst_i(	wb_rst_i	),
	.wb_dat_i(wb_dat_i),
	.wb_dat_o(wb_dat_o),
	.wb_dat8_i(wb_dat8_i),
	.wb_dat8_o(wb_dat8_o),
	 .wb_sel_i(wb_sel_i),
	 .wb_dat32_o(wb_dat32_o),								 
		.wb_we_i(	wb_we_i		),
		.wb_stb_i(	wb_stb_i	),
		.wb_cyc_i(	wb_cyc_i	),
		.wb_ack_o(	wb_ack_o	),
	.wb_adr_i(wb_adr_i),
	.wb_adr_int(wb_adr_int),
		.we_o(		we_o		),
		.re_o(re_o)
		);
`endif

// Registers
uart_regs	regs(
	.clk(		wb_clk_i		),
	.wb_rst_i(	wb_rst_i	),
	.wb_addr_i(	wb_adr_int	),
	.wb_dat_i(	wb_dat8_i	),
	.wb_dat_o(	wb_dat8_o	),
	.wb_we_i(	we_o		),
   .wb_re_i(re_o),
	.modem_inputs(	{cts_pad_i, dsr_pad_i,
	ri_pad_i,  dcd_pad_i}	),
	.stx_pad_o(		stx_pad_o		),
	.srx_pad_i(		srx_pad_i		),
`ifdef DATA_BUS_WIDTH_8
`else
// debug interface signals	enabled
.ier(ier), 
.iir(iir), 
.fcr(fcr), 
.mcr(mcr), 
.lcr(lcr), 
.msr(msr), 
.lsr(lsr), 
.rf_count(rf_count),
.tf_count(tf_count),
.tstate(tstate),
.rstate(rstate),
`endif					  
	.rts_pad_o(		rts_pad_o		),
	.dtr_pad_o(		dtr_pad_o		),
	.int_o(		int_o		)
`ifdef UART_HAS_BAUDRATE_OUTPUT
	, .baud_o(baud_o)
`endif

);

`ifdef DATA_BUS_WIDTH_8
`else
uart_debug_if dbg(/*AUTOINST*/
						// Outputs
						.wb_dat32_o				 (wb_dat32_o[31:0]),
						// Inputs
						.wb_adr_i				 (wb_adr_int[`UART_ADDR_WIDTH-1:0]),
						.ier						 (ier[3:0]),
						.iir						 (iir[3:0]),
						.fcr						 (fcr[1:0]),
						.mcr						 (mcr[4:0]),
						.lcr						 (lcr[7:0]),
						.msr						 (msr[7:0]),
						.lsr						 (lsr[7:0]),
						.rf_count				 (rf_count[`UART_FIFO_COUNTER_W-1:0]),
						.tf_count				 (tf_count[`UART_FIFO_COUNTER_W-1:0]),
						.tstate					 (tstate[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_8
		$display("(%m) UART INFO: Data bus width is 8. No Debug interface.\n");
	`else
		$display("(%m) UART INFO: Data bus width is 32. Debug Interface present.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT
		$display("(%m) UART INFO: Has baudrate output\n");
	`else
		$display("(%m) UART INFO: Doesn't have baudrate output\n");
	`endif
end

endmodule


