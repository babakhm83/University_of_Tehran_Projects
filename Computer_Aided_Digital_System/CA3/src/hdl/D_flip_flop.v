module D_flip_flop(clk,rst,D,out);
    input clk,rst,D,out;
    S2 DFF0 (
        .D00(D), .D01(1'b0),
        .D10(1'b0), .D11(1'b0),
        .A0(1'b0), .B0(1'b0),
        .A1(1'b0), .B1(1'b0),
        .clr(rst), .clk(clk),
        .out(out)
    );
    
endmodule