class wb_agent extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id;

  wb_monitor   monitor;
  wb_driver    driver;
  wb_sequencer sequencer;

  `uvm_component_utils_begin(wb_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = wb_monitor::type_id::create("monitor", this);
    if (is_active == UVM_ACTIVE) begin
      sequencer = wb_sequencer::type_id::create("sequencer", this);
      driver    = wb_driver::type_id::create("driver", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

  function void set_agent_id(int i);
    monitor.agent_id = i;
    if (is_active == UVM_ACTIVE) begin
      sequencer.agent_id = i;
      driver.agent_id    = i;
    end
  endfunction

endclass