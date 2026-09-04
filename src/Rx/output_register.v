`timescale 1ns / 1ps

module output_register (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire [7:0] r_out,

    output reg [7:0] rx_data
);

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rx_data <= 8'h00;
        end

        else if (load) begin
            rx_data <= r_out;
        end

    end

endmodule