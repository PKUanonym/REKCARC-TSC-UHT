//  Created by Colin on 2021/05/13.
//  Copyright © 2021 Colin. All rights reserved.

// D Flip-flop
module DFlipflop (
    input data, clk, rst,
    output reg q, nq
);
initial begin
    q   <= 0;
    nq  <= 1;
end
always @(posedge rst or posedge clk) begin
    if (rst) begin
        q   <= 0;
        nq  <= 1;
    end
    else begin
        q    <= data;
        nq   <= ~data;
    end
end
endmodule

/* async counter with mod 64
 */
module Counter64 (
    input clk, rst,
    output[5:0] num
);
    // use 6 D flip-flop in series (2 ** 6 == 64)
    // the 6 Q ports of DFF serves as output num
    logic nq[5:0];
    DFlipflop d5(.data(nq[5]), .clk(clk),   .rst(rst), .q(num[0]), .nq(nq[5]));
    DFlipflop d4(.data(nq[4]), .clk(nq[5]), .rst(rst), .q(num[1]), .nq(nq[4]));
    DFlipflop d3(.data(nq[3]), .clk(nq[4]), .rst(rst), .q(num[2]), .nq(nq[3]));
    DFlipflop d2(.data(nq[2]), .clk(nq[3]), .rst(rst), .q(num[3]), .nq(nq[2]));
    DFlipflop d1(.data(nq[1]), .clk(nq[2]), .rst(rst), .q(num[4]), .nq(nq[1]));
    DFlipflop d0(.data(nq[0]), .clk(nq[1]), .rst(rst), .q(num[5]), .nq(nq[0]));
endmodule

/* judge whether 6-bit number x and y are equal
 */
module Equal6Bits (
    input[5:0] x, y,
    output flag
);
    logic[5:0] tmp;
    assign tmp = ~(x ^ y);
    assign flag = tmp[5] & tmp[4] & tmp[3] & tmp[2] & tmp[1] & tmp[0];
endmodule

/* Counter with mod X
 * X is a 6-bit binary number ( 2 <= X <= 64 )
 * implemented by Counter64
 */
module CounterX (
    input clk, rst,
    input[5:0] x,
    output[5:0] num
);
    logic same = 0, need_to_ret = 0;

    /* when the Counter64 needs to be reset?
     * posedge of rst (when the user pushes the button)
     * or, posedge of (need_to_ret & clk)
     * i.e. need_to_ret == 1 and the posedge of clk arrives
     */
    Counter64 c64(.clk(clk), .rst(rst | need_to_ret & clk), .num(num));

    // when num reaches x, same goes to 1
    Equal6Bits equal(.x(x), .y(num), .flag(same));

    /* use a D flip-flop as a holder to store the signal of event that num reaches x
     * use same as the data for DFF
     * the holder is triggered when clk 1 -> 0
     * need_to_ret == 1 means the counter needs to return to 0 when the following posedge arrives
     */
    DFlipflop holder(.data(same), .clk(~clk), .rst(rst), .q(need_to_ret));

endmodule

/* Decode a 6-bit binary number
 * to double digit decimal number
 */
module Decoder (
    input[5:0] num,
    output reg[6:0] disp0, disp1
);
    assign disp0 = four_bits_decoder(num % 6'd10);
    assign disp1 = four_bits_decoder(num / 6'd10);

    function logic[6:0] four_bits_decoder(
        logic[3:0] number
    );
        case(number)
            4'h0:   four_bits_decoder = 7'b1111110;
            4'h1:   four_bits_decoder = 7'b0110000;
            4'h2:   four_bits_decoder = 7'b1101101;
            4'h3:   four_bits_decoder = 7'b1111001;
            4'h4:   four_bits_decoder = 7'b0110011;
            4'h5:   four_bits_decoder = 7'b1011011;
            4'h6:   four_bits_decoder = 7'b1011111;
            4'h7:   four_bits_decoder = 7'b1110000;
            4'h8:   four_bits_decoder = 7'b1111111;
            4'h9:   four_bits_decoder = 7'b1110011;
            4'ha:   four_bits_decoder = 7'b1110111;
            4'hb:   four_bits_decoder = 7'b0011111;
            4'hc:   four_bits_decoder = 7'b1001110;
            4'hd:   four_bits_decoder = 7'b0111101;
            4'he:   four_bits_decoder = 7'b1001111;
            4'hf:   four_bits_decoder = 7'b1000111;
            default:
                    four_bits_decoder = 7'bx;
        endcase
    endfunction
endmodule


module Counter (
    input clk, rst, trig,
    output[6:0] disp1, disp0
);
    /* start or pause
     * on == 1, continue
     * on == 0, pause
     */
    logic on = 0;
    always @(posedge trig) begin
        on = ~on;
    end

    /* generate signal myClk with alternate 0 and 1
     * 0 -- 0.5s --> 1 -- 0.5s --> 0 -- 0.5s --> 1
     */
    logic myClk = 0;
    int cc = 0;
    always @(posedge clk) begin
        cc++;
        if (cc == 1_000_000) begin
            myClk = 1;
        end
        else if (cc == 2_000_000) begin
            myClk = 0;
            cc = 0;
        end
    end

    /* instantiate a Counter40
     * send the counter a posedge only when (on & myClk) == 1
     */
    logic[5:0] num = 0;
    CounterX counter40(.clk(on & myClk), .rst(rst), .x(6'd39), .num(num));

    // decode the 6-bit num to outputs for display
    Decoder trans(.num(num), .disp1(disp1), .disp0(disp0));

endmodule