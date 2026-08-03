
;          SimpleCPU v1.0 - CPU Torture Test
;               Uses ALL 16 Instructions



; Register Setup


MVI R0 25
MVI R1 7
MVI R2 100
MVI R3 3


; Arithmetic


ADD R4 R0 R1        ; 25 + 7 = 32
SUB R5 R0 R1        ; 18


; Logic


AND R6 R0 R1        ; 25 & 7 = 1
OR  R6 R0 R1        ; 31
XOR R6 R0 R1        ; 30

NOT R7 R1           ; ~7 = 248


; Shift Test

LSL R5 R3           ; 3 << 1 = 6
LSR R5 R5           ; 6 >> 1 = 3


; Memory Test


STR R4 R3           ; MEM[3] = 32

MVI R4 0            ; Destroy register

LDR R4 R3           ; Should recover 32


; Compare Equal


CMP R4 R4

BEQ equal_ok

MVI R6 255          ; SHOULD NEVER EXECUTE

equal_ok:


; Compare Not Equal


CMP R0 R1

BNE notequal_ok

MVI R7 123          ; SHOULD NEVER EXECUTE

notequal_ok:


; More Arithmetic


ADD R2 R4 R5        ; 32 + 3 = 35

SUB R2 R2 R1        ; 35 - 7 = 28

AND R2 R2 R0

OR  R2 R2 R3

XOR R2 R2 R1


; Multiple Memory Locations


STR R2 R0

LDR R6 R0

CMP R6 R2

BEQ memory_ok

MVI R5 88           ; SHOULD NEVER EXECUTE

memory_ok:


; Jump Test

JMP final

MVI R0 222          ; SHOULD NEVER EXECUTE

final:

HLT