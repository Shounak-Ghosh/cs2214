module recitation2a(A,B,X);
    input A,B;
    ouput X;

    wire w1, w2, w3;
    assign w1 = ~(A | ~B)
    assign w2 = A & B;
    assign w3 = ~(w1 | w2);

    assign X = ~(w3 & (A|B));
endmodule




