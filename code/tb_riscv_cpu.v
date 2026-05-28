`timescale 1ns / 1ps

module tb_riscv_cpu;

   reg clk;
   reg reset;

   riscv_cpu uut (
                  .clk(clk),
                  .reset(reset)
                  );

   // Clock generation: 10 ns period = 100 MHz
   initial begin
      clk = 1'b0;
      forever #5 clk = ~clk;
   end

   integer i; // For for loop

   initial begin
      // Start simulation
      reset = 1'b1;

      #20;
      reset = 1'b0;

      // Run for enough cycles to execute the test program
      #300;

      // Display register values
      
      for (i = 0; i < 10; i = i + 1) begin
         $display("x%1d = %d", i, uut.regs.registers[i]);
      end
      for (i = 10; i < 32; i = i + 1) begin
         $display("x%2d = %d", i, uut.regs.registers[i]);
      end
      $display("memory[0] = %d", uut.dmem.memory[0]);

      $finish;
   end

endmodule
