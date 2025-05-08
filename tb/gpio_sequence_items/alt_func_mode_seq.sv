`ifndef ALT_FUNC_MODE_SEQ_SV
`define ALT_FUNC_MODE_SEQ_SV
`include "gpio_transaction.sv"
class alt_func_mode_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(alt_func_mode_seq)

  function new(string name = "alt_func_mode_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set IO_SELECT[n] = 1
    tx = gpio_transaction::type_id::create("tx_io_select");
    tx.addr      = 6'h0C;  // IO_SELECT
    tx.data      = 32'h00000001;  // enable peripheral on pin 0
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Disable GPIO_OE
    tx = gpio_transaction::type_id::create("tx_oe_disable");
    tx.addr      = 6'h04;  // GPIO_OE
    tx.data      = 32'h00000000;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 3: Peripheral signal driven externally (assumed handled by testbench/pad model)
    // You can optionally wait here if needed using `#delay` or synchronization

    // Step 4: Scoreboard/monitor should check if correct signal appears on pads
  endtask
endclass
`endif