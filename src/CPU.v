module CPU (

input clk,
input rst,
input CPU_enable,
output [5:0] debug_pc,
output [15:0] debug_instruction,
output debug_JMP,
output debug_REG_write,
output debug_MEM_write,
output [7:0] debug_MEM_address,
output [7:0] debug_MEM_data,
output [7:0] debug_ALU_result,
output [3:0] debug_ALU_opcode,
output [7:0] debug_R0,
  output [7:0] debug_R1,
  output [7:0] debug_R2,
  output [7:0] debug_R3,
  output [7:0] debug_R4,
  output [7:0] debug_R5,
  output [7:0] debug_R6,
  output [7:0] debug_R7,
  output debug_instruction_done,
  output [2:0] debug_state,
  output [2:0] debug_next_state,
  output debug_halted


);




wire [5:0] pc_address;
wire [15:0] instruction;
wire ir_load;
wire pc_enable;
wire [3:0] alu_op;
wire [3:0] opcode;
wire [15:0] instruction_decode;
wire [2:0] read_address0;
wire [2:0] read_address1;
wire [7:0] alu_a;
wire [7:0] alu_b;
wire [2:0] write_address;
wire [7:0] write_data;
wire write_enable;
wire [7:0] data_reg;
wire [7:0] mem_address;
wire write_mem;
wire [2:0] mem_reg;
wire [7:0] mem_data;

wire [2:0] writeback_sel;

wire [7:0] wire1;
wire [7:0] wire2;
wire [7:0] wire3;
wire [3:0] imm_op;
wire [2:0] Rg;
wire [5:0] jump_address;
wire jump_enable;
wire flag_we;
wire flag;
wire zero_flag;
wire halt;


assign debug_pc = pc_address;
assign debug_instruction = instruction_decode;
assign debug_JMP         = jump_enable;
assign debug_REG_write   = write_enable;
assign debug_MEM_write   = write_mem;
assign debug_MEM_address = mem_address;
assign debug_MEM_data    = data_reg;
assign debug_ALU_result  = wire1;
assign debug_ALU_opcode  = alu_op;



flag_register flag_reg(

    .clk(clk),
    .rst(rst),
    .zero_in(flag),
    .we(flag_we),
    .zero_out(zero_flag)
);



program_counter pc (
    .clk(clk),  
    .reset(rst),
    .pc(pc_address),
    .pc_enable(pc_enable),
    .jump_address(jump_address),
    .jump(jump_enable),
    .halt(halt)
    


);

instruction_memory instruction_memory0 (
    .address(pc_address),
    .instruction(instruction)
);

instruction_register instruction_register0 (
    .clk(clk),
    .instruction(instruction),
    .ir_load(ir_load),
    .ir(instruction_decode)
);
control_unit control_unit0 (
    .clk(clk),
    .rst(rst),
    .opcode(opcode),           
    .pc_enable(pc_enable),     
    .ir_load(ir_load),         
    .reg_write(write_enable),  
    .alu_op(alu_op),
    .writeback_sel(writeback_sel),
    .imm_op(imm_op),
    .data_mem_write(write_mem),
    .jump_enable(jump_enable),
    .flag_we(flag_we),
    .zero_flag(zero_flag),
    .halt(halt),
    .CPU_enable(CPU_enable),
    .instruction_done(debug_instruction_done),
    .debug_state(debug_state),
    .debug_next_state(debug_next_state),
    .debug_halted(debug_halted)
);

writeback_mux mux1(

    .sel(writeback_sel),
    
    .alu_data(wire1),
    
    .imm_data(wire2),

    .mem_data(mem_data),
    
    .write_data(write_data)
);
immediate_block imm_block (

    .op(imm_op),
    
    .imm(wire3),
    .write_data(wire2)
    
);

alu alu0 (
    .op(alu_op),
    .a(alu_a),
    .b(alu_b),
    .result(wire1),
    .zero_flag(flag)

);
instruction_decoder decoder1 (

    .instruction(instruction_decode),
    .opcode(opcode), 
    .RS1(read_address0),
    .RS2(read_address1),
    .Rd(write_address),
    .imm(wire3),
    .rsv(),
    .jump_address(jump_address),
    .Reg(mem_reg),
    .Rg(Rg)
);
Data_memory data_memory0 (

    .clk(clk),
    .write_data(data_reg),
    .mem_address(mem_address),
    .write_enable(write_mem),
    .read_data(mem_data)
);
regfile reg_file (
    .clk(clk),
    .rst(rst),

    .write_address(write_address),
    .read_address0(read_address0),
    .read_address1(read_address1),

    .read_data0(alu_a),
    .read_data1(alu_b),

    .write_data(write_data),
    .write_enable(write_enable),

    .read_address_mem(mem_reg),
    .mem_data(data_reg),
    .memory_address(mem_address),

    .Rg(Rg),

    .debug_R0(debug_R0),
    .debug_R1(debug_R1),
    .debug_R2(debug_R2),
    .debug_R3(debug_R3),
    .debug_R4(debug_R4),
    .debug_R5(debug_R5),
    .debug_R6(debug_R6),
    .debug_R7(debug_R7)
);



endmodule