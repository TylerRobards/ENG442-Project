module register_file (
                      // Inputs
                      input wire         clk,
                      input wire         reset,
                      input wire [4:0]   rs1,
                      input wire [4:0]   rs2,
                      input wire [4:0]   rd,
                      input wire [31:0]  write_data,
                      input wire         reg_write,
                      // Outputs
                      output wire [31:0] read_data1,
                      output wire [31:0] read_data2
                      );

   reg [31:0] registers [0:31];

   integer    i;
   
   // async reads
   assign read_data1 = registers[rs1];
   assign read_data2 = registers[rs2];

   // sync writes
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         // Reset all registers
         for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'd0;
         end
      end else begin
         // Write to register
         if (reg_write) begin
            registers[rd] <= write_data;
         end
         // x0 must always remain zero
         registers[0] <= 32'd0;
      end
   end

endmodule
