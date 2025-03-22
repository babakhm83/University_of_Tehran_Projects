module up_down_counter#(parameter WIDTH=3)(ucnt,dcnt,clr,stall,clk,rst, pout,co);
    input ucnt,dcnt,clr,stall,clk,rst;
    output co;
    output reg [WIDTH-1:0] pout=0;
    always @(posedge clk) begin
        if(rst)
            pout = 0;
        else if(!stall)begin 
            if(clr)
                pout = 0;
            else if(ucnt)
                pout = (pout+1);
            else if(dcnt)
                pout = (pout-1);
        end
    end
    assign co = dcnt & (pout==0);
endmodule