package gpio_module_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import wb_pkg::*;              
  import clock_and_reset_pkg::*; 

  // Include GPIO Reference Model & Scoreboard
  `include "../gpio_verification/wb_x_gpio_module/wb_x_gpio_module.sv"
  `include "../gpio_verification/wb_x_gpio_module/scoreboard.sv"
  `include "../gpio_verification/wb_x_gpio_module/gpio_module.sv"

endpackage : gpio_module_pkg