module counter_circular_buffer #(parameter BITS=3,PAR=1) (cnt,clk,rst, pout);
    input cnt,clk,rst;
    output reg [BITS:0] pout=0;
    always @(posedge clk) begin
        if(rst)
            pout <= 0;
        else if(cnt) begin
            if((pout+PAR)>={1'b1,{(BITS-1){1'b0}},1'b1})
                pout <= (pout+PAR)-{1'b1,{(BITS-1){1'b0}},1'b1};
            else
                pout <= (pout+PAR);
        end
    end
endmodule