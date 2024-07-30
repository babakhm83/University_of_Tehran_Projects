`timescale 1ns/1ns
module register(input [15:0] pin, input ld,clk,rst,sclr,sset, output reg [15:0] pout);
    always @(posedge clk, posedge rst) begin
        if(rst)
            pout <= 16'd0;
        else begin
            if(sclr)
                pout <= 16'd0;
            else if(sset)
                pout <= 16'b100000000;
            else if(ld)
                pout <= pin;
        end
    end
endmodule