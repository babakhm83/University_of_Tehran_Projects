`timescale 1ns/1ns
module q1_sr_latch_1 #(parameter q_inputs_cnt = 2, qb_inputs_cnt=2) (input S, R, S1,R1, output Q, Qb);
    nand #(q_inputs_cnt*4) n0(Q,S,S1,Qb);
    nand #(qb_inputs_cnt*4) n1(Qb,R,R1,Q);
endmodule
