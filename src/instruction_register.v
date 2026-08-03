module instruction_register (
    input clk,

input [15:0] instruction,
input ir_load,
output reg [15:0] ir

);


always @(posedge clk) begin

    if (ir_load) begin

    ir <= instruction;
    end
    
end
endmodule 