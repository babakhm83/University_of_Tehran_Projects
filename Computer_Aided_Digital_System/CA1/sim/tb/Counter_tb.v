module counter_tb();
    reg clk=0,rst=1,clr=0,cnt=0;
    wire co;
    wire [2:0] po;
    counter #(.n(3)) count(.cnt(cnt),.clr(clr),.clk(clk),.rst(rst), .co(co),.pout(po));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; cnt=1;
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
        #38; cnt=0;
        #38; clr=1;
        #38; clr=0;
        #38; cnt=1;
        #38;
        $stop;
    end
endmodule