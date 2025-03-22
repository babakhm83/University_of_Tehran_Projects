module AND (A, B, out);
    input A,B;
    output out;
    C1 c1 (
        .A0(1'b0),
        .A1(1'b0),
        .SA(1'b0),
        .B0(1'b0),
        .B1(1'b1),
        .SB(B),
        .S0(A),
        .S1(A),
        .out(out)
    );
endmodule