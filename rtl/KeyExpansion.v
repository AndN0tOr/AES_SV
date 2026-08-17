	module KeyExpansion (
		input [127:0] prev_key,
		input [3:0] round_num,
		output [127:0] round_key
		);
		wire [127:0] round_key_temp;
		// temp = w[i-1]
		wire [31:0] rotated_word, subedword, rc;
		reg [7:0] rcon;
		// RotWord(temp)
		
		assign rotated_word = {prev_key[23:0], prev_key[31:24]};

		// SubWord(RotWord(temp))
		S_Box sw1(rotated_word[31:24],subedword[31:24]); 
		S_Box sw2(rotated_word[23:16],subedword[23:16]); 
		S_Box sw3(rotated_word[15:8],subedword[15:8]); 
		S_Box sw4(rotated_word[7:0],subedword[7:0]); 
		
		// Rcon(i / 4)
		always @(*) 
			case(round_num)	
			 4'h1: rcon=8'h01;
			 4'h2: rcon=8'h02;
			 4'h3: rcon=8'h04;
			 4'h4: rcon=8'h08;
			 4'h5: rcon=8'h10; //16
			 4'h6: rcon=8'h20; //32
			 4'h7: rcon=8'h40; //64
			 4'h8: rcon=8'h80; //128
			 4'h9: rcon=8'h1b; //256 chua hieu, can tim hieu them
			 4'ha: rcon=8'h36; //432 
			 default: rcon=8'h00;
		endcase
		assign rc[31:24] = rcon;
		assign rc[23:0] = 24'b0;
		// 1st word
		// w = subword(rotWord(w[i-1]))
		assign round_key_temp[127:96] = subedword ^ rc ^ prev_key[127:96];
		// 2nd word
		assign round_key_temp[95:64] = prev_key[95:64] ^ round_key[127:96];
		assign round_key_temp[63:32] = prev_key[63:32] ^ round_key[95:64];
		assign round_key_temp[31:0] = prev_key[31:0] ^ round_key[63:32];
		assign round_key = (round_num == 4'h0) ? prev_key : round_key_temp; 
	endmodule
