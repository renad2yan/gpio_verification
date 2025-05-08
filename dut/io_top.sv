`ifndef IO_TOP_SV
`define IO_TOP_SV
// Top-level I/O module combining gpio_top, io_mux and pad cells
module io_top #(
    parameter NO_OF_GPIO_PINS   = 24,
    parameter NO_OF_SHARED_PINS = 13
)(
    // Wishbone slave interface
    input  wire                 wb_clk_i,
    input  wire                 wb_rst_i,
    input  wire                 wb_cyc_i,
    input  wire                 wb_stb_i,
    input  wire                 wb_we_i,
    input  wire [5:0]           wb_adr_i,
    input  wire [31:0]          wb_dat_i,
    input  wire [3:0]           wb_sel_i,
    output wire [31:0]          wb_dat_o,
    output wire                 wb_ack_o,
    output wire                 wb_err_o,
    output wire                 wb_inta_o,

    // Peripheral inputs for IO Mux
    // --- SPI1 ---
    input  wire                 o_flash_sclk,
    input  wire [1:0]           o_flash_cs_n,
    input  wire                 o_flash_mosi,
    output wire                 i_flash_miso,
    // --- SPI2 ---
    input  wire                 o_sclk,
    input  wire [1:0]           o_cs_n,
    input  wire                 o_mosi,
    output wire                 i_miso,
    // --- I²C ---
    input  wire                 o_scl,
    input  wire                 o_sda,
    input  wire                 o_scl_oen,
    input  wire                 o_sda_oen,
    output wire                 i_scl,
    output wire                 i_sda,
    // --- PWM ---
    input  wire                 pwm_pad_o,

    // Bidirectional external pads
    inout  wire [NO_OF_GPIO_PINS-1:0] IO_DATA_PAD
);

  //==========================================================================
  // Internal nets
  //==========================================================================
  // From pad cells → IO Mux
  wire [NO_OF_GPIO_PINS-1:0] pad_i;

  // From IO Mux → gpio_top
  wire [NO_OF_GPIO_PINS-1:0] mux_i_gpio_;
  // From gpio_top → IO Mux
  wire [NO_OF_GPIO_PINS-1:0] gpio_o;
  wire [NO_OF_GPIO_PINS-1:0] gpio_en;
  wire [NO_OF_GPIO_PINS-1:0] io_sel;

  // From IO Mux → pad cells
  wire [NO_OF_GPIO_PINS-1:0] mux_o_gpio;
  wire [NO_OF_GPIO_PINS-1:0] mux_en_gpio;


  //==========================================================================
  // 1) Pad Cells: PDD24DGZ for each bit
  //    Drives IO_DATA_PAD when mux_en_gpio=1, samples into pad_i
  //==========================================================================
  genvar i;
  generate
    for (i = 0; i < NO_OF_GPIO_PINS; i = i + 1) begin : PAD_GEN
      PDD24DGZ u_pad (
        .I   (mux_o_gpio[i]),
        .OEN (~mux_en_gpio[i]),    // OEN=1 disables drive, 0 enables
        .PAD (IO_DATA_PAD[i]),
        .C   (pad_i[i])
      );
    end
  endgenerate


  //==========================================================================
  // 2) IO Multiplexer
  //==========================================================================
  io_mux #(
    .NO_OF_SHARED_PINS(NO_OF_SHARED_PINS)
  ) u_io_mux (
    .io_sel        (io_sel),

    // SPI1
    .o_flash_sclk  (o_flash_sclk),
    .o_flash_cs_n  (o_flash_cs_n),
    .o_flash_mosi  (o_flash_mosi),
    .i_flash_miso  (i_flash_miso),

    // SPI2
    .o_sclk        (o_sclk),
    .o_cs_n        (o_cs_n),
    .o_mosi        (o_mosi),
    .i_miso        (i_miso),

    // I²C
    .o_scl         (o_scl),
    .o_sda         (o_sda),
    .o_scl_oen     (o_scl_oen),
    .o_sda_oen     (o_sda_oen),
    .i_scl         (i_scl),
    .i_sda         (i_sda),

    // PWM
    .pwm_pad_o     (pwm_pad_o),

    // From/To gpio_top
    .i_gpio_       (mux_i_gpio_),
    .o_gpio_       (gpio_o),
    .en_gpio_      (gpio_en),

    // From/To pad cells
    .i_gpio        (pad_i),
    .o_gpio        (mux_o_gpio),
    .en_gpio       (mux_en_gpio)
  );


  //==========================================================================
  // 3) GPIO Controller (Wishbone Slave)
  //==========================================================================
  gpio_top #(
    .NO_OF_GPIO_PINS  (NO_OF_GPIO_PINS),
    .NO_OF_SHARED_PINS(NO_OF_SHARED_PINS)
  ) u_gpio_top (
    // Wishbone
    .wb_clk_i   (wb_clk_i),
    .wb_rst_i   (wb_rst_i),
    .wb_cyc_i   (wb_cyc_i),
    .wb_stb_i   (wb_stb_i),
    .wb_we_i    (wb_we_i),
    .wb_adr_i   (wb_adr_i),
    .wb_dat_i   (wb_dat_i),
    .wb_sel_i   (wb_sel_i),
    .wb_dat_o   (wb_dat_o),
    .wb_ack_o   (wb_ack_o),
    .wb_err_o   (wb_err_o),
    .wb_inta_o  (wb_inta_o),

    // GPIO <> IO Mux
    .i_gpio     (mux_i_gpio_),
    .o_gpio     (gpio_o),
    .en_gpio    (gpio_en),
    .io_sel     (io_sel)
  );


endmodule
`endif