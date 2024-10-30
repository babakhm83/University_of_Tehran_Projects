module subtractor(A,B,out);
    input [9:0] A,B;
    output [9:0] out;
    reg [9:0] out;
    always @(A,B) begin
        out=A-B;
    end
endmodule