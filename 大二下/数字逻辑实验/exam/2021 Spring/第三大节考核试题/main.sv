//  Created by Colin on 2021/06/11.
//  Copyright © 2021 Colin. All rights reserved.

module Main (
    input wire Clk,
    input wire E_Button, Ctrl, Rst,
    output reg[6:0] Seg,
    output reg Div_out
);
    logic[3:0] number = 1;
    FourBitsDecoder decoder(.number(number), .digits(Seg));

    shortint counter = 0;
    int cc = 0;
    
    initial begin
        Div_out = 1;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            number = 1;
            cc = 0;
        end
        else if (cc == 1_000_000) begin
            cc = 0;
            if (E_Button == 0) begin
                if (Ctrl == 1) begin
                    // 1 -> 6
                    if (number < 6) begin
                        number++;
                    end
                end
                else begin
                    // 6 -> 1
                    if (number > 1) begin
                        number--;
                    end
                end
            end
        end
        if (E_Button == 0)
            cc++;

        if (counter % 2 == 0) begin
            Div_out = ~Div_out;
            counter = 0;
        end
        counter++;
    end

endmodule

module FourBitsDecoder (
    input wire[3:0] number,
    output reg[6:0] digits
);

always @(number) begin
    case(number)
        4'h0:   digits = 7'b1111110;
        4'h1:   digits = 7'b0110000;
        4'h2:   digits = 7'b1101101;
        4'h3:   digits = 7'b1111001;
        4'h4:   digits = 7'b0110011;
        4'h5:   digits = 7'b1011011;
        4'h6:   digits = 7'b1011111;
        4'h7:   digits = 7'b1110000;
        4'h8:   digits = 7'b1111111;
        4'h9:   digits = 7'b1110011;
        4'ha:   digits = 7'b1110111;
        4'hb:   digits = 7'b0011111;
        4'hc:   digits = 7'b1001110;
        4'hd:   digits = 7'b0111101;
        4'he:   digits = 7'b1001111;
        4'hf:   digits = 7'b1000111;
        default:
                digits = 7'b0;
    endcase
end
    
endmodule