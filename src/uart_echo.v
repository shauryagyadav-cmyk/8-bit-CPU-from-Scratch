module uart_echo (

    input        clk,
    input        rst,

    input [7:0]  rx_data,
    input        rx_done,

    input        tx_busy,

    output reg [7:0] tx_data,
    output reg       tx_start

);

    always @(posedge clk) begin

        if (rst) begin

            tx_data  <= 8'd0;
            tx_start <= 1'b0;

        end

        else begin

            // tx_start is a one-clock pulse
            tx_start <= 1'b0;

            // When a byte arrives, immediately echo it
            if (rx_done && !tx_busy) begin

                tx_data  <= rx_data;
                tx_start <= 1'b1;

            end

        end

    end

endmodule