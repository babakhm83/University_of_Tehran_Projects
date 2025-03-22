module datapath #(parameter n_input = 16, parameter n_effective=8)
(clk,rst,pin1,pin2,shr1,shr2,cnt1,cnt2,ld1,ld2, lsb2,half1,half2,co1,co2,pout);
  input clk,rst,shr1,shr2,cnt1,cnt2,ld1,ld2;
  input [n_input-1:0] pin1,pin2;
  output lsb2,half1,half2,co1,co2;
  output [2*n_effective-1:0] pout;
  wire [n_input-1:0] rpo1;
  assign lsb2 = pout[0];
  down_counter_4bit cnter(.cnt(cnt1),.clk(clk),.rst(rst), .co(co1));
  Shift_register #(.N(n_input))regp1(.pin1(pin1),.ld(ld1),.shr(shr1),.clk(clk),.rst(rst), .pout(rpo1),.half(half1),.mid(co2)); // stay load shr shift1
  Shift_register2 #(.N(n_input))regp2(.pin1(pin2),.pin2(rpo1[n_input/2-1:0]),
  .ld(ld2),.shr(shr2),.clk(clk),.rst(rst), .pout(pout),.half(half2)); // stay load shr add
endmodule