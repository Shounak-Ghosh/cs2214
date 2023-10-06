module E15Process(input clk);

   // Register names
   parameter 
      Rg0 = 2'b00, Rg1 = 2'b01,
      Rg2 = 2'b10, Rg3 = 2'b11, 
      RXX = 2'b00;

   // Opcodes
   parameter
     jmp  = 4'b0000, jz   = 4'b0010,
     movi = 4'b1001, mov  = 4'b1000,
     addi = 4'b1011, add  = 4'b1010,
     subi = 4'b1101, sub  = 4'b1100,
     cmpi = 4'b1111, cmp  = 4'b1110,
     jnz  = 4'b0011;
   

   /*Processor state (actual values) */
   reg [3:0] pc;             // Program Counter
   reg       zFlag;          // Zero flag
   reg [3:0] r0, r1, r2, r3; // Registers


   /*Program storage*/
   reg [11:0] myROM [15:0]; // ROM (holds program)

   initial
     begin

        `include "leq.v"   // load the program
        
        pc = 4'b0000;           // initialize the program counter
        
     end


   /*Parts of the instruction*/
   wire [3:0] opCode;         // op code
   wire [1:0] src, dst;       // src and dst register
   wire [3:0] immData;        // "Immediate" data


   wire [3:0] pcIncr; // Program Counter Increment
   wire [3:0] pcRes;  // Output of pc ALU
   wire       pcz;    // Unused - zero flag for pc ALU
   
   wire [3:0] storeVal, operand1, operand2;

   /*ALU wires*/
   wire       addNotSub; // Determines if ALU adds or subtracts
   wire [3:0] aluOutput;    // Output (combinational) of ALU
   wire       aluOutputZero;      // Output (combinational) of ALU zero flag


   
   assign {opCode, src, dst, immData} = myROM[pc];
   assign addNotSub = ((opCode == add) | (opCode == addi));


   /*
   pcIncr is a 4-bit value representing the value
   that is to be added to the program counter
   logic: if jmp, then immData, else if jz and zFlag, 
            then immData, else if jnz and not zFlag, 
            then immData, else 1  
   */
   assign pcIncr = (opCode == jmp) ? immData :
                    (opCode == jz)  ? (zFlag ? immData : 4'b0001) :
                    (opCode == jnz) ? (zFlag ? 4'b0001 : immData) : 
                    4'b0001;
  
   /*
   storeVal is a 4-bit value representing the value that
   is to be stored in the destination register, for
   instructions that write to it
   logic: If mov, then src (0 if RXX)), 
          else if movi, then immData 
          else aluOutput
   */
   assign storeVal = (opCode == mov) ? (src == Rg0) ? r0 :
                                        (src == Rg1) ? r1 :
                                        (src == Rg2) ? r2 :
                                        (src == Rg3) ? r3 : 4'bz :
                      (opCode == movi) ? immData : aluOutput;
   
   /* 
   operand1 is a 4-bit value representing the first operand
   to be passed into the ALU
   logic: If addi, subi, cmpi, then immData
          else if src is Rg0, then r0
          else if src is Rg1, then r1
          else if src is Rg2, then r2
          else if src is Rg3, then r3
          else 0 (RXX)
   */
   assign operand1 = (opCode == addi | opCode == subi | opCode == cmpi) ? immData :
                     (src == Rg0) ? r0 :
                     (src == Rg1) ? r1 :
                     (src == Rg2) ? r2 :
                     (src == Rg3) ? r3 : 4'bz; 
   
   /*
   operand1 is a 4-bit value representing the second operand
   to be passed into the ALU
   logic: If dst is Rg0, then r0
          else if dst is Rg1, then r1
          else if dst is Rg2, then r2
          else if dst is Rg3, then r3
          else 0 (RXX)
   */
   assign operand2 = (dst == Rg0) ? r0 :
                     (dst == Rg1) ? r1 :
                     (dst == Rg2) ? r2 :
                     (dst == Rg3) ? r3 : 4'bz;

   always @(posedge clk)
      begin 

        // Update zero flag
        case(opCode)
          addi, add, subi, sub, cmpi, cmp:
            begin
               zFlag <= aluOutputZero; // taken care of by dataALU
            end
        endcase

        // update destination register
        case(opCode)
          movi, mov, add, addi, sub, subi:
            case(dst) // switch statement, will store storeVal in appropriate register
              Rg0: r0 <= storeVal;
              Rg1: r1 <= storeVal;
              Rg2: r2 <= storeVal;
              Rg3: r3 <= storeVal;
            endcase
        endcase

        // Update program counter
        pc <= pcRes; // taken care of by pcALU
 
     end

   // inputs/outputs:        add/sub, operand1, operand2, zero flag, operation result
   simpleALU dataALU(addNotSub, operand1, operand2, aluOutputZero, aluOutput);
   // input is always add
   simpleALU pcALU(1'b1, pc, pcIncr, pcz, pcRes);

endmodule


module simpleALU(
    input addNotSub,
    input [3:0] src, dst,
    output zFlag,
    output [3:0] res);
    wire Cout;

    fourbit_adder the_adder(dst, addNotSub ? src : ~src, ~addNotSub, res, Cout);

    assign zFlag = !(res);

endmodule

module fourbit_adder(A,B, Cin, S, Cout);

    input [3:0] A;
    input [3:0] B;
    input Cin;
    output[3:0] S;
    output Cout;

    wire temp0, temp1, temp2;

    full_adder_nodelay first(A[0], B[0], Cin, S[0], temp0);
    full_adder_nodelay second(A[1], B[1], temp0, S[1], temp1);
    full_adder_nodelay third(A[2], B[2], temp1, S[2], temp2);
    full_adder_nodelay fourth(A[3], B[3], temp2, S[3], Cout);

endmodule

module full_adder_nodelay(A, B, Cin, S, Cout);

    input A, B, Cin;
    output S, Cout;

    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule



//ra0Eequ6ucie6Jei0koh6phishohm9