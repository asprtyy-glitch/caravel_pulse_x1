`default_nettype none

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
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
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,
    output [2:0] user_irq
);

    Pulse_X1_Edge_AI_Core ai_core (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
    `endif
        .clk(wb_clk_i),
        .rst_n(~wb_rst_i),
        .wb_stb_i(wbs_stb_i),
        .wb_cyc_i(wbs_cyc_i),
        .wb_we_i(wbs_we_i),
        .wb_sel_i(wbs_sel_i),
        .wb_dat_i(wbs_dat_i),
        .wb_adr_i(wbs_adr_i),
        .wb_ack_o(wbs_ack_o),
        .wb_dat_o(wbs_dat_o)
    );

    assign user_irq = 3'b000;
    assign io_out = {`MPRJ_IO_PADS{1'b0}};
    assign io_oeb = {`MPRJ_IO_PADS{1'b1}};
    assign la_data_out = 128'b0;

endmodule
