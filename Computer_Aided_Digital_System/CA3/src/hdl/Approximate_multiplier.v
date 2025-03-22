module approximate_multiplier #(parameter n_input = 16, parameter n_effective=8,parameter n_multiplications = 8) (Start,pin1,pin2,clk,rst, Done,pout);
    input Start,clk,rst;
    input [n_input-1:0] pin1,pin2;
    output Done;
    output [2*n_effective-1:0] pout;
    wire shr1,shr2,cnt1,cnt2,ld1,ld2,lsb2,half1,half2,co1,co2;
    datapath #(.n_input(n_input), .n_effective(n_effective))dp
    (.clk(clk),.rst(rst),.pin1(pin1),.pin2(pin2),.shr1(shr1),.shr2(shr2),.cnt1(cnt1),.cnt2(cnt2),.ld1(ld1),.ld2(ld2), 
    .lsb2(lsb2),.half1(half1),.half2(half2),.co1(co1),.co2(co2),.pout(pout));
    controller ctrl(.Start(Start),.lsb2(lsb2),.half1(half1),.half2(half2),.co1(co1),.co2(co2),.clk(clk),.rst(rst), 
    .Done(Done),.shr1(shr1),.shr2(shr2),.cnt1(cnt1),.cnt2(cnt2),.ld1(ld1),.ld2(ld2));
endmodule