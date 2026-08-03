module register 
(
  input [7:0] d,
  input clk,
  input we,
  output reg [7:0] q
   
  


);

always @(posedge clk) begin

  if (we) begin

    q <=d;
end

end


endmodule

