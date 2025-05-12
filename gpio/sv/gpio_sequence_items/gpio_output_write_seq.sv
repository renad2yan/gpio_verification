`ifndef GPIO_OUTPUT_WRITE_SEQ_SV
`define GPIO_OUTPUT_WRITE_SEQ_SV
`include "gpio_transaction.sv"
class gpio_output_write_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_output_write_seq)

  function new(string name = "gpio_output_write_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set GPIO_OE = all 1s
    tx = gpio_transaction::type_id::create("tx_oe");
    tx.addr      = 6'h08;  // GPIO_OE address
    tx.data      = 32'hFFFFFFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Write known pattern to GPIO_OUTPUT
    tx = gpio_transaction::type_id::create("tx_out");
    tx.addr      = 6'h04;  // GPIO_OUTPUT address
    tx.data      = 32'hA5A5A5A5;  // known pattern
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

  endtask
endclass
`endif