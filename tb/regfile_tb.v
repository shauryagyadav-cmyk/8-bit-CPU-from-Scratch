module regfile_tb;

reg clk;
reg [7:0] write_data;
reg [2:0] read_address;
reg write_enable;
reg [2:0] write_address;
wire [7:0] read_data;

regfile uut (


    .clk(clk), 
    .write_data(write_data),
    .write_address(write_address),
    .read_address(read_address),
    .read_data(read_data),
    .write_enable(write_enable)
);

initial begin

$display("Simulation Started!");
$dumpfile("waves/regfile.vcd");
$dumpvars(0, regfile_tb);

clk = 0;
write_enable = 0;
write_data = 0;
write_address = 0;
read_address = 0;

#20;

write_enable =1;
write_address = 3'd4;
write_data = 8'd9;

@(posedge clk);
#1;

write_enable =0;
read_address = 3'd4;

#10;

write_enable =1;
write_address = 3'd2;
write_data = 8'd10;
 
@(posedge clk);
#1;

write_enable = 0;

read_address = 3'd2;
#20;



$finish;



    
end
always begin

    #5;
    clk = ~clk; 
end




endmodule

