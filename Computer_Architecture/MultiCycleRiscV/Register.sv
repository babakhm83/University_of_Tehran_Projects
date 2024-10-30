module register(clk,rst,pin, pout);
    input clk,rst;
    input [31:0] pin;
    output [31:0] pout;
    reg [31:0] pout = 32'd0;
    always @(posedge clk) begin
        if(rst)
            pout <= 32'd0;
        else
            pout <= pin;
    end
endmodule