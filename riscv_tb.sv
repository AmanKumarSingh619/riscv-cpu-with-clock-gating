module riscv_tb;

    // Parameters
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    
    // Testbench Signals
    logic clk;
    logic reset_n;
    
    // Instantiate RISC-V CPU
    riscv_cpu #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) CPU (
        .clk(clk),
        .reset_n(reset_n)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period

    // Test Sequence
    initial begin
        // Initialize Signals
        clk = 0;
        reset_n = 0;
        
        // Apply Reset
        #20 reset_n = 1;
        
        // Run CPU for 200 clock cycles
        #2000 $finish;
    end

    // Monitor Important Signals
    always @(posedge clk) begin
        $display("PC: %h | Instr: %h", CPU.pc, CPU.IFETCH.instr);
    end

endmodule