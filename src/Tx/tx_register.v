`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2026 22:24:03
// Design Name: 
// Module Name: tx_register
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2026 22:45:05
// Design Name: 
// Module Name: tx_register
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

module tx_register (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire       shift_en,
    input  wire [7:0] tx_data,

    output wire       serial_out,
    output wire [2:0] bit_count,

    // Added only so we can easily see it in simulation
    output wire [7:0] shift_data
);

    reg [7:0] tx_data_reg;
    reg [7:0] tx_shift_reg;
    reg [2:0] counter;


    // TX DATA REGISTER
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_data_reg <= 8'b00000000;
        else if (load)
            tx_data_reg <= tx_data;
    end


    // TX SHIFT REGISTER
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_shift_reg <= 8'b00000000;

        else if (load)
            tx_shift_reg <= tx_data;

        else if (shift_en)
            tx_shift_reg <= tx_shift_reg >> 1;
    end


    // 3-BIT COUNTER
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'b000;

        else if (load)
            counter <= 3'b000;

        else if (shift_en)
            counter <= counter + 1'b1;
    end


    // LSB of shift register
    assign serial_out = tx_shift_reg[0];

    assign bit_count = counter;

    // Show complete shift register
    assign shift_data = tx_shift_reg;

endmodule

