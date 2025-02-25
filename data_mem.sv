module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_DEPTH = 256
)(
    input  logic                   clk,
    input  logic                   MemRead,    // Read Enable
    input  logic                   MemWrite,   // Write Enable
    input  logic [ADDR_WIDTH-1:0]   addr,       // Memory Address
    input  logic [DATA_WIDTH-1:0]   write_data, // Data to Store
    output logic [DATA_WIDTH-1:0]   read_data   // Loaded Data
);

    // Memory Array
    logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize Memory with Test Values
    initial begin
        mem[0] = 32'h00000001; // Sample Data at Address 0
        mem[1] = 32'h00000002; // Sample Data at Address 4
    end

    // Memory Read Operation (Combinational Logic)
    always_comb begin
        if (MemRead)
            read_data = mem[addr >> 2]; // Byte to Word Address Conversion
        else
            read_data = 32'b0;
    end

    // Memory Write Operation (Synchronous Logic)
    always_ff @(posedge clk) begin
        if (MemWrite)
            mem[addr >> 2] <= write_data; // Store Data at Memory Address
    end

endmodule