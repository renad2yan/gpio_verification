// Base sequence for Wishbone transactions
class wb_base_seq extends uvm_sequence #(wb_transaction);
  `uvm_object_utils(wb_base_seq)

  function new(string name = "wb_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask

  task post_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask
endclass

// 1. Reset sequence
class gpio_reset_seq extends wb_base_seq;
  `uvm_object_utils(gpio_reset_seq)
  function new(string name = "gpio_reset_seq"); super.new(name); endfunction
  virtual task body(); #50ns; endtask
endclass

// 2. Configure input mode, then read
class gpio_input_config_seq extends wb_base_seq;
  `uvm_object_utils(gpio_input_config_seq)
  function new(string name = "gpio_input_config_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'h0; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h00; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 3. Write to GPIO_OUTPUT
class gpio_output_write_seq extends wb_base_seq;
  `uvm_object_utils(gpio_output_write_seq)
  function new(string name = "gpio_output_write_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'hA5A5A5A5; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 4. GPIO_INPUT read with OE=0
class gpio_input_read_seq extends wb_base_seq;
  `uvm_object_utils(gpio_input_read_seq)
  function new(string name = "gpio_input_read_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'h00000000; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h00; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 5. GPIO direction control
class gpio_direction_control_seq extends wb_base_seq;
  `uvm_object_utils(gpio_direction_control_seq)
  function new(string name = "gpio_direction_control_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'h000000FF; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'hA5A5A5A5; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 6. GPIO override with IO_SELECT
class gpio_output_override_seq extends wb_base_seq;
  `uvm_object_utils(gpio_output_override_seq)
  function new(string name = "gpio_output_override_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'hAAAAAAAA; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 7. Alternate function mode
class alt_func_mode_seq extends wb_base_seq;
  `uvm_object_utils(alt_func_mode_seq)
  function new(string name = "alt_func_mode_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'h00000001; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'h00000000; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 8. Mixed mode output
class mixed_mode_output_seq extends wb_base_seq;
  `uvm_object_utils(mixed_mode_output_seq)
  function new(string name = "mixed_mode_output_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'h0000FFFF; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 9. Pad sampling
class pad_sampling_seq extends wb_base_seq;
  `uvm_object_utils(pad_sampling_seq)
  function new(string name = "pad_sampling_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'h0; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'h0; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h00; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 10. Pad output enable
class pad_output_enable_seq extends wb_base_seq;
  `uvm_object_utils(pad_output_enable_seq)
  function new(string name = "pad_output_enable_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'h0000FFFF; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 11. IO_SELECT reset effect
class io_select_reset_seq extends wb_base_seq;
  `uvm_object_utils(io_select_reset_seq)
  function new(string name = "io_select_reset_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'hA5A5A5A5; rest_rf==0; valid_sb==1; })
    // assume reset occurs externally
    #50ns;
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h0C; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 12. Full register access test
class full_register_access_seq extends wb_base_seq;
  `uvm_object_utils(full_register_access_seq)
  function new(string name = "full_register_access_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'h11111111; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'h22222222; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h0C; din==32'h33333333; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h04; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h08; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h0C; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 13. Random output toggling
class random_output_toggle_seq extends wb_base_seq;
  `uvm_object_utils(random_output_toggle_seq)
  function new(string name = "random_output_toggle_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h08; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
    foreach (int i in {0,1,2,3,4,5,6,7,8,9}) begin
      `uvm_do_with(req, { op_type==wb_write; addr==32'h04; rest_rf==0; valid_sb==1; })
    end
  endtask
endclass

// 14. Byte-masked write
class byte_selective_write_seq extends wb_base_seq;
  `uvm_object_utils(byte_selective_write_seq)
  function new(string name = "byte_selective_write_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'hAABBCCDD; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h04; din==32'h00EE0000; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_read;  addr==32'h04; rest_rf==0; valid_sb==1; })
  endtask
endclass

// 15. Interrupt logic blocked by IO_SELECT
class interrupt_blocked_seq extends wb_base_seq;
  `uvm_object_utils(interrupt_blocked_seq)
  function new(string name = "interrupt_blocked_seq"); super.new(name); endfunction
  virtual task body();
    `uvm_do_with(req, { op_type==wb_write; addr==32'h28; din==32'hFFFFFFFF; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h30; din==32'h00000001; rest_rf==0; valid_sb==1; })
    `uvm_do_with(req, { op_type==wb_write; addr==32'h00; din==32'h00000001; rest_rf==0; valid_sb==1; })
  endtask
endclass

