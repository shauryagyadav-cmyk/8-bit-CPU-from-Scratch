module baud_generator (

 input clk,                    //clk = 10Mhz
                               //baud = 10000 (10000 clock cycles per bit)
 output reg tick

);

reg [13:0] counter;

initial begin
    tick = 0;
    counter = 0;
end
always @(posedge clk) begin


counter <= counter +1;

if (counter == 9999) begin
    tick <= 1;
    counter <= 0;
end

else begin
    tick <= 0;
    
end
end

endmodule 