`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2026 22:32:49
// Design Name: 
// Module Name: tx_fsm
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

module tx_fsm (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       tx_start,
    input  wire       baud_tick,

    input  wire [2:0] bit_count,
    input  wire       serial_data,

    output reg        load,
    output reg        shift_en,

    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;


    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end


    // Next-state logic
    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (tx_start)
                    next_state = START;
            end

            START: begin
                if (baud_tick)
                    next_state = DATA;
            end

            DATA: begin
                if (baud_tick && bit_count == 3'd7)
                    next_state = STOP;
            end

            STOP: begin
                if (baud_tick)
                    next_state = IDLE;
            end

            default:
                next_state = IDLE;

        endcase
    end


    // Output logic
    always @(*) begin

        load     = 1'b0;
        shift_en = 1'b0;

        tx       = 1'b1;
        tx_busy  = 1'b0;
        tx_done  = 1'b0;

        case (state)

            IDLE: begin
                tx = 1'b1;

                if (tx_start)
                    load = 1'b1;
            end


            START: begin
                tx      = 1'b0;
                tx_busy = 1'b1;
            end


            DATA: begin
                tx      = serial_data;
                tx_busy = 1'b1;

                if (baud_tick)
                    shift_en = 1'b1;
            end


            STOP: begin
                tx      = 1'b1;
                tx_busy = 1'b1;

                if (baud_tick)
                    tx_done = 1'b1;
            end

        endcase
    end

endmodule