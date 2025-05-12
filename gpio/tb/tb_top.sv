//`include "/home/Renad_Altawyan/gpio_verification/dut/gpio_top.sv"
//`include "/home/Renad_Altawyan/gpio_verification/dut/io_mux.sv"
//`include "/home/Renad_Altawyan/gpio_verification/dut/io_top.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_if.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_transaction.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_sequence.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_driver.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_monitor.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_sequencer.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_agent.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_env.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_test.sv"
//`include "/home/Renad_Altawyan/gpio_verification/tb/gpio_scoreboard.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;
import gpio_pkg::*;
//`include "gpio_if.sv" 
module tb_top;
  gpio_if gpio_if();
 io_top dut (
  .wb_clk_i   (gpio_if.wb_clk_i),
  .wb_rst_i   (gpio_if.wb_rst_i),
  .wb_adr_i   (gpio_if.wb_adr_i),
  .wb_dat_i   (gpio_if.wb_dat_i),
  .wb_dat_o   (gpio_if.wb_dat_o),
  .wb_we_i    (gpio_if.wb_we_i),
  .wb_sel_i   (gpio_if.wb_sel_i),
  .wb_cyc_i   (gpio_if.wb_cyc_i),
  .wb_stb_i   (gpio_if.wb_stb_i),
  .wb_ack_o   (gpio_if.wb_ack_o),
  .wb_inta_o  (gpio_if.wb_inta_o));
  initial begin
    gpio_if.wb_clk_i = 0;
    forever #5 gpio_if.wb_clk_i = ~gpio_if.wb_clk_i;
  end
  initial begin
    gpio_if.wb_rst_i = 1;
    #20;
    gpio_if.wb_rst_i = 0;
  end
  initial begin
    uvm_config_db#(virtual gpio_if)::set(null, "*", "vif", gpio_if);
    run_test("gpio_test");
  end
endmodule