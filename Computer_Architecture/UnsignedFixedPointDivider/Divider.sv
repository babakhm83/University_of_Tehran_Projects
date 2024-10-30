module divider(a_in,b_in,start,sclr,clk, q_out,dvz,ovf,busy,valid);
    input start,sclr,clk;
    input [9:0] a_in,b_in;
    output dvz,ovf,busy,valid;
    output [9:0] q_out;
    wire ldA,ldBQ,shA,ldQ,Q0,sclrA,cnt_sclr,cnt_en,cout,gt;
    datapath dp(clk,rst,a_in,b_in,ldA,ldBQ,shA,shQ,ldQ,Q0,sclrA,cnt_sclr,cnt_en, cout,gt,ovf_dp,dvz_dp,q_out);
    controller crtl(start,cout,gt,ovf_dp,dvz_dp,clk,rst, ldA,ldBQ,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy);
endmodule