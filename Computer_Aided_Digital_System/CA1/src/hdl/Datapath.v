module datapath #(parameter n_input = 16, parameter n_effective=8,parameter n_multiplications = 8)
(clk,rst,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr, msb1,msb2,co1,co2,co3);
  input clk,rst,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr;
  output msb1,msb2,co1,co2,co3;
  wire [n_input-1:0] p2i,p2i1,rpo1,rpo2;
  wire [2*n_effective-1:0] mout;
  wire [2*n_input-1:0] rpi3,rpo3;
  wire [$clog2(n_multiplications)-1:0] cpo1;
  wire [$clog2(n_effective)-1:0] cpo2;
  assign msb1 = rpo1[n_input-1];
  assign msb2 = rpo2[n_input-1];
  assign rpi3 = {{n_input{'b0}},mout};
  input_ram #(.r(2*n_multiplications),.n(n_input))in_ram(.i(cpo1),.clk(clk),.rst(rst), .po1(p2i), .po2(p2i1));
  register_pin #(.n(n_input))regp1(.pin(p2i),.ld(ld1),.shl(shl1),.clk(clk),.rst(rst), .pout(rpo1));
  register_pin #(.n(n_input))regp2(.pin(p2i1),.ld(ld2),.shl(shl2),.clk(clk),.rst(rst), .pout(rpo2));
  multiplier mult(.pin1(rpo1[n_input-1:n_input/2]),.pin2(rpo2[n_input-1:n_input/2]), .pout(mout));
  register_pin #(.n(2*n_input))regp3(.pin(rpi3),.ld(ld3),.shl(shl3),.clk(clk),.rst(rst),.pout(rpo3));
  output_ram #(.r(n_multiplications),.n(2*n_input))out_ram(.i(cpo1),.pi(rpo3),.clk(clk),.rst(rst),.wr(wr));
  counter #(.n($clog2(n_multiplications)))cnter1(.cnt(cnt1),.clr(1'b0),.clk(clk),.rst(rst), .co(co1),.pout(cpo1));
  counter #(.n($clog2(n_effective)))cnter2(.cnt(cnt2),.clr(clr_cntr),.clk(clk),.rst(rst), .co(co2),.pout(cpo2));
  counter_with_two_cnt #(.n($clog2(n_input)))cnter3(.cnt1(shl1),.cnt2(shl2),.clr(clr_cntr),.clk(clk),.rst(rst), .co(co3));
endmodule