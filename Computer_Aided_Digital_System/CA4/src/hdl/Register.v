module register #(parameter WIDTH=16) (pin,ld,stall,clk,rst, pout);
    input ld,stall,clk,rst;
    input [WIDTH-1:0]pin;
    output reg [WIDTH-1:0] pout={WIDTH{1'b0}};
    always @(posedge clk) begin
        if(rst) begin
            pout<={WIDTH{1'b0}};
        end
        else if(!stall) begin
            if(ld)
                pout<=pin;
        end
    end
endmodule