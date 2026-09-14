import sys

input_file = sys.argv[1] if len(sys.argv) > 1 else "program.asm"

with open(input_file) as file:
    lines = file.readlines()

output_file = sys.argv[2] if len(sys.argv) > 2 else "output.bin"

with open(output_file, "w") as outfile:

    OPCODES = {

        "ADD": "0000",
        "SUB": "0001",
        "AND": "0010",
        "OR" : "0011",
        "XOR": "0100",
        "NOT": "0101",
        "LSL": "0110",
        "LSR": "0111",
        "MVI": "1000",
        "STR": "1001",
        "LDR": "1010",
        "JMP": "1011",
        "CMP": "1100",
        "BEQ": "1101",
        "HLT": "1110",
        "BNE": "1111"

    }

    REGISTERS = {
        "R0": "000",
        "R1": "001",
        "R2": "010",
        "R3": "011",
        "R4": "100",
        "R5": "101",
        "R6": "110",
        "R7": "111"
    }

    labels = {}
    pc = 0

    for line in lines:

        instruction = line.split(";")[0].strip()

        if not instruction:
            continue

        if instruction.endswith(":"):
            labels[instruction[:-1].upper()] = pc
            continue

        pc += 1

    print("Labels:", labels)

    for line in lines:

        instruction = line.split(";")[0].strip()

        if not instruction:
            continue

        if instruction.endswith(":"):
            continue

        parts = instruction.upper().split()

        print(parts)

        opcode = OPCODES[parts[0]]

        match opcode:

            

            case "0000" | "0001" | "0010" | "0011" | "0100":

                rd  = REGISTERS[parts[1]]
                rs1 = REGISTERS[parts[2]]
                rs2 = REGISTERS[parts[3]]

                binaryinstruction = opcode + rd + rs1 + rs2 + "000"


            case "0101" | "0110" | "0111":

                rd  = REGISTERS[parts[1]]
                rs1 = REGISTERS[parts[2]]

                binaryinstruction = opcode + rd + rs1 + "000000"


            case "1000":

                rd = REGISTERS[parts[1]]
                imm = f"{int(parts[2],0):08b}"

                binaryinstruction = opcode + rd + imm + "0"


            case "1001" | "1010":

                rd = REGISTERS[parts[1]]
                mem = REGISTERS[parts[2]]

                binaryinstruction = opcode + rd + mem + "000000"


            case "1011" | "1101" | "1111":

                target = parts[1]

                try:
                    address = int(target, 0)
                except ValueError:
                    address = labels[target.upper()]

                jump_add = f"{address:06b}"

                binaryinstruction = opcode + jump_add + "000000"


            case "1100":

                rs1 = REGISTERS[parts[1]]
                rs2 = REGISTERS[parts[2]]

                binaryinstruction = opcode + rs1 + rs2 + "000000"


            case "1110":

                binaryinstruction = opcode + "000000000000"

        print(binaryinstruction)
        outfile.write(binaryinstruction + "\n")