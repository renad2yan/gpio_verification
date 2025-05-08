`ifndef GPIO_DRIVER_SV
`define GPIO_DRIVER_SV
`include "uvm_macros.svh"
`include "gpio_transaction.sv"
import uvm_pkg::*;
import gpio_pkg::*;
class gpio_driver extends uvm_driver #(gpio_transaction);
  `uvm_component_utils(gpio_driver)

  virtual gpio_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual gpio_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for gpio_driver")
  endfunction

  task run_phase(uvm_phase phase);
    gpio_transaction tr;
    forever begin
      seq_item_port.get_next_item(tr);

      vif.wb_adr_i = tr.addr;
      vif.wb_dat_i = tr.data;
      vif.wb_sel_i = tr.sel;
      vif.wb_we_i  = tr.write_en;
      vif.wb_stb_i = 1;
      vif.wb_cyc_i = 1;

      @(posedge vif.wb_clk_i);
      wait(vif.wb_ack_o == 1);

      if (tr.write_en == 0)
        tr.read_data = vif.wb_dat_o;

      vif.wb_stb_i = 0;
      vif.wb_cyc_i = 0;

      seq_item_port.item_done();
    end
  endtask

endclass

`endif