module multiplier#(parameter WIDTH=3)(pin1,pin2, pout);
    input [WIDTH-1:0] pin1,pin2;
    output [WIDTH-1:0] pout;
    wire [2*WIDTH-1:0] mult;
    assign mult = pin1 * pin2;
    assign pout = mult[WIDTH-1:0];
endmodule