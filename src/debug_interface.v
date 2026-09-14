  module debug_interface (

    input clk,
    input rst,

    input BTN_RUN,
    input BTN_PAUSE,
    input BTN_CLOCK_STEP,
    input BTN_INSTRUCTION_STEP,

    output run_request,
    output pause_request,
    output clock_step_request,
    output instruction_step_request

);

localparam debug_cycles = 3;

// RUN BUTTON

button_pulse #(.DEBOUNCE_CYCLES(debug_cycles)) run_button (


    .clk(clk),
    .rst(rst),
    .button(BTN_RUN),
    .press(run_request)
);

//PAUSE BUTTON

button_pulse #(.DEBOUNCE_CYCLES(debug_cycles)) pause_button (

    .clk(clk),
    .rst(rst),
    .button(BTN_PAUSE),
    .press(pause_request)
);

//CLOCK STEP BUTTON

button_pulse #(.DEBOUNCE_CYCLES(debug_cycles)) clock_step_button (

    .clk(clk),
    .rst(rst),
    .button(BTN_CLOCK_STEP),
    .press(clock_step_request)
);

//INSTRUCTION STEP REQUEST

button_pulse #(.DEBOUNCE_CYCLES(debug_cycles)) instruction_step_button (

    .clk(clk),
    .rst(rst),
    .button(BTN_INSTRUCTION_STEP),
    .press(instruction_step_request)
); 



endmodule