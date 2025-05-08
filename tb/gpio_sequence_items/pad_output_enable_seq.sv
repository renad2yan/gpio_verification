`ifndef PAD_OUTPUT_ENABLE_SEQ_SV
`define PAD_OUTPUT_ENABLE_SEQ_SV
`include "gpio_transaction.sv"
class pad_output_enable_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(pad_output_enable_seq)

  function new(string name = "pad_output_enable_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Write GPIO_OUTPUT = all 1s
    tx = gpio_transaction::type_id::create("tx_write_output_all_ones");
    tx.addr      = 6'h04;  // GPIO_OUTPUT
    tx.data      = 32'hFFFFFFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Write GPIO_OE = 0x0000FFFF
    tx = gpio_transaction::type_id::create("tx_write_oe_half");
    tx.addr      = 6'h08;  // GPIO_OE
    tx.data      = 32'h0000FFFF;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 3: Scoreboard أو monitor يتأكد إن بس أول 16 بت هم اللي طالعين على الـ pad
  endtask
endclass
`endif