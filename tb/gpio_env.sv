
`ifndef GPIO_ENV_SV
`define GPIO_ENV_SV
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_env extends uvm_env;
  `uvm_component_utils(gpio_env)

  gpio_agent        agt;
  gpio_scoreboard   sb;
  gpio_ref_model    rm;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = gpio_agent::type_id::create("agt", this);
    sb  = gpio_scoreboard::type_id::create("sb", this);
    rm  = gpio_ref_model::type_id::create("rm", this);

    uvm_config_db#(uvm_active_passive_enum)::set(this, "agt", "is_active", UVM_ACTIVE);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // توصيل monitor مع reference model
    agt.mon.analysis_port.connect(rm.analysis_export);

    // توصيل reference model مع scoreboard
    rm.out_port.connect(sb.analysis_export);
  endfunction
endclass
`endif