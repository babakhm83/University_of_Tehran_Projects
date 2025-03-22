module comparator #(parameter BITS) (pin0,pin1, lt);
    input signed [BITS-1:0] pin0,pin1;
    output lt;
    wire [BITS-1:0] sub;
    assign lt=sub[BITS-1];
    adder #(.BITS(BITS))add(.pin0(pin0),.pin1(-pin1),.pout(sub));
endmodule