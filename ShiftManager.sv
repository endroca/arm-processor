module shiftManager(input  logic[7:0] instruction,
		    output logic[3:0] Rshift,
                    input logic[31:0] RshiftValue,
                    output logic[1:0] command,
                    output logic[31:0] shamt);

  assign registerOrimmediate = instruction[0];
  assign command = instruction[2:1];
  
  always_comb
    if(registerOrimmediate === 1) begin
      Rshift = instruction[7:4];
      shamt = RshiftValue;
    end else begin
      shamt = {27'b0, instruction[7:3]};
    end

endmodule