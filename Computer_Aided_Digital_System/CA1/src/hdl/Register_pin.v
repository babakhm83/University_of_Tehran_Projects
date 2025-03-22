module register_pin #(parameter n=16) (pin,ld,shl,clk,rst, pout);
    input ld,shl,clk,rst;
    input [n-1:0] pin;
    output reg [n-1:0] pout={n{'b0}};
    always @(posedge clk) begin
        if(rst) begin
            pout<={n{'b0}};
        end
        else begin
            if(ld)
                pout<=pin;
            else if(shl) begin
                pout<={pout[n-2:0],1'b0};
            end
        end
    end
endmodule