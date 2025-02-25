module instr_fetch #(
    parameter ADDR_WIDTH = 32,
    parameter INSTR_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  reset_n,
    input  logic                  branch_taken,   // Branch control signal
    input  logic [ADDR_WIDTH-1:0] branch_target,  // Branch address
    output logic [ADDR_WIDTH-1:0] pc,             // Program Counter Output
    output logic [INSTR_WIDTH-1:0] instr          // Instruction Output
);

    // Internal PC Register
    logic [ADDR_WIDTH-1:0] pc_internal;

    // Instantiate Program Counter
    pc #(.ADDR_WIDTH(ADDR_WIDTH)) PC_UNIT (
        .clk(clk),
        .reset_n(reset_n),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .pc(pc_internal) // Internal PC value
    );

    // Instantiate Instruction Memory
    instr_mem #(.ADDR_WIDTH(ADDR_WIDTH), .INSTR_WIDTH(INSTR_WIDTH)) IMEM (
        .pc(pc_internal),
        .instr(instr) // Output instruction
    );

    // Assign the internal PC to output
    assign pc = pc_internal;

endmodule