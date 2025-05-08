`ifndef GPIO_DIRECTION_CONTROL_SEQ_SV
`define GPIO_DIRECTION_CONTROL_SEQ_SV
`include "gpio_transaction.sv"
class gpio_direction_control_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_direction_control_seq)

  function new(string name = "gpio_direction_control_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set GPIO_OE = 0x000000FF (LSB 8 as output)
    tx = gpio_transaction::type_id::create("tx_oe_config");
    tx.addr      = 6'h08;  // GPIO_OE
    tx.data      = 32'h000000FF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Write to GPIO_OUTPUT
    tx = gpio_transaction::type_id::create("tx_output_write");
    tx.addr      = 6'h04;  // GPIO_OUTPUT
    tx.data      = 32'hA5A5A5A5;  // any pattern
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

  endtask
endclass
`endif