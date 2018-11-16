module datapath(input  logic        clk, reset,
                input  logic [1:0]  RegSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic        ALUSrcA, ALUSrcB,
                input  logic [1:0]  ALUControl,
                input  logic        MemtoReg,
                input  logic        PCSrc,
                output logic [3:0]  ALUFlags,
                output logic [31:0] PC,
                input  logic [31:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input  logic [31:0] ReadData);

  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, SrcB, SrcAnew, Result, WriteDataShifted;
  logic [3:0]  RA1, RA2;

  // next PC logic
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext); //primeiro gegistrador (seleciona PCplus ou result)
  flopr #(32) pcreg(clk, reset, PCNext, PC); // gerencia o reset para colocar o pc = 0 se o reset for acionado
  adder #(32) pcadd1(PC, 32'b100, PCPlus4); // soma pc+4
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8); //soma pc+4= pc+8

  // register file logic
  mux2 #(4)   ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1); // seleciona as duas primeiras entradas de acordo com o RegSRC
  mux2 #(4)   ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2); // seleciona as duas primeiras entradas de acordo com o RegSRC
  regfile     rf(clk, RegWrite, RA1, RA2,
                 Instr[15:12], Result, PCPlus8, 
                 SrcA, WriteData);
  shift       sht(WriteData, Instr[6:5], Instr[11:7], WriteDataShifted);

  mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[23:0], ImmSrc, ExtImm);

  // ALU logic
  mux2 #(32)  srcbmux(SrcA, 32'b0, ALUSrcA, SrcAnew);
  mux2 #(32)  srcbmux2(WriteDataShifted, ExtImm, ALUSrcB, SrcB);  

  alu         alu(SrcAnew, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
endmodule
