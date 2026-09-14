module debug_controller (

    input run_request,
    input clk,
    input rst,

    input pause_request,
    input clock_step_request,
    input instruction_step_request,
    input instruction_done,

    output reg CPU_enable,
    output [1:0] debug_controller_state

);

localparam PAUSED           = 2'd0;
localparam RUNNING          = 2'd1;
localparam CLOCK_STEP       = 2'd2;
localparam INSTRUCTION_STEP = 2'd3;

reg [1:0] current_state;
reg [1:0] next_state;

assign debug_controller_state = current_state;


// =========================================================
// State Register
// =========================================================

always @(posedge clk or posedge rst) begin

    if (rst)
        current_state <= PAUSED;

    else
        current_state <= next_state;

end


// =========================================================
// Next-State Logic
// =========================================================

always @(*) begin

    next_state = current_state;

    case (current_state)

        PAUSED: begin

            if (run_request)
                next_state = RUNNING;

            else if (clock_step_request)
                next_state = CLOCK_STEP;

            else if (instruction_step_request)
                next_state = INSTRUCTION_STEP;

        end


        RUNNING: begin

            if (pause_request)
                next_state = PAUSED;

            else if (clock_step_request)
                next_state = CLOCK_STEP;

            else if (instruction_step_request)
                next_state = INSTRUCTION_STEP;

        end


        CLOCK_STEP: begin

            next_state = PAUSED;

        end


        INSTRUCTION_STEP: begin

            if (instruction_done)
                next_state = PAUSED;

        end


        default: begin

            next_state = PAUSED;

        end

    endcase

end


// =========================================================
// CPU Enable
// =========================================================

always @(*) begin

    case (current_state)

        PAUSED:
            CPU_enable = 1'b0;

        RUNNING:
            CPU_enable = 1'b1;

        CLOCK_STEP:
            CPU_enable = 1'b1;

        INSTRUCTION_STEP:
            CPU_enable = 1'b1;

        default:
            CPU_enable = 1'b0;

    endcase

end

endmodule