module approximate_multiplier #(parameter n_input = 16, parameter n_effective=8,parameter n_multiplications = 8) (Start,clk,rst, Done);
    input Start,clk,rst;
    output Done;
    wire cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,msb1,msb2,co1,co2,co3,wr;
    datapath #(.n_input(n_input), .n_effective(n_effective),.n_multiplications(n_multiplications))dp(.clk(clk),.rst(rst),.cnt1(cnt1),.shl1(shl1),
    .shl2(shl2),.shl3(shl3),.cnt2(cnt2),.clr_cntr(clr_cntr),.ld1(ld1),.ld2(ld2),.ld3(ld3), .msb1(msb1),.msb2(msb2),.co1(co1)
    ,.co2(co2),.co3(co3),.wr(wr));
    controller ctrl(.Start(Start),.msb1(msb1),.msb2(msb2),.co1(co1),.co2(co2),.clk(clk),.rst(rst), .Done(Done),.cnt1(cnt1),.shl1(shl1),.shl2(shl2),
    .shl3(shl3),.cnt2(cnt2),.clr_cntr(clr_cntr),.ld1(ld1),.ld2(ld2),.ld3(ld3),.co3(co3),.wr(wr));
endmodule