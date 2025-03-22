module multiplexer #(parameter BITS=32) (pin0,pin1,sel, pout);
    input sel;
    input signed [BITS-1:0] pin0,pin1;
    output signed [BITS-1:0] pout;
    assign pout = sel ? pin1 : pin0;
endmodule