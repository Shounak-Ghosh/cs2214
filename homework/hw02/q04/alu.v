`include "four_bit_adder.v"

module alu(A, B, Op, S);

   input [3:0]  A;
   input [3:0]  B;
   output [3:0] S;  // Y in the diagram
   input [2:0]  Op; // F in the diagram

   wire Cout; 
   wire [3:0] adder_out;
   wire [3:0] Bmux = Op[2] ? ~B : B;

   // Op[2] is the carry in to the adder 0 for add, 1 for subtract
   four_bit_adder adder(A, Bmux, Op[2], adder_out, Cout);
   wire [3:0] slt;
   // zero extend MSB of adder out
   assign slt = {3'b0,adder_out[3]};

   // order of ternary return values: x11 x10 x01 x00
   assign S = Op[1] ? Op[0] ? slt : adder_out : Op[0] ? A | Bmux : A & Bmux;



endmodule // alu
