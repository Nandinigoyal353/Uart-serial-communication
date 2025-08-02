module uart_rx (
    input clk,
    input rst,
    input rx,
    input tick,
    output reg [7:0] rx_data,
    output reg rx_done
);

    reg [3:0] bit_index;
    reg [7:0] data_reg;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 0;
            data_reg <= 0;
            rx_data <= 0;
            rx_done <= 0;
            state <= 0;
        end else begin
            rx_done <= 0;
            case(state)
                0: begin // Wait for start bit
                    if (~rx) state <= 1;
                end
                1: begin // Read 8 bits
                    if (tick) begin
                        data_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) begin
                            state <= 2;
                            bit_index <= 0;
                        end
                    end
                end
                2: begin // Stop bit
                    if (tick) begin
                        rx_data <= data_reg;
                        rx_done <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
