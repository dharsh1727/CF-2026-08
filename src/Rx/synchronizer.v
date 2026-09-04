`timescale 1ns / 1ps

module synchronizer(
    input  wire clk,
    input  wire rst_n,
    input  wire rx,
    output wire rx_sync
);

    reg ff1;
    reg ff2;

    always @(posedge clk or negedge rst_n)
    begin

        if (!rst_n) begin
            ff1 <= 1'b1;
            ff2 <= 1'b1;
        end

        else begin
            ff1 <= rx;
            ff2 <= ff1;
        end

    end

    assign rx_sync = ff2;

endmodule