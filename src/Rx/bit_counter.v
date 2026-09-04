`timescale 1ns / 1ps

module bit_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       bit_count_en,
    input  wire       bit_count_rst,

    output reg [3:0]  bit_count
);

    always @(posedge clk or negedge rst_n) begin

        // Active-low reset
        if (!rst_n) begin
            bit_count <= 4'd0;
        end

        // Reset counter when requested by RX FSM
        else if (bit_count_rst) begin
            bit_count <= 4'd0;
        end

        // Increment counter
        else if (bit_count_en) begin

            if (bit_count < 4'd8) begin
                bit_count <= bit_count + 1'b1;
            end

            else begin
                bit_count <= bit_count;
            end

        end

    end

endmodule