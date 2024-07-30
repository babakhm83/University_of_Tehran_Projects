`timescale 1ns/1ns
module q3_tb_1();
    reg d=1'd0;
    reg pre=1'd0;
    reg clr=1'd0;
    reg clk=1'd0;
    wire q,qb;
    q3 a1(d,clk,~pre,~clr,q,qb);
    always #37 clk=~clk;
    initial begin
        d=0; clr=0; pre=0;
        #50;
        #30; d=1;
        #80; clr=1;
        #29; d=0; clr=0;
        #45; pre=1;
        #20; pre=0;
        #80; d=1;
        #80; clr=1; pre=1;
        #80; pre=0; clr=0;
        #80; d=0;
        #100; $stop;
    end
endmodule
//24-36:d0to1
//36-24:d1to0
//24-12:clr0to1
//12-24:pre0to1
//12:pre0to1clr0to1