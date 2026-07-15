module ShiftRows(
	input [127:0] in,
	input SR_skip,
	output [127:0] out 
	);
	wire [31:0] row3, row2, row1, row0,
					row3s, row2s, row1s, row0s,
					col_3_o, col_2_o, col_1_o, col_0_o;
	
	assign row3 = {in[127-:8], in[95-:8], in[63-:8], in[31-:8]};
	assign row2 = {in[119-:8], in[87-:8], in[55-:8], in[23-:8]};
	assign row1 = {in[111-:8], in[79-:8], in[47-:8], in[15-:8]};
	assign row0 = {in[103-:8], in[71-:8], in[39-:8], in[7-:8]};
	
	assign row3s = {row3};
	// round 2 shift left 1 byte
	assign row2s = {row2[23:0], row2[31:24]};
	
	// round 1 shift left 2 bytes
	assign row1s = {row1[15:0], row1[31:16]};
	
	// roudn 0 shift left 3 bytes
	assign row0s = {row0[7:0], row0[31:8]};
	// return back columns for the output
	assign col_3_o = {row3s[31:24], row2s[31:24], row1s[31:24], row0s[31:24]};
	assign col_2_o = {row3s[23:16], row2s[23:16], row1s[23:16], row0s[23:16]};
	assign col_1_o = {row3s[15:8], row2s[15:8], row1s[15:8], row0s[15:8]};
	assign col_0_o = {row3s[7:0], row2s[7:0], row1s[7:0], row0s[7:0]};
	// out = sequence of 4 columns
	assign out = (SR_skip == 1'b0) ? {col_3_o, col_2_o, col_1_o, col_0_o} : in;
endmodule
