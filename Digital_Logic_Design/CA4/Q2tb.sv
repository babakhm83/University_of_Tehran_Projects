`timescale 1ns/1ns
module q2_tb_1();
    reg d=1'd0;
    reg clk=1'd0;
    wire q,qb;
    q2_edge_trigger a1(d,clk,q,qb);
    always #37 clk=~clk;
    initial begin
        d=0;
        #37; d=1;
        #37; d=1;
        #28; d=0;
        #83; d=1;
        #20;
	    #37; d=0;
        #22; d=1;
        #72; d=0;
        #100; $stop;
    end
endmodule
//c:0:0to1 10:1to0
//d:0:0to1 4:1to0