module decoder #(parameter BITS=3,N_PIPE=4) (N, pout);
    input [BITS-1:0] N;
    output [N_PIPE-1:0] pout;
    wire [N_PIPE-1:0] shifted,res;
    assign shifted = 1<<(N % N_PIPE +1);
    adder #(.BITS(N_PIPE))add(.pin0(shifted),.pin1(-{{(N_PIPE-1){1'b0}},1'b1}), .pout(res)); 
    assign pout = ~res;
endmodule