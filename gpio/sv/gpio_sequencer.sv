`ifndef GPIO_SEQUENCER_SV
`define GPIO_SEQUENCER_SV
`include "gpio_transaction.sv"
import gpio_pkg::*;
`include "uvm_macros.svh"
class gpio_sequencer extends uvm_sequencer #(gpio_transaction);
  `uvm_component_utils(gpio_sequencer)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
`endif 