module counter_with_two_cnt_tb();
    reg clk=0,rst=1,cnt1=0,cnt2=0,clr;
    wire co;
    counter_with_two_cnt #(.n(3)) count(.cnt1(cnt1),.cnt2(cnt2),.clr(clr),.clk(clk),.rst(rst), .co(co));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; cnt1=1;cnt2=0;
        #38; cnt1=1;cnt2=1;
        #38; cnt1=0;cnt2=0;
        #38; cnt1=0;cnt2=0;
        #38;
        #38; clr=1'b1;
        #38; clr=1'b0;
        #38;
        $stop;
    end
endmodule