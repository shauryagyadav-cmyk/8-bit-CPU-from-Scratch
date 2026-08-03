module reg_tb;

reg [7:0] d;
wire [7:0] q;
reg clk;


register uut(


    .d(d),
    .q(q),
    .clk(clk)
);

initial begin
    $display("Simulation Started!");

    $dumpfile("waves/reg.vcd");
    $dumpvars(0, reg_tb);


     d=8'd4;
     clk = 0;



     #20;
     d=8'd5;


     #20;
     d=8'd6;

     #20;
     d=8'd7;

     #20;
     d=8'd8;
     #20;

     $finish;
end

always begin

    

    #5;
    clk = ~clk;

end

endmodule