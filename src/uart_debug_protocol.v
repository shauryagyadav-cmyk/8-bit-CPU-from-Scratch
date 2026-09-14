module uart_debug_protocol (

    input clk,
    input rst,

    // =========================================================
    // UART RX
    // =========================================================

    input [7:0] rx_data,
    input       rx_done,

    // =========================================================
    // CPU / Debug signals
    // =========================================================

    input [5:0]  debug_pc,
    input [15:0] debug_instruction,

    input [7:0] debug_R0,
    input [7:0] debug_R1,
    input [7:0] debug_R2,
    input [7:0] debug_R3,
    input [7:0] debug_R4,
    input [7:0] debug_R5,
    input [7:0] debug_R6,
    input [7:0] debug_R7,
    input [2:0] debug_state,

    // =========================================================
    // Debug controller requests
    // =========================================================

    output reg run_request,
    output reg pause_request,
    output reg clock_step_request,
    output reg instruction_step_request,

    // =========================================================
    // UART TX
    // =========================================================

    output reg [7:0] response_data,
    output reg       response_start,

    input            response_busy,
    input            response_done

);

    // =========================================================
    // Commands
    // =========================================================

    localparam CMD_RUN              = 8'h01;
    localparam CMD_PAUSE            = 8'h02;
    localparam CMD_CLOCK_STEP       = 8'h03;
    localparam CMD_INSTRUCTION_STEP = 8'h04;

   

    localparam CMD_READ_R0          = 8'h20;
    localparam CMD_READ_R1          = 8'h21;
    localparam CMD_READ_R2          = 8'h22;
    localparam CMD_READ_R3          = 8'h23;
    localparam CMD_READ_R4          = 8'h24;
    localparam CMD_READ_R5          = 8'h25;
    localparam CMD_READ_R6          = 8'h26;
    localparam CMD_READ_R7          = 8'h27;
    localparam CMD_READ_PC          = 8'h10;
    localparam CMD_READ_INSTRUCTION = 8'h11;
    localparam CMD_READ_STATE       = 8'h12;

    // =========================================================
    // Response buffer
    // =========================================================

    reg [7:0] response_buffer [0:2];
    reg [1:0] response_count;

    // =========================================================
    // TX state machine
    // =========================================================

    localparam TX_IDLE  = 2'd0;
    localparam TX_START = 2'd1;
    localparam TX_WAIT  = 2'd2;

    reg [1:0] tx_state;

    // =========================================================
    // Main logic
    // =========================================================

    always @(posedge clk) begin

        if (rst) begin

            run_request              <= 1'b0;
            pause_request            <= 1'b0;
            clock_step_request       <= 1'b0;
            instruction_step_request <= 1'b0;

            response_data  <= 8'h00;
            response_start <= 1'b0;

            response_count <= 2'd0;

            response_buffer[0] <= 8'h00;
            response_buffer[1] <= 8'h00;
            response_buffer[2] <= 8'h00;

            tx_state <= TX_IDLE;

        end

        else begin

            // =================================================
            // One-clock pulse outputs
            // =================================================

            run_request              <= 1'b0;
            pause_request            <= 1'b0;
            clock_step_request       <= 1'b0;
            instruction_step_request <= 1'b0;

            response_start <= 1'b0;


            // =================================================
            // TX RESPONSE STATE MACHINE
            // =================================================

            case (tx_state)

                // -------------------------------------------------
                // Nothing currently being transmitted
                // -------------------------------------------------

                TX_IDLE: begin

                    if (response_count != 0) begin

                        response_data <= response_buffer[0];

                        tx_state <= TX_START;

                    end

                end


                // -------------------------------------------------
                // Generate exactly one clock of tx_start
                // -------------------------------------------------

                TX_START: begin

                    // Only start if UART is actually idle.
                    if (!response_busy) begin

                        response_start <= 1'b1;

                        tx_state <= TX_WAIT;

                    end

                end


                // -------------------------------------------------
                // Wait for the UART TX to explicitly finish
                // -------------------------------------------------

                TX_WAIT: begin

                    if (response_done) begin

                        // Remove first byte from queue.
                        response_buffer[0] <= response_buffer[1];
                        response_buffer[1] <= response_buffer[2];

                        response_count <= response_count - 1'b1;

                        tx_state <= TX_IDLE;

                    end

                end


                default: begin

                    tx_state <= TX_IDLE;

                end

            endcase


            // =================================================
            // RECEIVE COMMAND
            // =================================================

            if (rx_done) begin

                case (rx_data)

                    // =============================================
                    // RUN
                    // =============================================

                    CMD_RUN: begin

                        run_request <= 1'b1;

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h81;
                            response_count <= 2'd1;

                        end

                    end


                    // =============================================
                    // PAUSE
                    // =============================================

                    CMD_PAUSE: begin

                        pause_request <= 1'b1;

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h82;
                            response_count <= 2'd1;

                        end

                    end


                    // =============================================
                    // CLOCK STEP
                    // =============================================

                    CMD_CLOCK_STEP: begin

                        clock_step_request <= 1'b1;

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h83;
                            response_count <= 2'd1;

                        end

                    end


                    // =============================================
                    // INSTRUCTION STEP
                    // =============================================

                    CMD_INSTRUCTION_STEP: begin

                        instruction_step_request <= 1'b1;

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h84;
                            response_count <= 2'd1;

                        end

                    end


                    // =============================================
                    // READ PC
                    // =============================================

                    CMD_READ_PC: begin

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h90;
                            response_buffer[1] <= {2'b00, debug_pc};

                            response_count <= 2'd2;

                        end

                    end


                    // =============================================
                    // READ INSTRUCTION
                    // =============================================

                    CMD_READ_INSTRUCTION: begin

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h91;
                            response_buffer[1] <= debug_instruction[7:0];
                            response_buffer[2] <= debug_instruction[15:8];

                            response_count <= 2'd3;

                        end

                    end
                    // =============================================
                    // READ FSM STATE
                    // =============================================

                    CMD_READ_STATE: begin

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            response_buffer[0] <= 8'h92;
                            response_buffer[1] <= {5'b00000, debug_state};

                            response_count <= 2'd2;

                        end

                    end


                    // =============================================
                    // READ REGISTERS
                    // =============================================

                    CMD_READ_R0,
                    CMD_READ_R1,
                    CMD_READ_R2,
                    CMD_READ_R3,
                    CMD_READ_R4,
                    CMD_READ_R5,
                    CMD_READ_R6,
                    CMD_READ_R7: begin

                        if (response_count == 0 &&
                            tx_state == TX_IDLE) begin

                            case (rx_data)

                                CMD_READ_R0: begin
                                    response_buffer[0] <= 8'hA0;
                                    response_buffer[1] <= debug_R0;
                                end

                                CMD_READ_R1: begin
                                    response_buffer[0] <= 8'hA1;
                                    response_buffer[1] <= debug_R1;
                                end

                                CMD_READ_R2: begin
                                    response_buffer[0] <= 8'hA2;
                                    response_buffer[1] <= debug_R2;
                                end

                                CMD_READ_R3: begin
                                    response_buffer[0] <= 8'hA3;
                                    response_buffer[1] <= debug_R3;
                                end

                                CMD_READ_R4: begin
                                    response_buffer[0] <= 8'hA4;
                                    response_buffer[1] <= debug_R4;
                                end

                                CMD_READ_R5: begin
                                    response_buffer[0] <= 8'hA5;
                                    response_buffer[1] <= debug_R5;
                                end

                                CMD_READ_R6: begin
                                    response_buffer[0] <= 8'hA6;
                                    response_buffer[1] <= debug_R6;
                                end

                                CMD_READ_R7: begin
                                    response_buffer[0] <= 8'hA7;
                                    response_buffer[1] <= debug_R7;
                                end

                                default: begin
                                    response_buffer[0] <= 8'hFF;
                                    response_buffer[1] <= 8'h00;
                                end

                            endcase

                            response_count <= 2'd2;

                        end

                    end


                    // =============================================
                    // UNKNOWN COMMAND
                    // =============================================

                    default: begin
                        // Ignore unknown commands.
                    end

                endcase

            end

        end

    end

endmodule