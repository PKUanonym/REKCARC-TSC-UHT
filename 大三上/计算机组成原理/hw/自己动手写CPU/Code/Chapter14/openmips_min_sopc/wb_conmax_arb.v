/////////////////////////////////////////////////////////////////////
////                                                             ////
////  General Round Robin Arbiter                                ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/wb_conmax/ ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: wb_conmax_arb.v,v 1.2 2002-10-03 05:40:07 rudi Exp $
//
//  $Date: 2002-10-03 05:40:07 $
//  $Revision: 1.2 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/10/19 11:01:40  rudi
//               WISHBONE CONMAX IP Core
//
//
//
//
//
//
//                        

`include "wb_conmax_defines.v"

module wb_conmax_arb(clk, rst, req, gnt, next);

input		clk;
input		rst;
input	[7:0]	req;		// Req input
output	[2:0]	gnt; 		// Grant output
input		next;		// Next Target

///////////////////////////////////////////////////////////////////////
//
// Parameters
//

parameter	[2:0]
                grant0 = 3'h0,
                grant1 = 3'h1,
                grant2 = 3'h2,
                grant3 = 3'h3,
                grant4 = 3'h4,
                grant5 = 3'h5,
                grant6 = 3'h6,
                grant7 = 3'h7;

///////////////////////////////////////////////////////////////////////
//
// Local Registers and Wires
//

reg [2:0]	state, next_state;

///////////////////////////////////////////////////////////////////////
//
//  Misc Logic 
//

assign	gnt = state;

always@(posedge clk or posedge rst)
	if(rst)		state <= #1 grant0;
	else		state <= #1 next_state;

///////////////////////////////////////////////////////////////////////
//
// Next State Logic
//   - implements round robin arbitration algorithm
//   - switches grant if current req is dropped or next is asserted
//   - parks at last grant
//

always@(state or req or next)
   begin
	next_state = state;	// Default Keep State
	case(state)		// synopsys parallel_case full_case
 	   grant0:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[0] | next)
		   begin
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
		   end
 	   grant1:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[1] | next)
		   begin
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
		   end
 	   grant2:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[2] | next)
		   begin
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
		   end
 	   grant3:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[3] | next)
		   begin
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
		   end
 	   grant4:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[4] | next)
		   begin
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
		   end
 	   grant5:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[5] | next)
		   begin
			if(req[6])	next_state = grant6;
			else
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
		   end
 	   grant6:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[6] | next)
		   begin
			if(req[7])	next_state = grant7;
			else
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
		   end
 	   grant7:
		// if this req is dropped or next is asserted, check for other req's
		if(!req[7] | next)
		   begin
			if(req[0])	next_state = grant0;
			else
			if(req[1])	next_state = grant1;
			else
			if(req[2])	next_state = grant2;
			else
			if(req[3])	next_state = grant3;
			else
			if(req[4])	next_state = grant4;
			else
			if(req[5])	next_state = grant5;
			else
			if(req[6])	next_state = grant6;
		   end
	endcase
   end

endmodule 

