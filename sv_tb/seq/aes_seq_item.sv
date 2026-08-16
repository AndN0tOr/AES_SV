import uvm_pkg::*;
`include "uvm_macros.svh"
class aes_seq_item extends uvm_sequence_item;
  typedef enum {
    TYPE_KEY, 
    TYPE_DATA
    } pkt_type_e;
  pkt_type_e packet_type;

  rand bit [127:0] key_data;
  rand bit [127:0] data_in;

  bit [127:0] data_out_rtl;
  bit [127:0] data_out_ref;

  `uvm_object_utils_begin(aes_seq_item)
    `uvm_field_enum(pkt_type_e, packet_type, UVM_ALL_ON)
    `uvm_field_int(key_data, UVM_ALL_ON)
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(data_out_rtl, UVM_ALL_ON)
    `uvm_field_int(data_out_ref, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "aes_seq_item");
    super.new(name);
  endfunction

endclass