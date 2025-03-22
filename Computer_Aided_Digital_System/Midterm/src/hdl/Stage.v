module stage #(parameter BITS=32) (outX,X,powerX,of,mux_in0,mux_in1,mux_sel,out_sel, outX_o,X_o,powerX_o,of_o);
    input of,mux_sel,out_sel;
    input signed [BITS-1:0] outX,X,powerX,mux_in0,mux_in1;
    output of_o;
    output signed [BITS-1:0] outX_o,X_o,powerX_o;
    wire ofd_o;
    wire [BITS-1:0] mult,sum,constant;
    assign X_o=X;
    assign of_o=ofd_o | of;
    multiplier #(.BITS(BITS))mult0(.pin0(powerX),.pin1(X), .pout(powerX_o));
    multiplexer #(.BITS(BITS))mux0(.pin0(mux_in0),.pin1(mux_in1),.sel(mux_sel), .pout(constant));
    multiplier #(.BITS(BITS))mult1(.pin0(powerX_o),.pin1(constant), .pout(mult));
    adder #(.BITS(BITS))add(.pin0(mult),.pin1(outX), .pout(sum));
    overflow_detector #(.BITS(BITS))ofd(.pin0(mult),.pin1(outX),.sum(sum), .of(ofd_o));
    multiplexer #(.BITS(BITS))mux1(.pin0(sum),.pin1(outX),.sel(out_sel), .pout(outX_o));
endmodule