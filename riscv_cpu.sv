module riscv_cpu #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic reset_n
);

    // Internal Signals
    logic [ADDR_WIDTH-1:0] pc, instr, read_data1, read_data2;
    logic [ADDR_WIDTH-1:0] alu_result, mem_read_data, write_data;
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    logic [1:0] ALUOp;
    logic [3:0] alu_ctrl;
    logic zero, branch_taken;

    // INSTRUCTION FETCH STAGE (Includes PC + Instruction Memory)
    instr_fetch #(.ADDR_WIDTH(ADDR_WIDTH), .INSTR_WIDTH(DATA_WIDTH)) IFETCH (
        .clk(clk),
        .reset_n(reset_n),
        .branch_taken(branch_taken),
        .branch_target(alu_result), // ALU result is branch target
        .pc(pc),
        .instr(instr)
    );

    // DECODE INSTRUCTION FIELDS
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // CONTROL UNIT
    control_unit CU (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // REGISTER FILE
    reg_file #(.REG_WIDTH(DATA_WIDTH)) REG_FILE (
        .clk(clk),
        .reset_n(reset_n),
        .reg_write(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU CONTROL UNIT
    alu_control ALU_CTRL (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    // ALU EXECUTION STAGE
    alu #(.DATA_WIDTH(DATA_WIDTH)) ALU (
        .operand_a(read_data1),
        .operand_b(ALUSrc ? instr[31:20] : read_data2), // Immediate or rs2
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero(zero)
    );

    // BRANCH LOGIC
    assign branch_taken = Branch & zero;

    // DATA MEMORY (FOR LOAD/STORE)
    data_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) DMEM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_read_data)
    );

    // WRITE-BACK STAGE
    assign write_data = MemtoReg ? mem_read_data : alu_result;

    // JAL LOGIC
    logic [31:0] jal_imm;
    assign jal_imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; // Correct JAL immediate

    logic jal_taken;
    assign jal_taken = (opcode == 7'b1101111); // JAL opcode

    logic [31:0] jal_target;
    assign jal_target = pc + jal_imm; // Compute jump target address

    // INSTANTIATE PC MODULE (Now Includes JAL Handling)
    pc PC (
        .clk(clk),
        .reset_n(reset_n),
        .branch_taken(branch_taken),
        .branch_target(alu_result),
        .jal_taken(jal_taken),   // New signal for JAL
        .jal_target(jal_target), // New JAL target address
        .pc(pc)
    );

endmodule
