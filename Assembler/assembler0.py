with open("program.asm") as file:
    lines = file.readlines()

with open("output.bin", "w") as outfile:

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

    # ==========================================
    # PASS 1 : Collect labels
    # ==========================================

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

    # ==========================================
    # PASS 2 : Assemble
    # ==========================================

    for line in lines:

        instruction = line.split(";")[0].strip()

        if not instruction:
            continue

        # Ignore labels
        if instruction.endswith(":"):
            continue

        parts = instruction.upper().split()

        print(parts)

        opcode = OPCODES[parts[0]]

        match opcode:

            # ============================
            # ALU Instructions
            # ============================

            case "0000" | "0001" | "0010" | "0011" | "0100":

                rd  = REGISTERS[parts[1]]
                rs1 = REGISTERS[parts[2]]
                rs2 = REGISTERS[parts[3]]

                binaryinstruction = opcode + rd + rs1 + rs2 + "000"

            # ============================
            # NOT / LSL / LSR
            # ============================

            case "0101" | "0110" | "0111":

                rd  = REGISTERS[parts[1]]
                rs1 = REGISTERS[parts[2]]

                binaryinstruction = opcode + rd + rs1 + "000000"

            # ============================
            # MVI
            # ============================

            case "1000":

                rd = REGISTERS[parts[1]]
                imm = f"{int(parts[2],0):08b}"

                binaryinstruction = opcode + rd + imm + "0"

            # ============================
            # STR / LDR
            # ============================

            case "1001" | "1010":

                rd = REGISTERS[parts[1]]
                mem = REGISTERS[parts[2]]

                binaryinstruction = opcode + rd + mem + "000000"

            # ============================
            # JMP / BEQ / BNE
            # ============================

            case "1011" | "1101" | "1111":

                target = parts[1]

                try:
                    address = int(target, 0)
                except ValueError:
                    address = labels[target.upper()]

                jump_add = f"{address:06b}"

                binaryinstruction = opcode + jump_add + "000000"

            # ============================
            # CMP
            # ============================

            case "1100":

                rs1 = REGISTERS[parts[1]]
                rs2 = REGISTERS[parts[2]]

                binaryinstruction = opcode + rs1 + rs2 + "000000"

            # ============================
            # HLT
            # ============================

            case "1110":

                binaryinstruction = opcode + "000000000000"

        print(binaryinstruction)
        outfile.write(binaryinstruction + "\n")