module majority(A,Y);
    input [2:0] A;
    output Y;

    wire w1,w2,w3,w4;

    assign w1 = A[0] & A[1];
    assign w2 = A[1] & A[2];
    assign w3 = A[0] & A[2];

    assign Y = (w1 | w2) | w3;
endmodule