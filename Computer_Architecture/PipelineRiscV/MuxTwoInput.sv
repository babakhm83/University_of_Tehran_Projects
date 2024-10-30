module mux_two_input(A,B,sel, out);
    input [31:0] A,B;
    input sel;
    output [31:0] out;
    reg [31:0] out;
    always @(A,B,sel) begin
        out= sel ? B : A;
    end
endmodule