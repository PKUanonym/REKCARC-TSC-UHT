//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
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
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  wishbone_bus_if
// File:    wishbone_bus_if.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: wishbone????
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module wishbone_bus_if(

	input	wire										clk,
	input wire										rst,
	
	//??????ctrl
	input wire[5:0]               stall_i,
	input                         flush_i,
	
	//CPU???????
	input wire                    cpu_ce_i,
	input wire[`RegBus]           cpu_data_i,
	input wire[`RegBus]           cpu_addr_i,
	input wire                    cpu_we_i,
	input wire[3:0]               cpu_sel_i,
	output reg[`RegBus]           cpu_data_o,
	
	//Wishbone?????
	input wire[`RegBus]           wishbone_data_i,
	input wire                    wishbone_ack_i,
	output reg[`RegBus]           wishbone_addr_o,
	output reg[`RegBus]           wishbone_data_o,
	output reg                    wishbone_we_o,
	output reg[3:0]               wishbone_sel_o,
	output reg                    wishbone_stb_o,
	output reg                    wishbone_cyc_o,

	output reg                    stallreq	       
	
);

  reg[1:0] wishbone_state;
  reg[`RegBus] rd_buf;

	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wishbone_state <= `WB_IDLE;
			wishbone_addr_o <= `ZeroWord;
			wishbone_data_o <= `ZeroWord;
			wishbone_we_o <= `WriteDisable;
			wishbone_sel_o <= 4'b0000;
			wishbone_stb_o <= 1'b0;
			wishbone_cyc_o <= 1'b0;
			rd_buf <= `ZeroWord;
//			cpu_data_o <= `ZeroWord;
		end else begin
			case (wishbone_state)
				`WB_IDLE:		begin
					if((cpu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						wishbone_stb_o <= 1'b1;
						wishbone_cyc_o <= 1'b1;
						wishbone_addr_o <= cpu_addr_i;
						wishbone_data_o <= cpu_data_i;
						wishbone_we_o <= cpu_we_i;
						wishbone_sel_o <=  cpu_sel_i;
						wishbone_state <= `WB_BUSY;
						rd_buf <= `ZeroWord;
//					end else begin
//						wishbone_state <= WB_IDLE;
//						wishbone_addr_o <= `ZeroWord;
//						wishbone_data_o <= `ZeroWord;
//						wishbone_we_o <= `WriteDisable;
//						wishbone_sel_o <= 4'b0000;
//						wishbone_stb_o <= 1'b0;
//						wishbone_cyc_o <= 1'b0;
//						cpu_data_o <= `ZeroWord;			
					end							
				end
				`WB_BUSY:		begin
					if(wishbone_ack_i == 1'b1) begin
						wishbone_stb_o <= 1'b0;
						wishbone_cyc_o <= 1'b0;
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_sel_o <=  4'b0000;
						wishbone_state <= `WB_IDLE;
						if(cpu_we_i == `WriteDisable) begin
							rd_buf <= wishbone_data_i;
						end
						
						if(stall_i != 6'b000000) begin
							wishbone_state <= `WB_WAIT_FOR_STALL;
						end					
					end else if(flush_i == `True_v) begin
					  wishbone_stb_o <= 1'b0;
						wishbone_cyc_o <= 1'b0;
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_sel_o <=  4'b0000;
						wishbone_state <= `WB_IDLE;
						rd_buf <= `ZeroWord;
					end
				end
				`WB_WAIT_FOR_STALL:		begin
					if(stall_i == 6'b000000) begin
						wishbone_state <= `WB_IDLE;
					end
				end
				default: begin
				end 
			endcase
		end    //if
	end      //always
			

	always @ (*) begin
		if(rst == `RstEnable) begin
			stallreq <= `NoStop;
			cpu_data_o <= `ZeroWord;
		end else begin
			stallreq <= `NoStop;
			case (wishbone_state)
				`WB_IDLE:		begin
					if((cpu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						stallreq <= `Stop;
						cpu_data_o <= `ZeroWord;				
					end
				end
				`WB_BUSY:		begin
					if(wishbone_ack_i == 1'b1) begin
						stallreq <= `NoStop;
						if(wishbone_we_o == `WriteDisable) begin
							cpu_data_o <= wishbone_data_i;  //????
						end else begin
						  cpu_data_o <= `ZeroWord;
						end							
					end else begin
						stallreq <= `Stop;	
						cpu_data_o <= `ZeroWord;				
					end
				end
				`WB_WAIT_FOR_STALL:		begin
					stallreq <= `NoStop;
					cpu_data_o <= rd_buf;
				end
				default: begin
				end 
			endcase
		end    //if
	end      //always

endmodule