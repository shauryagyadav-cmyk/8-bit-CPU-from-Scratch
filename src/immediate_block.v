module immediate_block (

    input [3:0] op,
    
    input [7:0] imm,
    output reg [7:0] write_data
    
);
always @(*) begin
    case(op)
    
    4'b1000: begin //MVI
    write_data = imm;
    
    end

    default: begin
        write_data = 0;

    end
    endcase
end
endmodule