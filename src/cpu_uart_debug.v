module cpu_uart_debug #(
    parameter CLK_FREQ  = 27_000_000,
    parameter BAUD_RATE = 115_200
)(
    input clk,
    input rst,

    // Physical UART pins
    input  uart_rx,
    output uart_tx,

    // CPU debug information
    input [5:0]  debug_pc,
    input [15:0] debug_instruction,

    input debug_instruction_done,

    input [7:0] debug_R0,
    input [7:0] debug_R1,
    input [7:0] debug_R2,
    input [7:0] debug_R3,
    input [7:0] debug_R4,
    input [7:0] debug_R5,
    input [7:0] debug_R6,
    input [7:0] debug_R7,

    // CPU control
    output CPU_enable

);


    // =========================================================
    // UART RX
    // =========================================================

    wire [7:0] rx_data;
    wire       rx_done;


    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_rx0 (

        .clk(clk),
        .rst(rst),

        .rx(uart_rx),

        .rx_data(rx_data),
        .rx_done(rx_done)

    );


    // =========================================================
    // Debug command requests
    // =========================================================

    wire run_request;
    wire pause_request;
    wire clock_step_request;
    wire instruction_step_request;


    // =========================================================
    // Response UART
    // =========================================================

    wire [7:0] response_data;
    wire       response_start;
    wire       response_busy;


    // =========================================================
    // Command protocol
    // =========================================================

    uart_debug_protocol protocol0 (

        .clk(clk),
        .rst(rst),

        .rx_data(rx_data),
        .rx_done(rx_done),

        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),

        .debug_R0(debug_R0),
        .debug_R1(debug_R1),
        .debug_R2(debug_R2),
        .debug_R3(debug_R3),
        .debug_R4(debug_R4),
        .debug_R5(debug_R5),
        .debug_R6(debug_R6),
        .debug_R7(debug_R7),

        .run_request(run_request),
        .pause_request(pause_request),
        .clock_step_request(clock_step_request),
        .instruction_step_request(instruction_step_request),

        .response_data(response_data),
        .response_start(response_start),
        .response_busy(response_busy)

    );


    // =========================================================
    // UART TX
    // =========================================================

    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_tx0 (

        .clk(clk),
        .rst(rst),

        .tx_start(response_start),
        .tx_data(response_data),

        .tx(uart_tx),
        .busy(response_busy)

    );


    // =========================================================
    // Debug controller
    // =========================================================

    debug_controller controller0 (

        .clk(clk),
        .rst(rst),

        .run_request(run_request),
        .pause_request(pause_request),

        .clock_step_request(clock_step_request),
        .instruction_step_request(instruction_step_request),

        .instruction_done(debug_instruction_done),

        .CPU_enable(CPU_enable)

    );


endmodule