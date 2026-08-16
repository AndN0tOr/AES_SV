import uvm_pkg::*;
`include "uvm_macros.svh"
`include "aes_seq_item.sv"

class aes_sequence extends uvm_sequence #(aes_seq_item);
  `uvm_object_utils(aes_sequence)

  function new (string name = "aes_sequence");
    super.new(name);
  endfunction

  virtual task body();
    begin
      aes_seq_item req;
      req = aes_seq_item::type_id::create("req");

      // Send KEY 1 time
      start_item(req);
      if (!req.randomize() with { packet_type == TYPE_KEY; }) begin
      `uvm_fatal("SEQ", "Randomization failed for Key Packet!")
      end
      finish_item(req);

      // Send DATA 10 times
      for (int i = 0; i < 10; i = i + 1) begin
        req = aes_seq_item::type_id::create("req");
        start_item(req);
        if (!req.randomize() with { packet_type == TYPE_DATA; }) begin
        `uvm_fatal("SEQ", "Randomization failed for Data Packet!")
        end
        finish_item(req);
      end 

    end 
  endtask

endclass