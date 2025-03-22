module counter_with_two_cnt #(parameter n = 5) (cnt1,cnt2,clr,clk,rst, co);
    input cnt1,cnt2,clr,clk,rst;
    output reg co=1'b0;
    reg [n-1:0] pout={n{'b0}};
    always @(posedge clk) begin
        if(rst) begin
            pout <= {n{'b0}};
            co<=1'b0;
        end
        else begin
            if(cnt1 && cnt2)
                pout <= pout+2;
            else if(cnt1 || cnt2)
                pout <= pout+1;
        end
    end
    always @(posedge clr,pout) begin
        if(clr || !pout)
            co<=~co;
    end
    // assign co = (cnt1 || cnt2) ? (&pout) : 1'b0;
endmodule