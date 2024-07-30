module mux_four_input(A,B,C,D,sel, out);
    input [31:0] A,B,C,D;
    input [1:0] sel;
    output [31:0] out;
    reg [31:0] out;
    always @(A,B,C,D, sel) begin
        out = A;
        case (sel)
            2'b00: out = A;
            2'b01: out = B;
            2'b10: out = C;
            2'b11: out = D;
            default: out = A;
        endcase
    end
endmodule