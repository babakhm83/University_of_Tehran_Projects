module multiplier #(parameter n=8) (pin1,pin2, pout);
    input unsigned [n-1:0] pin1,pin2;
    output unsigned [2*n-1:0] pout;
    assign pout = pin1*pin2;
endmodule