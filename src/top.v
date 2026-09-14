module top(

    input clk,
    input reset_btn,
    output [5:0] led

);

wire [5:0] pc;

CPU cpu (

    .clk(clk),
    .rst(~reset_btn),
    .debug_pc(pc)

);

assign led = ~pc;

endmodule