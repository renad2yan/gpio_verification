package wb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual wb_if) wb_vif_config;

  // Transaction type
  `include "../sv/wb_transaction.sv"

  // UVC components
  `include "../sv/wb_sequencer.sv"
  `include "../sv/wb_driver.sv"
  `include "../sv/wb_monitor.sv"
  `include "../sv/wb_agent.sv"

  // Sequences
  `include "../sv/wb_sequences.sv"

  // Environment
  `include "../sv/wb_env.sv"

endpackage : wb_pkg