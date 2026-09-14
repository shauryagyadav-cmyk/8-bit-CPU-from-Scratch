module button_pulse #(
    parameter integer DEBOUNCE_CYCLES = 100000
)(
    input clk,
    input rst,
    input button,

    output reg press
);

reg button_sync1;
reg button_sync2;

reg button_state;
reg button_state_prev;

reg [31:0] counter;


//================================
// Synchronizer
//================================

always @(posedge clk) begin

    if (rst) begin
        button_sync1 <= 0;
        button_sync2 <= 0;
    end
    else begin
        button_sync1 <= button;
        button_sync2 <= button_sync1;
    end

end


//================================
// Debouncer
//================================

always @(posedge clk) begin

    if (rst) begin
        button_state <= 0;
        counter <= 0;
    end

    else begin

        if (button_sync2 == button_state) begin

            counter <= 0;

        end

        else begin

            if (counter < DEBOUNCE_CYCLES) begin

                counter <= counter + 1;

            end

            else begin

                button_state <= button_sync2;
                counter <= 0;

            end

        end

    end

end


//================================
// Rising-edge detector
//================================

always @(posedge clk) begin

    if (rst) begin
        button_state_prev <= 0;
        press <= 0;
    end

    else begin

        button_state_prev <= button_state;

        press <= button_state & ~button_state_prev;

    end

end

endmodule