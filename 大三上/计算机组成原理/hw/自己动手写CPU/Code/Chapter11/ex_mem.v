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
// Module:  ex_mem
// File:    ex_mem.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: EX/MEM阶段的寄存器
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(

	input	wire										clk,
	input wire										rst,

	//来自控制模块的信息
	input wire[5:0]							 stall,	
	input wire                   flush,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]					 ex_wdata, 	
	input wire[`RegBus]           ex_hi,
	input wire[`RegBus]           ex_lo,
	input wire                    ex_whilo, 	

  //为实现加载、访存指令而添加
  input wire[`AluOpBus]        ex_aluop,
	input wire[`RegBus]          ex_mem_addr,
	input wire[`RegBus]          ex_reg2,

	input wire[`DoubleRegBus]     hilo_i,	
	input wire[1:0]               cnt_i,	

	input wire                   ex_cp0_reg_we,
	input wire[4:0]              ex_cp0_reg_write_addr,
	input wire[`RegBus]          ex_cp0_reg_data,	

  input wire[31:0]             ex_excepttype,
	input wire                   ex_is_in_delayslot,
	input wire[`RegBus]          ex_current_inst_address,
	
	//送到访存阶段的信息
	output reg[`RegAddrBus]      mem_wd,
	output reg                   mem_wreg,
	output reg[`RegBus]					 mem_wdata,
	output reg[`RegBus]          mem_hi,
	output reg[`RegBus]          mem_lo,
	output reg                   mem_whilo,

  //为实现加载、访存指令而添加
  output reg[`AluOpBus]        mem_aluop,
	output reg[`RegBus]          mem_mem_addr,
	output reg[`RegBus]          mem_reg2,
	
	output reg                   mem_cp0_reg_we,
	output reg[4:0]              mem_cp0_reg_write_addr,
	output reg[`RegBus]          mem_cp0_reg_data,
	
	output reg[31:0]            mem_excepttype,
  output reg                  mem_is_in_delayslot,
	output reg[`RegBus]         mem_current_inst_address,
		
	output reg[`DoubleRegBus]    hilo_o,
	output reg[1:0]              cnt_o	
	
	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;	
		  mem_hi <= `ZeroWord;
		  mem_lo <= `ZeroWord;
		  mem_whilo <= `WriteDisable;		
	    hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;	
  		mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;	
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_write_addr <= 5'b00000;
			mem_cp0_reg_data <= `ZeroWord;	
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
	    mem_current_inst_address <= `ZeroWord;
		end else if(flush == 1'b1 ) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;
		  mem_hi <= `ZeroWord;
		  mem_lo <= `ZeroWord;
		  mem_whilo <= `WriteDisable;
  		mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_write_addr <= 5'b00000;
			mem_cp0_reg_data <= `ZeroWord;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
	    mem_current_inst_address <= `ZeroWord;
	    hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;	    	    				
		end else if(stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;
		  mem_hi <= `ZeroWord;
		  mem_lo <= `ZeroWord;
		  mem_whilo <= `WriteDisable;
	    hilo_o <= hilo_i;
			cnt_o <= cnt_i;	
  		mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;		
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_write_addr <= 5'b00000;
			mem_cp0_reg_data <= `ZeroWord;	
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
	    mem_current_inst_address <= `ZeroWord;						  				    
		end else if(stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;	
			mem_hi <= ex_hi;
			mem_lo <= ex_lo;
			mem_whilo <= ex_whilo;	
	    hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;	
  		mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;
			mem_cp0_reg_we <= ex_cp0_reg_we;
			mem_cp0_reg_write_addr <= ex_cp0_reg_write_addr;
			mem_cp0_reg_data <= ex_cp0_reg_data;	
			mem_excepttype <= ex_excepttype;
			mem_is_in_delayslot <= ex_is_in_delayslot;
	    mem_current_inst_address <= ex_current_inst_address;						
		end else begin
	    hilo_o <= hilo_i;
			cnt_o <= cnt_i;											
		end    //if
	end      //always
			

endmodule