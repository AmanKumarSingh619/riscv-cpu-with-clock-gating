module alu #(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0] operand_a,  // Input A (rs1)
    input  logic [DATA_WIDTH-1:0] operand_b,  // Input B (rs2 or immediate)
    input  logic [3:0]            alu_ctrl,   // ALU Control Signal
    output logic [DATA_WIDTH-1:0] alu_result, // ALU Output
    output logic                  zero        // Zero Flag (For Branch)
);

    always_comb begin
        case (alu_ctrl)
            4'b0000: alu_result = operand_a + operand_b;  // ADD
            4'b0001: alu_result = operand_a - operand_b;  // SUB
            4'b0010: alu_result = operand_a & operand_b;  // AND
            4'b0011: alu_result = operand_a | operand_b;  // OR
            4'b0100: alu_result = operand_a ^ operand_b;  // XOR
            4'b0101: alu_result = ($signed(operand_a) < $signed(operand_b)) ? 1 : 0; // SLT (signed)
            4'b0110: alu_result = (operand_a < operand_b) ? 1 : 0; // SLTU (unsigned)
            default: alu_result = 0; // Default Case
        endcase
    end

    // Zero Flag: Set when alu_result is 0 (Used for branch instructions)
    assign zero = (alu_result == 0) ? 1 : 0;

endmodule