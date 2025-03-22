module overflow_detector #(parameter BITS=32) (pin0,pin1,sum, of);
    input signed [BITS-1:0] pin0,pin1;
    output of;
    output signed [BITS-1:0] sum;
    assign of = (pin0[BITS-1] & pin1[BITS-1] & ~sum[BITS-1]) | (~(pin0[BITS-1] | pin1[BITS-1]) & sum[BITS-1]);
endmodule