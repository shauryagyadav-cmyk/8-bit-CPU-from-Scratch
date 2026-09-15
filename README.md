# SimpleCPU — 8-bit CPU from Scratch

![CPU Overview](docs/CPU_overview.jpg)

> A custom 8-bit multi-cycle CPU designed in Verilog, featuring a custom ISA, Python assembler, FPGA implementation, UART debug system, and host-side debugger.

---

## Project Status

**Completed / Archived**

SimpleCPU is a completed personal hardware project. Development has concluded, and this repository preserves the final implementation.

---

## Overview

SimpleCPU is an **8-bit processor designed and implemented from scratch in Verilog**.

The project began as an exploration of computer architecture and digital logic, starting with individual hardware components and eventually becoming a complete processor capable of running programs on a physical FPGA.

The final system consists of:

```text
Assembly Program
       │
       ▼
 Python Assembler
       │
       ▼
 16-bit Machine Code
       │
       ▼
 Instruction Memory
       │
       ▼
    SimpleCPU
       │
       ▼
Tang Nano 9K FPGA
       │
      UART
       │
       ▼
Python Debugger
```

The CPU was first developed and verified using RTL simulation before being synthesized and deployed to a **Sipeed Tang Nano 9K FPGA**.

A UART-based debugging system was then added, allowing the processor's state to be inspected and controlled from a host computer.

## CPU Specifications


| Component | Specification |
| :--- | :--- |
| Datapath Width | 8-bit |
| Instruction Width | 16-bit |
| Program Counter | 6-bit |
| Instruction Memory | 64 × 16-bit |
| Data Memory | 256 × 8-bit |
| Registers | 8 × 8-bit |
| ALU | 8-bit |
| Architecture | Multi-cycle |
| Control | Finite State Machine |
| Execution States | Fetch → Decode → Read → Execute → Writeback |
| ISA | 16 instructions |
| FPGA | Sipeed Tang Nano 9K |
| FPGA Clock | 27 MHz |
| UART Baud Rate | 115200 |

## CPU Architecture

The processor uses a **multi-cycle architecture** controlled by a finite state machine.

Each instruction progresses through five major states:

![CPU architecture](docs/CPU_arch.jpg)

## Main Components

- Program Counter
- Instruction Memory
- Instruction Register
- Instruction Decoder
- Register file
- Immediate block
- ALU
- Zero Flag Register
- Data Memory
- Multiplexer
- Writeback MUX
- Multi-Cycle Control Unit

Additionally, FPGA implementation includes:

- UART Receiver
- UART transmitter
- UART Debug Protocol
- Debug Controller
- Debug Interface
- Debug System
- Button Pulse Generator
- FPGA Top-Level Logic

  
## Instruction Set Architecture

This CPU includes a custom **16-instruction ISA**.

| Opcode | Instruction | Description |
| :--- | :--- | :--- |
| `0000` | ADD | Add two registers |
| `0001` | SUB | Subtract two registers |
| `0010` | AND | Bitwise AND |
| `0011` | OR  | Bitwise OR |
| `0100` | XOR | Bitwise XOR |
| `0101` | NOT | Bitwise NOT |
| `0110` | LSL | Logical shift left |
| `0111` | LSR | Logical shift right |
| `1000` | MVI | Move immediate |
| `1001` | STR | Store register to memory |
| `1010` | LDR | Load register from memory |
| `1011` | JMP | Unconditional jump |
| `1100` | CMP | Compare two registers |
| `1101` | BEQ | Branch if equal |
| `1110` | HLT | Halt processor |
| `1111` | BNE | Branch if not equal |

## Assembler

The project includes a custom Python assembler capable of converting assembly programs into the CPU's 16-bit machine code.

## Supported Features

- All 16 CPU instructions
- Register Parsing
- Immediate Values
- Labels
- Comments
- Instruction encoding
- Binary machine-code generation

Example:

```asm
 START:
       MVI R0 10
       MVI R1 20
       MVI R2 0
       ADD R2 R0 R1
       CMP R2 R1
       BNE START
```
The generated machine code can be loaded into the CPU's instruction memory.

## Running the Assembler

```Bash
       python Assembler/assembler0.py

```
