// This module is a wrapper based on the idea of implementation AXI handshake to the AES IP.
// The wrapper, however, was wrote to understand the handshake of this protocol.
// Not to fully implement any AXI bus protocol.

module AESv3(
  input   logic clk,
  input   logic rst,

  // to the producer, about key
  output  logic key_ready,
  input   logic key_valid,
  input   logic [127:0] key_data,

  // to the producer, about data_in
  output  logic data_ready,
  input   logic data_valid,
  input   logic [127:0] data_in,

  // to the consumer, about data_out
  input   logic data_out_ready,
  output  logic data_out_valid,
  output  logic [127:0] data_out

);
  logic [127:0] key_data_reg, data_in_reg;
  wire [127:0] data_out_wire;
  logic [127:0] data_out_reg;
  logic core_enable, core_done;

  logic key_loaded;

  typedef enum logic [2:0] {
    IDLE,
    WAIT_KEY,
    WAIT_DATA,
    EXECUTING,
    WAIT_CONSUMER
  } state_t;
  state_t state, next_state;

  AESv2 AEScore(
    .clk(clk),
    .reset(rst),
    .AES_en(core_enable),
    .in(data_in_reg),
    .key(key_data_reg),
    .done(core_done),
    .dataOut(data_out_wire)
  );
  // block about key

  always_ff@(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      key_loaded <= 1'b0;
    end else begin
      state <= next_state;
      if (key_valid && key_ready) begin
        key_data_reg <= key_data;
        key_loaded <= 1'b1;
      end
      if (data_valid && data_ready) begin
        data_in_reg <= data_in;
      end
      if (state == EXECUTING && core_done) begin
        data_out_reg <= data_out_wire;
      end
    end
  end

  always_comb begin
    next_state = state;
    key_ready = 1'b0;
    data_ready = 1'b0;
    data_out_valid = 1'b0;
    core_enable = 1'b0;

    case (state)
      IDLE: begin
        if (!key_loaded) next_state = WAIT_KEY;
        else next_state = WAIT_DATA;
      end
      WAIT_KEY: begin
        key_ready = 1'b1;
        if (key_ready && key_valid) next_state = WAIT_DATA;
      end
      WAIT_DATA: begin
        data_ready = 1'b1;
        if (data_ready && data_valid) next_state = EXECUTING;
      end
      EXECUTING: begin
        core_enable = 1'b1; // notice here
        if (core_done) next_state = WAIT_CONSUMER;
      end
      WAIT_CONSUMER: begin
        data_out_valid = 1'b1;
        if (data_out_ready) begin
          next_state = WAIT_DATA;
        end
      end
      default:
        next_state = state;
    endcase
  end

  assign data_out = data_out_reg;

endmodule
