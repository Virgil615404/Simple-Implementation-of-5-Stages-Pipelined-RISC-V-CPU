# RISC-V 5-Stage Pipeline CPU (Vivado Project)

This repository contains a Verilog implementation of a simple pipelined RISC-V CPU project built in Xilinx Vivado.

## Project Structure

- `RISC_V_CPU_PIPELINE.srcs/`: RTL source files
- `RISC_V_CPU_PIPELINE.xdc/`: constraints
- `RISC_V_CPU_PIPELINE.xpr`: Vivado project file
- `RISC_V_CPU_PIPELINE.sim/`: simulation-related files (generated run artifacts are ignored)

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

- Vivado (recommended: same major version used to create this project)

## How to Open

1. Open Vivado.
2. Select **Open Project**.
3. Choose `RISC_V_CPU_PIPELINE.xpr`.

## Notes

- Large/generated Vivado artifacts are excluded via `.gitignore` to keep the repository clean.
- If your Vivado version differs, Vivado may request project upgrade steps.

## License

No license file has been added yet. If you plan to make this public, consider adding a license (for example, MIT).
