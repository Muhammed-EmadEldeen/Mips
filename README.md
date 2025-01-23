# Simple MIPS Processor

This project demonstrates a simple MIPS processor implemented in Verilog. The processor supports basic instructions such as `add`, `sub`, `lw`, `sw`, `beq`, and `bne`. A testbench is provided to verify the functionality.

## Features
- **Instruction Set:**
  - R-type instructions: `add`, `sub`
  - I-type instructions: `lw`, `sw`, `beq`, `bne`
- **Memory:**
  - Instruction memory: 4096 bytes
  - Data memory: 16384 bytes
- **Registers:**
  - 32 general-purpose registers
- **Testbench:**
  - Pre-loaded instructions for testing
  - Displays the register values after execution
  - Generates a waveform dump for simulation analysis

## File Structure
- `mips.v`: Contains the Verilog code for the MIPS processor and the testbench.


## Requirements
- Verilog simulator (e.g., [Icarus Verilog](https://iverilog.fandom.com/))

## Usage

### Compiling and Running the Simulation
1. Install [Icarus Verilog](https://iverilog.fandom.com/).

2. Compile the Verilog files:
   ```bash
   iverilog -o mips_sim mips.v
   ```

3. Run the simulation:
   ```bash
   vvp mips_sim
   ```

4. View the waveform (optional):
   Use a waveform viewer like GTKWave to analyze the simulation results.
   ```bash
   gtkwave main.vcd
   ```

### Output
- The simulation outputs the executed instructions and register values to the console.
- A waveform dump (`main.vcd`) is generated for further analysis.


## Notes
- Modify the instruction memory (`inst`) in the testbench to test additional instructions.
- Debugging outputs are included for instruction execution and program counter updates.



