module shift(input  logic [31:0] WriteData,
           input  logic [1:0]  Sh,
	   input logic  [4:0] instrc,
           output logic [31:0] Result);

  always_comb
    casex (Sh[1:0])
      2'b00: Result = WriteData << instrc; //LSL
      2'b01: Result = WriteData >> instrc; //LSR
      2'b10: Result = WriteData >>> instrc; //ASR
      2'b11: Result = WriteData >> instrc; //ROR depois eu acerto isso
    endcase
endmodule
