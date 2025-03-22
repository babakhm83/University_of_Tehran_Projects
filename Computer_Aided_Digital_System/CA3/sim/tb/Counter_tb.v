module Counter_tb();
    reg clk=0,rst=1,cnt=0;
    wire co1,c2;
    down_counter_3bit c0(cnt,clk,rst, co1);
    down_counter_4bit c1(cnt,clk,rst, co2);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #19; rst=1'b0;
        #38; cnt=1;
        #38; cnt=0;
        #38; cnt=1;
        #38; cnt=0;
        #38; cnt=1;
        #38; cnt=0;
        #38; cnt=1;
        #38; cnt=0;
        #38; cnt=1;
        #38;
        #38;
        #38;
        $stop;
    end
endmodule
