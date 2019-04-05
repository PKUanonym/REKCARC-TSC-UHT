//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb.v                                                   ////
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
////  UART core WISHBONE interface.                               ////
////                                                              ////
////  Known problems (limits):                                    ////
////  Inserts one wait state on all transfers.                    ////
////  Note affected signals and the way they are affected.        ////
////                                                              ////
////  To Do:                                                      ////
////  Nothing.                                                    ////
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
// Revision 1.16  2002/07/29 21:16:18  gorban
// The uart_defines.v file is included again in sources.
//
// Revision 1.15  2002/07/22 23:02:23  gorban
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
// Revision 1.12  2001/12/19 08:03:34  mohor
// Warnings cleared.
//
// Revision 1.11  2001/12/06 14:51:04  gorban
// Bug in LSR[0] is fixed.
// All WISHBONE signals are now sampled, so another wait-state is introduced on all transfers.
//
// Revision 1.10  2001/12/03 21:44:29  gorban
// Updated specification documentation.
// Added full 32-bit data bus interface, now as default.
// Address is 5-bit wide in 32-bit data bus mode.
// Added wb_sel_i input to the core. It's used in the 32-bit mode.
// Added debug interface with two 32-bit read-only registers in 32-bit mode.
// Bits 5 and 6 of LSR are now only cleared on TX FIFO write.
// My small test bench is modified to work with 32-bit mode.
//
// Revision 1.9  2001/10/20 09:58:40  gorban
// Small synopsis fixes
//
// Revision 1.8  2001/08/24 21:01:12  mohor
// Things connected to parity changed.
// Clock devider changed.
//
// Revision 1.7  2001/08/23 16:05:05  mohor
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
// Revision 1.3  2001/05/21 19:12:01  gorban
// Corrected some Linter messages.
//
// Revision 1.2  2001/05/17 18:34:18  gorban
// First 'stable' release. Should be sythesizable now. Also added new header.
//
// Revision 1.0  2001-05-17 21:27:13+02  jacob
// Initial revision
//
//

// UART core WISHBONE interface 
//
// Author: Jacob Gorban   (jacob.gorban@flextronicssemi.com)
// Company: Flextronics Semiconductor
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "uart_defines.v"
 
module uart_wb (clk, wb_rst_i, 
	wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_adr_i,
	wb_adr_int, wb_dat_i, wb_dat_o, wb_dat8_i, wb_dat8_o, wb_dat32_o, wb_sel_i,
	we_o, re_o // Write and read enable output for the core
);

input 		  clk;

// WISHBONE interface	
input 		  wb_rst_i;
input 		  wb_we_i;
input 		  wb_stb_i;
input 		  wb_cyc_i;
input [3:0]   wb_sel_i;
input [`UART_ADDR_WIDTH-1:0] 	wb_adr_i; //WISHBONE address line

`ifdef DATA_BUS_WIDTH_8
input [7:0]  wb_dat_i; //input WISHBONE bus 
output [7:0] wb_dat_o;
reg [7:0] 	 wb_dat_o;
wire [7:0] 	 wb_dat_i;
reg [7:0] 	 wb_dat_is;
`else // for 32 data bus mode
input [31:0]  wb_dat_i; //input WISHBONE bus 
output [31:0] wb_dat_o;
reg [31:0] 	  wb_dat_o;
wire [31:0]   wb_dat_i;
reg [31:0] 	  wb_dat_is;
`endif // !`ifdef DATA_BUS_WIDTH_8

output [`UART_ADDR_WIDTH-1:0]	wb_adr_int; // internal signal for address bus
input [7:0]   wb_dat8_o; // internal 8 bit output to be put into wb_dat_o
output [7:0]  wb_dat8_i;
input [31:0]  wb_dat32_o; // 32 bit data output (for debug interface)
output 		  wb_ack_o;
output 		  we_o;
output 		  re_o;

wire 			  we_o;
reg 			  wb_ack_o;
reg [7:0] 	  wb_dat8_i;
wire [7:0] 	  wb_dat8_o;
wire [`UART_ADDR_WIDTH-1:0]	wb_adr_int; // internal signal for address bus
reg [`UART_ADDR_WIDTH-1:0]	wb_adr_is;
reg 								wb_we_is;
reg 								wb_cyc_is;
reg 								wb_stb_is;
reg [3:0] 						wb_sel_is;
wire [3:0]   wb_sel_i;
reg 			 wre ;// timing control signal for write or read enable

// wb_ack_o FSM
reg [1:0] 	 wbstate;
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) begin
		wb_ack_o <= #1 1'b0;
		wbstate <= #1 0;
		wre <= #1 1'b1;
	end else
		case (wbstate)
			0: begin
				if (wb_stb_is & wb_cyc_is) begin
					wre <= #1 0;
					wbstate <= #1 1;
					wb_ack_o <= #1 1;
				end else begin
					wre <= #1 1;
					wb_ack_o <= #1 0;
				end
			end
			1: begin
			   wb_ack_o <= #1 0;
				wbstate <= #1 2;
				wre <= #1 0;
			end
			2,3: begin
				wb_ack_o <= #1 0;
				wbstate <= #1 0;
				wre <= #1 0;
			end
		endcase

assign we_o =  wb_we_is & wb_stb_is & wb_cyc_is & wre ; //WE for registers	
assign re_o = ~wb_we_is & wb_stb_is & wb_cyc_is & wre ; //RE for registers	

// Sample input signals
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) begin
		wb_adr_is <= #1 0;
		wb_we_is <= #1 0;
		wb_cyc_is <= #1 0;
		wb_stb_is <= #1 0;
		wb_dat_is <= #1 0;
		wb_sel_is <= #1 0;
	end else begin
		wb_adr_is <= #1 wb_adr_i;
		wb_we_is <= #1 wb_we_i;
		wb_cyc_is <= #1 wb_cyc_i;
		wb_stb_is <= #1 wb_stb_i;
		wb_dat_is <= #1 wb_dat_i;
		wb_sel_is <= #1 wb_sel_i;
	end

`ifdef DATA_BUS_WIDTH_8 // 8-bit data bus
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i)
		wb_dat_o <= #1 0;
	else
		wb_dat_o <= #1 wb_dat8_o;

always @(wb_dat_is)
	wb_dat8_i = wb_dat_is;

assign wb_adr_int = wb_adr_is;

`else // 32-bit bus
// put output to the correct byte in 32 bits using select line
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i)
		wb_dat_o <= #1 0;
	else if (re_o)
		case (wb_sel_is)
			4'b0001: wb_dat_o <= #1 {24'b0, wb_dat8_o};
			4'b0010: wb_dat_o <= #1 {16'b0, wb_dat8_o, 8'b0};
			4'b0100: wb_dat_o <= #1 {8'b0, wb_dat8_o, 16'b0};
			4'b1000: wb_dat_o <= #1 {wb_dat8_o, 24'b0};
			4'b1111: wb_dat_o <= #1 wb_dat32_o; // debug interface output
 			default: wb_dat_o <= #1 0;
		endcase // case(wb_sel_i)

reg [1:0] wb_adr_int_lsb;

always @(wb_sel_is or wb_dat_is)
begin
	case (wb_sel_is)
		4'b0001 : wb_dat8_i = wb_dat_is[7:0];
		4'b0010 : wb_dat8_i = wb_dat_is[15:8];
		4'b0100 : wb_dat8_i = wb_dat_is[23:16];
		4'b1000 : wb_dat8_i = wb_dat_is[31:24];
		default : wb_dat8_i = wb_dat_is[7:0];
	endcase // case(wb_sel_i)

  `ifdef LITLE_ENDIAN
	case (wb_sel_is)
		4'b0001 : wb_adr_int_lsb = 2'h0;
		4'b0010 : wb_adr_int_lsb = 2'h1;
		4'b0100 : wb_adr_int_lsb = 2'h2;
		4'b1000 : wb_adr_int_lsb = 2'h3;
		default : wb_adr_int_lsb = 2'h0;
	endcase // case(wb_sel_i)
  `else
	case (wb_sel_is)
		4'b0001 : wb_adr_int_lsb = 2'h3;
		4'b0010 : wb_adr_int_lsb = 2'h2;
		4'b0100 : wb_adr_int_lsb = 2'h1;
		4'b1000 : wb_adr_int_lsb = 2'h0;
		default : wb_adr_int_lsb = 2'h0;
	endcase // case(wb_sel_i)
  `endif
end

assign wb_adr_int = {wb_adr_is[`UART_ADDR_WIDTH-1:2], wb_adr_int_lsb};

`endif // !`ifdef DATA_BUS_WIDTH_8

endmodule










