module controller(Start,lsb2,half1,half2,co1,co2,clk,rst, Done,shr1,shr2,cnt1,cnt2,ld1,ld2);
    input Start,lsb2,half1,half2,co1,co2,clk,rst;
    output Done,shr1,shr2,cnt1,cnt2,ld1,ld2;
    wire idle_w,wait_w,input_w,shr1_w,shr2_w,mult_w,sh0_w,done_w,init;
    D_flip_flop Init(.clk(clk),.rst(1'b0),.D(rst),.out(init));
    S2 Idle_(.D00(idle_w),.D01(1'b0),.D10(1'b1),.D11(1'b1),.A0(1'b1),.B0(Start),.A1(init),.B1(done_w),.clr(rst),.clk(clk),.out(idle_w));
    S2 Wait_(.D00(1'b0),.D01(1'b0),.D10(1'b0),.D11(Start),.A1(wait_w),.B1(idle_w),.A0(1'b1),.B0(1'b1),.clr(rst),.clk(clk),.out(wait_w));
    S2 Input_(.D00(wait_w),.D01(1'b0),.D10(1'b0),.D11(1'b0),.A1(Start),.B1(Start),.A0(Start),.B0(Start),.clr(rst),.clk(clk),.out(input_w));
    S2 ShR1_(.D00(shr1_w),.D01(1'b0),.D10(1'b1),.D11(1'b1),.A0(half1),.B0(half1),.A1(input_w),.B1(input_w),.clr(rst),.clk(clk),.out(shr1_w));
    S2 ShR2_(.D00(shr2_w),.D01(1'b0),.D10(half1),.D11(half1),.A0(half2),.B0(half2),.A1(shr1_w),.B1(shr1_w),.clr(rst),.clk(clk),.out(shr2_w));
    S2 Mult_(.D00(mult_w),.D01(1'b0),.D10(half2),.D11(half2),.A0(co2),.B0(co2),.A1(shr2_w),.B1(shr2_w),.clr(rst),.clk(clk),.out(mult_w));
    S2 Sh0_(.D00(1'b0),.D01(co1),.D10(co1),.D11(1'b0),.A1(sh0_w),.B1(sh0_w),.A0(mult_w),.B0(co2),.clr(rst),.clk(clk),.out(sh0_w));
    S2 Done_(.D00(1'b0),.D01(1'b0),.D10(co2),.D11(1'b0),.A1(mult_w),.B1(sh0_w),.A0(co1),.B0(co1),.clr(rst),.clk(clk),.out(done_w));
    C1 o_shr1(.A0(shr1_w),.A1(1'b0),.SA(half1),.B0(1'b1),.B1(1'b1),.SB(1'b1),.S0(mult_w),.S1(mult_w),.out(shr1));
    C1 o_shr2(.A0(mult_w),.A1(co1),.SA(sh0_w),.B0(1'b1),.B1(1'b0),.SB(half2),.S0(shr2_w),.S1(shr2_w),.out(shr2));
    C1 o_ld1(.A0(1'b0),.A1(1'b1),.SA(mult_w),.B0(1'b1),.B1(1'b1),.SB(1'b1),.S0(input_w),.S1(input_w),.out(ld1));
    C1 o_ld2(.A0(1'b0),.A1(lsb2),.SA(mult_w),.B0(1'b1),.B1(1'b1),.SB(1'b1),.S0(input_w),.S1(input_w),.out(ld2));
    C1 o_cnt1(.A0(1'b0),.A1(1'b0),.SA(1'b0),.B0(1'b1),.B1(1'b0),.SB(mult_w),.S0(shr1),.S1(shr2),.out(cnt1));
    assign cnt2 = mult_w;
    assign Done = done_w;
endmodule
// load a load b
// shr a until 7'b0 dec c
// shr b until 7'b0 dec c
// half_load a from b
// add b from a dec d
// shr b dec c