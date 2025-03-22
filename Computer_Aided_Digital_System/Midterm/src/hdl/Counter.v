module counter #(parameter BITS = 3) (cnt,clk,rst, co);
    input cnt,clk,rst;
    output co;
    reg [BITS-1:0] pout={BITS{1'b0}};
    always @(posedge clk) begin
        if(rst)
            pout <= {BITS{1'b0}};
        else begin
            if(cnt)
                pout <= pout+1;
        end
    end
    assign co = cnt ? (&pout) : 1'b0;
endmodule