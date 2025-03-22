module adder #(parameter BITS=32) (pin0,pin1, pout);
    input signed [BITS-1:0] pin0,pin1;
    output signed [BITS-1:0] pout;
    assign pout = pin1 + pin0;
endmodule