`default_nettype none
module user_project_wrapper #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 supply ground
    inout vssa2,	// User area 2 supply ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8V supply
    inout vsscl,	// User area 1 supply ground
    inout vsscd,	// User area 2 supply ground
`endif
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
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oeb,
    input  [2:0] user_irq
);

    // Pulse_X1 16-Core AI Accelerator Instantiation
    Pulse_X1_Edge_AI_Core pulse_cluster (
        .clk(wb_clk_i),
        .reset(wb_rst_i),
        .start_compute(la_data_in),
        .hbm3_bus_in(la_data_in[63:0]),
        .liquid_temp_sensor(la_data_in[71:64]),
        .data_out(la_data_out[63:0]),
        .process_complete(la_data_out),
        .system_alerts(la_data_out[67:65]),
        .pump_ctrl(la_data_out)
    );

endmodule
