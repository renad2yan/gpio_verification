`ifndef BYTE_SELECTIVE_WRITE_SEQ_SV
`define BYTE_SELECTIVE_WRITE_SEQ_SV
`include "gpio_transaction.sv"
class byte_selective_write_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(byte_selective_write_seq)

  function new(string name = "byte_selective_write_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Write full word to GPIO_OUTPUT
    tx = gpio_transaction::type_id::create("full_write");
    tx.addr = 6'h04; // GPIO_OUTPUT address
    tx.data = 32'hAABBCCDD;
    tx.sel  = 4'hF;
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Masked byte write (e.g., only byte 1)
    tx = gpio_transaction::type_id::create("byte_masked_write");
    tx.addr = 6'h04;
    tx.data = 32'h00EE0000; // modify only 2nd byte (byte 1)
    tx.sel  = 4'b0010; // enable only byte 1
    tx.write_en = 1;
    start_item(tx); finish_item(tx);

    // Step 3: Read back and verify
    tx = gpio_transaction::type_id::create("read_back");
    tx.addr = 6'h04;
    tx.write_en = 0;
    tx.sel = 4'hF;
    start_item(tx); finish_item(tx);
  endtask
endclass
`endif