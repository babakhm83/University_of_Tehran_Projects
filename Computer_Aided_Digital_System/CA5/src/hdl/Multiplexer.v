module multiplexer#(parameter WIDTH=3)(pin0,pin1,sel, pout);
    input sel;
    input [WIDTH-1:0] pin0,pin1;
    output [WIDTH-1:0] pout;
    assign pout = sel ? pin1 : pin0;
endmodule