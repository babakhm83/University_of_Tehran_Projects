module Full_Adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire carry
);
    wire s;
    XOR xor_sum1(.A(a),.B(b), .out(s));
    XOR xor_sum2(.A(s),.B(cin), .out(sum));
    C1 c1_co(.A0(1'b0),.A1(cin),.SA(b),.B0(cin),.B1(1'b1),.SB(b),.S0(a),.S1(a),.out(carry));
endmodule