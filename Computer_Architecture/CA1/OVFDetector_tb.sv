module overflowdetector_tb();
    reg clk=0,rst=1,sclr=0,cnt_en=0;
    wire co;
    wire [3:0] cnt;
    counter14 count(clk,rst,sclr,cnt_en, co,cnt);
    counter14 counter();
    reg [9:0] Q=5'd1;
    wire ovf;
    overflowdetector ovfd(cnt,Q, ovf);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; cnt_en=1;
        repeat (10)
            #38;
        Q=128;
        repeat (15)
            #38;
        $stop;
    end
endmodule