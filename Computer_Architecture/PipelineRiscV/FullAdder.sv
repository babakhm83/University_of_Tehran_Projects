module full_adder(A,B, out);
    input signed [31:0] A,B;
    output signed [31:0] out;
    reg signed [31:0] out;
    always @(A,B) begin
        out = A + B;
    end
endmodule