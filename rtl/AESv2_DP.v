module AESv2_DP(
    input reset,
	 input clk,
	 input [3:0] round_numb,
	 input is_R1,
	 input SB_skip, SR_skip, MXC_skip,
    input [127:0] dataIn, key,
//	 output [127:0] keyRound,
//	 output [127:0] afSB, afSR, afMXC, afARK,
//	 output [127:0] bfSB,
    output [127:0] dataOut
);
    wire [127:0] afSB, afSR, afMXC, afARK;
    wire [127:0] keyRound;
	 wire [127:0] bfSB;
	 
    
    KE_related KEr(clk, reset, 1'b1, round_numb, key, keyRound);
    Reg1 R1(.clk(clk), .reset(reset), .WE(1'b1), .dataIn(dataIn), .afARK(afARK), .is_R1(is_R1), .dataOut(bfSB));
	 
    SubBytes SB(bfSB, SB_skip, afSB);
    ShiftRows SR(afSB, SR_skip, afSR);
    S_MIX_COLUMNS MXC(afSR, MXC_skip, afMXC);
	 AddRoundKey ARK(afMXC, keyRound, afARK);
	 
    assign dataOut = (round_numb == 4'b1010) ? afARK : 128'b0 ;
endmodule