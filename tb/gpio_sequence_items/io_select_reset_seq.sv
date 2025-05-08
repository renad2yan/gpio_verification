`ifndef IO_SELECT_RESET_SEQ_SV
`define IO_SELECT_RESET_SEQ_SV
`include "gpio_transaction.sv"
class io_select_reset_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(io_select_reset_seq)

  function new(string name = "io_select_reset_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction tx;

    // Step 1: Write non-zero to IO_SELECT
    tx = gpio_transaction::type_id::create("tx_write_nonzero_io_select");
    tx.addr      = 6'h0C;  // IO_SELECT
    tx.data      = 32'hA5A5A5A5;
    tx.sel       = 4'hF;
    tx.write_en  = 1;
    start_item(tx); finish_item(tx);

    // Step 2: Apply reset - تعتمد على بيئة الـ testbench
    // إما عن طريق كتابة إلى واجهة الـ reset، أو انتظار assert
    // في العادة هذه الخطوة تتم من التست وليس السيكونس، فممكن تتخزن كملاحظة.

    // Step 3: Read IO_SELECT
    tx = gpio_transaction::type_id::create("tx_read_io_select");
    tx.addr      = 6'h0C;
    tx.sel       = 4'hF;
    tx.write_en  = 0;
    start_item(tx); finish_item(tx);

    // Step 4: التحقق يتم في الـ scoreboard: القيمة يجب أن تكون 0
  endtask
endclass
`endif
