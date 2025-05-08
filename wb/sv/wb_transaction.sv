typedef enum bit {wb_read, wb_write} op_type_enum;

class wb_transaction extends uvm_sequence_item;

  // Constant widths
  localparam int ADDR_WIDTH = 32;
  localparam int DATA_WIDTH = 32; // Adjusted for GPIO project

  // Variables
  rand logic [ADDR_WIDTH-1:0] addr;
  rand logic [DATA_WIDTH-1:0] din;
       logic [DATA_WIDTH-1:0] dout; // not randomized
  rand op_type_enum op_type;
  rand logic rest_rf;
  rand bit valid_sb;

  `uvm_object_utils_begin(wb_transaction)
    `uvm_field_enum(op_type_enum, op_type, UVM_DEFAULT)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(din, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
    `uvm_field_int(rest_rf, UVM_DEFAULT)
    `uvm_field_int(valid_sb, UVM_DEFAULT)
  `uvm_object_utils_end

  // Address constraint (optional, for 0x00 to 0xFF)
  constraint addr_limit { addr <= 32'hFF; }

  function new(string name = "wb_transaction");
    super.new(name);
  endfunction

  function void post_randomize();
    // Any post-processing after randomization (not needed now)
  endfunction

endclass




endclass : wb_transaction