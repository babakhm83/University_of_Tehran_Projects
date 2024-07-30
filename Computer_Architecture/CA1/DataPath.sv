module datapath(clk,rst,Ain,Bin,ldA,ldB,shA,shQ,ldQ,Q0,sclrA,cnt_sclr,cnt_en, cout,gt,ovf,dvz,out);
  input clk,rst,ldA,ldB,shA,shQ,ldQ,Q0,sclrA,cnt_sclr,cnt_en;
  input [9:0] Ain,Bin;
  output cout,gt,ovf,dvz;
  output [9:0] out;
  wire serinA;
  wire [3:0] cnt;
  wire [9:0] sub,A,B,Q;
  assign out=Q;
  registerB regB(Bin,ldB,clk,rst, B);
  shift_registerQ shregQ(Ain,ldQ,Q0,shQ,clk,rst, serinA,Q);
  shift_registerA shregA(sub,ldA,sclrA,serinA,shA,clk,rst, A);
  subtractor subtract(A,B,sub);
  counter14 count(clk,rst,cnt_sclr,cnt_en,cout,cnt);
  comparator compareAQ(A,B,gt);
  overflowdetector ovfdetector(cnt,Q,ovf);
  dividebyzerodetector dvzdetector(B,dvz);
endmodule