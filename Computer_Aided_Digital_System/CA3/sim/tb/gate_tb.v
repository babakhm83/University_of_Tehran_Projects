module gate_tb();
    reg clk=0,rst=1,a=0,b=0;
    wire and_o,or_o,xor_o,not_o;
    AND and0(.A(a),.B(b),.out(and_o));
    OR or0(.A(a),.B(b),.out(or_o));
    XOR xor0(.A(a),.B(b),.out(xor_o));
    NOT not0(.A(a),.out(not_o));
    reg SB=0,SA=0,S1=0,S0=0,A0=0,B0=1,A1=0,B1=1;
    wire F;
    C1 c1(SB,SA,S1,S0,A0,B0,A1,B1, F);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; a=0;b=0;
        #38; a=1;b=0;S1=0;
        #38; a=0;b=1;S1=1;
        #38; a=1;b=1;
        #38;
        $stop;
    end
endmodule
