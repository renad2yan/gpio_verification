class wb_sequencer extends uvm_sequencer #(wb_transaction);

 
  int agent_id;

  `uvm_component_utils_begin(wb_sequencer)
    `uvm_field_int(agent_id, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
