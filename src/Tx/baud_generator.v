`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2026 22:15:42
// Design Name: 
// Module Name: baud_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module baud_generator #(
    parameter integer CLK_FREQ  = 200_000_000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst_n,

    output reg baud_tick
);

    // Number of clock cycles per baud
    localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE;

    integer counter;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            counter  <= 0;
            baud_tick <= 1'b0;
        end

        else begin

            if (counter == BAUD_COUNT - 1) begin
                counter   <= 0;
                baud_tick <= 1'b1;
            end

            else begin
                counter   <= counter + 1;
                baud_tick <= 1'b0;
            end

        end

    end

endmodule