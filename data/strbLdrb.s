MOV		R0, #0
MOV		R1, #65 ; A
MOV		R2, #66 ; B
MOV		R3, #67 ; C
MOV		R4, #68 ; D

STRB		R1, [R0]
STRB		R2, [R0, #1]
STRB		R3, [R0, #2]
STRB		R4, [R0, #3]

LDRB		R5, [R0]
LDRB		R6, [R0, #1]
LDRB		R7, [R0, #2]
LDRB		R8, [R0, #3]