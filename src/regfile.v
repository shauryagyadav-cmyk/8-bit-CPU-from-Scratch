module regfile
(
  input clk,
  input [7:0] write_data,
  input [2:0] read_address_mem,
  input [2:0] read_address0,
  input [2:0] read_address1,
  input [2:0] Rg,
  input write_enable,
  input [2:0] write_address,
  output wire [7:0] read_data0,
  output wire [7:0] read_data1,
  output wire [7:0] mem_data,
  output wire [7:0] memory_address


);

wire [7:0] we;
wire [7:0] q0;
wire [7:0] q1;
wire [7:0] q2;
wire [7:0] q3;
wire [7:0] q4;
wire [7:0] q5;
wire [7:0] q6;
wire [7:0] q7;


decoder dec(

  .enable(write_enable),

  .in(write_address),
  .out(we)
);
register reg0(

   .d(write_data),
   .clk(clk),
   .we(we[0]),
   .q(q0)
   
);

register reg1(

   .d(write_data),
   .clk(clk),
   .we(we[1]),
   .q(q1)
   
);
register reg2(

   .d(write_data),
   .clk(clk),
   .we(we[2]),
   .q(q2)
   
);

register reg3(

   .d(write_data),
   .clk(clk),
   .we(we[3]),
   .q(q3)
   
);
register reg4(

   .d(write_data),
   .clk(clk),
   .we(we[4]),
   .q(q4)
   
);
register reg5(

   .d(write_data),
   .clk(clk),
   .we(we[5]),
   .q(q5)
   
);
register reg6(

   .d(write_data),
   .clk(clk),
   .we(we[6]),
   .q(q6)
   
);

register reg7(

   .d(write_data),
   .clk(clk),
   .we(we[7]),
   .q(q7)
   
);



mux mux0
(
 .q0(q0),
 .q1(q1),
 .q2(q2),
 .q3(q3),
 .q4(q4),
 .q5(q5),
 .q6(q6),
 .q7(q7),
 .sel(read_address0),
 .out(read_data0)

);

mux mux1
(
 .q0(q0),
 .q1(q1),
 .q2(q2),
 .q3(q3),
 .q4(q4),
 .q5(q5),
 .q6(q6),
 .q7(q7),
 .sel(read_address1),
 .out(read_data1)

);

mux mux2
(
 .q0(q0),
 .q1(q1),
 .q2(q2),
 .q3(q3),
 .q4(q4),
 .q5(q5),
 .q6(q6),
 .q7(q7),
 .sel(read_address_mem),
 .out(mem_data)

);
mux mux3
(
 .q0(q0),
 .q1(q1),
 .q2(q2),
 .q3(q3),
 .q4(q4),
 .q5(q5),
 .q6(q6),
 .q7(q7),
 .sel(Rg),
 .out(memory_address)

);

endmodule