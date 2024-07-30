`timescale 1ns/1ns
module controller(input Start,Co,Comp,clk,rst, output reg init, s, add_sub,ldt,ldr,cnt_en,ready);
    parameter [2:0] Idle=0,Initial=1,Mult1=2,Mult2=3,Mult3=4,Mult4=5,Add=6,Sub=7;
    reg [2:0] ns,ps;
    always@(ps,Start) begin
        ns=Idle;
        {init,s,ldt,ldr,cnt_en,ready} = 7'b0;
        case (ps)
            Idle: begin ns = Start ? Initial : Idle; add_sub = 1'b1; init = 1'b1; ready=1'b1; end
            Initial: begin ns = Start ? Initial : Mult1; init = 1'b1; end
            Mult1: begin ns = Mult2; s=1'b1; ldt=1'b1; end
            Mult2: begin ns = Mult3; cnt_en=1; ldt=1'b1; end
            Mult3: begin ns = Mult4; s=1'b1; ldt=1'b1; end
            Mult4: begin ns = add_sub ? Add : Sub; ldt=1'b1; end
            Add: begin ns = Co ? Idle : Comp ? Idle : Mult1; cnt_en=1; ldr=1'b1; add_sub = 1'b0; end
            Sub: begin ns = Co ? Idle : Comp ? Idle : Mult1; cnt_en=1; ldr=1'b1; add_sub = 1'b1; end
            default: ns= Idle;
        endcase
    end
    always@(posedge clk, posedge rst) begin
        if(rst)
            ps<=Idle;
        else
            ps<=ns;
    end
endmodule