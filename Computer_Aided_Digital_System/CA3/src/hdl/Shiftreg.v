module Shift_register #(parameter N = 4)(pin1,shr,ld,rst,clk, half,pout,mid); // stay load shr shift1
    input [N-1:0] pin1;
    input shr,ld,rst,clk;
    output [N-1:0] pout;
    output half,mid;
    S2 DFFN (
        .D00(pout[N-1]), .D01(pin1[N-1]),
        .D10(1'b0), .D11(1'b1),
        .A0(ld), .B0(ld),
        .A1(shr), .B1(shr),
        .clr(rst), .clk(clk),
        .out(pout[N-1])
    );
    wire half1,half2;
    assign mid = pout[N/2+1];
    C1 h1(.A0(1'b1),.A1(1'b0),.SA(pout[N-3]),.B0(1'b0),.B1(1'b0),.SB(1'b0),.S0(pout[N-2]),.S1(pout[N-1]),.out(half1));
    C1 h2(.A0(1'b1),.A1(1'b0),.SA(pout[N-6]),.B0(1'b0),.B1(1'b0),.SB(1'b0),.S0(pout[N-5]),.S1(pout[N-4]),.out(half2));
    C1 h3(.A0(1'b0),.A1(half2),.SA(half1),.B0(1'b0),.B1(1'b0),.SB(1'b0),.S0(pout[N-8]),.S1(pout[N-7]),.out(half));
    genvar i;
    generate
        for (i = N/2; i < N-1; i = i + 1) begin : gen_dffa
            S2 DFFa (
                .D00(pout[i]), .D01(pin1[i]),
                .D10(pout[i+1]), .D11(pout[i+1]),
                .A0(ld), .B0(ld),
                .A1(shr), .B1(shr),
                .clr(rst), .clk(clk),
                .out(pout[i])
            );
        end
        for (i = 0; i < N/2; i = i + 1) begin : gen_dffb
            S2 DFFb (
                .D00(pout[i]), .D01(pin1[i]),
                .D10(pout[i+1]), .D11(pout[i]),
                .A0(ld), .B0(ld),
                .A1(shr), .B1(shr),
                .clr(rst), .clk(clk),
                .out(pout[i])
            );
        end
    endgenerate
endmodule

