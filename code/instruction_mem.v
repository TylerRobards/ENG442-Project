module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

  // 256 words of instruction memory
  reg [31:0] memory[0:255];

  initial begin
    // Load the code
    $readmemh("program.hex", memory);
  end

  // Word aligned addressing, divide by 4
  assign instruction = memory[addr>>2];

endmodule
