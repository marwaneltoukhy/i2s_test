`default_nettype none

module i2s_example(
`ifdef USE_POWER_PINS
    inout vccd1,    // User area 1 1.8V supply
    inout vssd1,    // User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  la_data_in,   // Inputs from CPU
    output la_data_out,  // Outputs to CPU
    input  la_oenb,      // Output enable bar

    input  io_in,
    output [1:0] io_out,
    output [2:0] io_oeb
);

wire la_irq;              // Interrupt from I2C

// I2S Peripheral Instantiation
EF_I2S_WB i2s_peripheral (
    .ext_clk(),              // Not used
    .clk_i(wb_clk_i),        // Clock input from Wishbone
    .rst_i(wb_rst_i),        // Reset input
    .adr_i(wbs_adr_i),       // Address from Wishbone
    .dat_i(wbs_dat_i),       // Data input from Wishbone
    .dat_o(wbs_dat_o),       // Data output to Wishbone
    .sel_i(wbs_sel_i),       // Byte select from Wishbone
    .cyc_i(wbs_cyc_i),       // Cycle signal
    .stb_i(wbs_stb_i),       // Strobe signal
    .we_i(wbs_we_i),         // Write enable signal
    .ack_o(wbs_ack_o),       // Acknowledge signal
    .IRQ(la_irq),            // Interrupt output

    .ws(io_out[0]),          // Word Select output to IO
    .sck(io_out[1]),         // Serial Clock output to IO
    .sdi(io_in)              // Serial Data input from IO
);

// Logic Analyzer Outputs for Debugging
assign la_data_out = la_irq;         // Send IRQ to LA

// Set IO output enable (active low) for WS, SCK, and SDI
assign io_oeb = 3'b100; // Enable outputs for WS and SCK, set SDI as input

endmodule
`default_nettype wire
