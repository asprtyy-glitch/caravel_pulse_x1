`ifndef CORE_V
`define CORE_V

module Pulse_X1_Core (
    input wire clk,
    input wire reset,
    input wire [511:0] hbm3_bus_in,
    input wire [31:0] weight,
    input wire [31:0] bias,
    input wire [7:0] liquid_temp_sensor,
    input wire start_compute,
    output reg [511:0] data_out,
    output reg [7:0] pump_ctrl,
    output reg thermal_crit_flag,
    output reg done_flag
);
    reg [63:0] mul_stage;
    reg [31:0] mac_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 512'd0;
            done_flag <= 1'b0;
            thermal_crit_flag <= 1'b0;
            pump_ctrl <= 8'd0;
        end else if (start_compute) begin
            mul_stage <= hbm3_bus_in[31:0] * weight;
            mac_stage <= mul_stage[31:0] + bias;
            data_out <= hbm3_bus_in ^ {16{mac_stage}};
            done_flag <= 1'b1;
            // Trigger alerts if temp > 90
            thermal_crit_flag <= (liquid_temp_sensor > 8'd90);
            pump_ctrl <= (liquid_temp_sensor > 8'd80) ? 8'hFF : (liquid_temp_sensor << 1);
        end else begin
            done_flag <= 1'b0;
        end
    end
endmodule
`endif

