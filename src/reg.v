module register 
(
    input [7:0] d,
    input clk,
    input rst,
    input we,
    output reg [7:0] q
);

always @(posedge clk) begin

    if (rst)
        q <= 8'd0;

    else if (we)
        q <= d;

end

endmodule