module counter #(parameter n = 3) (cnt,clr,clk,rst, co,pout);
    input cnt,clr,clk,rst;
    output co;
    output reg [n-1:0] pout={n{'b0}};
    always @(posedge clk) begin
        if(rst)
            pout <= {n{'b0}};
        else begin
            if(clr)
                pout <= {n{'b0}};
            else if(cnt)
                pout <= pout+1;
        end
    end
    assign co = cnt ? (&pout) : 1'b0;
endmodule