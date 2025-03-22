module pipeline #(parameter BITS=32)(outX_in,X_in,powerX_in,of_in,cte0,cte1,sel_cte,out_sel,clk,rst, outX_o,X_o,powerX_o,of_o);
    input of_in,sel_cte,out_sel,clk,rst;
    input signed [BITS-1:0] outX_in,X_in,powerX_in,cte0,cte1;
    output of_o;
    output signed [BITS-1:0] outX_o,X_o,powerX_o;
    wire of;
    wire signed [BITS-1:0] outX,X,powerX;
    registerset #(.BITS(BITS))r41(.outX(outX_in),.of(of_in),.X(X_in),.powerX(powerX_in),.clk(clk),.rst(rst),
    .outX_o(outX),.of_o(of),.X_o(X),.powerX_o(powerX));
    stage #(.BITS(BITS))p1(.outX(outX),.X(X),.powerX(powerX),.of(of),.mux_in0(cte0),.mux_in1(cte1),.mux_sel(sel_cte),.out_sel(out_sel),
    .outX_o(outX_o),.X_o(X_o),.powerX_o(powerX_o),.of_o(of_o));
endmodule