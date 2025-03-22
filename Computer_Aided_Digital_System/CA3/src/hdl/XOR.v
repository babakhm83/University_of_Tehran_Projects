module XOR (A, B, out);
    input A,B;
    output out;
    C1 c1 (
        .A0(1'b0),
        .A1(1'b1),
        .SA(B),
        .B0(1'b1),
        .B1(1'b0),
        .SB(B),
        .S0(A),
        .S1(A),
        .out(out)
    );
endmodule