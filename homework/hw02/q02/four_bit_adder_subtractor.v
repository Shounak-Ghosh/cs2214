// Include our full adder source file.
`include "full_adder_nodelay.v"

// Define a four-bit ripple carry adder.
//
//  Inputs: 4-bit numbers A and B, and Operation
//       For the operation, 0 means addition
//                          1 means subtraction
//  Outputs: 4-bit sum S, carry out bit Cout
//
module four_bit_adder_subtractor(A, B, Op, S, Cout);

   // Note the special syntax here to tell the Verilog compiler that A
   // and B are not single-bit values, but 4-bit values.  These are
   // known as arrays in verilog. The 3:0 here indicates we will index
   // the bits of A and B from three (MSB) down to zero (LSB).
   input [3:0]  A;
   input [3:0]  B;
   input        Op;

   // Similarly, S is a four-bit output. Cout is a one-bit output
   output [3:0] S;
   output       Cout;

   // We need three wires to transmit the carry bits between
   // the individual full adders.
   wire         C1, C2, C3;
   wire final_carry;
   wire [3:0] final_B;
   // If Op is 1, we negate all the bits of B and set the carry in to 1.
   assign final_B = Op  ? ~B : B;
   assign final_carry = Op ? 1'b1 : 1'b0;

   // Here we are just instantiating four separate full adder modules
   // connected by wires. 
   full_adder_nodelay FA1(A[0], final_B[0], final_carry, S[0], C1);
   full_adder_nodelay FA2(A[1], final_B[1], C1,  S[1], C2);
   full_adder_nodelay FA3(A[2], final_B[2], C2,  S[2], C3);
   full_adder_nodelay FA4(A[3], final_B[3], C3,  S[3], Cout);
   
endmodule // four_bit_rca_nodelay


   
