module benchALL();

  logic        clk;
  logic        reset;

  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;
  logic [6:0] counter = 7'b0;

  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
	//reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; 
      clk <= 0; # 5;
      counter <= counter + 1;
    end

  // check results
  always @(negedge clk)
    begin
      if(reset === 0) begin
        if(counter === 100) begin
          $display("Simulation stop");
          $stop;
        //end else if (WriteData !== 1 & WriteData !== 2 & WriteData !== 3 & WriteData !== 5) begin //| WriteData !== 3 | WriteData !== 5 | WriteData !== 5
        //  $display("Simulation failed");
        //  $stop;
        end
      end
    end
endmodule
