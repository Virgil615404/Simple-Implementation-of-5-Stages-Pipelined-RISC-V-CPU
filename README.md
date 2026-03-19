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

## ISA Scope

This CPU currently targets an RV32I-style educational subset.

- Supported: basic integer ALU ops, immediate ops, load/store, and branch/jump control flow used by this project.
- Not supported yet: M extension (mul/div), CSR instructions, exceptions/interrupts, and full privileged architecture.

## Microarchitecture

- 5-stage pipeline: IF, ID, EX, MEM, WB
- Pipeline registers: IF/ID, ID/EX, EX/MEM, MEM/WB
- Hazard handling: forwarding + load-use hazard detection/stall
- Branch/control decisions are handled in the pipeline control path

## References

1. The RISC-V Instruction Set Manual (Unprivileged ISA), latest stable release.
2. Xilinx Vivado documentation for project/simulation workflow.

## Requirements

- Vivado

## How to Open

1. Use vivado and add source files or
2. Click `RISC_V_CPU_PIPELINE.xpr`.

## Notes

Instructions in "Instruction_Memory.v" are implemented through hardcoding and are for testing purposes only.

## License

No license file has been added yet.
