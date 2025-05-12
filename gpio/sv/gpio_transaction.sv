`ifndef GPIO_TRANSACTION_SV
`define GPIO_TRANSACTION_SV
import uvm_pkg::*;
`include "uvm_macros.svh"
class gpio_transaction extends uvm_sequence_item;
  // Transaction fields
  rand bit [5:0]  addr;
  rand bit [31:0] data;
  rand bit [3:0]  sel;
  rand bit        write_en;

  bit [31:0] read_data;  // filled by monitor or driver (if read)

  // Macros for factory and printing
  `uvm_object_utils(gpio_transaction)

  function new(string name = "gpio_transaction");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("addr", addr, 6);
    printer.print_field_int("data", data, 32);
    printer.print_field_int("sel", sel, 4);
    printer.print_field_int("write_en", write_en, 1);
    printer.print_field_int("read_data", read_data, 32);
  endfunction
endclass
`endif