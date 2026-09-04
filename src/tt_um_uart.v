/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_TT16 (
    input  wire [7:0] ui_in,     // Dedicated inputs
    output wire [7:0] uo_out,    // Dedicated outputs

    input  wire [7:0] uio_in,    // Bidirectional input path
    output wire [7:0] uio_out,   // Bidirectional output path
    output wire [7:0] uio_oe,    // Bidirectional output enable

    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // =========================================================
    // UART INTERNAL SIGNALS
    // =========================================================

    wire [7:0] tx_data;
    wire       tx_start;
    wire       rx;

    wire       tx;
    wire       tx_busy;
    wire       tx_done;

    wire [7:0] rx_data;
    wire       rx_done;
    wire       framing_error;


    // =========================================================
    // INPUT MAPPING
    // =========================================================

    // 8-bit TX data
    assign tx_data = ui_in[7:0];

    // UART RX input
    assign rx = uio_in[0];

    // Start TX transmission
    assign tx_start = uio_in[1];


    // =========================================================
    // OUTPUT MAPPING
    // =========================================================

    // Received UART data
    assign uo_out[7:0] = rx_data;


    // UART status / TX output
    assign uio_out[0] = 1'b0;           // unused
    assign uio_out[1] = 1'b0;           // unused

    assign uio_out[2] = tx;
    assign uio_out[3] = tx_busy;
    assign uio_out[4] = tx_done;
    assign uio_out[5] = rx_done;
    assign uio_out[6] = framing_error;
    assign uio_out[7] = 1'b0;           // unused


    // =========================================================
    // BIDIRECTIONAL PIN DIRECTION
    // =========================================================

    // uio[0] = RX input
    // uio[1] = TX start input
    // uio[2:6] = UART outputs
    // uio[7] = unused

    assign uio_oe[0] = 1'b0;
    assign uio_oe[1] = 1'b0;

    assign uio_oe[2] = 1'b1;
    assign uio_oe[3] = 1'b1;
    assign uio_oe[4] = 1'b1;
    assign uio_oe[5] = 1'b1;
    assign uio_oe[6] = 1'b1;

    assign uio_oe[7] = 1'b0;


    // =========================================================
    // UART TRANSMITTER
    // =========================================================

    uart_tx u_uart_tx (
        .clk      (clk),
        .rst_n    (rst_n),

        .tx_start (tx_start),
        .tx_data  (tx_data),

        .tx       (tx),
        .tx_busy  (tx_busy),
        .tx_done  (tx_done)
    );


    // =========================================================
    // UART RECEIVER
    // =========================================================

    rx_top u_rx_top (
        .clk           (clk),
        .rst_n         (rst_n),

        .rx            (rx),

        .rx_data       (rx_data),
        .rx_done       (rx_done),
        .framing_error (framing_error)
    );


    // =========================================================
    // UNUSED SIGNAL
    // =========================================================

    wire _unused;

    assign _unused = &{
        ena,
        uio_in[7:2]
    };

endmodule

`default_nettype wire
