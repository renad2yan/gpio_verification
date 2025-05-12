`ifndef GPIO_SCOREBOARD_SV
`define GPIO_SCOREBOARD_SV

class gpio_scoreboard extends uvm_component;
  `uvm_component_utils(gpio_scoreboard)

  uvm_tlm_analysis_fifo #(gpio_transaction) ref_fifo;
  uvm_tlm_analysis_fifo #(gpio_transaction) mon_fifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_fifo = new("ref_fifo", this);
    mon_fifo = new("mon_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    gpio_transaction ref_tx, mon_tx;

    forever begin
      ref_fifo.get(ref_tx);  // from reference model
      mon_fifo.get(mon_tx);  // from monitor

      if (!mon_tx.write_en && ref_tx.addr == mon_tx.addr) begin
        if (ref_tx.data !== mon_tx.read_data) begin
          `uvm_error("GPIO_SB", $sformatf("Mismatch at addr 0x%0h: Expected 0x%0h, Got 0x%0h",
                                          mon_tx.addr, ref_tx.data, mon_tx.read_data))
        end else begin
          `uvm_info("GPIO_SB", $sformatf("Match at addr 0x%0h: Value = 0x%0h",
                                         mon_tx.addr, mon_tx.read_data), UVM_LOW)
        end
      end
    end
  endtask
endclass

`endif