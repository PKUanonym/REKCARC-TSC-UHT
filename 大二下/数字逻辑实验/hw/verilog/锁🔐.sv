//  Created by Colin on 2021/06/02.
//  Copyright © 2021 Colin. All rights reserved.

module Lock (
    input rst, clk,
    input[3:0] code,
    input[1:0] mode,    // 0: set; 1: validation
    output reg unlock, err, alert,
    output[6:0] digits
);

typedef enum { init, set0, set1, set2, set3, val0, val1, val2, val3, open } state_t;

reg[3:0] admin_passwd[0:3] = '{ 4'd15, 4'd15, 4'd15, 4'd15 };
reg[3:0] users_passwd[0:3] = '{ 4'd0, 4'd0, 4'd0, 4'd0 };
state_t state = init; // 0 ~ 9
shortint wrong_times = 0;
logic admin_wrong = 0;

FourBitsDecoder decoder(.number(state), .digits(digits));

initial begin
    unlock = 0;
    err = 0;
    alert = 0;
end

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        case (state)
            init: begin
                case (mode)
                    2'b0: state = set0;  // set
                    2'b1: state = val0;  // validation
                    default: ;
                endcase
            end
            default: begin
                state = init;
                unlock = 0;
            end
        endcase
        err = 0;
    end
    else begin
        case (state)
            set0:  begin   // #0 set
                    users_passwd[0] = code;
                    state = set1;
                end
            set1:  begin   // #2 set
                    users_passwd[1] = code;
                    state = set2;
                end
            set2:  begin   // #2 set
                    users_passwd[2] = code;
                    state = set3;
                end
            set3:  begin   // #3 set
                    users_passwd[3] = code;
                    state = open;  // open!!!
                    unlock = 1;
                end
            val0:  begin   // #0 validation
                    if (~alert && code != users_passwd[0] ||
                        alert && code != admin_passwd[0] || admin_wrong) begin  // wrong
                        handle_wrong();
                    end
                    else begin  // right
                        state = val1;
                    end
                end
            val1:  begin   // #1 validation
                    if (~alert && code != users_passwd[1] ||
                        alert && code != admin_passwd[1] || admin_wrong) begin  // wrong
                        handle_wrong();
                    end
                    else begin  // right
                        state = val2;
                    end
                end
            val2:  begin   // #2 validation
                    if (~alert && code != users_passwd[2] ||
                        alert && code != admin_passwd[2] || admin_wrong) begin  // wrong
                        handle_wrong();
                    end
                    else begin  // right
                        state = val3;
                    end
                end
            val3:  begin   // #3 validation
                    if (~alert && code != users_passwd[3] ||
                        alert && code != admin_passwd[3] || admin_wrong) begin  // wrong
                        handle_wrong();
                    end
                    else begin  // right
                        state = open;  // open!!!
                        unlock = 1;
                        wrong_times = 0;
                        if (alert) begin
                            alert = 0;
                            users_passwd = '{ 4'd0, 4'd0, 4'd0, 4'd0 };
                        end
                    end
                end
            default: ;  // 0
        endcase
    end
end

function void handle_wrong();
    if (~alert) begin   // user
        state = init;
        err = 1;
        wrong_times++;
        if (wrong_times >= 5)
            alert = 1;
    end
    else begin  // admin
        if (state == val3) begin
            state = init;
            err = 1;
            admin_wrong = 0;
        end
        else begin
            admin_wrong = 1;
            state = state_t'(state + 1);
        end
    end
endfunction

endmodule

module FourBitsDecoder (
    input [3:0] number,
    output reg[6:0] digits
);

always_ff @(number) begin
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