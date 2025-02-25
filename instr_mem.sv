module instr_mem #(
    parameter ADDR_WIDTH = 32,
    parameter INSTR_WIDTH = 32,
    parameter MEM_DEPTH = 256  // Number of instructions
)(
    input  logic [ADDR_WIDTH-1:0] pc,   // Program Counter Input
    output logic [INSTR_WIDTH-1:0] instr // Instruction Output
);

    // Instruction Memory (Array)
    logic [INSTR_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize Instruction Memory with Sample RISC-V Instructions
    initial begin
    mem[0] = 32'h00000093; // ADDI x1, x0, 0
    mem[1] = 32'h00100113; // ADDI x2, x0, 1
    mem[2] = 32'h002081b3; // ADD  x3, x1, x2
    mem[3] = 32'h00310223; // SW   x3, 0(x2)
    mem[4] = 32'h0000006f; // JUMP
    mem[5] = 32'hFE000EE3; // BEQ x0, x0, -4 (Loop)
end

    // Read instruction at the given PC address
    assign instr = mem[pc >> 2]; // Convert byte address to word index

endmodule