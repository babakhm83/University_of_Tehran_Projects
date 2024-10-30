module counter_tb();
    reg clk=0,rst=1,sclr=0,cnt_en=0;
    wire co;
    wire [3:0] pout;
    counter14 count(clk,rst,sclr,cnt_en, co,pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; cnt_en=1;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38;
        #38; cnt_en=0;
        #38; sclr=1;
        #38; sclr=0;
        #38; cnt_en=1;
        #38;
        $stop;
    end
endmodule