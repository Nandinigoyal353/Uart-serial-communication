`timescale 1ns/1ps

module tb_uart;

    reg clk = 0;
    reg rst = 1;
    reg tx_start = 0;
    reg [7:0] tx_data;
    wire tx;
    reg rx;
    wire [7:0] rx_data;
    wire rx_done;

    uart_top dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx(tx),  // Loopback
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk; // 50 MHz

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_uart);

        #100;
        rst = 0;
        #100;
        tx_data = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(rx_done);
        $display("Received: %h", rx_data);

        #50000 $finish;
    end
endmodule
