module Half_Adder (a, b, sum, carry);
    input a,b;
    output sum, carry;

    XOR xor0(
        .A(a),
        .B(b),
        .out(sum)
    );

    AND and0(
        .A(a),
        .B(b),
        .out(carry)
    );
endmodule