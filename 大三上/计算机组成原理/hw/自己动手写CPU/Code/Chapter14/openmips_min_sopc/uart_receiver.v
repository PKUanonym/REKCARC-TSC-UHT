//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver.v                                             ////
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
////  UART core receiver logic                                    ////
////                                                              ////
////  Known problems (limits):                                    ////
////  None known                                                  ////
////                                                              ////
////  To Do:                                                      ////
////  Thourough testing.                                          ////
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
// Revision 1.29  2002/07/29 21:16:18  gorban
// The uart_defines.v file is included again in sources.
//
// Revision 1.28  2002/07/22 23:02:23  gorban
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
// Revision 1.27  2001/12/30 20:39:13  mohor
// More than one character was stored in case of break. End of the break
// was not detected correctly.
//
// Revision 1.26  2001/12/20 13:28:27  mohor
// Missing declaration of rf_push_q fixed.
//
// Revision 1.25  2001/12/20 13:25:46  mohor
// rx push changed to be only one cycle wide.
//
// Revision 1.24  2001/12/19 08:03:34  mohor
// Warnings cleared.
//
// Revision 1.23  2001/12/19 07:33:54  mohor
// Synplicity was having troubles with the comment.
//
// Revision 1.22  2001/12/17 14:46:48  mohor
// overrun signal was moved to separate block because many sequential lsr
// reads were preventing data from being written to rx fifo.
// underrun signal was not used and was removed from the project.
//
// Revision 1.21  2001/12/13 10:31:16  mohor
// timeout irq must be set regardless of the rda irq (rda irq does not reset the
// timeout counter).
//
// Revision 1.20  2001/12/10 19:52:05  gorban
// Igor fixed break condition bugs
//
// Revision 1.19  2001/12/06 14:51:04  gorban
// Bug in LSR[0] is fixed.
// All WISHBONE signals are now sampled, so another wait-state is introduced on all transfers.
//
// Revision 1.18  2001/12/03 21:44:29  gorban
// Updated specification documentation.
// Added full 32-bit data bus interface, now as default.
// Address is 5-bit wide in 32-bit data bus mode.
// Added wb_sel_i input to the core. It's used in the 32-bit mode.
// Added debug interface with two 32-bit read-only registers in 32-bit mode.
// Bits 5 and 6 of LSR are now only cleared on TX FIFO write.
// My small test bench is modified to work with 32-bit mode.
//
// Revision 1.17  2001/11/28 19:36:39  gorban
// Fixed: timeout and break didn't pay attention to current data format when counting time
//
// Revision 1.16  2001/11/27 22:17:09  gorban
// Fixed bug that prevented synthesis in uart_receiver.v
//
// Revision 1.15  2001/11/26 21:38:54  gorban
// Lots of fixes:
// Break condition wasn't handled correctly at all.
// LSR bits could lose their values.
// LSR value after reset was wrong.
// Timing of THRE interrupt signal corrected.
// LSR bit 0 timing corrected.
//
// Revision 1.14  2001/11/10 12:43:21  gorban
// Logic Synthesis bugs fixed. Some other minor changes
//
// Revision 1.13  2001/11/08 14:54:23  mohor
// Comments in Slovene language deleted, few small fixes for better work of
// old tools. IRQs need to be fix.
//
// Revision 1.12  2001/11/07 17:51:52  gorban
// Heavily rewritten interrupt and LSR subsystems.
// Many bugs hopefully squashed.
//
// Revision 1.11  2001/10/31 15:19:22  gorban
// Fixes to break and timeout conditions
//
// Revision 1.10  2001/10/20 09:58:40  gorban
// Small synopsis fixes
//
// Revision 1.9  2001/08/24 21:01:12  mohor
// Things connected to parity changed.
// Clock devider changed.
//
// Revision 1.8  2001/08/23 16:05:05  mohor
// Stop bit bug fixed.
// Parity bug fixed.
// WISHBONE read cycle bug fixed,
// OE indicator (Overrun Error) bug fixed.
// PE indicator (Parity Error) bug fixed.
// Register read bug fixed.
//
// Revision 1.6  2001/06/23 11:21:48  gorban
// DL made 16-bit long. Fixed transmission/reception bugs.
//
// Revision 1.5  2001/06/02 14:28:14  gorban
// Fixed receiver and transmitter. Major bug fixed.
//
// Revision 1.4  2001/05/31 20:08:01  gorban
// FIFO changes and other corrections.
//
// Revision 1.3  2001/05/27 17:37:49  gorban
// Fixed many bugs. Updated spec. Changed FIFO files structure. See CHANGES.txt file.
//
// Revision 1.2  2001/05/21 19:12:02  gorban
// Corrected some Linter messages.
//
// Revision 1.1  2001/05/17 18:34:18  gorban
// First 'stable' release. Should be sythesizable now. Also added new header.
//
// Revision 1.0  2001-05-17 21:27:11+02  jacob
// Initial revision
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

`include "uart_defines.v"

module uart_receiver (clk, wb_rst_i, lcr, rf_pop, srx_pad_i, enable, 
	counter_t, rf_count, rf_data_out, rf_error_bit, rf_overrun, rx_reset, lsr_mask, rstate, rf_push_pulse);

input				clk;
input				wb_rst_i;
input	[7:0]	lcr;
input				rf_pop;
input				srx_pad_i;
input				enable;
input				rx_reset;
input       lsr_mask;

output	[9:0]			counter_t;
output	[`UART_FIFO_COUNTER_W-1:0]	rf_count;
output	[`UART_FIFO_REC_WIDTH-1:0]	rf_data_out;
output				rf_overrun;
output				rf_error_bit;
output [3:0] 		rstate;
output 				rf_push_pulse;

reg	[3:0]	rstate;
reg	[3:0]	rcounter16;
reg	[2:0]	rbit_counter;
reg	[7:0]	rshift;			// receiver shift register
reg		rparity;		// received parity
reg		rparity_error;
reg		rframing_error;		// framing error flag
reg		rbit_in;
reg		rparity_xor;
reg	[7:0]	counter_b;	// counts the 0 (low) signals
reg   rf_push_q;

// RX FIFO signals
reg	[`UART_FIFO_REC_WIDTH-1:0]	rf_data_in;
wire	[`UART_FIFO_REC_WIDTH-1:0]	rf_data_out;
wire      rf_push_pulse;
reg				rf_push;
wire				rf_pop;
wire				rf_overrun;
wire	[`UART_FIFO_COUNTER_W-1:0]	rf_count;
wire				rf_error_bit; // an error (parity or framing) is inside the fifo
wire 				break_error = (counter_b == 0);

// RX FIFO instance
uart_rfifo #(`UART_FIFO_REC_WIDTH) fifo_rx(
	.clk(		clk		), 
	.wb_rst_i(	wb_rst_i	),
	.data_in(	rf_data_in	),
	.data_out(	rf_data_out	),
	.push(		rf_push_pulse		),
	.pop(		rf_pop		),
	.overrun(	rf_overrun	),
	.count(		rf_count	),
	.error_bit(	rf_error_bit	),
	.fifo_reset(	rx_reset	),
	.reset_status(lsr_mask)
);

wire 		rcounter16_eq_7 = (rcounter16 == 4'd7);
wire		rcounter16_eq_0 = (rcounter16 == 4'd0);
wire		rcounter16_eq_1 = (rcounter16 == 4'd1);

wire [3:0] rcounter16_minus_1 = rcounter16 - 1'b1;

parameter  sr_idle 					= 4'd0;
parameter  sr_rec_start 			= 4'd1;
parameter  sr_rec_bit 				= 4'd2;
parameter  sr_rec_parity			= 4'd3;
parameter  sr_rec_stop 				= 4'd4;
parameter  sr_check_parity 		= 4'd5;
parameter  sr_rec_prepare 			= 4'd6;
parameter  sr_end_bit				= 4'd7;
parameter  sr_ca_lc_parity	      = 4'd8;
parameter  sr_wait1 					= 4'd9;
parameter  sr_push 					= 4'd10;


always @(posedge clk or posedge wb_rst_i)
begin
  if (wb_rst_i)
  begin
     rstate 			<= #1 sr_idle;
	  rbit_in 				<= #1 1'b0;
	  rcounter16 			<= #1 0;
	  rbit_counter 		<= #1 0;
	  rparity_xor 		<= #1 1'b0;
	  rframing_error 	<= #1 1'b0;
	  rparity_error 		<= #1 1'b0;
	  rparity 				<= #1 1'b0;
	  rshift 				<= #1 0;
	  rf_push 				<= #1 1'b0;
	  rf_data_in 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle : begin
			rf_push 			  <= #1 1'b0;
			rf_data_in 	  <= #1 0;
			rcounter16 	  <= #1 4'b1110;
			if (srx_pad_i==1'b0 & ~break_error)   // detected a pulse (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start;
			end
		end
	sr_rec_start :	begin
  			rf_push 			  <= #1 1'b0;
				if (rcounter16_eq_7)    // check the pulse
					if (srx_pad_i==1'b1)   // no start bit
						rstate <= #1 sr_idle;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare;
				rcounter16 <= #1 rcounter16_minus_1;
			end
	sr_rec_prepare:begin
				case (lcr[/*`UART_LC_BITS*/1:0])  // number of bits in a word
				2'b00 : rbit_counter <= #1 3'b100;
				2'b01 : rbit_counter <= #1 3'b101;
				2'b10 : rbit_counter <= #1 3'b110;
				2'b11 : rbit_counter <= #1 3'b111;
				endcase
				if (rcounter16_eq_0)
				begin
					rstate		<= #1 sr_rec_bit;
					rcounter16	<= #1 4'b1110;
					rshift		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare;
				rcounter16 <= #1 rcounter16_minus_1;
			end
	sr_rec_bit :	begin
				if (rcounter16_eq_0)
					rstate <= #1 sr_end_bit;
				if (rcounter16_eq_7) // read the bit
					case (lcr[/*`UART_LC_BITS*/1:0])  // number of bits in a word
					2'b00 : rshift[4:0]  <= #1 {srx_pad_i, rshift[4:1]};
					2'b01 : rshift[5:0]  <= #1 {srx_pad_i, rshift[5:1]};
					2'b10 : rshift[6:0]  <= #1 {srx_pad_i, rshift[6:1]};
					2'b11 : rshift[7:0]  <= #1 {srx_pad_i, rshift[7:1]};
					endcase
				rcounter16 <= #1 rcounter16_minus_1;
			end
	sr_end_bit :   begin
				if (rbit_counter==3'b0) // no more bits in word
					if (lcr[`UART_LC_PE]) // choose state based on parity
						rstate <= #1 sr_rec_parity;
					else
					begin
						rstate <= #1 sr_rec_stop;
						rparity_error <= #1 1'b0;  // no parity - no error :)
					end
				else		// else we have more bits to read
				begin
					rstate <= #1 sr_rec_bit;
					rbit_counter <= #1 rbit_counter - 1'b1;
				end
				rcounter16 <= #1 4'b1110;
			end
	sr_rec_parity: begin
				if (rcounter16_eq_7)	// read the parity
				begin
					rparity <= #1 srx_pad_i;
					rstate <= #1 sr_ca_lc_parity;
				end
				rcounter16 <= #1 rcounter16_minus_1;
			end
	sr_ca_lc_parity : begin    // rcounter equals 6
				rcounter16  <= #1 rcounter16_minus_1;
				rparity_xor <= #1 ^{rshift,rparity}; // calculate parity on all incoming data
				rstate      <= #1 sr_check_parity;
			  end
	sr_check_parity: begin	  // rcounter equals 5
				case ({lcr[`UART_LC_EP],lcr[`UART_LC_SP]})
					2'b00: rparity_error <= #1  rparity_xor == 0;  // no error if parity 1
					2'b01: rparity_error <= #1 ~rparity;      // parity should sticked to 1
					2'b10: rparity_error <= #1  rparity_xor == 1;   // error if parity is odd
					2'b11: rparity_error <= #1  rparity;	  // parity should be sticked to 0
				endcase
				rcounter16 <= #1 rcounter16_minus_1;
				rstate <= #1 sr_wait1;
			  end
	sr_wait1 :	if (rcounter16_eq_0)
			begin
				rstate <= #1 sr_rec_stop;
				rcounter16 <= #1 4'b1110;
			end
			else
				rcounter16 <= #1 rcounter16_minus_1;
	sr_rec_stop :	begin
				if (rcounter16_eq_7)	// read the parity
				begin
					rframing_error <= #1 !srx_pad_i; // no framing error if input is 1 (stop bit)
					rstate <= #1 sr_push;
				end
				rcounter16 <= #1 rcounter16_minus_1;
			end
	sr_push :	begin
///////////////////////////////////////
//				$display($time, ": received: %b", rf_data_in);
        if(srx_pad_i | break_error)
          begin
            if(break_error)
        		  rf_data_in 	<= #1 {8'b0, 3'b100}; // break input (empty character) to receiver FIFO
            else
        			rf_data_in  <= #1 {rshift, 1'b0, rparity_error, rframing_error};
      		  rf_push 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle;
          end
        else if(~rframing_error)  // There's always a framing before break_error -> wait for break or srx_pad_i
          begin
       			rf_data_in  <= #1 {rshift, 1'b0, rparity_error, rframing_error};
      		  rf_push 		  <= #1 1'b1;
      			rcounter16 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start;
          end
                      
			end
	default : rstate <= #1 sr_idle;
	endcase
  end  // if (enable)
end // always of receiver

always @ (posedge clk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    rf_push_q <= 0;
  else
    rf_push_q <= #1 rf_push;
end

assign rf_push_pulse = rf_push & ~rf_push_q;

  
//
// Break condition detection.
// Works in conjuction with the receiver state machine

reg 	[9:0]	toc_value; // value to be set to timeout counter

always @(lcr)
	case (lcr[3:0])
		4'b0000										: toc_value = 447; // 7 bits
		4'b0100										: toc_value = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value = 511; // 8 bits
		4'b1100										: toc_value = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value = 703; // 11 bits
		4'b1111										: toc_value = 767; // 12 bits
	endcase // case(lcr[3:0])

wire [7:0] 	brc_value; // value to be set to break counter
assign 		brc_value = toc_value[9:2]; // the same as timeout but 1 insead of 4 character times

always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		counter_b <= #1 8'd159;
	else
	if (srx_pad_i)
		counter_b <= #1 brc_value; // character time length - 1
	else
	if(enable & counter_b != 8'b0)            // only work on enable times  break not reached.
		counter_b <= #1 counter_b - 1;  // decrement break counter
end // always of break condition detection

///
/// Timeout condition detection
reg	[9:0]	counter_t;	// counts the timeout condition clocks

always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		counter_t <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse || rf_pop || rf_count == 0) // counter is reset when RX FIFO is empty, accessed or above trigger level
			counter_t <= #1 toc_value;
		else
		if (enable && counter_t != 10'b0)  // we don't want to underflow
			counter_t <= #1 counter_t - 1;		
end
	
endmodule
