MOV		R0, #25
LSL		R2, R0, #2

MOV		R5, #2
MOV		R6, #2
LSL		R1, R5, R6
SUB		R1, R1, #1

STR		R1, [R2]