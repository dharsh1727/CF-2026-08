`timescale 1ns / 1ps

module rx_top (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx,

    output wire [7:0] rx_data,
    output wire       rx_done,
    output wire       framing_error
);

    // =========================================
    // INTERNAL SIGNALS
    // =========================================

    wire rx_sync;

    wire baud_tick;

    wire shift_en;
    wire load;

    wire bit_count_en;
    wire bit_count_rst;

    wire [3:0] bit_count;

    wire [7:0] r_out;


    // =========================================
    // 1. BAUD GENERATOR
    // 200 MHz -> 9600 baud
    // =========================================

    baud_generator #(
        .CLK_FREQ(200_000_000),
        .BAUD_RATE(9600)
    ) u_baud_generator (
        .clk       (clk),
        .rst_n     (rst_n),
        .baud_tick (baud_tick)
    );


    // =========================================
    // 2. RX SYNCHRONIZER
    // =========================================

    synchronizer u_synchronizer (
        .clk     (clk),
        .rst_n   (rst_n),
        .rx      (rx),
        .rx_sync (rx_sync)
    );


    // =========================================
    // 3. BIT COUNTER
    // =========================================

    bit_counter u_bit_counter (
        .clk           (clk),
        .rst_n         (rst_n),
        .bit_count_en  (bit_count_en),
        .bit_count_rst (bit_count_rst),
        .bit_count     (bit_count)
    );


    // =========================================
    // 4. RX FSM
    // =========================================

    rx_fsm u_rx_fsm (
        .clk           (clk),
        .rst_n         (rst_n),
        .baud_tick     (baud_tick),
        .rx_sync       (rx_sync),
        .bit_count     (bit_count),

        .shift_en      (shift_en),
        .load          (load),
        .bit_count_en  (bit_count_en),
        .bit_count_rst (bit_count_rst),
        .rx_done       (rx_done),
        .framing_error (framing_error)
    );


    // =========================================
    // 5. SIPO REGISTER
    // =========================================

    sipo_register u_sipo_register (
        .clk      (clk),
        .rst_n    (rst_n),
        .shift_en (shift_en),
        .rx_sync  (rx_sync),
        .r_out    (r_out)
    );


    // =========================================
    // 6. OUTPUT REGISTER
    // =========================================

    output_register u_output_register (
        .clk     (clk),
        .rst_n   (rst_n),
        .load    (load),
        .r_out   (r_out),
        .rx_data (rx_data)
    );

endmodule