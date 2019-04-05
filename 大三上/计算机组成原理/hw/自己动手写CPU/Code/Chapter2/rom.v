
module rom(

	input wire                    ce,
	input wire[5:0]			addr,
	output reg[31:0]					inst
	
);

	reg[31:0]  rom[63:0];

	initial $readmemh ( "rom.data", rom );

	always @ (*) begin
		if (ce == 1'b0) begin
			inst <= 32'h0;
	  end else begin
		  inst <= rom[addr];
		end
	end

endmodule