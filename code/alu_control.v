module alu_control (
                    // Inputs
                    input wire [1:0] alu_op,
                    input wire [2:0] funct3,
                    input wire [6:0] funct7,
                    // Outputs
                    output reg [3:0] alu_control_signal
                    );

   localparam ALU_ADD = 4'b0010;
   localparam ALU_SUB = 4'b0110;

   always @(*) begin
      case (alu_op)
        2'b00: begin // Used for addi, lw, sw
           alu_control_signal = ALU_ADD;
        end
        2'b01: begin // Used for beq
           alu_control_signal = ALU_SUB;
        end
        2'b10: begin // Used for R-type instructions
           case ({funct7, funct3})
             {7'b0000000, 3'b000}: // add
               alu_control_signal = ALU_ADD;
             {7'b0100000, 3'b000}: // sub
               alu_control_signal = ALU_SUB;
             default: // Default to add, this should not happen though
               alu_control_signal = ALU_ADD;
           endcase
        end
        default: begin // Default to add, this should not happen though
           alu_control_signal = ALU_ADD;
        end
      endcase
   end
endmodule
