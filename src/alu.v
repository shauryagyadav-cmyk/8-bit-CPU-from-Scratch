module alu
(
    input [7:0] a,
    input [7:0] b,
    input [3:0] op,
    output reg [7:0] result,
    output reg zero_flag

);






always @(*) begin

    result = 8'd0;
    zero_flag = 0;

   

    case(op)

    4'b0000: result = a+b;
    4'b0001: result = a-b;
    4'b0010: result = a&b;
    4'b0011: result = a|b;//OR
    4'b0100: result = a^b;//XOR
    4'b0101: result = ~a;//NOT
    4'b0110: result = a<<1;//LSL
    4'b0111: result = a>>1;//LSR
    4'b1100: begin //CMP
        zero_flag = ( a==b );
    end
    
    default: result = 8'b000;
    endcase






end


   

endmodule