`ifndef GPIO_SEQUENCE_SV
`define GPIO_SEQUENCE_SV
`include "uvm_macros.svh"
import uvm_pkg::*;
import gpio_pkg::*;
//`include "gpio_transaction.sv"
`include "gpio_reset_seq.sv"
`include "gpio_input_config_seq.sv"
`include "gpio_output_write_seq.sv"
`include "gpio_input_read_seq.sv"
`include "gpio_direction_control_seq.sv"
`include "gpio_output_override_seq.sv"
`include "alt_func_mode_seq.sv"
`include "mixed_mode_output_seq.sv"
`include "pad_sampling_seq.sv"
`include "pad_output_enable_seq.sv"
`include "io_select_reset_seq.sv"
`include "full_register_access_seq.sv"
`include "random_output_toggle_seq.sv"
`include "byte_selective_write_seq.sv"
`include "interrupt_blocked_seq.sv"
class gpio_sequence extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_sequence)
  function new(string name = "gpio_sequence");
    super.new(name);
  endfunction
  task body();
    gpio_reset_seq               seq1  = gpio_reset_seq::type_id::create("seq1");
    gpio_input_config_seq        seq2  = gpio_input_config_seq::type_id::create("seq2");
    gpio_output_write_seq        seq3  = gpio_output_write_seq::type_id::create("seq3");
    gpio_input_read_seq          seq4  = gpio_input_read_seq::type_id::create("seq4");
    gpio_direction_control_seq   seq5  = gpio_direction_control_seq::type_id::create("seq5");
    gpio_output_override_seq     seq6  = gpio_output_override_seq::type_id::create("seq6");
    alt_func_mode_seq            seq7  = alt_func_mode_seq::type_id::create("seq7");
    mixed_mode_output_seq        seq8  = mixed_mode_output_seq::type_id::create("seq8");
    pad_sampling_seq             seq9  = pad_sampling_seq::type_id::create("seq9");
    pad_output_enable_seq        seq10 = pad_output_enable_seq::type_id::create("seq10");
    io_select_reset_seq          seq11 = io_select_reset_seq::type_id::create("seq11");
    full_register_access_seq     seq12 = full_register_access_seq::type_id::create("seq12");
    random_output_toggle_seq     seq13 = random_output_toggle_seq::type_id::create("seq13");
    byte_selective_write_seq     seq14 = byte_selective_write_seq::type_id::create("seq14");
    interrupt_blocked_seq        seq15 = interrupt_blocked_seq::type_id::create("seq15");

    start_item(seq1);  finish_item(seq1);
    start_item(seq2);  finish_item(seq2);
    start_item(seq3);  finish_item(seq3);
    start_item(seq4);  finish_item(seq4);
    start_item(seq5);  finish_item(seq5);
    start_item(seq6);  finish_item(seq6);
    start_item(seq7);  finish_item(seq7);
    start_item(seq8);  finish_item(seq8);
    start_item(seq9);  finish_item(seq9);
    start_item(seq10); finish_item(seq10);
    start_item(seq11); finish_item(seq11);
    start_item(seq12); finish_item(seq12);
    start_item(seq13); finish_item(seq13);
    start_item(seq14); finish_item(seq14);
    start_item(seq15); finish_item(seq15);
  endtask
endclass

`endif