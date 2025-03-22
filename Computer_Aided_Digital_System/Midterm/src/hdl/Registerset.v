module registerset #(parameter BITS=32) (outX,of,X,powerX,clk,rst, outX_o,of_o,X_o,powerX_o);
    input of,clk,rst;
    input signed [BITS-1:0] outX,X,powerX;
    output of_o;
    output signed [BITS-1:0] outX_o,X_o,powerX_o;
    register #(.BITS(32))r_outX(.pin(outX),.ld(1'b1),.clk(clk),.rst(rst), .pout(outX_o));
    register #(.BITS(32))r_X(.pin(X),.ld(1'b1),.clk(clk),.rst(rst), .pout(X_o));
    register #(.BITS(32))r_powerX(.pin(powerX),.ld(1'b1),.clk(clk),.rst(rst), .pout(powerX_o));
    register #(.BITS(1))r_of(.pin(of),.ld(1'b1),.clk(clk),.rst(rst), .pout(of_o));
endmodule