module controller(Start,msb1,msb2,co1,co2,co3,clk,rst, Done,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr);
    input Start,msb1,msb2,co1,co2,co3,clk,rst;
    output reg Done,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr;
    parameter [3:0] IDLE=0,WAIT=1,INPUT=2,SHR1R2=3,SHR2=4,SHR1=5,READM=6,SH0=7,WR_TO_RAM=8,DONE=9;
    reg [3:0] ns=IDLE,ps=IDLE;
    always@(posedge clk) begin
        if(rst)
            ps<=IDLE;
        else
            ps<=ns;
    end
    always@(ps,Start,msb1,msb2,co2,co3) begin
        ns=IDLE;
        case (ps)
            IDLE: begin ns = Start ? WAIT : IDLE; end
            WAIT: begin ns =  Start ? WAIT : INPUT; end
            INPUT: begin ns = SHR1R2; end
            SHR1R2: begin ns = ((msb1 && msb2) || co2) ? READM : (msb2) ? SHR1 : (msb1) ? SHR2 : SHR1R2; end
            SHR2: begin ns = (msb2+co2) ? READM : SHR2; end
            SHR1: begin ns = (msb1+co2) ? READM : SHR1; end
            READM: begin ns = SH0; end
            SH0: begin ns = co3 ? WR_TO_RAM : SH0; end
            WR_TO_RAM: begin ns = co1 ? DONE : INPUT; end
            DONE: begin ns = IDLE; end
            default: ns= IDLE;
        endcase
    end
    always@(ps, msb1, msb2, co2,co3) begin
        {Done,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr} = 11'd0;
        case (ps)
            IDLE: begin end
            WAIT: begin end
            INPUT: begin {ld1,ld2} = 2'b11; end
            SHR1R2: begin {cnt2, shl1,shl2} = (msb1 || msb2) ? 3'b000 : 3'b111; end
            SHR2: begin {cnt2, shl2} = (msb2) ? 2'b00 : 2'b11; end
            SHR1: begin {cnt2, shl1} = (msb1) ? 2'b00 : 2'b11; end
            READM: begin ld3 = 1'b1; end
            SH0: begin {shl1, shl3} = (co3) ? 2'b00 : 2'b11; {cnt1,wr} = (co3) ? 2'b11 : 2'b00; end
            WR_TO_RAM: begin clr_cntr = 1'b1; end
            DONE: begin Done = 1'b1; end
            default: {Done,cnt1,shl1,shl2,shl3,cnt2,clr_cntr,ld1,ld2,ld3,wr} = 11'd0;
        endcase
    end
endmodule