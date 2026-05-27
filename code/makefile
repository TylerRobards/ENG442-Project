
run: compile
	vvp riscv_sim

compile:
	iverilog -o riscv_sim tb_riscv_cpu.v riscv_cpu.v control_unit.v alu_control.v alu.v register_file.v imm_gen.v instruction_mem.v data_mem.v
