module johnson_counter #(parameter BITS=32) (shl,clk,rst, pout);
    input shl,clk,rst;
    output reg [BITS-1:0] pout={BITS{1'b0}};
    always @(posedge clk) begin
        if(rst) begin
            pout<={BITS{1'b0}};
        end
        else begin
            if(shl)
                pout<={pout[BITS-2:0],~pout[BITS-1]};
        end
    end
endmodule