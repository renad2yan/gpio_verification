module Hardware_top;
 
 logic [31:0] clock_period;
 logic run_clock;
 logic clock;
 logic reset;
 
 logic i_gpio;
 logic o_gpio;
 logic en_gpio;
 logic io_sel;

 clock_and_reset_if cr_if(
.clock(clock),
.reset(reset),
.run_clock(run_clock),
.clock_period(clock_period)
 );

wb_if wif(
    .clk(clk),
    .rst_n(rst_n)
);

io_top io_top_dut(
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wb_cyc_i(wb_cyc_i),
    .wb_stb_i(wb_stb_i),
    .wb_we_i(wb_we_i),
    .wb_adr_i(wb_adr_i),
    .wb_dat_i(wb_dat_i),
    .wb_sel_i(wb_sel_i),
    .wb_dat_o(wb_dat_o),
    .wb_ack_o(wb_ack_o),
    .wb_err_o(wb_err_o),
    .wb_inta_o(wb_inta_o),
    
    .i_gpio(i_gpio),
    .o_gpio(o_gpio),
    .en_gpio(en_gpio),
    .io_sel(io_sel)
);


endmodule