module immediate_generator (
                            // Inputs
                            input wire [31:0] instruction,
                            // Outputs
                            output reg [31:0] immediate
                            );

   wire [6:0] opcode;
   assign opcode = instruction[6:0];

   localparam OPCODE_ITYPE  = 7'b0010011; // addi
   localparam OPCODE_LOAD   = 7'b0000011; // lw
   localparam OPCODE_STORE  = 7'b0100011; // sw
   localparam OPCODE_BRANCH = 7'b1100011; // beq
   localparam OPCODE_JAL    = 7'b1101111; // jal

   always @(*) begin
      case (opcode)

        // I-type: addi, lw
        OPCODE_ITYPE,
        OPCODE_LOAD: begin
           immediate = {{20{instruction[31]}}, instruction[31:20]};
        end

        // S-type: sw
        OPCODE_STORE: begin
           immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end

        // B-type: beq
        // Immediate layout: imm[12|10:5|4:1|11] [0]
        // Need to add the 1'b0 so it is a multiple of 2
        OPCODE_BRANCH: begin
           immediate = {{19{instruction[31]}}, // Sign extedn
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};
        end

        // J-type: jal
        // Immediate layout: imm[20|10:1|11|19:12] [0]
        OPCODE_JAL: begin
           immediate = {{11{instruction[31]}}, // Sign extend
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0};
        end

        default: begin
           // might cause problems if the ALU outputs somthing weird for non-immediate instructions, probably not though
           immediate = 32'd0;
        end

      endcase
   end

endmodule
