module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input tick,
    output reg tx,
    output reg tx_busy
);

    reg [3:0] state;
    reg [3:0] bit_index;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            tx <= 1;
            tx_busy <= 0;
        end else begin
            case(state)
                0: begin
                    tx <= 1;
                    tx_busy <= 0;
                    if (tx_start) begin
                        shift_reg <= {1'b1, tx_data, 1'b0}; // stop, data, start
                        bit_index <= 0;
                        tx_busy <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    if (tick) begin
                        tx <= shift_reg[bit_index];
                        bit_index <= bit_index + 1;
                        if (bit_index == 9)
                            state <= 2;
                    end
                end
                2: begin
                    if (tick) begin
                        tx <= 1;
                        tx_busy <= 0;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
