
`ifndef GPIO_AGENT_SV
`define GPIO_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "gpio_driver.sv"
class gpio_agent extends uvm_agent;
  `uvm_component_utils(gpio_agent)

  gpio_driver     drv;
  gpio_sequencer  seqr;
  gpio_monitor    mon;

  virtual gpio_if vif;
  uvm_active_passive_enum is_active;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get agent mode
    if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
      `uvm_fatal("AGENT", "is_active not set")

    // Get virtual interface
    if (!uvm_config_db#(virtual gpio_if)::get(this, "", "vif", vif))
      `uvm_fatal("AGENT", "Virtual interface not set for gpio_agent")

    // Always create monitor
    mon = gpio_monitor::type_id::create("mon", this);
    mon.vif = vif;

    if (is_active == UVM_ACTIVE) begin
      drv  = gpio_driver::type_id::create("drv", this);
      seqr = gpio_sequencer::type_id::create("seqr", this);

      drv.vif  = vif;
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass

`endif