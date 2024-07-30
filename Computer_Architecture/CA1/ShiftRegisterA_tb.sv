module shift_registerA_tb();
    reg clk=0,rst=1,sload=0,sclr=0,serin=0,sshl=0;
    reg [9:0] pin=10'd3;
    wire [9:0] pout;
    shift_registerA shiftregA(pin,sload,sclr,serin,sshl,clk,rst, pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; sload=1;
        #38; sload=0;
        #38; serin=1; sshl=1;
        #38; sshl=0;
        #38; sclr=1;
        #38; sclr=0;
        #38;
        $stop;
    end
endmodule