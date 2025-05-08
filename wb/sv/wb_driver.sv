class wb_driver extends uvm_driver #(wb_transaction);

  // Virtual interface to communicate with DUT
  virtual wb_if vif;

  // Agent ID (used instead of "master_id" لتوحيد التسمية)
  int agent_id;

  `uvm_component_utils_begin(wb_driver)
    `uvm_field_int(agent_id, UVM_DEFAULT)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), req.sprint(), UVM_MEDIUM)
      vif.send_to_dut(req);

      seq_item_port.item_done();
    end
  endtask

endclass