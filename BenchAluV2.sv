module benchAluV2();

	logic [31:0] result, result2, a, b;
	logic [3:0] flags, flags2;
	logic [2:0] control;
	logic [1:0] control2;

	alu aluCompare(a, b, control2, result2, flags2);
	aluV2 alu(a, b, control, result, flags);

	initial
		begin
			a = 32'b1;
			b = 32'b1;
			control = 3'b000;
			control2 = 2'b00; #20

			a = 32'b1;
			b = 32'b1;
			control = 3'b001;
			control2 = 2'b01; #20

			a = 32'b0;
			b = 32'b1;
			control = 3'b001;
			control2 = 2'b01; #20

			a = 32'b0;
			b = 32'b11111111111111111111111111111111;
			control = 3'b000;
			control2 = 2'b00; #20
		
			a = 32'b1;
			b = 32'b10;
			control = 3'b010;
			control2 = 2'b10; #20

			a = 32'b1;
			b = 32'b10;
			control = 3'b011;
			control2 = 2'b11;
// a & b = a ou b se ambos forem iguais, caso contrario sera zero
// a | b = sera

		end

endmodule
