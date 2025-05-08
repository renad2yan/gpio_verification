class wb_x_gpio_module extends uvm_component;
  `uvm_component_utils(wb_x_gpio_module)

  // Shadow Registers
  bit [31:0] gpio_output;
  bit [31:0] gpio_oe;
  bit [31:0] io_select;
  bit [31:0] interrupt_enable;

  // Transaction queues for debugging/comparison
  gpio_transaction tx_queue[$];

  // Analysis ports
  uvm_analysis_export #(gpio_transaction) analysis_export;
  uvm_analysis_port   #(gpio_transaction) out_port;

  function new(string name = "wb_x_gpio_module", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    out_port = new("out_port", this);
  endfunction
wb_x_gpio_module
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_output = 32'h0;
    gpio_oe     = 32'h0;
    io_select   = 32'h0;
    interrupt_enable = 32'h0;
  endfunction

  virtual function void write(gpio_transaction tx);
    tx.has_expected = 1;

    if (tx.write_en) begin
      case (tx.addr)
        6'h04: apply_mask(gpio_output, tx.data, tx.sel);
        6'h08: apply_mask(gpio_oe,     tx.data, tx.sel);
        6'h0C: apply_mask(io_select,   tx.data, tx.sel);
        6'h30: apply_mask(interrupt_enable, tx.data, tx.sel);
        default: ;
      endcase
    end else begin
      case (tx.addr)
        6'h00: tx.expected_data = sample_input(io_select, gpio_oe);
        6'h04: tx.expected_data = gpio_output;
        6'h08: tx.expected_data = gpio_oe;
        6'h0C: tx.expected_data = io_select;
        6'h30: tx.expected_data = interrupt_enable;
        default: tx.expected_data = 32'hDEADBEEF;
      endcase
    end

    out_port.write(tx);
    tx_queue.push_back(tx);
  endfunction

  function void apply_mask(ref bit [31:0] reg_val, bit [31:0] data, bit [3:0] sel);
    for (int i = 0; i < 4; i++) begin
      if (sel[i])
        reg_val[i*8 +: 8] = data[i*8 +: 8];
    end
  endfunction

  function bit [31:0] sample_input(bit [31:0] sel, bit [31:0] oe);
    bit [31:0] result;
    for (int i = 0; i < 32; i++) begin
      result[i] = (sel[i] == 0 && oe[i] == 0) ? 1'b1 : 1'b0;
    end
    return result;
  endfunction

  // Optional getters
  function bit [31:0] get_output(); return gpio_output; endfunction
  function bit [31:0] get_oe();     return gpio_oe; endfunction
  function bit [31:0] get_select(); return io_select; endfunction
  function bit [31:0] get_intr();   return interrupt_enable; endfunction

endclass