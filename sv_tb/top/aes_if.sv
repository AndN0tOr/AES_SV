// Defining interface for AES_DUT

interface aes_if(
  input logic clk,
  input logic rst
);
  logic key_valid;
  logic key_ready;
  logic [127:0] key_data;

  logic data_in_valid;
  logic data_in_ready;
  logic [127:0] data_in;

  logic data_out_valid;
  logic data_out_ready
  logic [127:0] data_out;
  
  clocking drv_cb (@posedge clk);
    default input #1step output 1ns;

    input key_ready
    input data_in_ready;

    output key_valid;
    output key_data;

    output data_in_valid;
    output data_in;

    output data_out_ready;

  endclocking

  clocking mon_cb (@posedge clk);
    default input #1step;

    input key_data, key_valid, key_ready;
    input data_in_valid, data_in_ready, data_in;
    input data_out_valid, data_out_ready, data_out;

  endclocking

  modport driver (clocking drv_cb, input clk, input rst);
  modport monitor (clocking mon_cb, input clk, input rst);

  modport DUT (
    input clk, rst,
    input key_valid, key_data, data_in_valid, data_in, data_out_ready,
    output key_ready, data_in_ready, data_out_valid, data_out;
  )

endinterface
