module program_counter
(
    input clk,
    input reset,
    input jump,
    input [5:0] jump_address,
    input pc_enable,
    input halt,
    output reg [5:0] pc
);

always @(posedge clk) begin
    if (reset) begin
        pc <= 6'd0;
    end
    else if (halt) begin
        // Hold PC (do nothing)
    end
    else if (pc_enable) begin
        if (jump)
            pc <= jump_address;
        else
            pc <= pc + 1'b1;
    end
end

endmodule