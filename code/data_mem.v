module data_memory (
                    // Inputs
                    input wire         clk,
                    input wire         mem_write,
                    input wire         mem_read,
                    input wire [31:0]  addr,
                    input wire [31:0]  write_data,
                    // Outputs
                    output wire [31:0] read_data
                    );

   // 256 words of data memory
   reg [31:0] memory [0:255];
   
   integer    i; // For for loop

   initial begin
      for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'd0;
   end

   // Write to memory (sync)
   always @(posedge clk) begin
      if (mem_write)
        memory[addr[31:2]] <= write_data;
   end

   // Read from memory (async)
   assign read_data = (mem_read) ? memory[addr[31:2]] : 32'd0;

endmodule
