`ifndef GPIO_REF_MODEL_SV
`define GPIO_REF_MODEL_SV
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_ref_model extends uvm_component;
  `uvm_component_utils(gpio_ref_model)
  uvm_analysis_export #(gpio_transaction) analysis_export;
  uvm_analysis_port   #(gpio_transaction) out_port;
  // Register shadow model
  bit [31:0] gpio_output;
  bit [31:0] gpio_oe;
  bit [31:0] io_select;
  bit [31:0] interrupt_enable;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    out_port = new("out_port", this);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_output       = 32'h0;
    gpio_oe           = 32'h0;
    io_select         = 32'h0;
    interrupt_enable  = 32'h0;
  endfunction
  virtual function void write(gpio_transaction tx);
    tx.has_expected = 1;
    if (tx.write_en) begin
      case (tx.addr)
        6'h04: begin // GPIO_OUTPUT
          apply_byte_mask(gpio_output, tx.data, tx.sel);
          tx.expected_data = gpio_output;
        end
        6'h08: begin // GPIO_OE
          apply_byte_mask(gpio_oe, tx.data, tx.sel);
          tx.expected_data = gpio_oe;
        end
        6'h0C: begin // IO_SELECT
          apply_byte_mask(io_select, tx.data, tx.sel);
          tx.expected_data = io_select;
        end
        6'h30: begin // Interrupt enable register
          apply_byte_mask(interrupt_enable, tx.data, tx.sel);
          tx.expected_data = interrupt_enable;
        end
        default: begin
          tx.expected_data = 32'hDEADBEEF; 
        end
      endcase
    end else begin // READ
      case (tx.addr)
        6'h00: tx.expected_data = sample_input(io_select, gpio_oe); // GPIO_INPUT
        6'h04: tx.expected_data = gpio_output;
        6'h08: tx.expected_data = gpio_oe;
        6'h0C: tx.expected_data = io_select;
        6'h30: tx.expected_data = interrupt_enable;
        default: tx.expected_data = 32'hDEADBEEF;
      endcase
    end
    out_port.write(tx);
  endfunction
  // Return 1 for input-enabled GPIOs only
  function bit [31:0] sample_input(bit [31:0] io_sel, bit [31:0] oe);
    bit [31:0] sampled;
    for (int i = 0; i < 32; i++) begin
      if ((io_sel[i] == 0) && (oe[i] == 0))
        sampled[i] = 1'b1; // Assume external pad driving high
      else
        sampled[i] = 1'b0; // Not driven / peripheral
    end
    return sampled;
  endfunction
  function void apply_byte_mask(ref bit [31:0] reg_val, bit [31:0] data, bit [3:0] sel);
    for (int i = 0; i < 4; i++) begin
      if (sel[i])
        reg_val[i*8 +: 8] = data[i*8 +: 8];
    end
  endfunction
endclass
`endif