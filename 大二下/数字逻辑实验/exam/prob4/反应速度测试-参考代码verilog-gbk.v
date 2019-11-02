module problem4_reaction(
    input wire clk1M, // 1MHz 时钟
    input wire clkBtn, // CLK 按钮
    input wire rstBtn, // RST 按钮
    output reg led1, // 连接LED1
    output reg led2, // 连接LED2
    output reg led3 // 连接LED3
);

reg btnSync, btnLast;
reg [21:0] counter;

always @(posedge clk1M) begin
    if(rstBtn) begin
        counter <= 0;
        led1 <= 0;
    end else begin
        if(!(&counter))
            counter <= counter + 1;
        if(~led1) begin
            // 判断counter计时到2s～4s的某个值时，点亮led1，并重新开始计时
            // === YOUR CODE HERE ===
        end
    end
end

always @(posedge clk1M) begin
    btnLast <= btnSync;
    btnSync <= clkBtn;
    if(rstBtn) begin
        led2 <= 0;
        led3 <= 0;
    end else if(btnSync & !btnLast) begin
        // 检测到CLK按钮按下瞬间，根据题目要求比较counter的值，并设置led2，led3
        // === YOUR CODE HERE ===
    end
end

endmodule