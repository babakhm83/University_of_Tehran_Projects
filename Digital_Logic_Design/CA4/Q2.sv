`timescale 1ns/1ns
module q2_edge_trigger(input D, clk, output Q, Qb);
    wire q0,qb0,q1,qb1;
    wire z=1'd1;
    q1_sr_latch_1 #(3,2) a0(qb1,D,clk,z,q0,qb0);
    q1_sr_latch_1 #(2,2) a1(qb0,clk,z,z,q1,qb1);
    q1_sr_latch_1 #(2,2) a2(qb1,q0,z,z,Q,Qb);
endmodule