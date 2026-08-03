module Data_memory (
    input clk,
    
    input [7:0] write_data,
    input [7:0] mem_address,
    input write_enable,
    
    output reg [7:0] read_data 
);
reg [7:0] memory [7:0];  

always @(posedge clk) begin
    if (write_enable)
        memory[mem_address] <= write_data;
end

always @(*) begin
    read_data = memory[mem_address];
end

endmodule