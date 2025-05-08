class wb_monitor extends uvm_monitor;

  // Virtual interface to communicate with DUT
  virtual wb_if vif;

  // Agent ID (for logging or distinction if needed)
  int agent_id;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port #(wb_transaction) item_collected_port;

  // Transaction object to collect data into
  wb_transaction tr_collect;

  `uvm_component_utils_begin(wb_monitor)
    `uvm_field_int(agent_id, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction

  virtual task run_phase(uvm_phase phase);
    @(negedge vif.clk);
    forever begin 
      tr_collect = wb_transaction::type_id::create("tr_collect");

      wait (vif.stb && vif.cyc);
      collect();

      `uvm_info(get_type_name(), $sformatf("Collected transaction:\n%s", tr_collect.sprint()), UVM_HIGH)
      item_collected_port.write(tr_collect);
    end
  endtask

  // Collect transaction from interface signals
  task collect();
    wait(vif.ack);
    @(negedge vif.clk);
    tr_collect.op_type   = vif.we ? wb_write : wb_read;
    tr_collect.addr      = vif.addr[2:0]; // Adjust if GPIO uses fewer bits
    tr_collect.din       = vif.din;
    tr_collect.dout      = vif.dout;
    tr_collect.valid_sb  = vif.valid_sb;
    wait(!vif.ack);
  endtask

endclass
class wb_monitor extends uvm_monitor;

  // Virtual interface to communicate with DUT
  virtual wb_if vif;

  // Agent ID (for logging or distinction if needed)
  int agent_id;

  // Analysis port to send collected transactions to scoreboard
  uvm_analysis_port #(wb_transaction) item_collected_port;

  // Transaction object to collect data into
  wb_transaction tr_collect;

  `uvm_component_utils_begin(wb_monitor)
    `uvm_field_int(agent_id, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction

  virtual task run_phase(uvm_phase phase);
    @(negedge vif.clk);
    forever begin 
      tr_collect = wb_transaction::type_id::create("tr_collect");

      wait (vif.stb && vif.cyc);
      collect();

      `uvm_info(get_type_name(), $sformatf("Collected transaction:\n%s", tr_collect.sprint()), UVM_HIGH)
      item_collected_port.write(tr_collect);
    end
  endtask

  // Collect transaction from interface signals
  task collect();
    wait(vif.ack);
    @(negedge vif.clk);
    tr_collect.op_type   = vif.we ? wb_write : wb_read;
    tr_collect.addr      = vif.addr[2:0]; // Adjust if GPIO uses fewer bits
    tr_collect.din       = vif.din;
    tr_collect.dout      = vif.dout;
    tr_collect.valid_sb  = vif.valid_sb;
    wait(!vif.ack);
  endtask

endclass