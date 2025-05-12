`ifndef GPIO_IF_SV
`define GPIO_IF_SV
interface gpio_if #(parameter ADDR_WIDTH = 6, DATA_WIDTH = 32);
  logic                  wb_clk_i;
  logic                  wb_rst_i;
  logic                  wb_cyc_i;
  logic                  wb_stb_i;
  logic                  wb_we_i;
  logic [ADDR_WIDTH-1:0] wb_adr_i;
  logic [DATA_WIDTH-1:0] wb_dat_i;
  logic [3:0]            wb_sel_i;
  logic [DATA_WIDTH-1:0] wb_dat_o;
  logic                  wb_ack_o;
  logic                  wb_err_o;
  logic                  wb_inta_o;
  logic [4:0] addr;
  logic [31:0] data;
  logic [2:0] sel;
  logic        write_en;
  logic [31:0] read_data;
  clocking cb @(posedge wb_clk_i);
    default input #1step output #1step;
    input  wb_dat_o, wb_ack_o, wb_err_o, wb_inta_o;
    output wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i, wb_sel_i;
  endclocking
endinterface
`endif
