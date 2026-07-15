module AESv2(
	input clk, reset,
	input AES_en,
	input [127:0] in, key,
	output done, 
	output [127:0] dataOut
);
	wire [3:0] round_numb;
	wire is_R1;
	wire SB_skip, SR_skip, MXC_skip;
	AESv2_FSM FSM(.reset(reset), .clk(clk), .AES_en(AES_en), .out_done(done), .round_numb(round_numb), .isR1(is_R1),.SB_skip(SB_skip), .SR_skip(SR_skip), .MXC_skip(MXC_skip));
	AESv2_DP DPv2(.reset(reset), .clk(clk), .round_numb(round_numb), .is_R1(is_R1), .SB_skip(SB_skip), .SR_skip(SR_skip), .MXC_skip(MXC_skip), .dataIn(in), .key(key), .dataOut(dataOut));
	
endmodule

  