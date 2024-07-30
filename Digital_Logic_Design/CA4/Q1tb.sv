`timescale 1ns/1ns
module q1_tb_1();
    reg s=1'd0;
    reg r=1'd0;
    reg clk=1'd1;
    wire q,qb;
    q1_sr_latch_1 #(2,2) a1(s,r,clk,clk,q0,qb0);
    initial begin
        s=0; r=0;
        #50; s=0; r=0;
        #50; s=0; r=0;
        #50; s=0; r=1;
        #50; s=0; r=1;
        #50; s=1; r=0;
        #50; s=1; r=0;
        #50; s=0; r=0;
        #50; s=0; r=0;
        #50; s=1; r=1;
        #50; s=1; r=1;
        #50; s=0; r=0;
        #50; s=0; r=0;
        #50;
    end
endmodule