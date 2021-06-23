//  Created by Colin on 2021/05/06.
//  Copyright © 2021 Colin. All rights reserved.

module OneBitHalfAdder (
    input   x, y,
    output  s, c
);  // 教科书上的半加器基本逻辑
    assign s = x ^ y;
    assign c = x & y;
endmodule

module OneBitFullAdder(
    input   c_last, x, y,
    output  s, c_this,
    output  p, g
);  // 利用两个半加器实现一个全加器；为了超前进位加法器的方便，输出了中间量p，g
    logic c1;   // 中间量
    // Verilog 模块例化：
    OneBitHalfAdder ha0(
        .x(x), .y(y), .s(p), .c(g)
    );
    OneBitHalfAdder ha1(
        .x(p), .y(c_last), .s(s), .c(c1)
    );
    assign c_this = g | c1;
endmodule

module SeqFourBitsAdder(
    input        c_last,
    input[3:0]   a, b,
    output[3:0]  s,
    output       c_this
);  // 逐次进位加法器；依照教材上的结构，利用四个全加器实现
    logic c[0:2];   // 中间量
    // Verilog 模块例化：
    OneBitFullAdder fa0(
        .c_last(c_last), .x(a[0]), .y(b[0]), .s(s[0]), .c_this(c[0])
    );
    OneBitFullAdder fa1(
        .c_last(c[0]), .x(a[1]), .y(b[1]), .s(s[1]), .c_this(c[1])
    );
    OneBitFullAdder fa2(
        .c_last(c[1]), .x(a[2]), .y(b[2]), .s(s[2]), .c_this(c[2])
    );
    OneBitFullAdder fa3(
        .c_last(c[2]), .x(a[3]), .y(b[3]), .s(s[3]), .c_this(c_this)
    );
endmodule

module AdvancedFourBitsAdder(
    input        c_last,
    input[3:0]   a, b,
    output[3:0]  s,
    output       c_this
);  // 逐次进位加法器；依照教材上的结构，利用四个全加器实现
    // 中间量
    logic p[0:3], g[0:3];
    logic c[0:2];
    // Verilog 模块例化：
    OneBitFullAdder fa0(
        .c_last(c_last), .x(a[0]), .y(b[0]), .s(s[0]), .p(p[0]), .g(g[0])
    );
    OneBitFullAdder fa1(
        .c_last(c[0]), .x(a[1]), .y(b[1]), .s(s[1]), .p(p[1]), .g(g[1])
    );
    OneBitFullAdder fa2(
        .c_last(c[1]), .x(a[2]), .y(b[2]), .s(s[2]), .p(p[2]), .g(g[2])
    );
    OneBitFullAdder fa3(
        .c_last(c[2]), .x(a[3]), .y(b[3]), .s(s[3]), .p(p[3]), .g(g[3])
    );
    // look and carry 结构，用于计算第2、3、4位需要的上一位的进位信息
    assign c[0] = g[0] | p[0] & c_last;
    assign c[1] = g[1] | p[1] & g[0] | p[1] & p[0] & c_last;
    assign c[2] = g[2] | p[2] & g[1] | p[2] & p[1] & g[0] | p[2] & p[1] & p[0] & c_last;
    assign c_this = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0] | 
                    p[3] & p[2] & p[1] & p[0] & c_last;
endmodule

module FourBitsAdder(
    input           clk,
    input           switch_mode,
    input           c_last,
    input[3:0]      a, b,
    output reg[3:0] s,
    output reg      c_this
);  // 顶级模块；统一两种加法器，监听一个微动开关用于切换输出哪个加法器的结果

logic       flag = 0;   // 标识当前用哪个加法器
logic[3:0]  sum[0:1];   // 两个加法器的结果（数组）
logic       c_out[0:1]; // 两个加法器输出的进位的结果（数组）

SeqFourBitsAdder adder0(
    .c_last(c_last), .a(a), .b(b), .s(sum[0]), .c_this(c_out[0])
);  // 逐次进位加法器的模块例化

AdvancedFourBitsAdder adder1(
    .c_last(c_last), .a(a), .b(b), .s(sum[1]), .c_this(c_out[1])
);  // 超前进位加法器的模块例化

always @(posedge switch_mode) begin
    flag <= ~flag;  // 当按下微动开关时，标识反转
end

// 当标识、输入量改变时，更新输出值
always @(flag or c_last or a or b) begin
    if (flag) begin // 用超前进位加法器时，将4位结果反向输出，用于区分
        s  <= { sum[flag][0], sum[flag][1], sum[flag][2], sum[flag][3] };
    end
    else begin  // 用逐次进位加法器时，直接输出4位结果
        s  <= sum[flag];
    end
    c_this <= c_out[flag];  // 两种加法器进位输出是一样的
end

endmodule