module alu_control (
    input  logic [6:0]  opcode,   // Opcode field from instruction
    input  logic [2:0]  funct3,   // Funct3 field from instruction
    input  logic [6:0]  funct7,   // Funct7 field from instruction
    output logic [3:0]  alu_ctrl  // ALU Control Signal Output
);

    always_comb begin
        case (opcode)
            7'b0110011: begin  // R-Type Instructions
                case (funct3)
                    3'b000: alu_ctrl = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB if funct7=0100000, else ADD
                    3'b111: alu_ctrl = 4'b0010; // AND
                    3'b110: alu_ctrl = 4'b0011; // OR
                    3'b100: alu_ctrl = 4'b0100; // XOR
                    3'b010: alu_ctrl = 4'b0101; // SLT
                    3'b011: alu_ctrl = 4'b0110; // SLTU
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            7'b0000011, 7'b0100011: alu_ctrl = 4'b0000; // LW, SW (use ADD)
            7'b1100011: alu_ctrl = 4'b0001; // BEQ, BNE (use SUB)
            default: alu_ctrl = 4'b0000; // Default to ADD
        endcase
    end

endmodule