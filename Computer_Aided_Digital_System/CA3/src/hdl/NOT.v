module NOT (A, out);
    input A;
    output out;
    C1 c1 (
        .A0(1'b1),
        .A1(1'b0),
        .SA(A),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(1'b0),
        .S1(1'b0),
        .out(out)
    );
endmodule