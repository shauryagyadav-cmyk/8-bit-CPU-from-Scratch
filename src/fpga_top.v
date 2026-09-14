module fpga_top (

    // =========================================================
    // Clock
    // =========================================================

    input clk_27m,


    // =========================================================
    // Physical buttons
    // Active-LOW
    //
    // BTN1 = Clock Step
    // BTN2 = Run
    // =========================================================

    input btn1,
    input btn2,
    input btn3,
    input btn4,
    
    


    // =========================================================
    // UART
    // =========================================================

    input uart_rx,
    output uart_tx,


    // =========================================================
    // LEDs
    // Active-LOW
    // =========================================================

    output [5:0] led

);


    // =========================================================
    // FPGA STARTUP RESET
    // =========================================================

    reg [3:0] reset_counter = 4'd0;
    reg fpga_rst = 1'b1;

    always @(posedge clk_27m) begin

        if (reset_counter != 4'd15) begin

            reset_counter <= reset_counter + 1'b1;
            fpga_rst <= 1'b1;

        end

        else begin

            fpga_rst <= 1'b0;

        end

    end


    // =========================================================
    // CPU / DEBUG SIGNALS
    // =========================================================

    wire CPU_enable;

    wire [5:0] debug_pc;

    wire [15:0] debug_instruction;

    wire debug_JMP;
    wire debug_REG_write;
    wire debug_MEM_write;

    wire [7:0] debug_MEM_address;
    wire [7:0] debug_MEM_data;

    wire [7:0] debug_ALU_result;
    wire [3:0] debug_ALU_opcode;

    wire [7:0] debug_R0;
    wire [7:0] debug_R1;
    wire [7:0] debug_R2;
    wire [7:0] debug_R3;
    wire [7:0] debug_R4;
    wire [7:0] debug_R5;
    wire [7:0] debug_R6;
    wire [7:0] debug_R7;

    wire debug_instruction_done;
    wire [2:0] debug_state;
    wire [1:0] debug_controller_state;
    wire [2:0] debug_next_state;
    wire debug_halted;

    


    // =========================================================
    // DEBUG SYSTEM
    // =========================================================

    debug_system debug_system0 (

    .clk(clk_27m),
    .rst(fpga_rst | ~btn4),

    .BTN_RUN(~btn1),
    .BTN_PAUSE(1'b0),

    // TEMPORARILY DISABLED
    .BTN_CLOCK_STEP(~btn2),
    .BTN_INSTRUCTION_STEP(~btn3),

    .uart_rx(uart_rx),
    .uart_tx(uart_tx),

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

    .debug_controller_state(debug_controller_state),

    .CPU_enable(CPU_enable)

);


    // =========================================================
    // DISPLAY PROGRAM COUNTER
    // LEDs are ACTIVE-LOW
    // =========================================================

        assign led = ~debug_pc;


endmodule