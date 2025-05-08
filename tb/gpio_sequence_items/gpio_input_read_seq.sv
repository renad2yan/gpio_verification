`ifndef GPIO_INPUT_READ_SEQ_SV
`define GPIO_INPUT_READ_SEQ_SV
`include "gpio_transaction.sv"
class gpio_input_read_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_input_read_seq)

  function new(string name = "gpio_input_read_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set GPIO_OE = 0 (all pins input)
    tx = gpio_transaction::type_id::create("tx_oe");
    tx.addr      = 6'h08;  // GPIO_OE
    tx.data      = 32'h00000000;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Drive external value on i_gpio (handled via interface or testbench signal, not part of transaction)

    // Step 3: Read GPIO_INPUT
    tx = gpio_transaction::type_id::create("tx_input_read");
    tx.addr      = 6'h00;  // GPIO_INPUT address
    tx.sel       = 4'hF;
    tx.write_en  = 0;      // read
    start_item(tx); finish_item(tx);

    
  endtask
endclass
`endif