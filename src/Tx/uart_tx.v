`timescale 1ns / 1ps

module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output wire       tx,
    output wire       tx_busy,
    output wire       tx_done
);

    // Internal signals
    wire baud_tick;

    wire load;
    wire shift_en;

    wire serial_data;
    wire [2:0] bit_count;

    wire [7:0] shift_data;


    // =========================================
    // BAUD RATE GENERATOR
    // 200 MHz -> 9600 baud
    // =========================================

    baud_generator #(
        .CLK_FREQ(200_000_000),
        .BAUD_RATE(9600)
    ) u_baud_generator (

        .clk(clk),
        .rst_n(rst_n),
        .baud_tick(baud_tick)
    );


    // =========================================
    // TX REGISTER / SHIFT REGISTER
    // =========================================

    tx_register u_tx_register (

        .clk(clk),
        .rst_n(rst_n),

        .load(load),
        .shift_en(shift_en),

        .tx_data(tx_data),

        .serial_out(serial_data),
        .bit_count(bit_count),

        .shift_data(shift_data)
    );


    // =========================================
    // TX FSM
    // =========================================

    tx_fsm u_tx_fsm (

        .clk(clk),
        .rst_n(rst_n),

        .tx_start(tx_start),
        .baud_tick(baud_tick),

        .bit_count(bit_count),
        .serial_data(serial_data),

        .load(load),
        .shift_en(shift_en),

        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

endmodule