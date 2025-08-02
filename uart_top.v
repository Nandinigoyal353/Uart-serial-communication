module uart_top (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output tx,
    input rx,
    output [7:0] rx_data,
    output rx_done
);

    wire tick;

    baud_gen baud_inst (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tick(tick),
        .tx(tx)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
endmodule
