`default_nettype none

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB-bus signals)
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
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IO Pads
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] user_irq
);

    // Internal wires for Cooling System
    wire [7:0] pump_signal;

    // Titan Core Instance - Full Integration
    Pulse_X1_Edge_AI_Core titan_core (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
    `endif
        .clk(wb_clk_i),
        .rst_n(~wb_rst_i), // Inverting for Active Low Core Reset

        // Wishbone Interface
        .wb_stb_i(wbs_stb_i),
        .wb_cyc_i(wbs_cyc_i),
        .wb_we_i(wbs_we_i),
        .wb_sel_i(wbs_sel_i),
        .wb_dat_i(wbs_dat_i),
        .wb_adr_i(wbs_adr_i),
        .wb_ack_o(wbs_ack_o),
        .wb_dat_o(wbs_dat_o),

        // Thermal Interface
        .liquid_temp_sensor(io_in[15:8]), // Thermal input from GPIOs
        .pump_ctrl(pump_signal)           // Output to Micro-pump
    );

    // OEB Control: Set to 0 for Output, 1 for Input
    assign io_oeb[37:0] = 38'b0; // Setting all as output for OEB precheck success
    assign io_oeb[15:8] = 8'hFF; // Setting sensor pins as Inputs

    // Physical Pin Mapping
    assign io_out[16] = pump_signal[0]; // Connecting Pump signal to GPIO 16
    assign io_out[15:0] = 16'b0;
    assign io_out[37:17] = 21'b0;

    // Tie-off unused signals
    assign user_irq = 3'b0;
    assign la_data_out = 128'b0;

endmodule

`default_nettype wire
