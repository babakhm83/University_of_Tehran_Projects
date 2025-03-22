module natural_log_acc #(parameter BITS_X=8,BITS_N=3) (Start,X,N,clk,rst,Reset, Valid,Ready,Error,Overflow,Y);
    input Start,clk,rst,Reset;
    input signed [BITS_X-1:0] X;
    input [BITS_N-1:0] N;
    output Valid,Ready,Error,Overflow;
    output signed [4*BITS_X-1:0] Y;
    wire selX,ldN,shl,sel_decode,Nlt,error;
    datapath #(.BITS_X(BITS_X),.BITS_N(BITS_N))dp(.N(N),.X(X),.selX(selX),.sel_decode(sel_decode),.ldN(ldN),.shl(shl),.clk(clk),.rst(rst|Reset), 
    .Nlt(Nlt),.out(Y),.of(Overflow),.error(error));
    controller ctrl(.Start(Start),.Nlt(Nlt),.of(Overflow),.error(error),.clk(clk),.rst(rst|Reset), .Valid(Valid),.Ready(Ready),.selX(selX),.sel_decode(sel_decode),.ldN(ldN),.shl(shl),.Error(Error));
endmodule