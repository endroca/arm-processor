// para multiplos de quatro os dois primeiros bits sempre seram 00 então nao é necessario representa-los
// porem se queremos representar os bytes pegaremos esses bitos como selecao


module dmem(input  logic        clk, memByte, we,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  //assign rd = RAM[a[31:2]]; // word aligned
  always_comb
    casex (a[1:0])
      2'b00: 
	if(memByte)	rd = {24'b0, RAM[a[31:2]][7:0]};
	else		rd = RAM[a[31:2]];
      2'b01: rd = {24'b0, RAM[a[31:2]][15:8]};
      2'b10: rd = {24'b0, RAM[a[31:2]][23:16]};
      2'b11: rd = {24'b0, RAM[a[31:2]][31:24]};
    endcase

  always_ff @(posedge clk)
    if (we)
    	casex (a[1:0])
		2'b00: 
			if(memByte)	RAM[a[31:2]][7:0] <= wd;
			else 		RAM[a[31:2]] <= wd;
      		2'b01: RAM[a[31:2]][15:8] <= wd;
      		2'b10: RAM[a[31:2]][23:16] <= wd;
      		2'b11: RAM[a[31:2]][31:24] <= wd;
    	endcase
endmodule
