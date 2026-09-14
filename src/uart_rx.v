module uart_rx #(
    parameter CLK_FREQ  = 27_000_000,
    parameter BAUD_RATE = 115_200
)(
    input        clk,
    input        rst,

    input        rx,

    output reg [7:0] rx_data,
    output reg       rx_done
);

    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD  = BAUD_TICKS / 2;


    // =========================================================
    // Synchronizer
    // =========================================================

    reg rx_sync1;
    reg rx_sync2;


    // =========================================================
    // Receiver state
    // =========================================================

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;

    reg [15:0] baud_counter;
    reg [2:0]  bit_index;

    reg [7:0] rx_shift_reg;


    // =========================================================
    // Synchronizer
    // =========================================================

    always @(posedge clk) begin

        if (rst) begin

            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;

        end

        else begin

            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;

        end

    end


    // =========================================================
    // UART receiver
    // =========================================================

    always @(posedge clk) begin

        if (rst) begin

            state        <= IDLE;
            baud_counter <= 16'd0;
            bit_index    <= 3'd0;
            rx_shift_reg <= 8'd0;

            rx_data      <= 8'd0;
            rx_done      <= 1'b0;

        end

        else begin

            rx_done <= 1'b0;


            case (state)


                // =================================================
                // IDLE
                // =================================================

                IDLE: begin

                    baud_counter <= 16'd0;

                    if (rx_sync2 == 1'b0) begin

                        state        <= START;
                        baud_counter <= 16'd0;

                    end

                end


                // =================================================
                // START BIT
                //
                // Verify that the line is still low halfway
                // through the start bit.
                // =================================================

                START: begin

                    if (baud_counter == HALF_BAUD - 1) begin

                        baud_counter <= 16'd0;

                        if (rx_sync2 == 1'b0) begin

                            bit_index <= 3'd0;
                            state     <= DATA;

                        end

                        else begin

                            // False start
                            state <= IDLE;

                        end

                    end

                    else begin

                        baud_counter <= baud_counter + 1'b1;

                    end

                end


                // =================================================
                // DATA
                // =================================================

                DATA: begin

                    if (baud_counter == BAUD_TICKS - 1) begin

                        baud_counter <= 16'd0;

                        // UART is LSB first
                        rx_shift_reg[bit_index] <= rx_sync2;

                        if (bit_index == 3'd7) begin

                            state <= STOP;

                        end

                        else begin

                            bit_index <= bit_index + 1'b1;

                        end

                    end

                    else begin

                        baud_counter <= baud_counter + 1'b1;

                    end

                end


                // =================================================
                // STOP BIT
                // =================================================

               STOP: begin

    if (baud_counter == BAUD_TICKS - 1) begin

        baud_counter <= 16'd0;

        if (rx_sync2 == 1'b1) begin

            rx_data <= rx_shift_reg;
            rx_done <= 1'b1;

        end

        state <= IDLE;

    end

    else begin

        baud_counter <= baud_counter + 1'b1;

    end

end

                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

endmodule