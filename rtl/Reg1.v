module Reg1(
	input clk, reset, WE,
	input [127:0] dataIn, afARK,
	input is_R1,
	output [127:0] dataOut
);
	reg [127:0] R1;
	always @ (negedge clk or posedge reset)
	begin
		if (reset)
			R1 = 128'b0;
		else if (WE) begin
			R1 = (is_R1 == 1'b0) ? dataIn : afARK;
		end
	end
	assign dataOut = R1;
endmodule