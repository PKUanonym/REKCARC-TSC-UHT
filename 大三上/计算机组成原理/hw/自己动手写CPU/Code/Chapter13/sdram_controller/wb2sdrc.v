/*********************************************************************
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: WISHBONE to SDRAM Controller Bus Transalator
     1. This module translate the WISHBONE protocol to custom sdram controller i/f 
     2. Also Handle the clock domain change from Application layer to Sdram layer
                                                              
  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):  Dinesh Annayya, dinesha@opencores.org                 
  Version  : 0.0 - Initial Release
             0.1 - 2nd Feb 2012
	           Async Fifo towards the application layer is selected 
		   with Registered Full Generation
             0.2 - 2nd Feb 2012
	           Pending Read generation bug fix done to handle backto back write 
		   followed by read request
                                                             
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


module wb2sdrc (
      // WB bus
                    wb_rst_i            ,
                    wb_clk_i            ,

                    wb_stb_i            ,
                    wb_ack_o            ,
                    wb_addr_i           ,
                    wb_we_i             ,
                    wb_dat_i            ,
                    wb_sel_i            ,
                    wb_dat_o            ,
                    wb_cyc_i            ,
                    wb_cti_i            , 


      //SDRAM Controller Hand-Shake Signal 
                    sdram_clk           ,
                    sdram_resetn        ,
                    sdr_req             ,
                    sdr_req_addr        ,
                    sdr_req_len         ,
                    sdr_req_wr_n        ,
                    sdr_req_ack         ,
                    sdr_busy_n          ,
                    sdr_wr_en_n         ,
                    sdr_wr_next         ,
                    sdr_rd_valid        ,
                    sdr_last_rd         ,
                    sdr_wr_data         ,
                    sdr_rd_data        

      ); 

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 9;   // burst_lenght_width 
parameter      APP_AW          = 26;  // Application Address Width
//--------------------------------------
// Wish Bone Interface
// -------------------------------------      
input                   wb_rst_i           ;
input                   wb_clk_i           ;

input                   wb_stb_i           ;
output                  wb_ack_o           ;
input [APP_AW-1:0]      wb_addr_i          ;
input                   wb_we_i            ; // 1 - Write , 0 - Read
input [dw-1:0]          wb_dat_i           ;
input [dw/8-1:0]        wb_sel_i           ; // Byte enable
output [dw-1:0]         wb_dat_o           ;
input                   wb_cyc_i           ;
input  [2:0]            wb_cti_i           ;
/***************************************************
The Cycle Type Idenfier [CTI_IO()] Address Tag provides 
additional information about the current cycle. 
The MASTER sends this information to the SLAVE. The SLAVE can use this
information to prepare the response for the next cycle.
Table 4-2 Cycle Type Identifiers
CTI_O(2:0) Description
‘000’ Classic cycle.
‘001’ Constant address burst cycle
‘010’ Incrementing burst cycle
‘011’ Reserved
‘100’ Reserved
‘101 Reserved
‘110’ Reserved
‘111’ End-of-Burst
****************************************************/
//--------------------------------------------
// SDRAM controller Interface 
//--------------------------------------------
input                   sdram_clk          ; // sdram clock
input                   sdram_resetn       ; // sdram reset
output                  sdr_req            ; // SDRAM request
output [APP_AW-1:0]           sdr_req_addr       ; // SDRAM Request Address
output [bl-1:0]         sdr_req_len        ;
output                  sdr_req_wr_n       ; // 0 - Write, 1 -> Read
input                   sdr_req_ack        ; // SDRAM request Accepted
input                   sdr_busy_n         ; // 0 -> sdr busy
output [dw/8-1:0]       sdr_wr_en_n        ; // Active low sdr byte-wise write data valid
input                   sdr_wr_next        ; // Ready to accept the next write
input                   sdr_rd_valid       ; // sdr read valid
input                   sdr_last_rd        ; // Indicate last Read of Burst Transfer
output [dw-1:0]         sdr_wr_data        ; // sdr write data
input  [dw-1:0]         sdr_rd_data        ; // sdr read data

//----------------------------------------------------
// Wire Decleration
// ---------------------------------------------------
wire                    cmdfifo_full       ;
wire                    cmdfifo_empty      ;
wire                    wrdatafifo_full    ;
wire                    wrdatafifo_empty   ;
wire                    tagfifo_full       ;
wire                    tagfifo_empty      ;
wire                    rddatafifo_empty   ;
wire                    rddatafifo_full    ;

reg                     pending_read       ;


//-----------------------------------------------------------------------------
// Ack Generaltion Logic
//  If Write Request - Acknowledge if the command and write FIFO are not full
//  If Read Request  - Generate the Acknowledgment once read fifo has data
//                     available
//-----------------------------------------------------------------------------

assign wb_ack_o = (wb_stb_i && wb_cyc_i && wb_we_i) ?  // Write Phase
	                  ((!cmdfifo_full) && (!wrdatafifo_full)) :
		  (wb_stb_i && wb_cyc_i && !wb_we_i) ? // Read Phase 
		           !rddatafifo_empty : 1'b0;

//---------------------------------------------------------------------------
// Command FIFO Write Generation
//    If Write Request - Generate write, when Write fifo and command fifo is
//                       not full
//    If Read Request - Generate write, when command fifo not full and there
//                      is no pending read request.
//---------------------------------------------------------------------------
wire           cmdfifo_wr   = (wb_stb_i && wb_cyc_i && wb_we_i && (!cmdfifo_full) ) ? wb_ack_o :
	                      (wb_stb_i && wb_cyc_i && !wb_we_i && (!cmdfifo_full)) ? !pending_read: 1'b0 ; 

//---------------------------------------------------------------------------
// command fifo read generation
//    Command FIFo read will be generated, whenever SDRAM Controller
//    Acknowldge the Request
//----------------------------------------------------------------------------

wire           cmdfifo_rd   = sdr_req_ack;

//---------------------------------------------------------------------------
// Application layer request is generated towards the controller, whenever
// Command FIFO is not full
// --------------------------------------------------------------------------
assign         sdr_req      = !cmdfifo_empty;

//----------------------------------------------------------------------------
// Since Burst length is not known at the start of the Burst, It's assumed as
// Single Cycle Burst. We need to improvise this ...
// --------------------------------------------------------------------------
wire [bl-1:0]  burst_length  = 1;  // 0 Mean 1 Transfer

//-----------------------------------------------------------------------------
// In Wish Bone Spec, For Read Request has to be acked along with data.
// We need to identify the pending read request.
// Once we accept the read request, we should not accept one more read
// request, untill we have transmitted the read data.
//  Pending Read will 
//     set - with Read Request 
//     reset - with Read Request + Ack
// ----------------------------------------------------------------------------
always @(posedge wb_rst_i or posedge wb_clk_i) begin
   if(wb_rst_i) begin
       pending_read <= 1'b0;
   end else begin
      //pending_read <=  wb_stb_i & wb_cyc_i & !wb_we_i & !wb_ack_o;
      pending_read <=   (cmdfifo_wr && !wb_we_i) ? 1'b1:
	                (wb_stb_i & wb_cyc_i & !wb_we_i & wb_ack_o) ? 1'b0: pending_read;
   end
end

//---------------------------------------------------------------------
// Async Command FIFO. This block handle the clock domain change from
// Application layer to SDRAM Controller
// ------------------------------------------------------------------
   // Address + Burst Length + W/R Request 
    async_fifo #(.W(APP_AW+bl+1),.DP(4),.WR_FAST(1'b0), .RD_FAST(1'b0)) u_cmdfifo (
     // Write Path Sys CLock Domain
          .wr_clk             (wb_clk_i           ),
          .wr_reset_n         (!wb_rst_i          ),
          .wr_en              (cmdfifo_wr         ),
          .wr_data            ({burst_length, 
	                        !wb_we_i, 
				wb_addr_i}        ),
          .afull              (                   ),
          .full               (cmdfifo_full       ),

     // Read Path, SDRAM clock domain
          .rd_clk             (sdram_clk          ),
          .rd_reset_n         (sdram_resetn       ),
          .aempty             (                   ),
          .empty              (cmdfifo_empty      ),
          .rd_en              (cmdfifo_rd         ),
          .rd_data            ({sdr_req_len,
	                        sdr_req_wr_n,
		                sdr_req_addr}     )
     );

// synopsys translate_off
always @(posedge wb_clk_i) begin
  if (cmdfifo_full == 1'b1 && cmdfifo_wr == 1'b1)  begin
     $display("ERROR:%m COMMAND FIFO WRITE OVERFLOW");
  end 
end 
// synopsys translate_on
// synopsys translate_off
always @(posedge sdram_clk) begin
   if (cmdfifo_empty == 1'b1 && cmdfifo_rd == 1'b1) begin
      $display("ERROR:%m COMMAND FIFO READ OVERFLOW");
   end
end 
// synopsys translate_on

//---------------------------------------------------------------------
// Write Data FIFO Write Generation, when ever Acked + Write Request
//   Note: Ack signal generation already taking account of FIFO full condition
// ---------------------------------------------------------------------

wire  wrdatafifo_wr  = wb_ack_o & wb_we_i ;

//------------------------------------------------------------------------
// Write Data FIFO Read Generation, When ever Next Write request generated
// from SDRAM Controller
// ------------------------------------------------------------------------
wire  wrdatafifo_rd  = sdr_wr_next;


//------------------------------------------------------------------------
// Async Write Data FIFO
//    This block handle the clock domain change over + Write Data + Byte mask 
//    From Application layer to SDRAM controller layer
//------------------------------------------------------------------------

   // Write DATA + Data Mask FIFO
    async_fifo #(.W(dw+(dw/8)), .DP(8), .WR_FAST(1'b0), .RD_FAST(1'b1)) u_wrdatafifo (
       // Write Path , System clock domain
          .wr_clk             (wb_clk_i           ),
          .wr_reset_n         (!wb_rst_i          ),
          .wr_en              (wrdatafifo_wr      ),
          .wr_data            ({~wb_sel_i, 
	                         wb_dat_i}        ),
          .afull              (                   ),
          .full               (wrdatafifo_full    ),


       // Read Path , SDRAM clock domain
          .rd_clk             (sdram_clk          ),
          .rd_reset_n         (sdram_resetn       ),
          .aempty             (                   ),
          .empty              (wrdatafifo_empty   ),
          .rd_en              (wrdatafifo_rd      ),
          .rd_data            ({sdr_wr_en_n,
                                sdr_wr_data}      )
     );
// synopsys translate_off
always @(posedge wb_clk_i) begin
  if (wrdatafifo_full == 1'b1 && wrdatafifo_wr == 1'b1)  begin
     $display("ERROR:%m WRITE DATA FIFO WRITE OVERFLOW");
  end 
end 

always @(posedge sdram_clk) begin
   if (wrdatafifo_empty == 1'b1 && wrdatafifo_rd == 1'b1) begin
      $display("ERROR:%m WRITE DATA FIFO READ OVERFLOW");
   end
end 
// synopsys translate_on

// -------------------------------------------------------------------
//  READ DATA FIFO
//  ------------------------------------------------------------------
wire    rd_eop; // last read indication

// Read FIFO write generation, when ever SDRAM controller issues the read
// valid signal
wire    rddatafifo_wr = sdr_rd_valid;

// Read FIFO read generation, when ever ack is generated along with read
// request.
// Note: Ack generation is already accounted the write FIFO Not Empty
//       condition
wire    rddatafifo_rd = wb_ack_o & !wb_we_i;

//-------------------------------------------------------------------------
// Async Read FIFO
// This block handles the clock domain change over + Read data from SDRAM
// controller to Application layer.
//  Note: 
//    1. READ DATA FIFO depth is kept small, assuming that Sys-CLock > SDRAM Clock
//       READ DATA + EOP
//    2. EOP indicate, last transfer of Burst Read Access. use-full for future
//       Tag handling per burst
//
// ------------------------------------------------------------------------
    async_fifo #(.W(dw+1), .DP(4), .WR_FAST(1'b0), .RD_FAST(1'b1) ) u_rddatafifo (
       // Write Path , SDRAM clock domain
          .wr_clk             (sdram_clk          ),
          .wr_reset_n         (sdram_resetn       ),
          .wr_en              (rddatafifo_wr      ),
          .wr_data            ({sdr_last_rd,
	                        sdr_rd_data}      ),
          .afull              (                   ),
          .full               (rddatafifo_full    ),


       // Read Path , SYS clock domain
          .rd_clk             (wb_clk_i           ),
          .rd_reset_n         (!wb_rst_i          ),
          .empty              (rddatafifo_empty   ),
          .aempty             (                   ),
          .rd_en              (rddatafifo_rd      ),
          .rd_data            ({rd_eop,
                                wb_dat_o}         )
     );

// synopsys translate_off
always @(posedge sdram_clk) begin
  if (rddatafifo_full == 1'b1 && rddatafifo_wr == 1'b1)  begin
     $display("ERROR:%m READ DATA FIFO WRITE OVERFLOW");
  end 
end 

always @(posedge wb_clk_i) begin
   if (rddatafifo_empty == 1'b1 && rddatafifo_rd == 1'b1) begin
      $display("ERROR:%m READ DATA FIFO READ OVERFLOW");
   end
end 
// synopsys translate_on

 
endmodule
