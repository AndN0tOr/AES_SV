
module SubBytes(
    input [127:0] word_i,
    input SB_skip,
	 output [127:0] word_o    
	);
	wire [127:0] sbox_o;     
	
	assign word_o = (SB_skip == 1'b0) ? sbox_o : word_i;

	S_Box sbox_e0 (word_i[127:120], sbox_o[127:120]); 
	S_Box sbox_e1 (word_i[119:112], sbox_o[119:112]); 
	S_Box sbox_e2 (word_i[111:104], sbox_o[111:104]); 
	S_Box sbox_e3 (word_i[103:96],  sbox_o[103:96]);  
	S_Box sbox_e4 (word_i[95:88],  sbox_o[95:88]);   
	S_Box sbox_e5 (word_i[87:80],  sbox_o[87:80]);   
	S_Box sbox_e6 (word_i[79:72],  sbox_o[79:72]); 
	S_Box sbox_e7 (word_i[71:64],  sbox_o[71:64]);   
	S_Box sbox_e8 (word_i[63:56],  sbox_o[63:56]);  
	S_Box sbox_e9 (word_i[55:48],  sbox_o[55:48]);  
	S_Box sbox_e10(word_i[47:40],  sbox_o[47:40]);  
	S_Box sbox_e11(word_i[39:32],  sbox_o[39:32]);  
	S_Box sbox_e12(word_i[31:24],  sbox_o[31:24]);  
	S_Box sbox_e13(word_i[23:16],  sbox_o[23:16]);  
	S_Box sbox_e14(word_i[15:8],   sbox_o[15:8]);    
	S_Box sbox_e15(word_i[7:0],    sbox_o[7:0]);     

endmodule


