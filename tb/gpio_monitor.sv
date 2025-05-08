`ifndef GPIO_MONITOR_SV
`define GPIO_MONITOR_SV
`include "uvm_macros.svh"
import uvm_pkg::*;


class gpio_monitor extends uvm_monitor;
  `uvm_component_utils(gpio_monitor)

  virtual gpio_if vif;
  uvm_analysis_port #(gpio_transaction) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual gpio_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for gpio_monitor")
  endfunction

  task run_phase(uvm_phase phase);
    gpio_transaction tr;

    forever begin
      @(posedge vif.wb_clk_i);
      if (vif.wb_cyc_i && vif.wb_stb_i && vif.wb_ack_o) begin
        tr = gpio_transaction::type_id::create("tr", this);

        tr.addr     = vif.wb_adr_i;
        tr.sel      = vif.wb_sel_i;
        tr.write_en = vif.wb_we_i;
        tr.data     = vif.wb_dat_i;

        if (vif.wb_we_i == 0) begin
          tr.read_data = vif.wb_dat_o;
        end

        analysis_port.write(tr);
      end
    end
  endtask
endclass

`endif