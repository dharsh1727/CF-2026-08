`timescale 1ns / 1ps

module sipo_register (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       shift_en,
    input  wire       rx_sync,

    output reg [7:0] r_out
);

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            r_out <= 8'h00;
        end

        else if (shift_en) begin
            r_out <= {rx_sync, r_out[7:1]};
        end

    end

endmodule