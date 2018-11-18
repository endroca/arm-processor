module decoder (
    input  logic [1:0] Op,
    input  logic [5:0] Funct,
    input  logic [3:0] Rd,
    output logic [1:0] FlagW,
    output logic       PCS, RegW, MemW, MemB,
    output logic       MemtoReg, ALUSrcA, ALUSrcB,
    output logic [1:0] ImmSrc, RegSrc,
    output logic [2:0] ALUControl
);

    logic [11:0] controls;
    logic       Branch, ALUOp;

    // Main Decoder

    always_comb
        case(Op)
            ///////////////////////////////////////////////////////////
            // DATA PROCESSING
            ///////////////////////////////////////////////////////////
            2'b00:
                case(Funct[4:1])
                    4'b1101 :
                        //MOV REGISTER, IMMEDIATE
                        if (Funct[5])   controls = 12'b000011010000;
                        //MOV REGISTER, REGISTER AND LSL
                        else            controls = 12'b000010010000;

                    4'b1010 :
                        //CMP REGISTER, IMMEDIATE
                        if (Funct[5])   controls = 12'b000001000001;
                        //CMP REGISTER, REGISTER
                        else            controls = 12'b000000000001;

                    4'b1000 :
                        //TST REGISTER, IMMEDIATE
                        if (Funct[5])   controls = 12'b000001000001;
                        //TST REGISTER, REGISTER
                        else            controls = 12'b000000000001;

                    default:
                        //ALU FUNCTIONS
                        if (Funct[5])   controls = 12'b000001010001;
                        else            controls = 12'b000000010001;
                endcase


            ///////////////////////////////////////////////////////////
            // MEMORY
            ///////////////////////////////////////////////////////////
            2'b01:
                // LDR
                if (Funct[0])
                    //Imediato
                    if (~Funct[5])
                        //Byte
                        if(Funct[2])    controls = 12'b000101110100;
                        //Normal
                        else            controls = 12'b000101110000;


                    //Registrador
                    else
                        //Byte
                        if(Funct[2])    controls = 12'b000100110100;
                        //Normal
                        else            controls = 12'b000100110000;
            
            
                // STR
                else
                    //Imediato
                    if (~Funct[5])
                        //Byte
                        if(Funct[2])    controls = 12'b100101101100;
                        //Normal
                        else            controls = 12'b100101101000;

                    //Registrador
                    else
                        //Byte
                        if(Funct[2])    controls = 12'b000100101100;
                        //Normal
                        else            controls = 12'b000100101000;
            

            ///////////////////////////////////////////////////////////
            // BRENCH
            ///////////////////////////////////////////////////////////
            2'b10:                      controls = 12'b011001000010;


            // Unimplemented
            default:                    controls = 12'bx;
        endcase

        assign {RegSrc, ImmSrc, ALUSrcA, ALUSrcB, MemtoReg,
            RegW, MemW, MemB, Branch, ALUOp} = controls;

    // ALU Decoder
    always_comb
        if (ALUOp) begin                 // which DP Instr?
            case(Funct[4:1])
                4'b0001: ALUControl = 3'b100; // EOR (XOR)
                4'b0100: ALUControl = 3'b000; // ADD
                4'b0010: ALUControl = 3'b001; // SUB
                4'b0000: ALUControl = 3'b010; // AND
                4'b1100: ALUControl = 3'b011; // ORR
                4'b1000: ALUControl = 3'b001; // TST = AND (COLOQUEI SUB)
                4'b1010: ALUControl = 3'b001; // CMP
                default: ALUControl = 3'bx;  // unimplemented
            endcase
            // update flags if S bit is set
            // (C & V only updated for arith instructions)
            FlagW[1]      = Funct[0]; // FlagW[1] = S-bit
            // FlagW[0] = S-bit & (ADD | SUB)
            FlagW[0]      = Funct[0] & (ALUControl == 3'b000 | ALUControl == 3'b001);
        end else begin
            ALUControl = 3'b000; // add for non-DP instructions
            FlagW      = 2'b00; // don't update Flags
        end

    // PC Logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule