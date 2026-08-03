module control_unit(

    input clk,
    input rst,
    input [3:0] opcode,
    input zero_flag,

    output reg pc_enable,
    output reg ir_load,
    output reg reg_write,

    output reg [3:0] alu_op,
    output reg [2:0] writeback_sel,
    output reg [3:0] imm_op,
    output reg data_mem_write,
    output reg jump_enable,
    output reg flag_we,
    output reg halt

);

reg [2:0] current_state;
reg [2:0] next_state;
reg halted;

//=========================
// State Register
//=========================
always @(posedge clk) begin
    if (rst)
        current_state <= 3'b000;
    else
        current_state <= next_state;
end

//=========================
// Halt Register
//=========================
always @(posedge clk or posedge rst) begin
    if (rst)
        halted <= 1'b0;
    else if (opcode == 4'b1110)
        halted <= 1'b1;
end

//=========================
// Control Logic
//=========================
always @(*) begin

    // Default outputs
    ir_load         = 0;
    pc_enable       = 0;
    reg_write       = 0;
    alu_op          = 4'b0000;
    writeback_sel   = 3'b000;
    imm_op          = 4'b0000;
    data_mem_write  = 0;
    jump_enable     = 0;
    flag_we         = 0;

    halt = halted;

    next_state = current_state;

    // Freeze CPU if halted
    if (halted) begin
        next_state = current_state;
    end
    else begin

        case(current_state)

        //-------------------------
        // FETCH
        //-------------------------
        3'b000: begin
            ir_load   = 1'b1;
            pc_enable = 1'b1;
            next_state = 3'b001;
        end

        //-------------------------
        // DECODE
        //-------------------------
        3'b001: begin
            next_state = 3'b010;
        end

        //-------------------------
        // READ
        //-------------------------
        3'b010: begin
            next_state = 3'b011;
        end

        //-------------------------
        // EXECUTE
        //-------------------------
        3'b011: begin

            case(opcode)

            // ADD
            4'b0000: begin
                alu_op = 4'b0000;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // SUB
            4'b0001: begin
                alu_op = 4'b0001;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // AND
            4'b0010: begin
                alu_op = 4'b0010;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // OR
            4'b0011: begin
                alu_op = 4'b0011;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // XOR
            4'b0100: begin
                alu_op = 4'b0100;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // NOT
            4'b0101: begin
                alu_op = 4'b0101;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // LSL
            4'b0110: begin
                alu_op = 4'b0110;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // LSR
            4'b0111: begin
                alu_op = 4'b0111;
                writeback_sel = 3'd0;
                reg_write = 1;
            end

            // MVI
            4'b1000: begin
                imm_op = 4'b1000;
                writeback_sel = 3'd1;
                reg_write = 1;
            end

            // STR
            4'b1001: begin
                data_mem_write = 1;
            end

            // LDR
            4'b1010: begin
                writeback_sel = 3'd2;
                reg_write = 1;
            end

            // JMP
            4'b1011: begin
                pc_enable = 1;
                jump_enable = 1;
            end

            // CMP
            4'b1100: begin
                alu_op = 4'b1100;
                flag_we = 1;
            end

            // BEQ
            4'b1101: begin
                if (zero_flag) begin
                    pc_enable = 1;
                    jump_enable = 1;
                end
            end

            // HLT
            4'b1110: begin
                // halted register is set in sequential block
            end

            // BNE
            4'b1111: begin
                if (!zero_flag) begin
                    pc_enable = 1;
                    jump_enable = 1;
                end
            end

            default: begin
            end

            endcase

            next_state = 3'b100;
        end

        //-------------------------
        // WRITEBACK
        //-------------------------
        3'b100: begin
            next_state = 3'b000;
        end

        endcase

    end

end

endmodule