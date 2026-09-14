module debug_system (

    // =========================================================
    // Clock / Reset
    // =========================================================

    input clk,
    input rst,


    // =========================================================
    // Physical Debug Buttons
    // =========================================================

    input BTN_RUN,
    input BTN_PAUSE,
    input BTN_CLOCK_STEP,
    input BTN_INSTRUCTION_STEP,


    // =========================================================
    // UART
    // =========================================================

    input  uart_rx,
    output uart_tx,


    // =========================================================
    // CPU Debug Outputs
    // =========================================================

    output [5:0] debug_pc,
    output [15:0] debug_instruction,

    output debug_JMP,
    output debug_REG_write,
    output debug_MEM_write,

    output [7:0] debug_MEM_address,
    output [7:0] debug_MEM_data,

    output [7:0] debug_ALU_result,
    output [3:0] debug_ALU_opcode,

    output [7:0] debug_R0,
    output [7:0] debug_R1,
    output [7:0] debug_R2,
    output [7:0] debug_R3,
    output [7:0] debug_R4,
    output [7:0] debug_R5,
    output [7:0] debug_R6,
    output [7:0] debug_R7,

    output debug_instruction_done,
    output [2:0] debug_state,

    output CPU_enable,
    output [1:0] debug_controller_state,
    output [2:0] debug_next_state,
    output debug_halted

);


    // =========================================================
    // Physical button requests
    // =========================================================

    wire button_run_request;
    wire button_pause_request;
    wire button_clock_step_request;
    wire button_instruction_step_request;


    debug_interface interface0 (

        .clk(clk),
        .rst(rst),

        .BTN_RUN(BTN_RUN),
        .BTN_PAUSE(BTN_PAUSE),
        .BTN_CLOCK_STEP(BTN_CLOCK_STEP),
        .BTN_INSTRUCTION_STEP(BTN_INSTRUCTION_STEP),

        .run_request(button_run_request),
        .pause_request(button_pause_request),
        .clock_step_request(button_clock_step_request),
        .instruction_step_request(button_instruction_step_request)

    );


    // =========================================================
    // UART RX
    // =========================================================

    wire [7:0] uart_rx_data;
    wire       uart_rx_done;


    uart_rx uart_rx0 (

        .clk(clk),
        .rst(rst),

        .rx(uart_rx),

        .rx_data(uart_rx_data),
        .rx_done(uart_rx_done)

    );


    // =========================================================
    // UART command requests
    // =========================================================

    wire uart_run_request;
    wire uart_pause_request;
    wire uart_clock_step_request;
    wire uart_instruction_step_request;


    // =========================================================
    // UART response
    // =========================================================

    wire [7:0] uart_response_data;
    wire       uart_response_start;
    wire       uart_response_busy;
    wire       uart_response_done;


    // =========================================================
    // UART protocol
    // =========================================================

    uart_debug_protocol protocol0 (

    .clk(clk),
    .rst(rst),

    .rx_data(uart_rx_data),
    .rx_done(uart_rx_done),

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

    .run_request(uart_run_request),
    .pause_request(uart_pause_request),
    .clock_step_request(uart_clock_step_request),
    .instruction_step_request(uart_instruction_step_request),

    .response_data(uart_response_data),
    .response_start(uart_response_start),
    .response_busy(uart_response_busy),
    .response_done(uart_response_done),
    .debug_state(debug_state)

    );


    // =========================================================
    // UART TX
    // =========================================================

    uart_tx uart_tx0 (

    .clk(clk),
    .rst(rst),

    .tx_start(uart_response_start),
    .tx_data(uart_response_data),

    .tx(uart_tx),
    .busy(uart_response_busy),
    .done(uart_response_done)

    );

    // =========================================================
    // Combine physical + UART requests
    // =========================================================

    wire run_request;
    wire pause_request;
    wire clock_step_request;
    wire instruction_step_request;

    assign run_request =
        button_run_request |
        uart_run_request;

    assign pause_request =
        button_pause_request |
        uart_pause_request;

    assign clock_step_request =
        button_clock_step_request |
        uart_clock_step_request;

    assign instruction_step_request =
        button_instruction_step_request |
        uart_instruction_step_request;


    // =========================================================
    // Debug Controller
    // =========================================================

    debug_controller controller0 (

    .clk(clk),
    .rst(rst),

    .run_request(run_request),
    .pause_request(pause_request),

    .clock_step_request(clock_step_request),
    .instruction_step_request(instruction_step_request),

    .instruction_done(debug_instruction_done),

    .CPU_enable(CPU_enable),

    .debug_controller_state(debug_controller_state)

);


    // =========================================================
    // CPU
    // =========================================================

    CPU cpu0 (

        .clk(clk),
        .rst(rst),

        .CPU_enable(CPU_enable),

        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),

        .debug_JMP(debug_JMP),
        .debug_REG_write(debug_REG_write),
        .debug_MEM_write(debug_MEM_write),

        .debug_MEM_address(debug_MEM_address),
        .debug_MEM_data(debug_MEM_data),

        .debug_ALU_result(debug_ALU_result),
        .debug_ALU_opcode(debug_ALU_opcode),

        .debug_R0(debug_R0),
        .debug_R1(debug_R1),
        .debug_R2(debug_R2),
        .debug_R3(debug_R3),
        .debug_R4(debug_R4),
        .debug_R5(debug_R5),
        .debug_R6(debug_R6),
        .debug_R7(debug_R7),

        .debug_instruction_done(debug_instruction_done),
        .debug_state(debug_state),
        .debug_next_state(debug_next_state),
        .debug_halted(debug_halted)

    );


endmodule