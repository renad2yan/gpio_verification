`ifndef GPIO_TEST_SV
`define GPIO_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;


class gpio_test extends uvm_test;
  `uvm_component_utils(gpio_test)

  gpio_env env;

  function new(string name = "gpio_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = gpio_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    gpio_sequence seq;
    string seq_name;

    phase.raise_objection(this);

    // Use default sequence if not provided
    if (!uvm_config_db#(string)::get(this, "", "seq_name", seq_name))
      seq_name = "gpio_sequence";

    `uvm_info("GPIO_TEST", $sformatf("Running sequence: %s", seq_name), UVM_LOW)

    seq = gpio_sequence::type_id::create(seq_name);
    seq.start(env.agt.seqr);

    phase.drop_objection(this);
  endtask

endclass

`endif