`ifndef GPIO_TOP_SV
`define GPIO_TOP_SV
`ifndef VCS
     `include "gpio_defines.v"
`endif
module gpio_top #(
  parameter NO_OF_GPIO_PINS,
  parameter NO_OF_SHARED_PINS
)(
	// WISHBONE Interface
	wb_clk_i, wb_rst_i, wb_cyc_i, wb_adr_i, wb_dat_i, wb_sel_i, wb_we_i, wb_stb_i,
	wb_dat_o, wb_ack_o, wb_err_o, wb_inta_o,

  // 
  i_gpio,
  o_gpio,
  en_gpio,
  io_sel
);

localparam dw = 32;
parameter aw = `GPIO_ADDRHH+1;
parameter gw = `GPIO_IOS;
//
// WISHBONE Interface
//
input             wb_clk_i;	// Clock
input             wb_rst_i;	// Reset
input             wb_cyc_i;	// cycle valid input
input   [aw-1:0]	wb_adr_i;	// address bus inputs
input   [dw-1:0]	wb_dat_i;	// input data bus
input	  [3:0]     wb_sel_i;	// byte select inputs
input             wb_we_i;	// indicates write transfer
input             wb_stb_i;	// strobe input
output  [dw-1:0]  wb_dat_o;	// output data bus
output            wb_ack_o;	// normal termination
output            wb_err_o;	// termination w/ error
output            wb_inta_o;	// Interrupt request output
input   [NO_OF_GPIO_PINS - 1:0]    i_gpio;
output  [NO_OF_GPIO_PINS - 1:0]    o_gpio;
output  [NO_OF_GPIO_PINS - 1:0]    en_gpio;
output  [NO_OF_SHARED_PINS - 1:0]  io_sel;



// Logic here
logic wb_acc;
logic gpio_write;
assign wb_acc = wb_stb_i & wb_cyc_i;
assign gpio_write = wb_acc & wb_we_i;

logic [NO_OF_GPIO_PINS - 1:0] rgpio_in;
logic [NO_OF_GPIO_PINS - 1:0] rgpio_out;
logic [NO_OF_GPIO_PINS - 1:0] rgpio_oe;
logic [NO_OF_SHARED_PINS - 1:0] io_sel;


logic rgpio_in_sel;
logic rgpio_out_sel;
logic rgpio_oe_sel;
logic io_sel_sel;

n_bit_dec #(
  .n(2)
) gpio_reg_sel_decoder (
  .in(wb_adr_i[3:2]),
  .out({ io_sel_sel ,rgpio_oe_sel, rgpio_out_sel, rgpio_in_sel})
);


always @(posedge wb_clk_i, posedge wb_rst_i) begin 
  if(wb_rst_i) begin 
    rgpio_out <= 0;
    rgpio_oe  <= 0;
    io_sel <= 0;
  end else if(gpio_write) begin 
    if(rgpio_out_sel) begin 
      if(wb_sel_i[0])                          rgpio_out[ 7: 0] <= wb_dat_i[ 7: 0];
      if(wb_sel_i[1])                          rgpio_out[15: 8] <= wb_dat_i[15: 8];
      if(wb_sel_i[2])                          rgpio_out[23:16] <= wb_dat_i[23:16];
      if (NO_OF_GPIO_PINS > 24 && wb_sel_i[3]) rgpio_out[31:24] <= wb_dat_i[31:24];

    end else if(rgpio_oe_sel) begin 
      if(wb_sel_i[0])                          rgpio_oe[ 7: 0] <= wb_dat_i[ 7: 0];
      if(wb_sel_i[1])                          rgpio_oe[15: 8] <= wb_dat_i[15: 8];
      if(wb_sel_i[2])                          rgpio_oe[23:16] <= wb_dat_i[23:16];
      if (NO_OF_GPIO_PINS > 24 && wb_sel_i[3]) rgpio_oe[31:24] <= wb_dat_i[31:24];

    end else if(io_sel_sel) begin // TODO LOGIC NOT PARAMETERIZED
      if(wb_sel_i[0])                          io_sel[ 7: 0] <= wb_dat_i[ 7: 0];
      if(wb_sel_i[1])                          io_sel[12: 8] <= wb_dat_i[12: 8]; 
    end
  end
end

assign rgpio_in = i_gpio;
assign o_gpio   = rgpio_out;
assign en_gpio  = rgpio_oe;


// output logic here 
assign wb_dat_o = rgpio_in_sel  ? {{(32-NO_OF_GPIO_PINS){1'b0}}, rgpio_in }  :
                  rgpio_out_sel ? {{(32-NO_OF_GPIO_PINS){1'b0}}, rgpio_out } :
                  rgpio_oe_sel  ? {{(32-NO_OF_GPIO_PINS){1'b0}}, rgpio_oe  } :
                  io_sel;

assign wb_ack_o = wb_acc;


endmodule
`endif