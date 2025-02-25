module pc #(
    parameter ADDR_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  reset_n,
    input  logic                  branch_taken,   // Branch control signal
    input  logic [ADDR_WIDTH-1:0] branch_target,  // Branch address
    input  logic                  jal_taken,      // JAL instruction flag
    input  logic [ADDR_WIDTH-1:0] jal_target,     // JAL target address
    output logic [ADDR_WIDTH-1:0] pc              // Program Counter Output
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            pc <= 0;
        else if (branch_taken)
            pc <= branch_target;  // Branch instruction
        else if (jal_taken)
            pc <= jal_target;      // JAL instruction
        else
            pc <= pc + 4;          // Normal instruction execution
    end

endmodule
