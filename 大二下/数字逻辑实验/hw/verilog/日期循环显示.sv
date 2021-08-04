//  Created by Colin on 2021/04/30.
//  Copyright © 2021 Colin. All rights reserved.

module seqdisplay (
    input logic rst,
    input logic clk,
    output logic [6:0] natural,
    output logic [3:0] even,
    output logic [3:0] odd
);

int counter;
logic[3:0] date [0:9] = '{ 4'h2, 4'h0, 4'h2, 4'h1, 4'h0, 4'h4, 4'h0, 4'h9, 4'h0, 4'h7 };
logic[3:0] index = 0;

initial begin
    even = 0;
    odd  = 0;
    //date = '{ 4'h2, 4'h0, 4'h2, 4'h1, 4'h0, 4'h4, 4'h0, 4'h9, 4'h0, 4'h7 };
    natural = digital_number(0);
end

always @ (posedge clk) begin
    if (rst) begin
        counter <= 32'd4_000_000;
        index   = 0;
        natural <= digital_number(date[0]); // display 0
    end
    else begin
        if (counter == 32'd4_000_000) begin   // need update
            // display the next number
            natural <= digital_number(date[index]);
            index = index + 4'b1;
            if (index == 10) begin
                index = 0;
            end
            counter <= 0;
        end
        else begin
            counter <= counter + 32'd1;
        end
    end
end

function logic[6:0] digital_number(
    logic[3:0] number
);
    case(number)
        4'h0:   digital_number = 7'b1111110;
        4'h1:   digital_number = 7'b0110000;
        4'h2:   digital_number = 7'b1101101;
        4'h3:   digital_number = 7'b1111001;
        4'h4:   digital_number = 7'b0110011;
        4'h5:   digital_number = 7'b1011011;
        4'h6:   digital_number = 7'b1011111;
        4'h7:   digital_number = 7'b1110000;
        4'h8:   digital_number = 7'b1111111;
        4'h9:   digital_number = 7'b1110011;
        4'ha:   digital_number = 7'b1110111;
        4'hb:   digital_number = 7'b0011111;
        4'hc:   digital_number = 7'b1001110;
        4'hd:   digital_number = 7'b0111101;
        4'he:   digital_number = 7'b1001111;
        4'hf:   digital_number = 7'b1000111;
        default:
                digital_number = 7'bx;
    endcase
endfunction

endmodule