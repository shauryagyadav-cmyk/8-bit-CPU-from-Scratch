module uart_tx #(
    parameter CLK_FREQ  = 27_000_000,
    parameter BAUD_RATE = 115_200
)(
    input clk,
    input rst,

    input       tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg busy,
    output reg done
);

    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter;
    reg [3:0]  bit_index;
    reg [9:0]  tx_shift_reg;


    always @(posedge clk) begin

        if (rst) begin

            tx           <= 1'b1;
            busy         <= 1'b0;
            done         <= 1'b0;
            baud_counter <= 16'd0;
            bit_index    <= 4'd0;
            tx_shift_reg <= 10'b1111111111;

        end

        else begin

            // done is a one-clock pulse
            done <= 1'b0;


            // =================================================
            // Start transmission
            // =================================================

            if (tx_start && !busy) begin

                tx_shift_reg <= {
                    1'b1,
                    tx_data,
                    1'b0
                };

                busy         <= 1'b1;
                baud_counter <= 16'd0;
                bit_index    <= 4'd0;

                tx <= 1'b0;

            end


            // =================================================
            // Transmission in progress
            // =================================================

            else if (busy) begin

                if (baud_counter == BAUD_TICKS - 1) begin

                    baud_counter <= 16'd0;


                    if (bit_index == 4'd9) begin

                        // =====================================
                        // Entire frame completed
                        // =====================================

                        busy <= 1'b0;
                        done <= 1'b1;
                        tx   <= 1'b1;

                    end

                    else begin

                        bit_index <= bit_index + 1'b1;

                        tx_shift_reg <= {
                            1'b1,
                            tx_shift_reg[9:1]
                        };

                        tx <= tx_shift_reg[1];

                    end

                end

                else begin

                    baud_counter <= baud_counter + 1'b1;

                end

            end

        end

    end

endmodule