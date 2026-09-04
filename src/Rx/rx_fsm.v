`timescale 1ns / 1ps

module rx_fsm (

    input  wire       clk,
    input  wire       rst_n,

    input  wire       baud_tick,
    input  wire       rx_sync,
    input  wire [3:0] bit_count,

    output reg        shift_en,
    output reg        load,
    output reg        bit_count_en,
    output reg        bit_count_rst,
    output reg        rx_done,
    output reg        framing_error
);


    // =========================================
    // STATES
    // =========================================

    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;


    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] prev_state;


    // =========================================
    // STATE REGISTER
    // =========================================

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            state     <= IDLE;
            prev_state <= IDLE;
        end

        else begin
            prev_state <= state;
            state      <= next_state;
        end

    end


    // =========================================
    // NEXT STATE LOGIC
    // =========================================

    always @(*) begin

        next_state = state;

        case (state)

            // ---------------------------------
            // IDLE
            // ---------------------------------

            IDLE: begin

                if (rx_sync == 1'b0)
                    next_state = START;

            end


            // ---------------------------------
            // START
            // ---------------------------------

            START: begin

                if (baud_tick) begin

                    if (rx_sync == 1'b0)
                        next_state = DATA;

                    else
                        next_state = IDLE;

                end

            end


            // ---------------------------------
            // DATA
            // ---------------------------------

            DATA: begin

                if (baud_tick) begin

                    if (bit_count == 4'd7)
                        next_state = STOP;

                    else
                        next_state = DATA;

                end

            end


            // ---------------------------------
            // STOP
            // ---------------------------------

            STOP: begin

                if (baud_tick)
                    next_state = IDLE;

            end


            // ---------------------------------
            // DEFAULT
            // ---------------------------------

            default:
                next_state = IDLE;

        endcase

    end


    // =========================================
    // OUTPUT LOGIC
    // =========================================

    always @(*) begin

        // Default values

        shift_en      = 1'b0;
        load          = 1'b0;
        bit_count_en  = 1'b0;
        bit_count_rst = 1'b0;

        rx_done       = 1'b0;
        framing_error = 1'b0;


        case (state)

            // ---------------------------------
            // IDLE
            // ---------------------------------

            IDLE: begin

                bit_count_rst = 1'b1;

            end


            // ---------------------------------
            // START
            // ---------------------------------

            START: begin

                // Wait for baud tick

            end


            // ---------------------------------
            // DATA
            // ---------------------------------

            DATA: begin

                if (baud_tick) begin

                    shift_en     = 1'b1;
                    bit_count_en = 1'b1;

                end

            end


            // ---------------------------------
            // STOP
            // ---------------------------------

            STOP: begin

                if (baud_tick && prev_state == STOP) begin

                    if (rx_sync == 1'b1) begin

                        load    = 1'b1;
                        rx_done = 1'b1;

                    end

                    else begin

                        framing_error = 1'b1;

                    end

                end

            end

        endcase

    end

endmodule