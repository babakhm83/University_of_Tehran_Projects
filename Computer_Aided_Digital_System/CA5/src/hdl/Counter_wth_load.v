module counter_with_load#(parameter WIDTH=3,WIDTH_INC)(pin,ld,cnt,clr,inc,max_count,stall,clk,rst, pout);
    input cnt,clr,stall,ld,clk,rst;
    input [WIDTH-1:0] pin,max_count;
    input [WIDTH_INC-1:0] inc;
    output reg [WIDTH-1:0] pout=0;
    always @(posedge clk) begin
        if(rst)
            pout = 0;
        else if(!stall) begin 
            if(clr)
                pout = 0;
            else if(ld)
                pout = pin;
            else if(cnt) begin
                pout = (pout+inc);
                if(pout == max_count) 
                    pout = {WIDTH{1'b0}};
            end
        end
    end
endmodule