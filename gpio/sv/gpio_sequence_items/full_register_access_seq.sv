`ifndef FULL_REGISTER_ACCESS_SEQ_SV
`define FULL_REGISTER_ACCESS_SEQ_SV
`include "gpio_transaction.sv"
class full_register_access_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(full_register_access_seq)

  function new(string name = "full_register_access_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Write unique value to OUTPUT (0x04)
    tx = gpio_transaction::type_id::create("write_output");
    tx.addr = 6'h04;
    tx.data = 32'h11111111;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Write unique value to OE (0x08)
    tx = gpio_transaction::type_id::create("write_oe");
    tx.addr = 6'h08;
    tx.data = 32'h22222222;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Write unique value to IO_SELECT (0x0C)
    tx = gpio_transaction::type_id::create("write_io_select");
    tx.addr = 6'h0C;
    tx.data = 32'h33333333;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Read back OUTPUT
    tx = gpio_transaction::type_id::create("read_output");
    tx.addr = 6'h04;
    tx.sel  = 4'hF;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

    // Read back OE
    tx = gpio_transaction::type_id::create("read_oe");
    tx.addr = 6'h08;
    tx.sel  = 4'hF;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

    // Read back IO_SELECT
    tx = gpio_transaction::type_id::create("read_io_select");
    tx.addr = 6'h0C;
    tx.sel  = 4'hF;
    tx.write_en = 0;
    start_item(tx); finish_item(tx);

    // Optional: Byte-masked write to OUTPUT
    tx = gpio_transaction::type_id::create("byte_masked_output");
    tx.addr = 6'h04;
    tx.data = 32'hAAAA5555;
    tx.sel  = 4'b0011; // Only lower two bytes
    tx.write_en = 1;
    start_item(tx); finish_item(tx);
  endtask
endclass
`endif