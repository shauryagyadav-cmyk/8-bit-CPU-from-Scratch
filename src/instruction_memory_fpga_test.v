module instruction_memory_fpga
(
    input [5:0] address,
    output reg [15:0] instruction
);

reg [15:0] memory [0:63];

initial begin
    memory[0] = 16'b1000000000110010; // MVI R0 25
    memory[1] = 16'b1000001000001110; // MVI R1 7
    memory[2] = 16'b1000010011001000; // MVI R2 100
    memory[3] = 16'b1000011000000110; // MVI R3 3

    memory[4] = 16'b0000100000001000; // ADD R4 R0 R1
    memory[5] = 16'b0001101000001000; // SUB R5 R0 R1
    memory[6] = 16'b0010110000001000; // AND R6 R0 R1
    memory[7] = 16'b0011110000001000; // OR R6 R0 R1
    memory[8] = 16'b0100110000001000; // XOR R6 R0 R1
    memory[9] = 16'b0101111001000000; // NOT R7 R1

    memory[10] = 16'b0110101011000000; // LSL R5 R3
    memory[11] = 16'b0111101101000000; // LSR R5 R5
    memory[12] = 16'b1001100011000000; // STR R4 R3
    memory[13] = 16'b1000100000000000; // MVI R4 0
    memory[14] = 16'b1010100011000000; // LDR R4 R3

    memory[15] = 16'b1100100100000000; // CMP R4 R4
    memory[16] = 16'b1101010010000000; // BEQ 18

    memory[17] = 16'b1000110111111110; // MVI R6 255
    memory[18] = 16'b1100000001000000; // CMP R0 R1
    memory[19] = 16'b1111010101000000; // BNE 21

    memory[20] = 16'b1000111011110110; // MVI R7 123
    memory[21] = 16'b0000010100101000; // ADD R2 R4 R5
    memory[22] = 16'b0001010010001000; // SUB R2 R2 R1
    memory[23] = 16'b0010010010000000; // AND R2 R2 R0
    memory[24] = 16'b0011010010011000; // OR R2 R2 R3
    memory[25] = 16'b0100010010001000; // XOR R2 R2 R1
    memory[26] = 16'b1001010000000000; // STR R2 R0
    memory[27] = 16'b1010110000000000; // LDR R6 R0
    memory[28] = 16'b1100110010000000; // CMP R6 R2
    memory[29] = 16'b1101011111000000; // BEQ 31
    memory[30] = 16'b1000101010110000; // MVI R5 88
    memory[31] = 16'b1011100001000000; // JMP 33
    memory[32] = 16'b1000000110111100; // MVI R0 222
    memory[33] = 16'b1110000000000000; // HLT
end

always @(*) begin
    instruction = memory[address];
end

endmodule