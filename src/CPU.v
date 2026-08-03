module CPU (

input clk,
input rst
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
    .halt(halt)      
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
    .Rg(Rg)
);



endmodule