class gpio_module extends uvm_env;
  `uvm_component_utils(gpio_module)

  // Declare components
  gpio_ref_model ref_model;
  gpio_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Instantiate components
    ref_model = gpio_ref_model::type_id::create("ref_model", this);
    sb        = gpio_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect ref_model output to scoreboard
    ref_model.out_port.connect(sb.ref_ap);

    // Scoreboard needs access to reference shadow registers
    sb.ref_model = ref_model;
  endfunction

endclass