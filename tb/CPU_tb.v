module CPU_tb ;

reg clk;
reg rst;

CPU uut (

    .clk(clk),
    .rst(rst)
);

initial begin
    $display("Simulation Started!");
    $dumpfile("waves/CPU.vcd");
$dumpvars(0, CPU_tb.uut);

    clk = 0;
    rst = 1;

    uut.reg_file.reg3.q = 8'd12;
    uut.reg_file.reg1.q = 8'd15;
    uut.reg_file.reg2.q = 8'd13;
    uut.reg_file.reg0.q = 8'd0;
    uut.reg_file.reg5.q = 8'd69;
    uut.reg_file.reg4.q = 8'd67;
    uut.reg_file.reg6.q = 8'd11;
    uut.reg_file.reg7.q = 8'd0; 

    #20;
    rst = 0;

    #1500;
    $display("finished!");
    $finish;
end
always begin


    #5;
    clk = ~clk; 
end




endmodule