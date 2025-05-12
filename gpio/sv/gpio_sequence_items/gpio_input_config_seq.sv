`ifndef GPIO_INPUT_CONFIG_SEQ_SV
`define GPIO_INPUT_CONFIG_SEQ_SV
`include "gpio_transaction.sv"
class gpio_input_config_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_input_config_seq)

  function new(string name = "gpio_input_config_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    //  Configure pins as input (OE = 0)
    tx = gpio_transaction::type_id::create("tx");
    tx.addr      = 6'h08;  // GPIO_OE address
    tx.data      = 32'h00000000;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    

    //Read GPIO_INPUT (assumed address = 0x0C)
    tx = gpio_transaction::type_id::create("tx_read_input");
    tx.addr      = 6'h0C;
    tx.write_en  = 0;  // read
    tx.sel       = 4'hF;
    start_item(tx); finish_item(tx);

    // Step 4: Scoreboard will compare actual vs expected

  endtask
endclass
`endif