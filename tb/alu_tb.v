module alu_tb;


reg [7:0] a;
reg [7:0] b;
reg [2:0] op;
 
wire [7:0] result;

alu uut (

    

 .a(a),
 .b(b),
 .op(op),
 .result(result)


);


initial begin 
    $display("Simulation started!");

    $dumpfile("waves/alu.vcd"); //creates a waveform file
    $dumpvars(0, alu_tb); //records all the signals
    a = 8'd10;
    b = 8'd5;
    op = 3'b000;
   
    #10;
    op=3'b001;
    #10;
    op=3'b010;
    #10;
    op=3'b011;
    #10;
    op=3'b100;
    #10;
    

    $finish;
end 















endmodule