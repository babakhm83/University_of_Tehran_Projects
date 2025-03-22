module natural_log_acc_tb();
    parameter BITS_X=8,BITS_N=3;
    reg clk=0,rst=1,Reset=0,Start=0;
    reg [BITS_N-1:0] N={BITS_N{1'b0}};
    reg signed [BITS_X-1:0] X={BITS_X{1'b0}};
    wire signed [4*BITS_X-1:0] Y;
    wire Valid,Ready,Error,Overflow;
    natural_log_acc #(.BITS_X(BITS_X),.BITS_N(BITS_N))nla(.Start(Start),.X(X),.N(N),.Reset(Reset),.clk(clk),.rst(rst), .Valid(Valid),.Ready(Ready),.Error(Error),.Overflow(Overflow),.Y(Y));
    always begin #19;clk=~clk;end
    initial begin
        #38; rst=1'b0;
        #38; Start=1;
        #38; Start=0;N=7;
        #38;
        #38; X={2'b01,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b11,{6{1'b0}}};
        #38;#38;#38;#38;
        #38; X=8'b00001100; // x=0.09375 ln=0.08961215868 ans=0.08961215661838650703
        #38; X=8'b11010000; // x=-0.375 ln=-0.47000362924 ans=-0.4699789742
        #38; X=8'b00101101; // x=0.3515625 ln=0.30126133057 ans=0.30125439912080764771
        #38; X=8'b00100101; // x=0.2890625 ln=0.25391520998 ans=0.25391396461054682732
        #380;Reset=1'b1;
        #38;Reset=1'b0;
        #38; Start=1;
        #38;Start=0;N=7;
        #38;
        #38; X=8'b01111111; // x=0.9921875 ln=0.68923328123 ans=0.63440362270921468735 using formula=0.634403626209939
        #38; X=8'b11111111; // x=-0.2890625 ln=-0.00784317746 ans=-0.00784317823
        #38; X=8'b00000000; // x=0 ln=0 ans=0
        #38; X=8'b10000000; // x=-1 ln=undefined ans=error
        #400;Reset=1'b1;
        #38;Reset=1'b0;
        #38; Start=1;
        #38;Start=0;N=2;
        #38;
        #38; X={2'b01,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b11,{6{1'b0}}};
        #200;Reset=1'b1;
        #38;Reset=1'b0;
        #38; Start=1;
        #38;Start=0;N=3;
        #38;
        #38; X={2'b01,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b11,{6{1'b0}}};
        #200;Reset=1'b1;
        #38;Reset=1'b0;
        #38; Start=1;
        #38;Start=0;N=4;
        #38;
        #38; X={2'b01,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b00,{6{1'b0}}};
        #38; X={2'b11,{6{1'b0}}};
        #380;
        $stop;
    end
endmodule