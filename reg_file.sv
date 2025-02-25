module reg_file #(
    parameter REG_WIDTH = 32,
    parameter REG_COUNT = 32
)(
    input  logic                  clk,
    input  logic                  reset_n,
    input  logic                  reg_write,  // Write Enable Signal
    input  logic [4:0]            rs1,        // Read Register 1 Address
    input  logic [4:0]            rs2,        // Read Register 2 Address
    input  logic [4:0]            rd,         // Destination Register Address
    input  logic [REG_WIDTH-1:0]  write_data, // Data to Write
    output logic [REG_WIDTH-1:0]  read_data1, // Read Data 1 Output
    output logic [REG_WIDTH-1:0]  read_data2  // Read Data 2 Output
);

    // Register File (32 Registers, Each 32-bit)
    logic [REG_WIDTH-1:0] reg_mem [0:REG_COUNT-1];

    // Initialize Register File (Optional: For Debugging)
    initial begin
        reg_mem[0] = 0;  // x0 is always 0
    end

    // Read Operation (Combinational Logic)
    assign read_data1 = reg_mem[rs1]; 
    assign read_data2 = reg_mem[rs2];

    // Write Operation (Synchronous)
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            reg_mem[0] <= 0; // Ensure x0 remains 0
        end else if (reg_write && (rd != 0)) begin
            reg_mem[rd] <= write_data; // Write data to rd if not x0
        end
    end

endmodule