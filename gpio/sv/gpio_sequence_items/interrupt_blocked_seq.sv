`ifndef INTERRUPT_BLOCKED_SEQ_SV
`define INTERRUPT_BLOCKED_SEQ_SV
`include "gpio_transaction.sv"
class interrupt_blocked_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(interrupt_blocked_seq)

  function new(string name = "interrupt_blocked_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Set IO_SELECT = 1 
    tx = gpio_transaction::type_id::create("set_io_select");
    tx.addr = 6'h28; // IO_SELECT address
    tx.data = 32'hFFFFFFFF; // all pins to peripheral mode
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    //Attempt to enable interrupt logic
    tx = gpio_transaction::type_id::create("enable_interrupt");
    tx.addr = 6'h30; // assuming interrupt enable register
    tx.data = 32'h1; // enable first bit
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    //Simulate trigger edge
    tx = gpio_transaction::type_id::create("trigger_edge");
    tx.addr = 6'h00; 
    tx.data = 32'h1;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);
  endtask
endclass
`endif