module register #(parameter BITS=32) (pin,ld,clk,rst, pout);
    input ld,clk,rst;
    input [BITS-1:0] pin;
    output reg [BITS-1:0] pout={BITS{1'b0}};
    always @(posedge clk) begin
        if(rst) begin
            pout<={BITS{1'b0}};
        end
        else begin
            if(ld)
                pout<=pin;
        end
    end
endmodule