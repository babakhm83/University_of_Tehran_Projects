module down_counter_3bit (cnt,clk,rst, co);
    input cnt,clk,rst;
    output co;
    wire [2:0] pout;
    genvar i;
    S2 DFF0(
        .D00(pout[0]), .D01(1'b1),
        .D10(pout[0]), .D11(1'b0),
        .A1(pout[0]), .B1(pout[0]),
        .A0(cnt), .B0(cnt),
        .clr(rst), .clk(clk),
        .out(pout[0])
    );
	generate
        for (i = 1; i < 3; i = i + 1) begin
            S2 DFF(
                .D00(pout[i]), .D01(1'b1),
                .D10(pout[i]), .D11(1'b0),
                .A1(pout[i]), .B1(pout[i]),
                .A0(pout[i-1]), .B0(pout[i-1]),
                .clr(rst), .clk(pout[i-1]),
                .out(pout[i])
            );		
        end
	endgenerate
    C1 co_(
    .A0(1'b0),.A1(cnt),.SA(pout[0]),
    .B0(1'b0),.B1(1'b0),.SB(1'b0),
    .S0(pout[2]),.S1(pout[1]),.out(co)
    );	
endmodule