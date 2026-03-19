# RISC-V 5-Stage Pipeline CPU (Vivado Project)

This repository contains a Verilog implementation of a simple pipelined RISC-V CPU project built in Xilinx Vivado.

## Project Structure

- `RISC_V_CPU_PIPELINE.srcs/`: RTL source files
- `RISC_V_CPU_PIPELINE.xdc/`: constraints
- `RISC_V_CPU_PIPELINE.xpr`: Vivado project file

## Main Modules

- `top.v`
- `PC_reg.v`
- `IF_ID.v`
- `ID_EX.v`
- `EX_MEM.v`
- `MEM_WB.v`
- `control.v`
- `hazard_detection.v`
- `forwarding_unit.v`
- `ALU.v`, `ALUcontrol.v`
- `Instruction_Memory.v`, `memory.v`, `register.v`, `immgen.v`

## Requirements

- Vivado

## How to Open

1. Use vivado and add source files or
2. Click `RISC_V_CPU_PIPELINE.xpr`.

## License

No license file has been added yet.
