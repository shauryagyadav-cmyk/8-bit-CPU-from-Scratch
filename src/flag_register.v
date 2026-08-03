module flag_register (
    input clk,
    input rst,  
    input zero_in,
    input we,
    output reg zero_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        zero_out <= 1'b0;      
    else if (we)
        zero_out <= zero_in;         
end

endmodule