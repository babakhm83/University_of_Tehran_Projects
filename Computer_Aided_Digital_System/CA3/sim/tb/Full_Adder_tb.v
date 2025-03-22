module Full_Adder_tb();
    reg clk=0,rst=1,a=0,b=0,c=0;
    wire s,co;
    Full_Adder fa(.a(a),.b(b),.cin(c),.sum(s),.carry(co));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; a=0;b=0;c=0;
        #38; a=1;b=0;c=0;
        #38; a=0;b=1;c=0;
        #38; a=0;b=0;c=1;
        #38; a=0;b=1;c=1;
        #38; a=1;b=1;c=1;
        #38; a=1;b=1;c=0;
        #38; a=1;b=0;c=1;
        #38;
        $stop;
    end
endmodule
