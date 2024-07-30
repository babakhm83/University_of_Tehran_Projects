`timescale 1ns/1ns
module q3(input D, clk,pre,clr, output Q, Qb);
    wire q0,qb0,q1,qb1;
    q1_sr_latch_1 #(3,3) a0(qb1,D,clk,clr,q0,qb0);
    q1_sr_latch_1 #(3,3) a1(qb0,clk,pre,clr,q1,qb1);
    q1_sr_latch_1 #(3,3) a2(qb1,q0,pre,clr,Q,Qb);
endmodule