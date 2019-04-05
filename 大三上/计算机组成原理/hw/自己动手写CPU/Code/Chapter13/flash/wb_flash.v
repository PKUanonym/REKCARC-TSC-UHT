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
// Module:  flash_top
// File:    wb_flash.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: Nor Flash Controller for DE2    
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

module flash_top(
    // Parallel FLASH Interface
    wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_o, wb_dat_i, wb_sel_i, wb_we_i,
    wb_stb_i, wb_cyc_i, wb_ack_o,
    flash_adr_o, flash_dat_i, flash_rst,
    flash_oe, flash_ce, flash_we
);

    //
    // Default address and data bus width
    //
    parameter aw = 19;   // number of address-bits
    parameter dw = 32;   // number of data-bits
    parameter ws = 4'h3; // number of wait-states

    //
    // FLASH interface
    //
    input   wb_clk_i;
    input   wb_rst_i;
    input   [31:0] wb_adr_i;
    output reg [dw-1:0] wb_dat_o;
    input   [dw-1:0] wb_dat_i;
    input   [3:0] wb_sel_i;
    input   wb_we_i;
    input   wb_stb_i;
    input   wb_cyc_i;
    output reg wb_ack_o;
    output reg [31:0] flash_adr_o;
    input   [7:0] flash_dat_i;
    output  flash_rst;
    output  flash_oe;
    output  flash_ce;
    output  flash_we;
    reg [3:0] waitstate;
    wire    [1:0] adr_low;

    // Wishbone read/write accesses
    wire wb_acc = wb_cyc_i & wb_stb_i;    // WISHBONE access
    wire wb_wr  = wb_acc & wb_we_i;       // WISHBONE write access
    wire wb_rd  = wb_acc & !wb_we_i;      // WISHBONE read access

    always @(posedge wb_clk_i) begin
        if( wb_rst_i == 1'b1 ) begin
            waitstate <= 4'h0;
            wb_ack_o <= 1'b0;
        end else if(wb_acc == 1'b0) begin
            waitstate <= 4'h0;
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h00000000;
        end else if(waitstate == 4'h0) begin
            wb_ack_o <= 1'b0;
            if(wb_acc) begin
              waitstate <= waitstate + 4'h1;
            end
						flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b00};
        end else begin
            waitstate <= waitstate + 4'h1;
				    if(waitstate == 4'h3) begin
					     wb_dat_o[31:24] <= flash_dat_i;
					     flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b01};
						end else if(waitstate == 4'h6) begin
						   wb_dat_o[23:16] <= flash_dat_i;
						   flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b10};
						end else if(waitstate == 4'h9) begin
						   wb_dat_o[15:8] <= flash_dat_i;
						   flash_adr_o <= {10'b0000000000,wb_adr_i[21:2],2'b11};
						end else if(waitstate == 4'hc) begin
						   wb_dat_o[7:0] <= flash_dat_i;
               wb_ack_o <= 1'b1;
						end else if(waitstate == 4'hd) begin
               wb_ack_o <= 1'b0;
               waitstate <= 4'h0;
            end
         end
      end

    assign flash_ce = !wb_acc;
    assign flash_we = 1'b1;
    assign flash_oe = !wb_rd;


    assign flash_rst = !wb_rst_i;

endmodule
