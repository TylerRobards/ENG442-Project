`timescale 1ns / 1ps

// Single-Cycle RV32I CPU
// Supports: add, sub, addi, lw, sw, beq, jal

module riscv_cpu (
                   input wire clk,
                   input wire reset
                  );

   // Program counter
   reg [31:0] pc;

   wire [31:0] pc_plus_4;
   assign pc_plus_4 = pc + 32'd4;

   // Instruction Fetch
   wire [31:0] instruction;

   instruction_memory imem (.addr(pc), .instruction(instruction));

   // Instruction fields
   wire [6:0] opcode;
   wire [4:0] rd;
   wire [2:0] funct3;
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [6:0] funct7;

   assign opcode = instruction[6:0];
   assign rd     = instruction[11:7];
   assign funct3 = instruction[14:12];
   assign rs1    = instruction[19:15];
   assign rs2    = instruction[24:20];
   assign funct7 = instruction[31:25];

   // Control signals
   wire reg_write;
   wire mem_write;
   wire mem_read;
   wire alu_src;
   wire mem_to_reg;
   wire branch;
   wire jump;
   wire [1:0] alu_op;

   control_unit control (.opcode(opcode),
                         .reg_write(reg_write),
                         .mem_write(mem_write),
                         .mem_read(mem_read),
                         .alu_src(alu_src),
                         .mem_to_reg(mem_to_reg),
                         .branch(branch),
                         .jump(jump),
                         .alu_op(alu_op)
                         );

   // Register File
   wire [31:0] reg_data1;
   wire [31:0] reg_data2;
   wire [31:0] write_back_data;

   register_file regs (.clk(clk),
                       .reset(reset),
                       .rs1(rs1),
                       .rs2(rs2),
                       .rd(rd),
                       .write_data(write_back_data),
                       .reg_write(reg_write),
                       .read_data1(reg_data1),
                       .read_data2(reg_data2)
                       );

   // Immediate generator
   wire [31:0] immediate;
   
   immediate_generator imm_gen (.instruction(instruction), .immediate(immediate));

   // ALU Control
   wire [3:0] alu_control_signal;
   alu_control alu_ctrl (.alu_op(alu_op),
                         .funct3(funct3),
                         .funct7(funct7),
                         .alu_control_signal(alu_control_signal)
                         );

   // ALU
   wire [31:0] alu_input_b;
   wire [31:0] alu_result;
   wire        zero;

   assign alu_input_b = (alu_src) ? immediate : reg_data2;
   alu alu_unit (.a(reg_data1),
                 .b(alu_input_b),
                 .alu_control_signal(alu_control_signal),
                 .result(alu_result),
                 .zero(zero)
                 );

   // Data Memory
   wire [31:0] memory_read_data;

   data_memory dmem (.clk(clk),
                     .mem_write(mem_write),
                     .mem_read(mem_read),
                     .addr(alu_result),
                     .write_data(reg_data2),
                     .read_data(memory_read_data)
                     );

   // Writeback MUX
   // For jal, rd receives PC + 4.
   // For lw, rd receives data memory output.
   // Otherwise, rd receives ALU result.
   // Plain code, cause the ternary expressions are hard to read:
   // if jump:
   //     write_back_data = pc_plus_4
   // else if mem_to_reg:
   //     write_back_data = memory_read_data
   // else:
   //     write_back_data = alu_result
   assign write_back_data = (jump) ? pc_plus_4 : ((mem_to_reg) ? memory_read_data : alu_result);


   // Next PC Logic
   wire branch_taken;
   wire [31:0] branch_target;
   wire [31:0] jump_target;
   wire [31:0] next_pc;

   assign branch_taken = branch && zero;
   assign branch_target = pc + immediate;
   assign jump_target = pc + immediate;

   // Plain code again, why doesnt verilog let us do this?
   // if jump:
   //     next_pc = jump_target
   // else if branch_taken:
   //     next_pc = branch_target
   // else:
   //     next_pc = pc_plus_4
   assign next_pc = (jump) ? jump_target : ((branch_taken) ? branch_target : pc_plus_4);

   // PC register update
   always @(posedge clk or posedge reset) begin
      if (reset)
        pc <= 32'd0;
      else
        pc <= next_pc;
   end

endmodule
