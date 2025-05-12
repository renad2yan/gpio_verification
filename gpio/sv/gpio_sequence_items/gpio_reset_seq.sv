`ifndef GPIO_RESET_SEQ_SV
`define GPIO_RESET_SEQ_SV
`include "gpio_transaction.sv"
class gpio_reset_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_reset_seq)

  function new(string name = "gpio_reset_seq");
    super.new(name);
  endfunction

  virtual task body();
    gpio_transaction tx;

    //  Reset delay 
    `uvm_info("GPIO_RESET_SEQ", "Waiting for reset to propagate...", UVM_MEDIUM)
    #50ns;

    // Read GPIO_OUTPUT
    tx = gpio_transaction::type_id::create("read_gpio_output", this);
    tx.addr     = 6'h04;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

    //  Read GPIO_OE
    tx = gpio_transaction::type_id::create("read_gpio_oe", this);
    tx.addr     = 6'h08;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

    // Read IO_SELECT
    tx = gpio_transaction::type_id::create("read_io_select", this);
    tx.addr     = 6'h0C;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

   

  endtask
endclass
`endif