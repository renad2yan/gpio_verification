class gpio_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(gpio_scoreboard)
  // Analysis ports
  uvm_analysis_imp #(gpio_transaction, gpio_scoreboard) mon_ap;
  uvm_analysis_imp #(gpio_transaction, gpio_scoreboard) ref_ap;
  // FIFOs for transactions
  mailbox #(gpio_transaction) mon_fifo;
  mailbox #(gpio_transaction) ref_fifo;
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
    ref_ap = new("ref_ap", this);
    mon_fifo = new();
    ref_fifo = new();
  endfunction
  // Write functions
  function void write(input gpio_transaction t);
    mon_fifo.put(t);
  endfunction
  function void write_ref(input gpio_transaction t);
    ref_fifo.put(t);
  endfunction
  // Run phase
  task run_phase(uvm_phase phase);
    gpio_transaction mon_tx, ref_tx;
    forever begin
      mon_fifo.get(mon_tx);
      ref_fifo.get(ref_tx);
      if (!ref_tx.has_expected) begin
        `uvm_info("GPIO_SB", $sformatf("Monitor TX (no expected data): %s", mon_tx.sprint()), UVM_MEDIUM)
        continue;
      end
      if (mon_tx.data === ref_tx.expected_data) begin
        `uvm_info("GPIO_SB", $sformatf("MATCH at addr 0x%0h: actual=0x%0h, expected=0x%0h",
          mon_tx.addr, mon_tx.data, ref_tx.expected_data), UVM_HIGH)
      end else begin
        `uvm_error("GPIO_SB", $sformatf("MISMATCH at addr 0x%0h: actual=0x%0h, expected=0x%0h",
          mon_tx.addr, mon_tx.data, ref_tx.expected_data))
      end
    end
  endtask

endclass