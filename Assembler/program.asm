start:

MVI R0 10
MVI R1 5

CMP R0 R1
BEQ equal

MVI R2 99

equal:

ADD R2 R0 R1

JMP done

MVI R3 100

done:

HLT