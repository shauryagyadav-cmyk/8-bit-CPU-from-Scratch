module regfile (

    input clk,
    input rst,

    // Register write
    input [2:0] write_address,
    input [7:0] write_data,
    input write_enable,

    // Normal register reads
    input [2:0] read_address0,
    input [2:0] read_address1,
    output [7:0] read_data0,
    output [7:0] read_data1,

    // Memory-related register access
    input [2:0] read_address_mem,
    output [7:0] mem_data,
    output [7:0] memory_address,

    input [2:0] Rg,

    // Debug outputs
    output [7:0] debug_R0,
    output [7:0] debug_R1,
    output [7:0] debug_R2,
    output [7:0] debug_R3,
    output [7:0] debug_R4,
    output [7:0] debug_R5,
    output [7:0] debug_R6,
    output [7:0] debug_R7

);


// ============================================================
// Register storage
// ============================================================

wire [7:0] q0;
wire [7:0] q1;
wire [7:0] q2;
wire [7:0] q3;
wire [7:0] q4;
wire [7:0] q5;
wire [7:0] q6;
wire [7:0] q7;


// ============================================================
// One-hot write enable
// ============================================================

wire [7:0] we;

assign we = write_enable ? (8'b00000001 << write_address) : 8'b00000000;


// ============================================================
// Registers
// ============================================================

register reg0 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[0]),
    .q(q0)
);

register reg1 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[1]),
    .q(q1)
);

register reg2 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[2]),
    .q(q2)
);

register reg3 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[3]),
    .q(q3)
);

register reg4 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[4]),
    .q(q4)
);

register reg5 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[5]),
    .q(q5)
);

register reg6 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[6]),
    .q(q6)
);

register reg7 (
    .d(write_data),
    .clk(clk),
    .rst(rst),
    .we(we[7]),
    .q(q7)
);


// ============================================================
// Register read multiplexer
// ============================================================

assign read_data0 =
    (read_address0 == 3'd0) ? q0 :
    (read_address0 == 3'd1) ? q1 :
    (read_address0 == 3'd2) ? q2 :
    (read_address0 == 3'd3) ? q3 :
    (read_address0 == 3'd4) ? q4 :
    (read_address0 == 3'd5) ? q5 :
    (read_address0 == 3'd6) ? q6 :
                              q7;


assign read_data1 =
    (read_address1 == 3'd0) ? q0 :
    (read_address1 == 3'd1) ? q1 :
    (read_address1 == 3'd2) ? q2 :
    (read_address1 == 3'd3) ? q3 :
    (read_address1 == 3'd4) ? q4 :
    (read_address1 == 3'd5) ? q5 :
    (read_address1 == 3'd6) ? q6 :
                              q7;


// ============================================================
// Memory-related register access
// ============================================================

assign mem_data =
    (read_address_mem == 3'd0) ? q0 :
    (read_address_mem == 3'd1) ? q1 :
    (read_address_mem == 3'd2) ? q2 :
    (read_address_mem == 3'd3) ? q3 :
    (read_address_mem == 3'd4) ? q4 :
    (read_address_mem == 3'd5) ? q5 :
    (read_address_mem == 3'd6) ? q6 :
                                 q7;


assign memory_address = Rg == 3'd0 ? q0 :
                        Rg == 3'd1 ? q1 :
                        Rg == 3'd2 ? q2 :
                        Rg == 3'd3 ? q3 :
                        Rg == 3'd4 ? q4 :
                        Rg == 3'd5 ? q5 :
                        Rg == 3'd6 ? q6 :
                                     q7;


// ============================================================
// Debug outputs
// ============================================================

assign debug_R0 = q0;
assign debug_R1 = q1;
assign debug_R2 = q2;
assign debug_R3 = q3;
assign debug_R4 = q4;
assign debug_R5 = q5;
assign debug_R6 = q6;
assign debug_R7 = q7;


endmodule