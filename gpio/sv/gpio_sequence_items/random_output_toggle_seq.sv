`ifndef RANDOM_OUTPUT_TOGGLE_SEQ_SV
`define RANDOM_OUTPUT_TOGGLE_SEQ_SV
`include "gpio_transaction.sv"
class random_output_toggle_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(random_output_toggle_seq)

  function new(string name = "random_output_toggle_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Enable GPIO_OE
    tx = gpio_transaction::type_id::create("enable_gpio_oe");
    tx.addr = 6'h08; // OE address
    tx.data = 32'hFFFFFFFF;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Write random patterns multiple times to OUTPUT
    for (int i = 0; i < 10; i++) begin
      tx = gpio_transaction::type_id::create($sformatf("rand_output_%0d", i));
      tx.addr = 6'h04; // OUTPUT address
      void'(std::randomize(tx.data));
      tx.sel  = 4'hF;
      tx.write_en = 1;
      start_item(tx); finish_item(tx);
      #10ns; // small delay to observe toggling
    end
  endtask
endclass
`endif