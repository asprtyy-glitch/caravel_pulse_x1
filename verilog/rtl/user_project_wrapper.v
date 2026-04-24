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

    // Titan Core Instance - Using the correct Module Name and Reset signal
    Pulse_X1_Edge_AI_Core titan_core (
        .clk(wb_clk_i),
        .rst_n(wb_rst_i)
    );

    // OEB fix: Enable output buffers for all GPIOs (Set to 0)
    // This resolves the "user mode requires oeb connection" error
    assign io_oeb = 38'b0;

    // Tie-off io_out to prevent floating outputs during Precheck
    assign io_out = 38'b0;

    // Tie-off unused Caravel signals
    assign wbs_ack_o = 1'b0;
    assign wbs_dat_o = 32'b0;
    assign user_irq  = 3'b0;
    assign la_data_out = 128'b0;

endmodule

`default_nettype wire
