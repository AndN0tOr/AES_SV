module AES(
	input CLOCK_50,
	input [0:0] KEY
);
  system IPAES128 (.clk_clk(CLOCK_50), .reset_reset_n(KEY));
endmodule 