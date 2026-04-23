`default_nettype none

module Pulse_X1_Edge_AI_Core (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input wire clk,
    input wire rst_n,

    // Wishbone Interface
    input wire        wb_stb_i,
    input wire        wb_cyc_i,
    input wire        wb_we_i,
    input wire [31:0] wb_dat_i,
    input wire [31:0] wb_adr_i,
    output reg        wb_ack_o,
    output reg [31:0] wb_dat_o
);

    // Internal Signals for the 16 cores
    wire [511:0] core_outputs [15:0];
    wire [15:0]  core_done_flags;
    reg  start_signal;

    // Parallel Cores Generation (16 Cores)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : core_gen
            Pulse_X1_Core core_inst (
                .clk(clk),
                .reset(!rst_n),
                .hbm3_bus_in(512'b0), // Connect your global bus here
                .weight(32'b0),
                .bias(32'b0),
                .liquid_temp_sensor(8'b0),
                .start_compute(start_signal),
                .data_out(core_outputs[i]),
                .done_flag(core_done_flags[i])
            );
        end
    endgenerate

    // Wishbone Control Logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wb_ack_o <= 1'b0;
            start_signal <= 1'b0;
        end else begin
            wb_ack_o <= 1'b0;
            if (wb_stb_i && wb_cyc_i && !wb_ack_o) begin
                wb_ack_o <= 1'b1;
                if (wb_we_i && wb_adr_i[7:0] == 8'h00)
                    start_signal <= wb_dat_i[0];
                else
                    wb_dat_o <= {16'b0, core_done_flags}; // Returns status of all 16 cores
            end
        end
    end

endmodule
