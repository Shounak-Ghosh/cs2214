module binary_to_gray(B,G);
    // initialize the inputs and outputs to 4 bits each
    input [3:0] B;
    output [3:0] G;

    // follow the problem description to assign the outputs
    assign G[3] = B[3];
    assign G[2] = B[3] ^ B[2];
    assign G[1] = B[2] ^ B[1];
    assign G[0] = B[1] ^ B[0];



endmodule // binary_to_gray