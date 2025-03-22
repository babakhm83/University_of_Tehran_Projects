module counter#(parameter WIDTH=3,WIDTH_INC)(cnt,clr,inc,max_count,stall,clk,rst, pout,co);
    input cnt,clr,stall,clk,rst;
    input [WIDTH-1:0] max_count;
    input [WIDTH_INC-1:0] inc;
    output co;
    output reg [WIDTH-1:0] pout=0;
    wire [WIDTH-1:0] temp;
    always @(posedge clk) begin
        if(rst)
            pout = 0;
        else if(!stall)begin 
            if(clr)
                pout = 0;
            else if(cnt) begin
                pout = (pout+inc);
                if(pout == max_count)
                    pout = {WIDTH{1'b0}};
            end
        end
    end
    assign temp =(max_count-1);
    assign co = cnt & (pout==temp);
endmodule