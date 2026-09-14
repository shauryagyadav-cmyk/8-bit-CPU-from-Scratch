module writeback_mux(
    
    input [2:0] sel,
    
    input [7:0] alu_data,
    input [7:0] imm_data,
    input [7:0] mem_data,
    
    output reg [7:0] write_data
);

always @(*) begin

    // Default
    write_data = 8'b0;

    case(sel)

        3'd0: begin
            write_data = alu_data;
        end

        3'd1: begin
            write_data = imm_data;
        end

        3'd2: begin
            write_data = mem_data;
        end

        default: begin
            write_data = 8'b0;
        end

    endcase

end

endmodule