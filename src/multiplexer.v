
module mux
(
  
input wire [7:0] q1,
input wire [7:0] q2,
input wire [7:0] q3,
input wire [7:0] q0,
input wire [7:0] q4,
input wire [7:0] q5,
input wire [7:0] q6,
input wire [7:0] q7,
input wire [2:0] sel,
output reg [7:0] out

);

always @(*) begin
    case(sel)
     3'b000: out = q0;
     3'b001: out = q1;
     3'b010: out = q2;
     3'b011: out = q3;
     3'b100: out = q4;
     3'b101: out = q5;
     3'b110: out = q6;
     3'b111: out = q7;


     default: out = 8'd0;





    endcase



end

endmodule 