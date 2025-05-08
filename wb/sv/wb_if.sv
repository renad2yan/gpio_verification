interface wb_if (input bit clk, input bit rst_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wb_pkg::*;

  // Wishbone signals
  bit cyc;
  bit stb;
  bit [31:0] addr;
  bit [3:0] sel;     // byte select
  bit we;            // write enable
  bit [31:0] din;    // data input to DUT
  bit [31:0] dout;   // data output from DUT
  bit ack;
  bit inta;

  // Extra control signals for reference model and scoreboard
  bit valid_sb; 
  bit rest_rf;

  // Send transaction to DUT
  task send_to_dut(wb_transaction tr);
    if (tr.op_type == wb_write) begin
      @(negedge clk);
      cyc   <= 1;
      stb   <= 1;
      addr  <= tr.addr;
      sel   <= 4'b1111;
      we    <= 1;
      din   <= tr.din;
      valid_sb <= tr.valid_sb;
      rest_rf  <= tr.rest_rf;

      wait(ack);
      wait(!ack);

      cyc   <= 0;
      stb   <= 0;
      addr  <= 0;
      din   <= 0;
      we    <= 0;
    end
    else if (tr.op_type == wb_read) begin
      @(negedge clk);
      cyc   <= 1;
      stb   <= 1;
      addr  <= tr.addr;
      sel   <= 4'b1111;
      we    <= 0;
      valid_sb <= tr.valid_sb;
      rest_rf  <= tr.rest_rf;

      @(posedge clk);
      wait(ack);
      tr.dout = dout;
      wait(!ack);

      cyc   <= 0;
      stb   <= 0;
      addr  <= 0;
    end
  endtask : send_to_dut

  // Response task (used by slave/UVC)
  task responsd_to_master();
    `uvm_info("SLAVE_DRV", "\n\n⭐⭐⭐ Waiting for cyc & stb \n\n", UVM_DEBUG);
    wait(cyc && stb);

    if (we) begin
      @(posedge clk);
      $display("\n\n⭐ Slave driver received din: 0x%0h at addr: 0x%0h at %0t ns\n", din, addr, $time);
      @(posedge clk);
      ack <= 1;
      @(posedge clk);
      ack <= 0;
    end
    else begin
      @(posedge clk);
      dout = $random();
      $display("\n\n⭐ Slave driver sending dout: 0x%0h at %0t ns\n", dout, $time);
      @(posedge clk);
      ack <= 1;
      @(posedge clk);
      ack <= 0;
    end
  endtask : responsd_to_master

endinterface : wb_if