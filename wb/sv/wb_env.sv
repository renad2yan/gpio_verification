class wb_env extends uvm_env;

  // Components of the environment
  wb_driver       wb_bfm;
  wb_monitor      wb_mon;
  wb_scoreboard   sb;
  wb_ref_model    ref;

  `uvm_component_utils(wb_env)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wb_bfm  = wb_driver::type_id::create("wb_bfm", this);
    wb_mon  = wb_monitor::type_id::create("wb_mon", this);
    sb      = wb_scoreboard::type_id::create("sb", this);
    ref     = wb_ref_model::type_id::create("ref", this);
  endfunction : build_phase

  // Connect Phase
  function void connect_phase(uvm_phase phase);
    wb_mon.analysis_port.connect(sb.analysis_export);
    wb_mon.analysis_port.connect(ref.analysis_export);
    ref.out_port.connect(sb.analysis_export);
  endfunction : connect_phase

endclass : wb_env

