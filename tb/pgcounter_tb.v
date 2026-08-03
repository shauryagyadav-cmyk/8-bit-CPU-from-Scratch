module pgcounter_tb;

reg clk;
reg jump;
reg reset;
reg [7:0] jump_address;
wire [7:0] pc;

pgcounter uut 
(

    .clk(clk),
    .jump(jump),
    .reset(reset),
    .jump_address(jump_address),
    .pc(pc)

);

initial begin

   $display("Simulation Started!");
   $dumpfile("waves/pgcounter.vcd");
   $dumpvars(0, pgcounter_tb);

   clk = 0;
   jump = 0;
   jump_address = 0;
   reset = 0;

   #20;
   jump = 1'b1;

   jump_address = 8'd4;

   #20;
   jump = 1'b0;

   reset = 1'b1;

   #20;
   reset = 1'b0;
   #20;

   $finish;






end


always begin


    #5;
    clk = ~clk; 
end


endmodule