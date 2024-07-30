module ALU(A,B,control, out,ZeroE,LessThanE);
    input signed [31:0] A,B;
    input [2:0] control;
    output ZeroE,LessThanE;
    output signed [31:0] out;
    reg signed [31:0] out;
    always @(A,B,control) begin
        out = A + B;
        case (control)
            3'b000: out = A + B;
            3'b001: out = A - B;
            3'b010: out = A & B;
            3'b011: out = A | B;
            3'b100: out = ({0,A} < {0,B}) ? 32'd1 : 32'd0;
            3'b101: out = (A < B) ? 32'd1 : 32'd0;
            3'b110: out = A ^ B;
            default: out = A + B;
        endcase
    end
    assign ZeroE = (A == B) ? 1 : 0;
    assign LessThanE = (A < B) ? 1 : 0;
endmodule