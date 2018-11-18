        MOV     R0, #0xFF             ; 20161ceca70326 
        ADD     R0, R0, #1            ; 0X100
        ORR     R0, R0, #0x46
       
        MOV     R1, #1                  ; increment for
        MOV     R4, #10                 ; elements number
        MOV     R2, #0               ; offset memory
       
        STR     R0, [R2]                ; storage first number serie
       
       
FOR
        CMP     R1,R4
        BEQ     ENDFOR
       
        LSL     R0, R0, #1
        STR     R0, [R2, R1, LSL #2]
       
       
        ADD     R1, R1, #1
        B       FOR
ENDFOR