# riscv-cpu-with-clock-gating
🟢 "🚀 RISC-V CPU | 5-Stage Pipeline | Clock Gating | Low Power | SystemVerilog | FPGA Ready ⚡"

# RISC-V CPU (SystemVerilog)

This is a simple **RISC-V CPU** implemented in **SystemVerilog**.  
It includes a **5-stage pipeline** and **clock gating** for low-power operation.

## 📂 Files
- **`src/`** → Contains all SystemVerilog source files
- **`tb/`** → Contains testbench files

## 🚀 How to Run
1. Use **Vivado, ModelSim, or Icarus Verilog** for simulation.  
2. Compile the design and testbench:
   ```sh
   iverilog -o riscv_tb src/*.sv tb/riscv_tb.sv
   vvp riscv_tb
