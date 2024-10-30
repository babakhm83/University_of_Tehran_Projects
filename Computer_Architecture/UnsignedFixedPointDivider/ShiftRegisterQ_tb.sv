module shift_registerQ_tb();
    reg clk=0,rst=1,sload=0,serin=0,sshl=0;
    reg [9:0] pin=10'd3;
    wire lout;
    wire [9:0] pout;
    shift_registerQ shiftregQ(pin,sload,serin,sshl,clk,rst, lout,pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; sload=1;
        #38; sload=0;
        #38; serin=1; sshl=1;
        #38; sshl=0;
        #38; pin=10'b1010001101; sload=1;
        #38; sload=0;
        #38; serin=0; sshl=1;
        #38; sshl=1;
        #38; sshl=0;
        #38;
        $stop;
    end
endmodule