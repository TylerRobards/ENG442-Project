module control_unit (
                     // Inputs
                     input wire [6:0] opcode,
                     // Outputs
                     output reg       reg_write,
                     output reg       mem_write,
                     output reg       mem_read,
                     output reg       alu_src,
                     output reg       mem_to_reg,
                     output reg       branch,
                     output reg       jump,
                     output reg [1:0] alu_op
                     );

   // RV32I opcodes needed
   localparam OPCODE_RTYPE = 7'b0110011; // add, sub (determined by funct7)
   localparam OPCODE_ITYPE = 7'b0010011; // addi
   localparam OPCODE_LOAD  = 7'b0000011; // lw
   localparam OPCODE_STORE = 7'b0100011; // sw
   localparam OPCODE_BRANCH= 7'b1100011; // beq
   localparam OPCODE_JAL   = 7'b1101111; // jal

   always @(*) begin
      // Default values
      reg_write = 1'b0;
      mem_write = 1'b0;
      mem_read  = 1'b0;
      alu_src   = 1'b0;
      mem_to_reg = 1'b0;
      branch    = 1'b0;
      jump      = 1'b0;
      alu_op    = 2'b00;

      case (opcode)
        OPCODE_RTYPE: begin 
           reg_write = 1'b1;
           alu_src = 1'b0;
           alu_op = 2'b10;
        end

        OPCODE_ITYPE: begin
           reg_write = 1'b1;
           alu_src = 1'b1;
           alu_op = 2'b00;
        end

        OPCODE_LOAD: begin
           reg_write = 1'b1;
           mem_read = 1'b1;
           alu_src = 1'b1;
           mem_to_reg = 1'b1;
           alu_op = 2'b00;
        end

        OPCODE_STORE: begin
           mem_write = 1'b1;
           alu_src = 1'b1;
           alu_op = 2'b00;
        end

        OPCODE_BRANCH: begin
           branch = 1'b1;
           alu_src = 1'b0;
           alu_op = 2'b01;
        end

        OPCODE_JAL: begin
           reg_write = 1'b1;
           jump = 1'b1;
        end

        default: begin
           // Unsupported instruction: show error
           $display("ERROR: Unsupported instruction in control_unit.v.");
           $display("    opcode was: %d", opcode);
        end
      endcase
   end
endmodule
