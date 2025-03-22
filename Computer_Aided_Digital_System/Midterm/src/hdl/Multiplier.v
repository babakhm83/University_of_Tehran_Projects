module multiplier #(parameter BITS=32) (pin0,pin1, pout);
    input signed [BITS-1:0] pin0,pin1;
    output signed [BITS-1:0] pout;
    wire signed [2*BITS-2:0] prod;
    assign prod = pin1 * pin0;
    assign pout = prod[2*BITS-2 : 2*BITS-1 - BITS];
endmodule