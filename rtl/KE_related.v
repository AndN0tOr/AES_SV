module KE_related(
	input clk,
	input reset,
	input KE_en,
	input [3:0] round_numb,
	input [127:0] or_key,
	output [127:0] key_round
	);
	
	reg [127:0] proc_key;
	// 1 register to save the previous key to re-expand after rounds
	always@(negedge clk or posedge reset)
	begin
		if (reset)
			proc_key = 128'b0;
		else if (KE_en)
			proc_key = (round_numb == 4'h0) ? or_key : key_round;
	end
	// 1 register to save the key_round after expansion
//	always@(negedge clk or posedge reset)
//	begin 
//		if (reset)
//			o_key_round = 128'b0;
//		else if (KE_en)
//			o_key_round = key_round;
//	end
	KeyExpansion KE (proc_key, round_numb, key_round);
	
endmodule

