import tkinter as tk
from tkinter import ttk

import sv_ttk
from cpu import CPU


# =========================
# Main Window
# =========================

root = tk.Tk()

sv_ttk.set_theme("dark")

cpu = CPU()

root.title("CPU DEBUGGER")
root.geometry("700x500")
root.resizable(False, False)


# =========================
# Title
# =========================

title = ttk.Label(
    root,
    text="CPU DEBUGGER",
    font=("Oswald", 20, "bold")
)

title.pack(pady=15)


# =========================
# CPU Information
# =========================

info_frame = ttk.LabelFrame(
    root,
    text="CPU"
)

info_frame.pack(
    padx=20,
    pady=10,
    fill="x"
)


# Connection

ttk.Label(
    info_frame,
    text="Connection:"
).grid(
    row=0,
    column=0,
    padx=10,
    pady=8,
    sticky="w"
)

connection_label = ttk.Label(
    info_frame,
    text="CONNECTED"
)

connection_label.grid(
    row=0,
    column=1,
    padx=10,
    pady=8,
    sticky="w"
)


# PC

ttk.Label(
    info_frame,
    text="PC:"
).grid(
    row=1,
    column=0,
    padx=10,
    pady=8,
    sticky="w"
)

pc_label = ttk.Label(
    info_frame,
    text="0"
)

pc_label.grid(
    row=1,
    column=1,
    padx=10,
    pady=8,
    sticky="w"
)


# Instruction

ttk.Label(
    info_frame,
    text="Instruction:"
).grid(
    row=2,
    column=0,
    padx=10,
    pady=8,
    sticky="w"
)

instruction_label = ttk.Label(
    info_frame,
    text="---",
    font=("Consolas", 11)
)

instruction_label.grid(
    row=2,
    column=1,
    padx=10,
    pady=8,
    sticky="w"
)


# FSM State

ttk.Label(
    info_frame,
    text="FSM State:"
).grid(
    row=3,
    column=0,
    padx=10,
    pady=8,
    sticky="w"
)

fsm_label = ttk.Label(
    info_frame,
    text="---"
)

fsm_label.grid(
    row=3,
    column=1,
    padx=10,
    pady=8,
    sticky="w"
)


# =========================
# Registers
# =========================

register_frame = ttk.LabelFrame(
    root,
    text="Registers"
)

register_frame.pack(
    padx=20,
    pady=10,
    fill="x"
)


register_labels = []

for i in range(8):

    label = ttk.Label(
        register_frame,
        text=f"R{i} = 0",
        font=("Consolas", 11)
    )

    label.grid(
        row=i // 2,
        column=i % 2,
        padx=25,
        pady=8
    )

    register_labels.append(label)


# =========================
# Register Update
# =========================

def update_registers():

    for i in range(8):

        value = cpu.read_register(i)

        if value is not None:

            register_labels[i].config(
                text=f"R{i} = {value}"
            )


# =========================
# Instruction Decoder
# =========================

def decode_instruction(instruction):

    opcode = (instruction >> 12) & 0xF


    # ADD

    if opcode == 0x0:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7
        rs2 = (instruction >> 3) & 0x7

        return f"ADD R{rd} R{rs1} R{rs2}"


    # SUB

    elif opcode == 0x1:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7
        rs2 = (instruction >> 3) & 0x7

        return f"SUB R{rd} R{rs1} R{rs2}"


    # AND

    elif opcode == 0x2:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7
        rs2 = (instruction >> 3) & 0x7

        return f"AND R{rd} R{rs1} R{rs2}"


    # OR

    elif opcode == 0x3:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7
        rs2 = (instruction >> 3) & 0x7

        return f"OR R{rd} R{rs1} R{rs2}"


    # XOR

    elif opcode == 0x4:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7
        rs2 = (instruction >> 3) & 0x7

        return f"XOR R{rd} R{rs1} R{rs2}"


    # NOT

    elif opcode == 0x5:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7

        return f"NOT R{rd} R{rs1}"


    # LSL

    elif opcode == 0x6:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7

        return f"LSL R{rd} R{rs1}"


    # LSR

    elif opcode == 0x7:

        rd = (instruction >> 9) & 0x7
        rs1 = (instruction >> 6) & 0x7

        return f"LSR R{rd} R{rs1}"


    # MVI

    elif opcode == 0x8:

        rd = (instruction >> 9) & 0x7
        imm = (instruction >> 1) & 0xFF

        return f"MVI R{rd} {imm}"


    # STR

    elif opcode == 0x9:

        rd = (instruction >> 9) & 0x7
        mem = (instruction >> 6) & 0x7

        return f"STR R{rd} R{mem}"


    # LDR

    elif opcode == 0xA:

        rd = (instruction >> 9) & 0x7
        mem = (instruction >> 6) & 0x7

        return f"LDR R{rd} R{mem}"


    # JMP

    elif opcode == 0xB:

        address = (instruction >> 6) & 0x3F

        return f"JMP {address}"


    # CMP

    elif opcode == 0xC:

        rs1 = (instruction >> 9) & 0x7
        rs2 = (instruction >> 6) & 0x7

        return f"CMP R{rs1} R{rs2}"


    # BEQ

    elif opcode == 0xD:

        address = (instruction >> 6) & 0x3F

        return f"BEQ {address}"


    # HLT

    elif opcode == 0xE:

        return "HLT"


    # BNE

    elif opcode == 0xF:

        address = (instruction >> 6) & 0x3F

        return f"BNE {address}"


    return f"UNKNOWN 0x{instruction:04X}"


# =========================
# Update CPU Display
# =========================

def update_cpu_display():

    # PC

    pc = cpu.read_pc()

    if pc is not None:

        pc_label.config(
            text=str(pc)
        )


    # Instruction

    instruction = cpu.read_instruction()

    if instruction is not None:

        decoded = decode_instruction(instruction)

        instruction_label.config(
            text=decoded
        )


    # FSM State

    fsm_state = cpu.read_fsmstate()

    if fsm_state is not None:

        fsm_names = {
            0: "FETCH",
            1: "DECODE",
            2: "READ",
            3: "EXECUTE",
            4: "WRITEBACK"
        }

        fsm_label.config(
            text=fsm_names.get(
                fsm_state,
                "UNKNOWN"
            )
        )


    # Registers

    update_registers()


# =========================
# RUN
# =========================

def run_cpu():

    if cpu.run():

        print("CPU running")

        update_cpu_display()

    else:

        print("No valid response from FPGA")


# =========================
# PAUSE
# =========================

def pause_cpu():

    if cpu.pause():

        print("CPU paused")

        update_cpu_display()

    else:

        print("No valid response from FPGA")


# =========================
# CLOCK STEP
# =========================

def clock_step():

    if cpu.clock():

        print("CLOCK pressed")

        update_cpu_display()

    else:

        print("No valid response from FPGA")


# =========================
# INSTRUCTION STEP
# =========================

def instruction_step():

    if cpu.step():

        print("Instruction stepped")

        update_cpu_display()

    else:

        print("No valid response from FPGA")


# =========================
# Control Buttons
# =========================

control_frame = ttk.Frame(root)

control_frame.pack(
    pady=20,
    padx=10
)


ttk.Button(
    control_frame,
    text="RUN",
    width=12,
    command=run_cpu
).grid(
    row=0,
    column=0,
    padx=5
)


ttk.Button(
    control_frame,
    text="PAUSE",
    width=12,
    command=pause_cpu
).grid(
    row=0,
    column=1,
    padx=5
)


ttk.Button(
    control_frame,
    text="CLOCK",
    width=12,
    command=clock_step
).grid(
    row=0,
    column=2,
    padx=5
)


ttk.Button(
    control_frame,
    text="STEP",
    width=12,
    command=instruction_step
).grid(
    row=0,
    column=3,
    padx=5
)


# =========================
# Start GUI
# =========================
def auto_refresh():
    update_cpu_display()
    root.after(250, auto_refresh)


auto_refresh()
root.mainloop()