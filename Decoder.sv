module decoder (
    input  logic [1:0] Op,
    input  logic [5:0] Funct,
    input  logic [3:0] Rd,
    output logic [1:0] FlagW,
    output logic       PCS, RegW, MemW,
    output logic       MemtoReg, ALUSrcA, ALUSrcB,
    output logic [1:0] ImmSrc, RegSrc, ALUControl
);

    logic [10:0] controls;
    logic       Branch, ALUOp;

    // Main Decoder

    always_comb
        case(Op)
            2'b00:
                case(Funct[4:1])
                    4'b1101 : controls = 11'b00001101000;

                    default:
                        if (Funct[5])   controls = 11'b00000101001; 
                        else            controls = 11'b00000001001; 
                endcase
            // LDR
            2'b01: 
                if (Funct[0])  controls = 11'b00010111000;
            // STR
                else           controls = 11'b10010110100;
            // B
            2'b10: controls = 11'b01100100010;
            // Unimplemented
            default: controls = 11'bx;
        endcase

    assign {RegSrc, ImmSrc, ALUSrcA, ALUSrcB, MemtoReg,
            RegW, MemW, Branch, ALUOp} = controls;

    // ALU Decoder
    always_comb
        if (ALUOp) begin                 // which DP Instr?
            case(Funct[4:1])
                4'b0100: ALUControl = 2'b00; // ADD
                4'b0010: ALUControl = 2'b01; // SUB
                4'b0000: ALUControl = 2'b10; // AND
                4'b1100: ALUControl = 2'b11; // ORR
                default: ALUControl = 2'bx;  // unimplemented
            endcase
            // update flags if S bit is set
            // (C & V only updated for arith instructions)
            FlagW[1]      = Funct[0]; // FlagW[1] = S-bit
            // FlagW[0] = S-bit & (ADD | SUB)
            FlagW[0]      = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
        end else begin
            ALUControl = 2'b00; // add for non-DP instructions
            FlagW      = 2'b00; // don't update Flags
        end

    // PC Logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule