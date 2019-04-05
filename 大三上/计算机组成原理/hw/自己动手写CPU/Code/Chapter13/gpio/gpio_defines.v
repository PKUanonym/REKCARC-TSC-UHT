//////////////////////////////////////////////////////////////////////
////                                                              ////
////  WISHBONE GPIO Definitions                                   ////
////                                                              ////
////  This file is part of the GPIO project                       ////
////  http://www.opencores.org/cores/gpio/                        ////
////                                                              ////
////  Description                                                 ////
////  GPIO IP Definitions.                                        ////
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
// Revision 1.8  2003/12/17 13:00:52  gorand
// added ECLK and NEC registers, all tests passed.
//
// Revision 1.7  2003/12/01 17:10:44  simons
// ifndef directive is not supported by all tools.
//
// Revision 1.6  2003/11/06 13:59:07  gorand
// added support for 8-bit access to registers.
//
// Revision 1.2  2003/10/02 18:54:35  simons
// GPIO signals muxed with other peripherals, higland_board fixed.
//
// Revision 1.1.1.1  2003/06/24 09:09:23  simons
// This files were moved here from toplevel folder.
//
// Revision 1.1.1.1  2003/06/11 18:51:13  simons
// Initial import.
//
// Revision 1.5  2002/11/11 21:36:28  lampret
// Added ifdef to remove mux from clk_pad_i if mux is not allowed. This also removes RGPIO_CTRL[NEC].
//
// Revision 1.4  2002/05/06 18:25:31  lampret
// negedge flops are enabled by default.
//
// Revision 1.3  2001/12/25 17:12:35  lampret
// Added RGPIO_INTS.
//
// Revision 1.2  2001/11/15 02:24:37  lampret
// Added GPIO_REGISTERED_WB_OUTPUTS, GPIO_REGISTERED_IO_OUTPUTS and GPIO_NO_NEGEDGE_FLOPS.
//
// Revision 1.1  2001/09/18 18:49:07  lampret
// Changed top level ptc into gpio_top. Changed defines.v into gpio_defines.v.
//
// Revision 1.1  2001/08/21 21:39:28  lampret
// Changed directory structure, port names and drfines.
//
// Revision 1.3  2001/07/15 00:21:10  lampret
// Registers can be omitted and will have certain default values
//
// Revision 1.2  2001/07/14 20:39:26  lampret
// Better configurability.
//
// Revision 1.1  2001/06/05 07:45:26  lampret
// Added initial RTL and test benches. There are still some issues with these files.
//
//

//
// Number of GPIO I/O signals
//
// This is the most important parameter of the GPIO IP core. It defines how many
// I/O signals core has. Range is from 1 to 32. If more than 32 I/O signals are
// required, use several instances of GPIO IP core.
//
// Default is 16.
//
`define GPIO_IOS 32

//depending on number of GPIO_IOS, define this...
// for example: if there is 26 GPIO_IOS, define GPIO_LINES26
//

`define GPIO_LINES32

//
// Undefine this one if you don't want to remove GPIO block from your design
// but you also don't need it. When it is undefined, all GPIO ports still
// remain valid and the core can be synthesized however internally there is
// no GPIO funationality.
//
// Defined by default (duhh !).
//
`define GPIO_IMPLEMENTED

//
// Define to register all WISHBONE outputs.
//
// Register outputs if you are using GPIO core as a block and synthesizing
// and place&routing it separately from the rest of the system.
//
// If you do not need registered outputs, you can save some area by not defining
// this macro. By default it is defined.
//
`define GPIO_REGISTERED_WB_OUTPUTS

//
// Define to register all GPIO pad outputs.
//
// Register outputs if you are using GPIO core as a block and synthesizing
// and place&routing it separately from the rest of the system.
//
// If you do not need registered outputs, you can save some area by not defining
// this macro. By default it is defined.
//
`define GPIO_REGISTERED_IO_OUTPUTS

//
// Implement aux feature. If this define is not defined also aux_i port and 
// RGPIO_AUX register will be removed
//
// Defined by default.
//
//`define GPIO_AUX_IMPLEMENT

//
// If this is not defined clk_pad_i will be removed. Input lines will be lached on 
// positive edge of system clock
// if disabled defines GPIO_NO_NEGEDGE_FLOPS, GPIO_NO_CLKPAD_LOGIC will have no effect.
//
// Defined by default.
//
//`define GPIO_CLKPAD

//
// Define to avoid using negative edge clock flip-flops for external clock
// (caused by NEC register. Instead an inverted external clock with
// positive edge clock flip-flops will be used.
// This define don't have any effect if GPIO_CLKPAD is not defined and if GPIO_SYNC_IN_CLK is defined
//
// By default it is not defined.
//
//`define GPIO_NO_NEGEDGE_FLOPS

//
// If GPIO_NO_NEGEDGE_FLOPS is defined, a mux needs to be placed on external clock
// clk_pad_i to implement RGPIO_CTRL[NEC] functionality. If no mux is allowed on
// clock signal, enable the following define.
// This define don't have any effect if GPIO_CLKPAD is not defined and if GPIO_SYNC_IN_CLK is defined
//
// By default it is not defined.
//
//`define GPIO_NO_CLKPAD_LOGIC


//
// synchronization defines
//
// Two synchronization flops to input lineis added.
// system clock synchronization.
//
`define GPIO_SYNC_IN_WB

//
// Add synchronization flops to external clock input line. Gpio will have just one clock domain, 
// everithing will be synchronized to wishbone clock. External clock muas be at least 2-3x slower 
// as systam clock.
//
`define GPIO_SYNC_CLK_WB

//
// Add synchronization to input pads. synchronization to external clock.
// Don't hawe any effect if GPIO_SYNC_CLK_WB is defined.
//
//`define GPIO_SYNC_IN_CLK

//
// Add synchronization flops between system clock and external clock.
// Only possible if external clock is enabled and clock synchroization is disabled.
//
//`define GPIO_SYNC_IN_CLK_WB



// 
// Undefine if you don't need to read GPIO registers except for RGPIO_IN register.
// When it is undefined all reads of GPIO registers return RGPIO_IN register. This
// is usually useful if you want really small area (for example when implemented in
// FPGA).
//
// To follow GPIO IP core specification document this one must be defined. Also to
// successfully run the test bench it must be defined. By default it is defined.
//
`define GPIO_READREGS

//
// Full WISHBONE address decoding
//
// It is is undefined, partial WISHBONE address decoding is performed.
// Undefine it if you need to save some area.
//
// By default it is defined.
//
`define GPIO_FULL_DECODE

//
// Strict 32-bit WISHBONE access
//
// If this one is defined, all WISHBONE accesses must be 32-bit. If it is
// not defined, err_o is asserted whenever 8- or 16-bit access is made.
// Undefine it if you need to save some area.
//
// By default it is defined.
//
//`define GPIO_STRICT_32BIT_ACCESS
//
`ifdef GPIO_STRICT_32BIT_ACCESS
`else
// added by gorand :
// if GPIO_STRICT_32BIT_ACCESS is not defined,
// depending on number of gpio I/O lines, the following are defined :
// if the number of I/O lines is in range 1-8,   GPIO_WB_BYTES1 is defined,
// if the number of I/O lines is in range 9-16,  GPIO_WB_BYTES2 is defined,
// if the number of I/O lines is in range 17-24, GPIO_WB_BYTES3 is defined,
// if the number of I/O lines is in range 25-32, GPIO_WB_BYTES4 is defined,

`define GPIO_WB_BYTES4
//`define GPIO_WB_BYTES3
//`define GPIO_WB_BYTES2
//`define GPIO_WB_BYTES1

`endif

//
// WISHBONE address bits used for full decoding of GPIO registers.
//
`define GPIO_ADDRHH 7
`define GPIO_ADDRHL 6
`define GPIO_ADDRLH 1
`define GPIO_ADDRLL 0

//
// Bits of WISHBONE address used for partial decoding of GPIO registers.
//
// Default 5:2.
//
`define GPIO_OFS_BITS	`GPIO_ADDRHL-1:`GPIO_ADDRLH+1

//
// Addresses of GPIO registers
//
// To comply with GPIO IP core specification document they must go from
// address 0 to address 0x18 in the following order: RGPIO_IN, RGPIO_OUT,
// RGPIO_OE, RGPIO_INTE, RGPIO_PTRIG, RGPIO_AUX and RGPIO_CTRL
//
// If particular register is not needed, it's address definition can be omitted
// and the register will not be implemented. Instead a fixed default value will
// be used.
//
`define GPIO_RGPIO_IN		  4'h0	// Address 0x00
`define GPIO_RGPIO_OUT		4'h1	// Address 0x04
`define GPIO_RGPIO_OE		  4'h2	// Address 0x08
`define GPIO_RGPIO_INTE		4'h3	// Address 0x0c
`define GPIO_RGPIO_PTRIG	4'h4	// Address 0x10

`ifdef GPIO_AUX_IMPLEMENT
`define GPIO_RGPIO_AUX		4'h5	// Address 0x14
`endif // GPIO_AUX_IMPLEMENT

`define GPIO_RGPIO_CTRL		4'h6	// Address 0x18
`define GPIO_RGPIO_INTS		4'h7	// Address 0x1c

`ifdef GPIO_CLKPAD
`define GPIO_RGPIO_ECLK   4'h8  // Address 0x20
`define GPIO_RGPIO_NEC    4'h9  // Address 0x24
`endif //  GPIO_CLKPAD

//
// Default values for unimplemented GPIO registers
//
`define GPIO_DEF_RGPIO_IN	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_OUT	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_OE	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_INTE	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_PTRIG	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_AUX	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_CTRL	`GPIO_IOS'h0
`define GPIO_DEF_RGPIO_ECLK `GPIO_IOS'h0
`define GPIO_DEF_RGPIO_NEC `GPIO_IOS'h0


//
// RGPIO_CTRL bits
//
// To comply with the GPIO IP core specification document they must go from
// bit 0 to bit 1 in the following order: INTE, INT
//
`define GPIO_RGPIO_CTRL_INTE		0
`define GPIO_RGPIO_CTRL_INTS		1


