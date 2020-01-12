module problem4_reaction(
    input wire clk1M, // 1MHz ʱ��
    input wire clkBtn, // CLK ��ť
    input wire rstBtn, // RST ��ť
    output reg led1, // ����LED1
    output reg led2, // ����LED2
    output reg led3 // ����LED3
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
            // �ж�counter��ʱ��2s��4s��ĳ��ֵʱ������led1�������¿�ʼ��ʱ
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
        // ��⵽CLK��ť����˲�䣬������ĿҪ��Ƚ�counter��ֵ��������led2��led3
        // === YOUR CODE HERE ===
    end
end

endmodule