		MOV		R4, #10                 ; elements number (1 - n)
		MOV		R0, #0           		; memory offset
		MOV		R2, #1              	; tmp variable for
		MOV		R1, #1              	; init fibb. sequence
		
		STR		R1, [R0]                ; storage firt number serie
FOR
		CMP		R2, R4              	; compare
		BEQ		ENDFOR              	; if(R2 == R4) break;
		
		CMP		R2, #1              	; compare
		BNE		ELSE                    ; to else if(R2 != 1)
		STR		R1, [R0, #4]            ; storage second number
		B		ENDIF               	; finalized condictional
		
ELSE
		SUB		R3, R2, #2          	; indice = i - 2
		LDR		R1, [R0, R3, LSL #2]    ; R1 = array[i-2]
		SUB		R3, R2, #1          	; indice = i - 1
		LDR		R3, [R0, R3, LSL #2]    ; R3 = array[i - 1]
		ADD		R12, R1,R3          	; add R1 + R3
		STR		R12, [R0, R2, LSL #2]   ; storage value
ENDIF
		ADD		R2, R2, #1          	; i = i + 1
		B		FOR                     ; repeat loop
ENDFOR
