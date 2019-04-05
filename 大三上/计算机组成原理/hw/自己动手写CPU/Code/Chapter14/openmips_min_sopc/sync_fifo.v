/*********************************************************************
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: SYNC FIFO 
  Parameters:
      W : Width (integer)
      D : Depth (integer, power of 2, 4 to 256)
                                                              
  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):  Dinesh Annayya, dinesha@opencores.org                 
                                                             
 Copyright (C) 2000 Authors and OPENCORES.ORG                
                                                             
 This source file may be used and distributed without         
 restriction provided that this copyright statement is not    
 removed from the file and that any derivative work contains  
 the original copyright notice and the associated disclaimer. 
                                                              
 This source file is free software; you can redistribute it   
 and/or modify it under the terms of the GNU Lesser General   
 Public License as published by the Free Software Foundation; 
 either version 2.1 of the License, or (at your option) any   
later version.                                               
                                                              
 This source is distributed in the hope that it will be       
 useful, but WITHOUT ANY WARRANTY; without even the implied   
 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
 PURPOSE.  See the GNU Lesser General Public License for more 
 details.                                                     
                                                              
 You should have received a copy of the GNU Lesser General    
 Public License along with this source; if not, download it   
 from http://www.opencores.org/lgpl.shtml                     
                                                              
*******************************************************************/


module sync_fifo (clk,
	          reset_n,
		  wr_en,
		  wr_data,
		  full,
		  empty,
		  rd_en,
		  rd_data);

   parameter W = 8;
   parameter D = 4;

   parameter AW = (D == 4)   ? 2 :
		  (D == 8)   ? 3 :
		  (D == 16)  ? 4 :
		  (D == 32)  ? 5 :
		  (D == 64)  ? 6 :
		  (D == 128) ? 7 :
		  (D == 256) ? 8 : 0;
   
   output [W-1 : 0]  rd_data;
   input [W-1 : 0]   wr_data;
   input 	     clk, reset_n, wr_en, rd_en;
   output 	     full, empty;

   // synopsys translate_off

   initial begin
      if (AW == 0) begin
	 $display ("%m : ERROR!!! Fifo depth %d not in range 4 to 256", D);
      end // if (AW == 0)
   end // initial begin

   // synopsys translate_on


   reg [W-1 : 0]    mem[D-1 : 0];
   reg [AW-1 : 0]   rd_ptr, wr_ptr;
   reg	 	    full, empty;

   wire [W-1 : 0]   rd_data;
   
   always @ (posedge clk or negedge reset_n) 
      if (reset_n == 1'b0) begin
         wr_ptr <= {AW{1'b0}} ;
      end
      else begin
         if (wr_en & !full) begin
            wr_ptr <= wr_ptr + 1'b1 ;
         end
      end

   always @ (posedge clk or negedge reset_n) 
      if (reset_n == 1'b0) begin
         rd_ptr <= {AW{1'b0}} ;
      end
      else begin
         if (rd_en & !empty) begin
            rd_ptr <= rd_ptr + 1'b1 ;
         end
      end


   always @ (posedge clk or negedge reset_n) 
      if (reset_n == 1'b0) begin
         empty <= 1'b1 ;
      end
      else begin
         empty <= (((wr_ptr - rd_ptr) == {{(AW-1){1'b0}}, 1'b1}) & rd_en & ~wr_en) ? 1'b1 : 
                   ((wr_ptr == rd_ptr) & ~rd_en & wr_en) ? 1'b0 : empty ;
      end

   always @ (posedge clk or negedge reset_n) 
      if (reset_n == 1'b0) begin
         full <= 1'b0 ;
      end
      else begin
         full <= (((wr_ptr - rd_ptr) == {{(AW-1){1'b1}}, 1'b0}) & ~rd_en & wr_en) ? 1'b1 : 
                 (((wr_ptr - rd_ptr) == {AW{1'b1}}) & rd_en & ~wr_en) ? 1'b0 : full ;
      end

   always @ (posedge clk) 
      if (wr_en)
	 mem[wr_ptr] <= wr_data;

assign  rd_data = mem[rd_ptr];


// synopsys translate_off
   always @(posedge clk) begin
      if (wr_en && full) begin
         $display("%m : Error! sfifo overflow!");
      end
   end

   always @(posedge clk) begin
      if (rd_en && empty) begin
         $display("%m : error! sfifo underflow!");
      end
   end

// synopsys translate_on
//---------------------------------------

endmodule


