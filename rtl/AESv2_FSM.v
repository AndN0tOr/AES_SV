module AESv2_FSM(
  input reset, clk,
  input AES_en,
  //output clk_round,
  output out_done,
  output [3:0] round_numb,
  output isR1,
  output SB_skip, SR_skip, MXC_skip
  // for debug
//  output reg [3:0] next_round,
//  output reg [1:0] round_step,
//  output reg [1:0] next_round_step
);
  reg [3:0] round;
  reg [3:0] next_round;
  reg round_step, next_round_step;
  // Round parameters
  localparam round0 = 4'h0;
  localparam round1 = 4'h1;
  localparam round2 = 4'h2;
  localparam round3 = 4'h3;
  localparam round4 = 4'h4;
  localparam round5 = 4'h5;
  localparam round6 = 4'h6;
  localparam round7 = 4'h7;
  localparam round8 = 4'h8;
  localparam round9 = 4'h9;
  localparam round10 = 4'ha;
  
  // Step parameters
  localparam step0 = 1'd0;
  localparam step1 = 1'd1;
  
  // Round step state machine
  always @(*)
  begin
    case (round_step)
      step0: 
        if (round == 4'b0 && AES_en == 1'b1) 
          next_round_step = step1;
        else 
          next_round_step = step0;
      step1:
        next_round_step = step0;
      default: next_round_step = step0;
    endcase
  end
  
  always @(negedge clk or posedge reset)
  begin
    if (reset)
      round_step <= step0;
    else
      round_step <= next_round_step;
  end
  
  // Round number state machine
  always @(*)
  begin
    // Default assignment to prevent latch inference
    next_round = round;
    
    if (round_step == step1 || (round > round0 && round <= round10)) begin
      case (round)
        round0: next_round = round1;
        round1: next_round = round2;
        round2: next_round = round3;
        round3: next_round = round4;
        round4: next_round = round5;
        round5: next_round = round6;
        round6: next_round = round7;
        round7: next_round = round8;
        round8: next_round = round9;
        round9: next_round = round10;
        round10: next_round = round0;
        default: next_round = round0;
      endcase
    end
  end
  
  always @(negedge clk or posedge reset)
  begin
    if (reset)
      round <= round0;
    else
      round <= next_round;
  end
  
  // Output assignments
  // assign clk_round = (round_step == step2 || round_step == step3) ? 1'b1 : 1'b0;
  assign out_done = (round == round10) ? 1'b1 : 1'b0;
  assign round_numb = round;
  
  // Register write enable signals
  assign isR1 = (round == round0 && round_step == step0) ? 1'b0 : 1'b1;
  assign SB_skip = (round == round0) ? 1'b1 : 1'b0;
  assign SR_skip = (round == round0) ? 1'b1 : 1'b0;
  assign MXC_skip = (round == round10 || round == round0) ? 1'b1 : 1'b0;
endmodule