`ifndef GPIO_OUTPUT_OVERRIDE_SEQ_SV
`define GPIO_OUTPUT_OVERRIDE_SEQ_SV
`include "gpio_transaction.sv"
class gpio_output_override_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_output_override_seq)

  function new(string name = "gpio_output_override_seq");
    super.new(name);
  endfunction
  task body();
    gpio_transaction tx;

    // Step 1: Write pattern to GPIO_OUTPUT
    tx = gpio_transaction::type_id::create("tx_output");
    tx.addr      = 6'h04;  // GPIO_OUTPUT
    tx.data      = 32'hAAAAAAAA;  // test pattern
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Enable GPIO_OE = all ones
    tx = gpio_transaction::type_id::create("tx_oe_enable");
    tx.addr      = 6'h08;  // GPIO_OE
    tx.data      = 32'hFFFFFFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 3: Toggle IO_SELECT = 1 (set override)
    tx = gpio_transaction::type_id::create("tx_select_override");
    tx.addr      = 6'h0C;  // IO_SELECT
    tx.data      = 32'hFFFFFFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);   
  endtask
endclass
`endif