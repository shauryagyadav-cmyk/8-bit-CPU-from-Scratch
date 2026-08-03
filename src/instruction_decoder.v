module instruction_decoder (
    input [15:0] instruction,
    
    output [3:0] opcode,
    output reg [2:0] RS1,
    output reg [2:0] RS2,
    output reg [2:0] Rd,
    output reg [2:0] rsv,
    output reg [7:0] imm,
    output reg [2:0] Reg,
    output reg [2:0] Rg,
    output reg [5:0] jump_address
);

    
    assign opcode = instruction[15:12];

    always @(*) begin
        
        Rd          = 3'b000;
        RS1         = 3'b000;
        RS2         = 3'b000;
        rsv         = 3'b000;
        imm         = 8'b00000000;
        Reg         = 3'b000;
        

        case (instruction[15:12])
            4'b1001: begin //STR
                Reg         = instruction[11:9];
                Rg = instruction[8:6];
            end
            4'b1010: begin //LDR
                Rd        = instruction[11:9];
                Rg = instruction[8:6];
            end
            4'b1011: begin //JMP
                jump_address = instruction[11:6];
            end
            4'b1100: begin //CMP
                RS1 = instruction[11:9];
                RS2 = instruction[8:6];
            end
            4'b1101: begin //BEQ
                jump_address = instruction[11:6];
            end
            4'b1111: begin //BNE
                jump_address = instruction[11:6];
            end

            default: begin
                Rd  = instruction[11:9];
                RS1 = instruction[8:6];
                RS2 = instruction[5:3];
                rsv = instruction[2:0];
                imm = instruction[8:1];
            end
        endcase
    end

endmodule