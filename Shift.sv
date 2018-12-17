module shift(input  logic [31:0] WriteData,
           input  logic [1:0]  Sh,
	   input logic  [31:0] shamt,
           output logic [31:0] Result);

  always_comb
    casex (Sh[1:0])
      2'b00: Result = WriteData << shamt; //LSL
      2'b01: Result = WriteData >> shamt; //LSR
      2'b10: Result = WriteData >>> shamt; //ASR
      2'b11: Result = (WriteData>>shamt)|(WriteData<<(32-shamt)); //ROR
    endcase
endmodule
