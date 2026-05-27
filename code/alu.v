module alu (
            // Inputs
            input wire [31:0] a,
            input wire [31:0] b,
            input wire [3:0]  alu_control_signal,
            // outputs
            output reg [31:0] result,
            output wire       zero
            );
   
   localparam ALU_ADD = 4'b0010;
   localparam ALU_SUB = 4'b0110;

   always @(*) begin
      case (alu_control_signal)
        ALU_ADD: begin // Do add if control signal says to
           result = a + b;
        end

        ALU_SUB: begin // Do sub if control signal says to
           result = a - b;
        end

        default: begin // return zero otherwise
           result = 32'd0;
        end

      endcase
   end

   assign zero = (result == 32'd0); // zero flag

endmodule
