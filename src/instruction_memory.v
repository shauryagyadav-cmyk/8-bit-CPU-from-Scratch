module instruction_memory
(
  input [5:0] address,
  output reg [15:0] instruction

);

reg [15:0] memory [0:63];
initial begin 

    $readmemb("Assembler/output.bin", memory);
end

always @(*) begin
    instruction = memory[address]; 
end


endmodule