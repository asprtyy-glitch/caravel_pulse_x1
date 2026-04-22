`include "src/Pulse_X1_Core_v2.v"

module Pulse_X1_Edge_AI_Core (
    input wire clk,
    input wire reset,
    input wire start_signal,
    input wire [511:0] main_hbm3_bus,
    input wire [31:0] global_weight,
    input wire [31:0] global_bias,
    input wire [127:0] thermal_grid,
    output wire [511:0] final_output,
    output wire [15:0] system_alerts,
    output wire process_complete
);
    wire [511:0] core_outputs [15:0];
    wire [15:0] core_done_flags;
    reg start_cores;

    always @(posedge clk or posedge reset) begin
        if (reset) start_cores <= 1'b0;
        else start_cores <= start_signal;
    end

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : core_gen
            Pulse_X1_Core core_inst (
                .clk(clk),
                .reset(reset),
                .hbm3_bus_in(main_hbm3_bus),
                .weight(global_weight),
                .bias(global_bias),
                .liquid_temp_sensor(thermal_grid[i*8+7 : i*8]),
                .start_compute(start_cores),
                .data_out(core_outputs[i]),
                .thermal_crit_flag(system_alerts[i]),
                .done_flag(core_done_flags[i])
            );
        end
    endgenerate

    assign final_output = core_outputs[0]; // Active Data Path
    assign process_complete = &core_done_flags;
endmodule
