# ALINX AX309 (XC6SLX9) FPGA Training Project
A Verilog HDL training project for the ALINX AX309 development board (Xilinx Spartan-6 XC6SLX9 FPGA), optimized for open-source simulation and waveform analysis.

## Key Features
- **Board Target**: ALINX AX309 (Xilinx XC6SLX9 Spartan-6 FPGA)
- **Toolchain**: Fully compatible with free open-source tools (Icarus Verilog + GTKWave)
- **Simulation Flow**: RTL coding → compile → simulation → waveform debugging
- **No Paid Tools**: Works entirely offline without Xilinx ISE/Vivado
- **Educational Focus**: Designed for FPGA beginners to learn the full RTL simulation workflow

## Project Structure
- `src/`: Verilog RTL source code (e.g., LED blink, counter modules)
- `tb/`: Testbench files for simulation
- `sim/`: Simulation scripts and waveform output files
- `constraints/`: UCF pin constraints for the AX309 board (for reference)
- `docs/`: Step-by-step guide for toolchain setup and simulation

## Quick Start
1. Install Icarus Verilog and GTKWave
2. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ax309-spartan6-rtl-simulation.git