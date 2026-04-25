`default_nettype none

module Pulse_X1_Edge_AI_Core (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input wire clk,
    input wire rst_n,

    // Wishbone Interface
    input wire wb_stb_i,
    input wire wb_cyc_i,
    input wire wb_we_i,
    input wire [3:0] wb_sel_i,
    input wire [31:0] wb_dat_i,
    input wire [31:0] wb_adr_i,
    output reg wb_ack_o,
    output reg [31:0] wb_dat_o,

    // Thermal & Cooling Interface
    input  wire [7:0] liquid_temp_sensor,
    output reg  [7:0] pump_ctrl
);

    // Internal Signals
    wire [511:0] core_outputs [7:0];
    wire [7:0] core_done_flags;
    reg  start_signal;
    wire internal_reset;
    
    // Internal Reset Logic (Active High for Cores)
    assign internal_reset = ~rst_n;

    // Thermal Management Logic (Titan Protection System)
    // Thresholds: 80C for Warning, 100C for Critical Shutdown
    always @(posedge clk) begin
        if (!rst_n) begin
            start_signal <= 1'b0;
            pump_ctrl    <= 8'h44; // Default safe pump speed
        end else begin
            if (liquid_temp_sensor > 8'd80) begin
                pump_ctrl <= 8'hFF; // Maximize cooling
            end else if (liquid_temp_sensor > 8'd100) begin
                start_signal <= 1'b0; // Emergency Shutdown
                pump_ctrl    <= 8'hFF;
            end else begin
                pump_ctrl <= 8'h66; // Normal operating speed
            end
        end
    end

    // Wishbone Communication & Register Mapping
    always @(posedge clk) begin
        if (!rst_n) begin
            wb_ack_o <= 1'b0;
            wb_dat_o <= 32'h0;
        end else begin
            wb_ack_o <= 1'b0;
            if (wb_stb_i && wb_cyc_i && !wb_ack_o) begin
                wb_ack_o <= 1'b1;
                if (wb_we_i) begin
                    if (wb_adr_i[7:0] == 8'h00) start_signal <= wb_dat_i[0];
                end else begin
                    case (wb_adr_i[7:0])
                        8'h00: wb_dat_o <= {31'b0, start_signal};
                        8'h04: wb_dat_o <= {24'b0, core_done_flags};
                        8'h08: wb_dat_o <= {24'b0, liquid_temp_sensor};
                        8'h0C: wb_dat_o <= {24'b0, pump_ctrl};
                        default: wb_dat_o <= 32'h0;
                    endcase
                end
            end
        end
    end

    // Generate 8 AI Cores
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : core_gen
            Pulse_X1_Core_inst titan_unit (
                .clk(clk),
                .reset(internal_reset),
                .hbm3_bus_in(512'b0),
                .weight(32'b0),
                .bias(32'b0),
                .liquid_temp_sensor(liquid_temp_sensor),
                .start_compute(start_signal),
                .data_out(core_outputs[i]),
                .done_flag(core_done_flags[i])
            );
        end
    endgenerate

endmodule
`default_nettype wire
