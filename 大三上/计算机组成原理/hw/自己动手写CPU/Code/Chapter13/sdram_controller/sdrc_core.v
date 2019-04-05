/*********************************************************************
                                                              
  SDRAM Controller Core File                                  
                                                              
  This file is part of the sdram controller project           
  http://www.opencores.org/cores/sdr_ctrl/                    
                                                              
  Description: SDRAM Controller Core Module
    2 types of SDRAMs are supported, 1Mx16 2 bank, or 4Mx16 4 bank.
    This block integrate following sub modules

    sdrc_bs_convert   
        convert the system side 32 bit into equvailent 8/16/32 SDR format
    sdrc_req_gen    
        This module takes requests from the app, chops them to burst booundaries
        if wrap=0, decodes the bank and passe the request to bank_ctl
   sdrc_xfr_ctl
      This module takes requests from sdr_bank_ctl, runs the transfer and
      controls data flow to/from the app. At the end of the transfer it issues a
      burst terminate if not at the end of a burst and another command to this
      bank is not available.

   sdrc_bank_ctl
      This module takes requests from sdr_req_gen, checks for page hit/miss and
      issues precharge/activate commands and then passes the request to
      sdr_xfr_ctl. 


  Assumption: SDRAM Pads should be placed near to this module. else
  user should add a FF near the pads
                                                              
  To Do:                                                      
    nothing                                                   
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesha@opencores.org                 
  Version  : 0.0 - 8th Jan 2012
                Initial version with 16/32 Bit SDRAM Support
           : 0.1 - 24th Jan 2012
	         8 Bit SDRAM Support is added
             0.2 - 2nd Feb 2012
	           Improved the command pipe structure to accept up-to 
		   4 command of different bank.
	     0.3 - 7th Feb 2012
	           Bug fix for parameter defination for request length has changed from 9 to 12
             0.4 - 26th April 2013
                   SDRAM Address Bit is Extended by 12 bit to 13 bit to support higher SDRAM

                                                             
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


`include "sdrc_define.v"
module sdrc_core 
           (
		clk,
                pad_clk,
		reset_n,
                sdr_width,
		cfg_colbits,

		/* Request from app */
		app_req,	        // Transfer Request
		app_req_addr,	        // SDRAM Address
		app_req_len,	        // Burst Length (in 16 bit words)
		app_req_wrap,	        // Wrap mode request (xfr_len = 4)
		app_req_wr_n,	        // 0 => Write request, 1 => read req
		app_req_ack,	        // Request has been accepted
		cfg_req_depth,	        //how many req. buffer should hold
		
		app_wr_data,
                app_wr_en_n,
		app_last_wr,

		app_rd_data,
		app_rd_valid,
		app_last_rd,
		app_wr_next_req,
		sdr_init_done,
		app_req_dma_last,

		/* Interface to SDRAMs */
		sdr_cs_n,
		sdr_cke,
		sdr_ras_n,
		sdr_cas_n,
		sdr_we_n,
		sdr_dqm,
		sdr_ba,
		sdr_addr, 
		pad_sdr_din,
		sdr_dout,
		sdr_den_n,

		/* Parameters */
		cfg_sdr_en,
		cfg_sdr_mode_reg,
		cfg_sdr_tras_d,
		cfg_sdr_trp_d,
		cfg_sdr_trcd_d,
		cfg_sdr_cas,
		cfg_sdr_trcar_d,
		cfg_sdr_twr_d,
		cfg_sdr_rfsh,
		cfg_sdr_rfmax);
  
parameter  APP_AW   = 26;  // Application Address Width
parameter  APP_DW   = 32;  // Application Data Width 
parameter  APP_BW   = 4;   // Application Byte Width
parameter  APP_RW   = 9;   // Application Request Width

parameter  SDR_DW   = 16;  // SDR Data Width 
parameter  SDR_BW   = 2;   // SDR Byte Width
             

//-----------------------------------------------
// Global Variable
// ----------------------------------------------
input                   clk                 ; // SDRAM Clock 
input                   pad_clk             ; // SDRAM Clock from Pad, used for registering Read Data
input                   reset_n             ; // Reset Signal
input [1:0]             sdr_width           ; // 2'b00 - 32 Bit SDR, 2'b01 - 16 Bit SDR, 2'b1x - 8 Bit
input [1:0]             cfg_colbits         ; // 2'b00 - 8 Bit column address, 2'b01 - 9 Bit, 10 - 10 bit, 11 - 11Bits


//------------------------------------------------
// Request from app
//------------------------------------------------
input 			app_req             ; // Application Request
input [APP_AW-1:0] 	app_req_addr        ; // Address 
input 			app_req_wr_n        ; // 0 - Write, 1 - Read
input                   app_req_wrap        ; // Address Wrap
output                  app_req_ack         ; // Application Request Ack
		
input [APP_DW-1:0] 	app_wr_data         ; // Write Data
output 		        app_wr_next_req     ; // Next Write Data Request
input [APP_BW-1:0] 	app_wr_en_n         ; // Byte wise Write Enable
output                  app_last_wr         ; // Last Write trannsfer of a given Burst
output [APP_DW-1:0] 	app_rd_data         ; // Read Data
output                  app_rd_valid        ; // Read Valid
output                  app_last_rd         ; // Last Read Transfer of a given Burst
		
//------------------------------------------------
// Interface to SDRAMs
//------------------------------------------------
output                  sdr_cke             ; // SDRAM CKE
output 			sdr_cs_n            ; // SDRAM Chip Select
output                  sdr_ras_n           ; // SDRAM ras
output                  sdr_cas_n           ; // SDRAM cas
output			sdr_we_n            ; // SDRAM write enable
output [SDR_BW-1:0] 	sdr_dqm             ; // SDRAM Data Mask
output [1:0] 		sdr_ba              ; // SDRAM Bank Enable
output [12:0] 		sdr_addr            ; // SDRAM Address
input [SDR_DW-1:0] 	pad_sdr_din         ; // SDRA Data Input
output [SDR_DW-1:0] 	sdr_dout            ; // SDRAM Data Output
output [SDR_BW-1:0] 	sdr_den_n           ; // SDRAM Data Output enable

//------------------------------------------------
// Configuration Parameter
//------------------------------------------------
output                  sdr_init_done       ; // Indicate SDRAM Initialisation Done
input [3:0] 		cfg_sdr_tras_d      ; // Active to precharge delay
input [3:0]             cfg_sdr_trp_d       ; // Precharge to active delay
input [3:0]             cfg_sdr_trcd_d      ; // Active to R/W delay
input 			cfg_sdr_en          ; // Enable SDRAM controller
input [1:0] 		cfg_req_depth       ; // Maximum Request accepted by SDRAM controller
input [APP_RW-1:0]	app_req_len         ; // Application Burst Request length in 32 bit 
input [12:0] 		cfg_sdr_mode_reg    ;
input [2:0] 		cfg_sdr_cas         ; // SDRAM CAS Latency
input [3:0] 		cfg_sdr_trcar_d     ; // Auto-refresh period
input [3:0]             cfg_sdr_twr_d       ; // Write recovery delay
input [`SDR_RFSH_TIMER_W-1 : 0] cfg_sdr_rfsh;
input [`SDR_RFSH_ROW_CNT_W -1 : 0] cfg_sdr_rfmax;
input                   app_req_dma_last;    // this signal should close the bank

/****************************************************************************/
// Internal Nets
   
// SDR_REQ_GEN
wire [`SDR_REQ_ID_W-1:0]r2b_req_id;
wire [1:0] 		r2b_ba;
wire [12:0] 		r2b_raddr;
wire [12:0] 		r2b_caddr;
wire [`REQ_BW-1:0] 	r2b_len;

// SDR BANK CTL
wire [`SDR_REQ_ID_W-1:0]b2x_id;
wire [1:0] 		b2x_ba;
wire [12:0] 		b2x_addr;
wire [`REQ_BW-1:0] 	b2x_len;
wire [1:0] 		b2x_cmd;

// SDR_XFR_CTL
wire [3:0] 		x2b_pre_ok;
wire [`SDR_REQ_ID_W-1:0]xfr_id;
wire [APP_DW-1:0] 	app_rd_data;
wire 			sdr_cs_n, sdr_cke, sdr_ras_n, sdr_cas_n, sdr_we_n; 
wire [SDR_BW-1:0] 	sdr_dqm;
wire [1:0] 		sdr_ba;
wire [12:0] 		sdr_addr;
wire [SDR_DW-1:0] 	sdr_dout;
wire [SDR_DW-1:0] 	sdr_dout_int;
wire [SDR_BW-1:0] 	sdr_den_n;
wire [SDR_BW-1:0] 	sdr_den_n_int;

wire [1:0] 		xfr_bank_sel;

wire [APP_AW-1:0]        app_req_addr;
wire [APP_RW-1:0]        app_req_len;

wire [APP_DW-1:0]        app_wr_data;
wire [SDR_DW-1:0]        a2x_wrdt       ;
wire [APP_BW-1:0]        app_wr_en_n;
wire [SDR_BW-1:0]        a2x_wren_n;

//wire [31:0] app_rd_data;
wire [SDR_DW-1:0]        x2a_rddt;


// synopsys translate_off 
   wire [3:0]           sdr_cmd;
   assign sdr_cmd = {sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}; 
// synopsys translate_on 

assign sdr_den_n = sdr_den_n_int ; 
assign sdr_dout  = sdr_dout_int ;


// To meet the timing at read path, read data is registered w.r.t pad_sdram_clock and register back to sdram_clk
// assumption, pad_sdram_clk is synhronous and delayed clock of sdram_clk.
// register w.r.t pad sdram clk
reg [SDR_DW-1:0] pad_sdr_din1;
reg [SDR_DW-1:0] pad_sdr_din2;
always@(posedge pad_clk) begin
   pad_sdr_din1 <= pad_sdr_din;
end

always@(posedge clk) begin
   pad_sdr_din2 <= pad_sdr_din1;
end


   /****************************************************************************/
   // Instantiate sdr_req_gen
   // This module takes requests from the app, chops them to burst booundaries
   // if wrap=0, decodes the bank and passe the request to bank_ctl

sdrc_req_gen #(.SDR_DW(SDR_DW) , .SDR_BW(SDR_BW)) u_req_gen (
          .clk                (clk          ),
          .reset_n            (reset_n            ),
	  .cfg_colbits        (cfg_colbits        ),
          .sdr_width          (sdr_width          ),

	/* Req to xfr_ctl */
          .r2x_idle           (r2x_idle           ),

	/* Request from app */
          .req                (app_req            ),
          .req_id             (4'b0               ),
          .req_addr           (app_req_addr       ),
          .req_len            (app_req_len        ),
          .req_wrap           (app_req_wrap       ),
          .req_wr_n           (app_req_wr_n       ),
          .req_ack            (app_req_ack        ),
		
       /* Req to bank_ctl */
          .r2b_req            (r2b_req            ),
          .r2b_req_id         (r2b_req_id         ),
          .r2b_start          (r2b_start          ),
          .r2b_last           (r2b_last           ),
          .r2b_wrap           (r2b_wrap           ),
          .r2b_ba             (r2b_ba             ),
          .r2b_raddr          (r2b_raddr          ),
          .r2b_caddr          (r2b_caddr          ),
          .r2b_len            (r2b_len            ),
          .r2b_write          (r2b_write          ),
          .b2r_ack            (b2r_ack            ),
          .b2r_arb_ok         (b2r_arb_ok         )
     );

   /****************************************************************************/
   // Instantiate sdr_bank_ctl
   // This module takes requests from sdr_req_gen, checks for page hit/miss and
   // issues precharge/activate commands and then passes the request to
   // sdr_xfr_ctl. 

sdrc_bank_ctl #(.SDR_DW(SDR_DW) ,  .SDR_BW(SDR_BW)) u_bank_ctl (
          .clk                (clk          ),
          .reset_n            (reset_n            ),
          .a2b_req_depth      (cfg_req_depth      ),
			      
      /* Req from req_gen */
          .r2b_req            (r2b_req            ),
          .r2b_req_id         (r2b_req_id         ),
          .r2b_start          (r2b_start          ),
          .r2b_last           (r2b_last           ),
          .r2b_wrap           (r2b_wrap           ),
          .r2b_ba             (r2b_ba             ),
          .r2b_raddr          (r2b_raddr          ),
          .r2b_caddr          (r2b_caddr          ),
          .r2b_len            (r2b_len            ),
          .r2b_write          (r2b_write          ),
          .b2r_arb_ok         (b2r_arb_ok         ),
          .b2r_ack            (b2r_ack            ),
			      
      /* Transfer request to xfr_ctl */
          .b2x_idle           (b2x_idle           ),
          .b2x_req            (b2x_req            ),
          .b2x_start          (b2x_start          ),
          .b2x_last           (b2x_last           ),
          .b2x_wrap           (b2x_wrap           ),
          .b2x_id             (b2x_id             ),
          .b2x_ba             (b2x_ba             ),
          .b2x_addr           (b2x_addr           ),
          .b2x_len            (b2x_len            ),
          .b2x_cmd            (b2x_cmd            ),
          .x2b_ack            (x2b_ack            ),
		     
      /* Status from xfr_ctl */
          .b2x_tras_ok        (b2x_tras_ok        ),
          .x2b_refresh        (x2b_refresh        ),
          .x2b_pre_ok         (x2b_pre_ok         ),
          .x2b_act_ok         (x2b_act_ok         ),
          .x2b_rdok           (x2b_rdok           ),
          .x2b_wrok           (x2b_wrok           ),

      /* for generate cuurent xfr address msb */
          .sdr_req_norm_dma_last(app_req_dma_last),
          .xfr_bank_sel       (xfr_bank_sel       ),

       /* SDRAM Timing */
          .tras_delay         (cfg_sdr_tras_d     ),
          .trp_delay          (cfg_sdr_trp_d      ),
          .trcd_delay         (cfg_sdr_trcd_d     )
      );
   
   /****************************************************************************/
   // Instantiate sdr_xfr_ctl
   // This module takes requests from sdr_bank_ctl, runs the transfer and
   // controls data flow to/from the app. At the end of the transfer it issues a
   // burst terminate if not at the end of a burst and another command to this
   // bank is not available.

sdrc_xfr_ctl #(.SDR_DW(SDR_DW) ,  .SDR_BW(SDR_BW)) u_xfr_ctl (
          .clk                (clk          ),
          .reset_n            (reset_n            ),
			    
      /* Transfer request from bank_ctl */
          .r2x_idle           (r2x_idle           ),
          .b2x_idle           (b2x_idle           ),
          .b2x_req            (b2x_req            ),
          .b2x_start          (b2x_start          ),
          .b2x_last           (b2x_last           ),
          .b2x_wrap           (b2x_wrap           ),
          .b2x_id             (b2x_id             ),
          .b2x_ba             (b2x_ba             ),
          .b2x_addr           (b2x_addr           ),
          .b2x_len            (b2x_len            ),
          .b2x_cmd            (b2x_cmd            ),
          .x2b_ack            (x2b_ack            ),
		     
       /* Status to bank_ctl, req_gen */
          .b2x_tras_ok        (b2x_tras_ok        ),
          .x2b_refresh        (x2b_refresh        ),
          .x2b_pre_ok         (x2b_pre_ok         ),
          .x2b_act_ok         (x2b_act_ok         ),
          .x2b_rdok           (x2b_rdok           ),
          .x2b_wrok           (x2b_wrok           ),
		    
       /* SDRAM I/O */
          .sdr_cs_n           (sdr_cs_n           ),
          .sdr_cke            (sdr_cke            ),
          .sdr_ras_n          (sdr_ras_n          ),
          .sdr_cas_n          (sdr_cas_n          ),
          .sdr_we_n           (sdr_we_n           ),
          .sdr_dqm            (sdr_dqm            ),
          .sdr_ba             (sdr_ba             ),
          .sdr_addr           (sdr_addr           ),
          .sdr_din            (pad_sdr_din2       ),
          .sdr_dout           (sdr_dout_int       ),
          .sdr_den_n          (sdr_den_n_int      ),
      /* Data Flow to the app */
          .x2a_rdstart        (x2a_rdstart        ),
          .x2a_wrstart        (x2a_wrstart        ),
          .x2a_id             (xfr_id             ),
          .x2a_rdlast         (x2a_rdlast         ),
          .x2a_wrlast         (x2a_wrlast         ),
          .a2x_wrdt           (a2x_wrdt           ),
          .a2x_wren_n         (a2x_wren_n         ),
          .x2a_wrnext         (x2a_wrnext         ),
          .x2a_rddt           (x2a_rddt           ),
          .x2a_rdok           (x2a_rdok           ),
          .sdr_init_done      (sdr_init_done      ),
			    
      /* SDRAM Parameters */
          .sdram_enable       (cfg_sdr_en         ),
          .sdram_mode_reg     (cfg_sdr_mode_reg   ),
		    
      /* current xfr bank */
          .xfr_bank_sel       (xfr_bank_sel       ),

      /* SDRAM Timing */
          .cas_latency        (cfg_sdr_cas        ),
          .trp_delay          (cfg_sdr_trp_d      ),
          .trcar_delay        (cfg_sdr_trcar_d    ),
          .twr_delay          (cfg_sdr_twr_d      ),
          .rfsh_time          (cfg_sdr_rfsh       ),
          .rfsh_rmax          (cfg_sdr_rfmax      )
    );
   
   /****************************************************************************/
   // Instantiate sdr_bs_convert
   //    This model handle the bus with transaltion from application layer to
   //       8/16/32 SDRAM Memory format
   //     During Write Phase, this block split the data as per SDRAM Width
   //     During Read Phase, This block does the re-packing based on SDRAM
   //     Width
   //---------------------------------------------------------------------------
sdrc_bs_convert #(.SDR_DW(SDR_DW) ,  .SDR_BW(SDR_BW)) u_bs_convert (
          .clk                (clk          ),
          .reset_n            (reset_n            ),
          .sdr_width          (sdr_width          ),

   /* Control Signal from xfr ctrl */
          // Read Interface Inputs
          .x2a_rdstart        (x2a_rdstart        ),
          .x2a_rdlast         (x2a_rdlast         ),
          .x2a_rdok           (x2a_rdok           ),
	  // Read Interface outputs
          .x2a_rddt           (x2a_rddt           ),

          // Write Interface, Inputs
          .x2a_wrstart        (x2a_wrstart        ),
          .x2a_wrlast         (x2a_wrlast         ),
          .x2a_wrnext         (x2a_wrnext         ),

          // Write Interface, Outputs
          .a2x_wrdt           (a2x_wrdt           ),
          .a2x_wren_n         (a2x_wren_n         ),

   /* Control Signal from sdrc_bank_ctl  */

   /*  Control Signal from/to to application i/f  */
          .app_wr_data        (app_wr_data        ),
          .app_wr_en_n        (app_wr_en_n        ),
          .app_wr_next        (app_wr_next_req    ),
	  .app_last_wr        (app_last_wr        ),
          .app_rd_data        (app_rd_data        ),
          .app_rd_valid       (app_rd_valid       ),
	  .app_last_rd        (app_last_rd        )

       );   
   
endmodule // sdrc_core
