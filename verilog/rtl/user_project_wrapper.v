`default_nettype none

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vccd1,	
    inout vssd1,	
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

    // Internal wires for Titan Core connection
    wire [7:0] core_done_flags;
    wire [7:0] core_pump_ctrl;

    // Titan Core Instance (Pulse_X1_Core_v2)
    Pulse_X1_Core_v2 titan_core (
        .clk(wb_clk_i),
        .reset(wb_rst_i),
        .done_flags(core_done_flags),
        .pump_ctrl(core_pump_ctrl)
    );

    // Physical Mapping and OEB fix
    // Setting io_oeb to 0 enables the output buffer for all pins
    assign io_oeb = 38'b0; 

    // Mapping core outputs to GPIO pins 10-17 and 18-25
    assign io_out[17:10] = core_done_flags;
    assign io_out[25:18] = core_pump_ctrl;
    
    // Default values for unused pins
    assign io_out[9:0]   = 10'b0;
    assign io_out[37:26] = 12'b0;

    // Tie-off unused Caravel signals
    assign wbs_ack_o = 1'b0;
    assign wbs_dat_o = 32'b0;
    assign user_irq  = 3'b0;
    assign la_data_out = 128'b0;

endmodule

`default_nettype wire
