module control_unit (
    input  logic [6:0]  opcode,    // Opcode field from instruction
    output logic        RegWrite,  // Register Write Enable
    output logic        ALUSrc,    // ALU Source Selection
    output logic        MemRead,   // Memory Read Enable
    output logic        MemWrite,  // Memory Write Enable
    output logic        MemtoReg,  // Memory to Register Selection
    output logic        Branch,    // Branch Signal
    output logic [1:0]  ALUOp      // ALU Operation Selection
);

    always_comb begin
        case (opcode)
            7'b0110011: begin // R-Type Instructions
                RegWrite = 1;
                ALUSrc   = 0;
                MemRead  = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end
            7'b0000011: begin // Load (LW)
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                MemWrite = 0;
                MemtoReg = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            7'b0100011: begin // Store (SW)
                RegWrite = 0;
                ALUSrc   = 1;
                MemRead  = 0;
                MemWrite = 1;
                MemtoReg = 0; // X (Don't Care)
                Branch   = 0;
                ALUOp    = 2'b00;
            end
            7'b1100011: begin // Branch (BEQ, BNE)
                RegWrite = 0;
                ALUSrc   = 0;
                MemRead  = 0;
                MemWrite = 0;
                MemtoReg = 0; // X (Don't Care)
                Branch   = 1;
                ALUOp    = 2'b01;
            end
            default: begin // Default (NOP)
                RegWrite = 0;
                ALUSrc   = 0;
                MemRead  = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end

endmodule