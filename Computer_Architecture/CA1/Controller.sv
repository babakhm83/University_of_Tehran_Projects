module controller(Start,cout,gt,ovf_in,dvz_in,clk,rst, ldA,ldB,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy);
    input Start,cout,gt,clk,rst,ovf_in,dvz_in;
    output ldA,ldB,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy;
    reg ldA,ldB,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy;
    parameter [3:0] Idle=0,Load=1,ShiftA=2,WaitShift=3,Compare=4,Subtract=5,ShiftQ0=6,ShiftQ1=7,Done=8,DevideByZero=9,OverFlow=10;
    reg [3:0] ns=Idle,ps=Idle;
    always@(posedge clk) begin
        if(rst)
            ps<=Idle;
        else
            ps<=ns;
    end
    always@(ps,Start) begin
        ns=Idle;
        case (ps)
            Idle: begin ns = Start ? Load : Idle; end
            Load: begin ns = ShiftA; end
            ShiftA: begin ns = WaitShift; end
            WaitShift: begin ns = (dvz_in)?DevideByZero:(Compare); end
            Compare: begin ns = cout?Done : (gt ? Subtract : ShiftQ0); end
            Subtract: begin ns = ShiftQ1; end
            ShiftQ0: begin ns = ShiftA; end
            ShiftQ1: begin ns = ShiftA; end
            Done: begin ns = Idle; end
            DevideByZero: begin ns=Idle; end
            OverFlow: begin ns=Idle; end
            default: ns= Idle;
        endcase
    end
    always@(ps,Start) begin
        {ldA,ldB,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy} = 13'd1;
        case (ps)
            Idle: begin busy=1'b0; sclrA=1'b1; cnt_sclr=1'b1; end
            Load: begin ldQ=1'b1; ldB=1'b1; end
            ShiftA: begin shA=1'b1; end
            WaitShift: cnt_en=1;
            Compare: ;
            Subtract: begin ldA=1'b1; end
            ShiftQ0: begin shQ=1'b1; Q0=1'b0;end
            ShiftQ1: begin shQ=1'b1; Q0=1'b1;end
            Done: begin valid=1'b1; end
            DevideByZero: begin dvz=1'b1; end
            OverFlow: begin ovf=1'b1; end
            default: {ldA,ldB,shA,shQ,valid,ldQ,Q0,sclrA,cnt_sclr,cnt_en,dvz,ovf,busy} = 13'd1;
        endcase
    end
endmodule