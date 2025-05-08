`ifndef PAD_SAMPLING_SEQ_SV
`define PAD_SAMPLING_SEQ_SV
`include "gpio_transaction.sv"
class pad_sampling_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(pad_sampling_seq)

  function new(string name = "pad_sampling_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Set IO_SELECT = 0
    tx = gpio_transaction::type_id::create("tx_io_select_zero");
    tx.addr      = 6'h0C;  // IO_SELECT
    tx.data      = 32'h00000000;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Set GPIO_OE = 0 (input mode)
    tx = gpio_transaction::type_id::create("tx_gpio_oe_input");
    tx.addr      = 6'h04;  // GPIO_OE
    tx.data      = 32'h00000000;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: External stimulus will drive i_gpio (done outside DUT, in testbench or driver)

    // Step 3: Read from GPIO_INPUT
    tx = gpio_transaction::type_id::create("tx_read_input");
    tx.addr      = 6'h00;  // GPIO_INPUT
    tx.sel       = 4'hF;
    tx.write_en  = 0;
    start_item(tx); finish_item(tx);

    // Step 4: Scoreboard will compare expected vs read value
  endtask
endclass
`endif