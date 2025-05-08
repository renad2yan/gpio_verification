`ifndef MIXED_MODE_OUTPUT_SEQ_SV 
`define MIXED_MODE_OUTPUT_SEQ_SV
`include "gpio_transaction.sv"
class mixed_mode_output_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(mixed_mode_output_seq)

  function new(string name = "mixed_mode_output_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set IO_SELECT to mix GPIO and peripheral
    tx = gpio_transaction::type_id::create("tx_io_select_mix");
    tx.addr      = 6'h0C;  // IO_SELECT
    tx.data      = 32'h0000FFFF;  // lower 16 pins peripheral, upper 16 GPIO
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Enable GPIO_OE
    tx = gpio_transaction::type_id::create("tx_gpio_oe");
    tx.addr      = 6'h04;  // GPIO_OE
    tx.data      = 32'hFFFFFFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 3: Peripheral signal is driven externally on lower 16 pins
    // (Assumed from testbench/driver)

    // Step 4: Scoreboard or monitor should check the expected routing on each pin
  endtask
endclass
`endif