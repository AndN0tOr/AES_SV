import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../seq/aes_seq_item.sv"

class aes_driver extends uvm_driver #(aes_seq_item);
  `uvm_component_utils(aes_driver);
  virtual aes_if vif;

  function new(string name = "aes_driver", uvm_component parent);
    super.new(name);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual aes_if.driver)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface has not been set for: ", get_full_name(), ".vif"})
  endfunction

    virtual task run_phase(uvm_phase phase);
      
      vif.drv_cb.key_valid <= 1'b0;
      vif.drv_cb.key_data <= 128'b0;
      vif.drv_cb.data_in <= 1'b0;
      vif.drv_cb.data_valid <= 128'b0;
      vif.drv_cb.data_out_ready = 1'b1;

      wait (vif.rst);
      forever begin
        seq_item_port.get_next_item(req);
        @(posedge vif.clk);
        case (req.packet_type)
          aes_seq_item::TYPE_KEY: begin
            vif.drv_cb.key_valid <= 1'b1;
            vif.drv_cb.key_data  <= req.key_data;

            wait(vif.drv_cb.key_ready == 1'b1);
          end
          aes_seq_item::TYPE_DATA: begin
            vif.drv_cb.data_in_valid <= 1'b1;
            vif.drv_cb.data_in <= req.data_in;

            wait(vif.drv_cb.data_ready == 1'b1);
          end
          default: begin
            vif.drv_cb.key_valid <= 1'b0;
            vif.drv_cb.data_in_valid <= 1'b0;
          end
        endcase
        @(posedge vif.clk) begin
          vif.drv_cb.key_valid <= 1'b0;
          vif.drv_cb.data_in_valid <= 1'b0;
        end
        seq_item_port.item_done();
      end
    endtask

endclass
