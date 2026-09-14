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
